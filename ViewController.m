//
//  ViewController.m
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-16.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()

@end

@implementation ViewController
@synthesize myScrollView,pageControl;
@synthesize flag;
-(void)initArray
{
    if ([UIScreen mainScreen].bounds.size.height>=568) {
        imageArray=[NSArray arrayWithObjects: [UIImage imageNamed:@"q1.jpg"],[UIImage imageNamed:@"q2.jpg"],[UIImage imageNamed:@"q3.jpg"],[UIImage imageNamed:@"q4.jpg"],[UIImage imageNamed:@"q5.jpg"],nil];

    }else
    {
    imageArray=[NSArray arrayWithObjects: [UIImage imageNamed:@"i1.jpg"],[UIImage imageNamed:@"i2.jpg"],[UIImage imageNamed:@"i3.jpg"],[UIImage imageNamed:@"i4.jpg"],[UIImage imageNamed:@"i5.jpg"],nil];
    }
    //存放图片的数组
    
}
- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [XGPush startApp:2200052190 appKey:@"I65X7X6NWU3X"];
    //[XGPush startApp:2290000353 appKey:@"key1"];
    
    //注销之后需要再次注册前的准备
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(sysVer < 8){
        [self registerPush];
    }
    else{
        [self registerPushForIOS8];
    }

    [self initArray];
    [self configScrollView];
}
-(void)configScrollView
{
    
   //  @//初始化UIScrollView，设置相关属性，均可在storyBoard中设置
     CGRect frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.navigationController.navigationBarHidden = YES;
     self.myScrollView = [[UIScrollView alloc]initWithFrame:frame];    //scrollView的大小
     self.myScrollView.backgroundColor=[UIColor clearColor];
     self.myScrollView.pagingEnabled=YES;//以页为单位滑动，即自动到下一页的开始边界
     self.myScrollView.showsVerticalScrollIndicator=NO;
     self.myScrollView.showsHorizontalScrollIndicator=NO;//隐藏垂直和水平显示条
    self.myScrollView.delegate=self;
    self.myScrollView.alwaysBounceVertical = NO;
    //UIImageView *firstView=[[UIImageView alloc] initWithImage:[imageArray lastObject]];
    CGFloat Width=self.myScrollView.frame.size.width;
    CGFloat Height=self.myScrollView.frame.size.height;
    //firstView.frame=CGRectMake(0, -20, Width, Height);
    //[self.myScrollView addSubview:firstView];
    //set the last as the first
    
    for (int i=0; i<[imageArray count]; i++) {
        UIImageView *subViews=[[UIImageView alloc] initWithImage:[imageArray objectAtIndex:i]];
        subViews.frame=CGRectMake(Width*i, -20, Width, Height);
        [self.myScrollView addSubview: subViews];
    }
    
    //UIImageView *lastView=[[UIImageView alloc] initWithImage:[imageArray objectAtIndex:0]];
    //lastView.frame=CGRectMake(Width*imageArray.count, -20, Width, Height);
    //[self.myScrollView addSubview:lastView];
    //set the first as the last
    
    [self.myScrollView setContentSize:CGSizeMake(Width*imageArray.count, 0)];
    [self.view addSubview:self.myScrollView];
    //[self.myScrollView scrollRectToVisible:CGRectMake(Width, 0, Width, Height) animated:NO];
    //show the real first image,not the first in the scrollView
    
    
     //@//设置pageControl的位置，及相关属性，可选
//     CGRect pageControlFrame=CGRectMake(100, 160, 78, 36);
//     self.pageControl=[[UIPageControl alloc]initWithFrame:pageControlFrame];
//     
//     [self.pageControl setBounds:CGRectMake(0, 0, 16*(self.pageControl.numberOfPages-1), 16)];//设置pageControl中点的间距为16
//     [self.pageControl.layer setCornerRadius:8];//设置圆角
//    
//    self.pageControl.numberOfPages=imageArray.count;
//    //    self.pageControl.backgroundColor=[UIColor blueColor];//背景
//    self.pageControl.currentPage=0;
//    self.pageControl.enabled=YES;
//    [self.view addSubview:self.pageControl];
//    [self.pageControl addTarget:self action:@selector(pageTurn:)forControlEvents:UIControlEventValueChanged];
//    
  //  myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    
}

#pragma UIScrollView delegate
-(void)scrollToNextPage:(id)sender
{
    int pageNum=self.pageControl.currentPage;
    CGSize viewSize=self.myScrollView.frame.size;
    CGRect rect=CGRectMake((pageNum+2)*viewSize.width, 0, viewSize.width, viewSize.height);
    [self.myScrollView scrollRectToVisible:rect animated:NO];
    pageNum++;
    //if (pageNum==imageArray.count-1) {
       // NSLog(@"asdasd");
    //}
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth=self.myScrollView.frame.size.width;
    int currentPage=floor((self.myScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    if (currentPage==0) {
        self.pageControl.currentPage=imageArray.count-1;
    }else if(currentPage==imageArray.count+1){
        self.pageControl.currentPage=0;
    }
    self.pageControl.currentPage=currentPage-1;
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   // [myTimer invalidate];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   // myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth=self.myScrollView.frame.size.width;
    CGFloat pageHeigth=self.myScrollView.frame.size.height;
    int currentPage=floor((self.myScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    //NSLog(@"the current offset==%f",self.myScrollView.contentOffset.x);
   // NSLog(@"the current page==%d",currentPage);
    if (currentPage==4) {
        if ([UIScreen mainScreen].bounds.size.height>=568) {
            UIButton* but = [[UIButton alloc]initWithFrame:CGRectMake(320*4+95, 451, 132, 30)];
            //[but setBackgroundColor:[UIColor greenColor]];
            [but setImage:[UIImage imageNamed:@"tiyan.png"] forState:UIControlStateNormal];
            [but addTarget:self action:@selector(showManView) forControlEvents:UIControlEventTouchUpInside];
            [self.myScrollView addSubview:but];
        }
        else
        {
            UIButton* but = [[UIButton alloc]initWithFrame:CGRectMake(320*4+95, 402, 132, 30)];
            //[but setBackgroundColor:[UIColor greenColor]];
            [but setImage:[UIImage imageNamed:@"tiyan.png"] forState:UIControlStateNormal];
            [but addTarget:self action:@selector(showManView) forControlEvents:UIControlEventTouchUpInside];
            [self.myScrollView addSubview:but];
        }
    }
    if (currentPage==0) {
        [self.myScrollView scrollRectToVisible:CGRectMake(pageWidth*imageArray.count, 0, pageWidth, pageHeigth) animated:NO];
        self.pageControl.currentPage=imageArray.count-1;
       // NSLog(@"pageControl currentPage==%d",self.pageControl.currentPage);
        //NSLog(@"the last image");
        return;
    }else  if(currentPage==[imageArray count]+1){
        [self.myScrollView scrollRectToVisible:CGRectMake(pageWidth, 0, pageWidth, pageHeigth) animated:NO];
        self.pageControl.currentPage=0;
       // NSLog(@"pageControl currentPage==%d",self.pageControl.currentPage);
       // NSLog(@"the first image");
        return;
    }
    self.pageControl.currentPage=currentPage-1;
    //NSLog(@"pageControl currentPage==%d",self.pageControl.currentPage);
    
}
-(void)showManView
{
    if (flag == 10) {
        UINavigationController *viewController = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
        [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [myScrollView removeFromSuperview];
        [self presentViewController:viewController animated:YES completion:nil];
    }else if(flag == 11)
    {
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBarHidden = NO;
    }
    else
    {
    UINavigationController *viewController = [[UINavigationController alloc]initWithRootViewController:[[Sign_inViewController alloc]init]];
    [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [myScrollView removeFromSuperview];
    [self presentViewController:viewController animated:YES completion:nil];
    }
}
-(void)pageTurn:(UIPageControl *)sender
{
   int pageNum=pageControl.currentPage;
    CGSize viewSize=self.myScrollView.frame.size;
    [self.myScrollView setContentOffset:CGPointMake((pageNum+1)*viewSize.width, 0)];
   // NSLog(@"myscrollView.contentOffSet.x==%f",myScrollView.contentOffset.x);
   // NSLog(@"pageControl currentPage==%d",self.pageControl.currentPage);
    //[myTimer invalidate];
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * deviceTokenStr = [XGPush registerDevice: deviceToken];
    //打印获取的deviceToken的字符串
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:TheCurrentUserDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"++++++++++++++++deviceTokenStr is %@",deviceTokenStr);
    //UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"tishi" message:[NSString stringWithFormat:@"%@",deviceToken] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //[alert show];
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    NSLog(@"%@",str);
    
}
@end