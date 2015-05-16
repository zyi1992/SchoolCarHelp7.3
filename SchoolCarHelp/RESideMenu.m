//
//  RESideMenu.m
// RESideMenu
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "RESideMenu.h"
#import "AccelerationAnimation.h"
#import "Evaluate.h"

const int INTERSTITIAL_STEPS = 99;

@interface RESideMenu ()
{
    BOOL _appIsHidingStatusBar;
    BOOL _isInSubMenu;
}
@property (assign, readwrite, nonatomic) NSInteger initialX;
@property (assign, readwrite, nonatomic) CGSize originalSize;
@property (strong, readonly, nonatomic) REBackgroundView *backgroundView;
@property (strong, readonly, nonatomic) UIImageView *screenshotView;

// Array containing menu (which are array of items)
@property (strong, readwrite, nonatomic) NSMutableArray *menuStack;
@property (strong, readwrite, nonatomic) RESideMenuItem *backMenu;

@end

@implementation RESideMenu
@synthesize tableView = _tableView;
- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    self.verticalOffset = 100;
    self.horizontalOffset = 50;
    self.itemHeight = 50;
    self.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
    self.textColor = [UIColor whiteColor];
    self.highlightedTextColor = [UIColor lightGrayColor];
    self.hideStatusBarArea = YES;
    
    self.menuStack = [NSMutableArray array];
    self.backgroundImage = [UIImage imageNamed:@"侧滑界面背景图.jpg"];
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [self init];
    if (!self)
        return nil;
    
    _items = items;
    [_menuStack addObject:items];
    _backMenu = [[RESideMenuItem alloc] initWithTitle:@"<" action:nil];
    
    return self;
}

- (void) showItems:(NSArray *)items
{
    // Animate to deappear
    __typeof (&*self) __weak weakSelf = self;
    weakSelf.tableView.transform = CGAffineTransformScale(_tableView.transform, 0.9, 0.9);
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.tableView.transform = CGAffineTransformIdentity;
    }];
    [UIView animateWithDuration:0.6 animations:^{
        weakSelf.tableView.alpha = 0;
    }];
    
    // Set items and reload
    _items = items;
    [self.tableView reloadData];
    
    // Animate to reappear once reloaded
    weakSelf.tableView.transform = CGAffineTransformScale(_tableView.transform, 1, 1);
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.tableView.transform = CGAffineTransformIdentity;
    }];
    [UIView animateWithDuration:0.6 animations:^{
        weakSelf.tableView.alpha = 1;
    }];
    
}

- (void)show
{
    if (_isShowing)
        return;
    
    _isShowing = YES;
    
    // keep track of whether or not it was already hidden
    _appIsHidingStatusBar=[[UIApplication sharedApplication] isStatusBarHidden];
    
    if(!_appIsHidingStatusBar)
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self performSelector:@selector(showAfterDelay) withObject:nil afterDelay:0.1];
}

- (void)hide
{
    if (_isShowing)
        [self restoreFromRect:_screenshotView.frame];
}

- (void)setRootViewController:(UIViewController *)viewController
{
    if (_isShowing)
        [self hide];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.rootViewController = viewController;
    _screenshotView.image = [window re_snapshotWithStatusBar:!self.hideStatusBarArea];
    [window bringSubviewToFront:_backgroundView];
    [window bringSubviewToFront:_tableView];
    [window bringSubviewToFront:_screenshotView];
}

- (void)addAnimation:(NSString *)path view:(UIView *)view startValue:(double)startValue endValue:(double)endValue
{
    AccelerationAnimation *animation = [AccelerationAnimation animationWithKeyPath:path
                                                                        startValue:startValue
                                                                          endValue:endValue
                                                                  evaluationObject:[[ExponentialDecayEvaluator alloc] initWithCoefficient:6.0]
                                                                 interstitialSteps:INTERSTITIAL_STEPS];
    animation.removedOnCompletion = NO;
    [view.layer addAnimation:animation forKey:path];
}

//- (void)animate

- (void)showAfterDelay
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // Take a snapshot
    //
    _screenshotView = [[UIImageView alloc] initWithFrame:CGRectNull];
    _screenshotView.image = [window re_snapshotWithStatusBar:!self.hideStatusBarArea];
    _screenshotView.frame = CGRectMake(0, 0, _screenshotView.image.size.width, _screenshotView.image.size.height);
    _screenshotView.userInteractionEnabled = YES;
    _screenshotView.layer.anchorPoint = CGPointMake(0, 0);
    
    _originalSize = _screenshotView.frame.size;
    
    // Add views
    //
    _backgroundView = [[REBackgroundView alloc] initWithFrame:window.bounds];
    _backgroundView.backgroundImage = _backgroundImage;
    [window addSubview:_backgroundView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(30, 10, window.frame.size.width, self.verticalOffset+50)];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked)];
    [ _tableView.tableHeaderView addGestureRecognizer:singleTap];

   // _tableView.tableHeaderView.se
    //[_tableView deselectRowAtIndexPath:indexPath animated:<#(BOOL)#>]
    _tableView.tableHeaderView.userInteractionEnabled = YES;
      // _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(30, 30, 40, 40)];
    //添加的tableview的headview
    //NSDictionary* dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:TheCurrentUserInfo];
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:TheCurrentUserInfoAvtor]){
            UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"头像%@",[[NSUserDefaults standardUserDefaults] objectForKey:TheCurrentUserInfoAvtor]]]];
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:TheCurrentUserInfoAvtor]);
            img.frame = CGRectMake(50, 25, 65, 65);
            [_tableView.tableHeaderView addSubview:img];
        }
        else
        {
            UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"头像0"]];
            img.frame = CGRectMake(50, 25, 65, 65);
            // img.userInteractionEnabled = YES;
            [_tableView.tableHeaderView addSubview:img];
        }
        
        UILabel* namelable = [[UILabel alloc]initWithFrame:CGRectMake(120, 40, 150, 30)];
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:thecurrentuserNickName] isEqual:[NSNull null]] ) {
            namelable.text = [[NSUserDefaults standardUserDefaults] objectForKey:thecurrentuserNickName];
        }
        else
        {
            namelable.text = @"未知";
        }
        namelable.textColor = [UIColor whiteColor];
        namelable.font = [UIFont systemFontOfSize:20];
        [_tableView.tableHeaderView addSubview:namelable];
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(50, 95, 190, 1)];
        line.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.8];
        [_tableView addSubview:line];
        UILabel* personLable = [[UILabel alloc]initWithFrame:CGRectMake(55, 98, 185, 20)];
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:TheCurrentUserMotto] isEqual:[NSNull null]]) {
            personLable.text = [[NSUserDefaults standardUserDefaults] objectForKey:TheCurrentUserMotto];
        }else
        {
            personLable.text = @"未填写个性签名";
        }
        personLable.textColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
        personLable.font = [UIFont systemFontOfSize:12];
        [_tableView addSubview:personLable];
        UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(50, 120, 190, 2)];
        line1.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.8];
        [_tableView addSubview:line1];

    }
    else
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:TheCurrentUserInfoAvtor]){
            UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"头像%@",[[NSUserDefaults standardUserDefaults] objectForKey:TheCurrentUserInfoAvtor]]]];
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:TheCurrentUserInfoAvtor]);
            img.frame = CGRectMake(50, 55, 65, 65);
            [_tableView.tableHeaderView addSubview:img];
        }
        else
        {
            UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"头像0"]];
            img.frame = CGRectMake(50, 55, 65, 65);
            // img.userInteractionEnabled = YES;
            [_tableView.tableHeaderView addSubview:img];
            
        }
        
        UILabel* namelable = [[UILabel alloc]initWithFrame:CGRectMake(120, 70, 150, 30)];
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:thecurrentuserNickName] isEqual:[NSNull null]] ) {
            namelable.text = [[NSUserDefaults standardUserDefaults] objectForKey:thecurrentuserNickName];
        }
        else
        {
            namelable.text = @"未知";
        }
        namelable.textColor = [UIColor whiteColor];
        namelable.font = [UIFont systemFontOfSize:20];
        [_tableView.tableHeaderView addSubview:namelable];
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(50, 125, 190, 1)];
        line.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.8];
        [_tableView addSubview:line];
        UILabel* personLable = [[UILabel alloc]initWithFrame:CGRectMake(55, 128, 185, 20)];
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:TheCurrentUserMotto] isEqual:[NSNull null]]) {
            personLable.text = [[NSUserDefaults standardUserDefaults] objectForKey:TheCurrentUserMotto];
        }else
        {
            personLable.text = @"未填写个性签名";
        }
        personLable.textColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
        personLable.font = [UIFont systemFontOfSize:12];
        [_tableView addSubview:personLable];
        UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(50, 150, 190, 2)];
        line1.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.8];
        [_tableView addSubview:line1];
    
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.alpha = 0;
    [window addSubview:_tableView];
    
    [window addSubview:_screenshotView];
    
    [self minimizeFromRect:CGRectMake(0, 0, _originalSize.width, _originalSize.height)];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [_screenshotView addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [_screenshotView addGestureRecognizer:tapGestureRecognizer];
}
-(void)UesrClicked
{
    UINavigationController *viewController = [[UINavigationController alloc]initWithRootViewController:[[PersonViewController alloc]init]];
    [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self setRootViewController:viewController];
}
- (void)minimizeFromRect:(CGRect)rect
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGFloat m = 0.71;
    CGFloat newWidth = _originalSize.width * m;
    CGFloat newHeight = _originalSize.height * m;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.6] forKey:kCATransactionAnimationDuration];
    [self addAnimation:@"position.x" view:_screenshotView startValue:rect.origin.x endValue:window.frame.size.width - 80.0];
    [self addAnimation:@"position.y" view:_screenshotView startValue:rect.origin.y endValue:(window.frame.size.height - newHeight) / 2.0];
    [self addAnimation:@"bounds.size.width" view:_screenshotView startValue:rect.size.width endValue:newWidth];
    [self addAnimation:@"bounds.size.height" view:_screenshotView startValue:rect.size.height endValue:newHeight];
    
    _screenshotView.layer.position = CGPointMake(window.frame.size.width - 80.0, (window.frame.size.height - newHeight) / 2.0);
    _screenshotView.layer.bounds = CGRectMake(window.frame.size.width - 80.0, (window.frame.size.height - newHeight) / 2.0, newWidth, newHeight);
    [CATransaction commit];
    
    if (_tableView.alpha == 0) {
        __typeof (&*self) __weak weakSelf = self;
        weakSelf.tableView.transform = CGAffineTransformScale(_tableView.transform, 0.9, 0.9);
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.tableView.transform = CGAffineTransformIdentity;
        }];
        
        [UIView animateWithDuration:0.6 animations:^{
            weakSelf.tableView.alpha = 1;
        }];
    }
}

- (void)restoreFromRect:(CGRect)rect
{
    _screenshotView.userInteractionEnabled = NO;
    while (_screenshotView.gestureRecognizers.count) {
        [_screenshotView removeGestureRecognizer:[_screenshotView.gestureRecognizers objectAtIndex:0]];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.4] forKey:kCATransactionAnimationDuration];
    [self addAnimation:@"position.x" view:_screenshotView startValue:rect.origin.x endValue:0];
    [self addAnimation:@"position.y" view:_screenshotView startValue:rect.origin.y endValue:0];
    [self addAnimation:@"bounds.size.width" view:_screenshotView startValue:rect.size.width endValue:window.frame.size.width];
    [self addAnimation:@"bounds.size.height" view:_screenshotView startValue:rect.size.height endValue:window.frame.size.height];
    
    _screenshotView.layer.position = CGPointMake(0, 0);
    _screenshotView.layer.bounds = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    [CATransaction commit];
    [self performSelector:@selector(restoreView) withObject:nil afterDelay:0.4];
    
    __typeof (&*self) __weak weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.tableView.alpha = 0;
        weakSelf.tableView.transform = CGAffineTransformScale(_tableView.transform, 0.7, 0.7);
    }];
    
    // restore the status bar to its original state.
    [[UIApplication sharedApplication] setStatusBarHidden:_appIsHidingStatusBar withAnimation:UIStatusBarAnimationFade];
    _isShowing = NO;
}

- (void)restoreView
{
    __typeof (&*self) __weak weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.screenshotView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.screenshotView removeFromSuperview];
    }];
    [_backgroundView removeFromSuperview];
    [_tableView removeFromSuperview];
}

#pragma mark -
#pragma mark Gestures

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    CGPoint translation = [sender translationInView:window];
	if (sender.state == UIGestureRecognizerStateBegan) {
		_initialX = _screenshotView.frame.origin.x;
	}
	
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat x = translation.x + _initialX;
        CGFloat m = 1 - ((x / window.frame.size.width) * 210/window.frame.size.width);
        CGFloat y = (window.frame.size.height - _originalSize.height * m) / 2.0;
        
        _tableView.alpha = (x + 80.0) / window.frame.size.width;
        
        if (x < 0 || y < 0) {
            _screenshotView.frame = CGRectMake(0, 0, _originalSize.width, _originalSize.height);
        } else {
            _screenshotView.frame = CGRectMake(x, y, _originalSize.width * m, _originalSize.height * m);
        }
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ([sender velocityInView:window].x < 0) {
            [self restoreFromRect:_screenshotView.frame];
        } else {
            [self minimizeFromRect:_screenshotView.frame];
        }
    }
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)sender
{
    [self restoreFromRect:_screenshotView.frame];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"RESideMenuCell";
    
    RESideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[RESideMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.textLabel.font = self.font;
        cell.textLabel.textColor = self.textColor;
        cell.textLabel.highlightedTextColor = self.highlightedTextColor;
        
    }
    
    RESideMenuItem *item = [_items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    //cell.imageView.frame = CGRectMake(10, 10, 10,10);
    cell.imageView.image = item.image;
   // [cell.imageView setBackgroundColor:[UIColor colorWithPatternImage:item.image]];
    cell.imageView.highlightedImage = item.highlightedImage;
   
        if (indexPath.row == 2) {
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(50, cell.frame.size.height, 200, 1)];
        line.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.8];
            line.tag = 113;
        [cell addSubview:line];
    }
    cell.horizontalOffset = self.horizontalOffset;

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RESideMenuItem *item = [_items objectAtIndex:indexPath.row];
    // Case back on subMenu
    if(_isInSubMenu &&
       indexPath.row==0 &&
       indexPath.section == 0){
        
        [_menuStack removeLastObject];
        if(_menuStack.count==1){
            _isInSubMenu = NO;
        }
        [self showItems:_menuStack.lastObject];
        
        return;
    }
        
    // Case menu with subMenu
    if(item.subItems){
        _isInSubMenu = YES;
        
        // Concat back menu to submenus and show
        NSMutableArray * array = [NSMutableArray arrayWithObject:_backMenu];
        [array addObjectsFromArray:item.subItems];
        [self showItems:array];
        
        // Push new menu on stack
        [_menuStack addObject:array];
    }
    
    if (item.action)
        item.action(self, item);
}

@end
