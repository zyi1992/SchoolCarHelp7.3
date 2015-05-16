//
//  TieZiViewController.m
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-5.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "postCenterViewViewController.h"
#import "PostDetailsViewContrViewController.h"
#import "userDefaultHeader.h"
@interface postCenterViewViewController ()

@end

@implementation postCenterViewViewController
@synthesize _scroll;
@synthesize instantLine;
@synthesize appointLine;
@synthesize instantIvt;
@synthesize appointIvt;
@synthesize signBtn;
@synthesize signLable;
@synthesize dataArray;
@synthesize headBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBack.png"] forBarMetrics:UIBarMetricsDefault];
}
- (void)initTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.textColor        = [UIColor whiteColor];
    titleLabel.text             = title;
    titleLabel.font = [UIFont systemFontOfSize:20.f];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

-(void)_scrollLoad
{
    instantIvt = [[UIButton alloc]initWithFrame:CGRectMake(30, 70, 100, 40)];
    [instantIvt setTitle:@"即时帖子" forState:UIControlStateNormal];
    instantIvt.titleLabel.font = [UIFont systemFontOfSize:19.f];
    [instantIvt setTitleColor:[UIColor colorWithRed:76/255.0 green:193/255.0 blue:210/255.0 alpha:1.0] forState:UIControlStateNormal];
    [instantIvt addTarget:self action:@selector(instantDo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:instantIvt];
    
    appointIvt = [[UIButton alloc]initWithFrame:CGRectMake(190, 70, 100, 40)];
    [appointIvt setTitle:@"预约帖子" forState:UIControlStateNormal];
    appointIvt.titleLabel.font = [UIFont systemFontOfSize:19.f];
    [appointIvt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [appointIvt addTarget:self action:@selector(appointDo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:appointIvt];
    
    instantLine = [[UIView alloc]initWithFrame:CGRectMake(21, 107, 120, 3)];
    instantLine.backgroundColor = [UIColor colorWithRed:76/255.0 green:193/255.0 blue:210/255.0 alpha:1.0];
    [self.view addSubview:instantLine];
    
    appointLine = [[UIView alloc]initWithFrame:CGRectMake(179, 107, 120, 3)];
    appointLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:appointLine];
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,110, 320, 458)];
    _scroll.contentSize = CGSizeMake(320, 480);
    _scroll.backgroundColor = [UIColor whiteColor];
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
    
 }
-(void)addPost
{
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:ThestartAnnotationCoordinatetitle] isEqual:[NSNull null]]||[[[NSUserDefaults standardUserDefaults] stringForKey:ThestartAnnotationCoordinatetitle] length] == 0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有获取到你当前的位置信息，请回到主页选取一个位置或者开启定位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 99;
        [alert show];
    }
    if (flag == 1) {
        NSURL *url = [NSURL URLWithString:@"http://cai.chinacloudsites.cn/CAI/CAI/GetNowPosts"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSMutableData* body = [NSMutableData data];
          [body appendData:[[NSString stringWithFormat:@"index=%d&UserId=%@&Longitude=%f&Latitude=%f",TheAddTimeNum,[[NSUserDefaults standardUserDefaults] stringForKey:TheCUrrentUserId], [[NSUserDefaults standardUserDefaults] doubleForKey:ThestartAnnotationCoordinatelongitude],[[NSUserDefaults standardUserDefaults] doubleForKey:ThestartAnnotationCoordinatelatitude]] dataUsingEncoding:NSUTF8StringEncoding]];
            NSLog(@"http://cai.chinacloudsites.cn/CAI/CAI/GetNowPosts?%@",[NSString stringWithFormat:@"index=%d&UserId=%@&Longitude=%f&Latitude=%f",TheAddTimeNum,[[NSUserDefaults standardUserDefaults] stringForKey:TheCUrrentUserId], [[NSUserDefaults standardUserDefaults] doubleForKey:ThestartAnnotationCoordinatelongitude],[[NSUserDefaults standardUserDefaults] doubleForKey:ThestartAnnotationCoordinatelatitude]]);
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:body];
            [request setTimeoutInterval:10];
            NSData * returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (returnData) {
            NSArray* mutablearry = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
            TheLastPostNum = [mutablearry count];
            [dataArray addObjectsFromArray:mutablearry];
        }else
        {
           
        }
    }
        else
        {
            NSURL *url = [NSURL URLWithString:@"http://cai.chinacloudsites.cn/CAI/CAI/GetBookPosts"];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            NSMutableData* body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"index=%d&UserId=%@&Longitude=%f&Latitude=%f",TheAddTimeNum,[[NSUserDefaults standardUserDefaults] stringForKey:TheCUrrentUserId], [[NSUserDefaults standardUserDefaults] doubleForKey:ThestartAnnotationCoordinatelongitude],[[NSUserDefaults standardUserDefaults] doubleForKey:ThestartAnnotationCoordinatelatitude]] dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:body];
            [request setTimeoutInterval:10];
            
            NSData * returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            if (returnData) {
                NSArray* mutablearry = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
               // NSLog(@"预约帖子的信息：%@",mutablearry);
                TheLastPostNum = [mutablearry count];
                [dataArray addObjectsFromArray:mutablearry];
            }else
            {
                
            }

            
        }
        int i = (TheAddTimeNum-1)*10;
        int j = [dataArray count];
        for (; i < j ; i ++ )
        {
            NSDictionary* dic = [dataArray objectAtIndex:i];
            NSDictionary* post = [dic objectForKey:@"Post"];
            NSDictionary* User = [dic objectForKey:@"User"];
            UIView *blockView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 + 127 * i, 320, 127)];
            [_scroll addSubview:blockView];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 110, 320, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
            [self.view addSubview:lineView];
        
            headBtn = [[name_Btn alloc]initWithFrame:CGRectMake(15, 7, 55, 55)];
            if (![[User objectForKey:@"Avator"] isEqual:[NSNull null]])
            {
                
                [headBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"头像%@",[User objectForKey:@"Avator"]]] forState:UIControlStateNormal];
            }
            else
            {
                [headBtn setBackgroundImage:[UIImage imageNamed:@"头像11"] forState:UIControlStateNormal];
            }
            [headBtn addTarget:self action:@selector(ShowPersonInfo:) forControlEvents:UIControlEventTouchUpInside];
            headBtn.name = [post objectForKey:@"UserId"];
            [blockView addSubview:headBtn];
        
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 15,100, 20)];
            if (![[User objectForKey:@"NickName"] isEqual:[NSNull null]]) {
                 nameLabel.text = [User objectForKey:@"NickName"];
            }
            else
            {
                nameLabel.text = @"未设置";
            }
            [blockView addSubview:nameLabel];
            UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 45, 230,15)];
            if (![[post objectForKey:@"Message"] isEqual:[NSNull null]]) {
                remarkLabel.text = [post objectForKey:@"Message"];
            }
            else
            {
                remarkLabel.text  = @"";
            }
            
            remarkLabel.font = [UIFont systemFontOfSize:13];
            remarkLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
            [blockView addSubview:remarkLabel];
        
            signBtn = [[name_Btn alloc]initWithFrame:CGRectMake(245, 10, 65, 28)];
            signBtn.postId = [post objectForKey:@"Id"];
            signBtn.flag = flag;
          //  UILabel* lable =[UILabel alloc]initWithFrame:CGRectMake(5, 5, 60, 20)];
            NSLog(@"%@",[dic objectForKey:@"IsIn"]);

            if ([[dic objectForKey:@"IsIn"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [signBtn setTitle:@"已报名" forState:UIControlStateNormal];
                [signBtn setTitleColor:[UIColor colorWithRed:76/255.0 green:193/255.0 blue:210/255.0 alpha:1.0] forState:UIControlStateNormal];
                [signBtn setBackgroundImage:[UIImage imageNamed:@"已报名"] forState:UIControlStateNormal];
                signBtn.name = [post objectForKey:@"UserId"];
                signBtn.flag = 0;
                NSLog(@"已加入");
                //signBtn.titleLabel.textColor = [UIColor blueColor];
            }
            else
            {
                NSLog(@"weijiaru");
                 [signBtn setBackgroundImage:[UIImage imageNamed:@"去报名"] forState:UIControlStateNormal];
                [signBtn setTitle:@"去报名" forState:UIControlStateNormal];
                  signBtn.titleLabel.text = @"去报名";
                signBtn.name = [post objectForKey:@"UserId"];
                signBtn.titleLabel.textColor = [UIColor whiteColor];
                signBtn.flag = 1;
            }
            [signBtn addTarget:self action:@selector(signDo:) forControlEvents:UIControlEventTouchUpInside];
            
            signBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
            [blockView addSubview:signBtn];
            NSArray *contentArray = [NSArray arrayWithObjects:[post objectForKey:@"Origin"],[post objectForKey:@"Terminal"], nil];
            NSArray *imgArray = [NSArray arrayWithObjects:@"icon_outset", @"ico_to_there",nil];
        for (int it = 0; it<2; it++) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 70+it*45, 300, 1)];
            line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
            [blockView addSubview:line];
            
            UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(10+300*it, 70, 1, 45)];
            line1.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
            [blockView addSubview:line1];
            
            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 75+it*20, 230, 15)];
            if (![[contentArray objectAtIndex:it] isEqual: [NSNull null]]) {
                 contentLabel.text = [contentArray objectAtIndex:it];
            }
            else
            {
                contentLabel.text =@"未知";
            }
            contentLabel.font = [UIFont systemFontOfSize:13];
            [blockView addSubview:contentLabel];
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(22, 76+20*it, 12, 14)];
            imgView.image = [UIImage imageNamed:[imgArray objectAtIndex:it]];
            [blockView addSubview:imgView];
        }
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 72, 70, 15)];
           // NSDate* date = [post objectForKey:@"CreateTime"];
           // NSString *dateString = [dateFormat stringFromDate:date]
            if (![[post objectForKey:@"CreateTime"] isEqual:[NSNull null]]) {
                NSString *string2 = [post objectForKey:@"CreateTime"];
               // NSLog(@"-------------%@",string2);
                long long dq =[string2 longLongValue];
               // NSLog(@"-----------%lld",dq);
                NSDate *dd = [[NSDate alloc]initWithTimeIntervalSince1970:dq];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
                NSTimeZone* timeZone =  [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
                [dateFormatter setTimeZone:timeZone];
                dateFormatter.dateFormat = @"MM-dd  HH:mm:ss";
                // NSLog(@"%@",[dateFormatter stringFromDate:dd]);
                timeLabel.text = [dateFormatter stringFromDate:dd];
                //NSLog(@"%@",timeLabel.text);
            }
            else
            {
                 timeLabel.text = @"未知";
            }
            timeLabel.font = [UIFont systemFontOfSize:8];
            timeLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
            [blockView addSubview:timeLabel];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 127, 320, 1)];
        line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        [blockView addSubview:line];
    }
    _scroll.contentSize = CGSizeMake(320, 127*[dataArray count]);
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.1f];
    TheAddTimeNum++;
    [blackView removeFromSuperview];

}
-(void)addViewAnimate
{
    blackView = [[UIView alloc]initWithFrame:CGRectMake(110, ([[UIScreen mainScreen]bounds].size.height-100)/2.0,100, 100)];
    [[blackView layer] setCornerRadius:10.0];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.6;
    [self. view addSubview:blackView];
    
    UILabel *wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 100, 20)];
    wordLabel.text = @"正在加载...";
    wordLabel.textColor = [UIColor whiteColor];
    wordLabel.textAlignment = NSTextAlignmentCenter;
    wordLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [blackView addSubview:wordLabel];
    
    activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(50, 40);
    [activityView startAnimating];
    [blackView addSubview:activityView];

}
-(void)ShowPersonInfo:(name_Btn*)but
{
  //  signBtn = _signBtn;
    PersonViewController *viewController = [[PersonViewController alloc]init];
    //viewController.thePostId = signBtn.postId;
    viewController.Userid = but.name;
    if ([signBtn.name isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:TheCUrrentUserId]]) {
        viewController.WhetherIsTheUserSelfPost= NO;
    }
    else
    {
        viewController.WhetherIsTheUserSelfPost= YES;
    }
    //viewController.type = flag;
    [self.navigationController pushViewController:viewController animated:YES];

    
}
-(void)doBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTitle:@"拼车帖集中营"];
     self.view.backgroundColor = [UIColor whiteColor];
    UIButton* backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(0, 0, 25, 20);
    [backBtn setImage:[UIImage imageNamed:@"backBut.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    flag = 1;
    TheAddTimeNum = 1;
    TheLastPostNum = 10;
    dataArray = [[NSMutableArray alloc]init];
    [self _scrollLoad];
    [self addViewAnimate];
    [self performSelector:@selector(addPost) withObject:nil afterDelay:0.3f];
   //[self setFooterView];
    //[self refreshView];
    
    
}
-(void)initData
{
    [dataArray removeAllObjects];
    TheAddTimeNum = 1;
    TheLastPostNum = 10;
    dataArray =  [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Target Action
-(void)instantDo
{
    if (flag == 2) {
        [_scroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self initData];
        appointLine.backgroundColor =[UIColor whiteColor];
        [appointIvt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        instantLine.backgroundColor = [UIColor colorWithRed:76/255.0 green:193/255.0 blue:210/255.0 alpha:1.0];
        [instantIvt setTitleColor:[UIColor colorWithRed:76/255.0 green:193/255.0 blue:210/255.0 alpha:1.0] forState:UIControlStateNormal];
        flag = 1;
        [self addViewAnimate];
        [self performSelector:@selector(addPost) withObject:nil afterDelay:0.3f];
    }
}

-(void)appointDo
{
    if (flag == 1) {
         [_scroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self initData];
        appointLine.backgroundColor = [UIColor colorWithRed:76/255.0 green:193/255.0 blue:210/255.0 alpha:1.0];
        [appointIvt setTitleColor:[UIColor colorWithRed:76/255.0 green:193/255.0 blue:210/255.0 alpha:1.0] forState:UIControlStateNormal];
        instantLine.backgroundColor = [UIColor whiteColor];
        [instantIvt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        flag = 2;
        [self addViewAnimate];
        [self performSelector:@selector(addPost) withObject:nil afterDelay:0.3f];
    }
}

-(void)signDo:(name_Btn *)_signBtn
{
    signBtn = _signBtn;
    PostDetailsViewContrViewController *viewController = [[PostDetailsViewContrViewController alloc]init];
    viewController.thePostId = signBtn.postId;
    if ([signBtn.name isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:TheCUrrentUserId]]) {
        viewController.WhetherThePostUserSelf = YES;
    }
    else
    {
        viewController.WhetherThePostUserSelf = NO;
    }
    if (signBtn.flag == 0) {
        viewController.WheTherTheUserIsIn = YES;
    }
    else
    {
        viewController.WheTherTheUserIsIn =NO;

    }
    viewController.type = flag;
    [self.navigationController pushViewController:viewController animated:YES];

}

#pragma mark
#pragma methods for creating and removing the header view

-(void)setFooterView{
    //UIEdgeInsets test = self._scroll.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self._scroll.contentSize.height, self._scroll.frame.size.height);
    // NSLog(@"%f",height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,height,320,self.view.bounds.size.height);
        _refreshFooterView.delegate = self;
        [self._scroll addSubview:_refreshFooterView];
        
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self._scroll.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self._scroll addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter){
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
    
	// overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    

    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self._scroll];
        //[self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

//刷新调用的方法
-(void)refreshView{
    
    [self testFinishedLoadData];
    
}
//加载调用的方法
-(void)getNextPageView{

    [self hahahaha];
    
    [self testFinishedLoadData];
    
    [self removeFooterView];
    
    [self setFooterView];
    
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    
    //[self createHeaderView];
    
    [self setFooterView];
}

//刷新的方法
-(void)hahahaha
{
    if (TheLastPostNum == 10) {
          [self addPost];
        [self setFooterView];
    }
    
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==98) {
        UINavigationController *viewController = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
        [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:viewController animated:YES completion:nil];

    }
}
@end
