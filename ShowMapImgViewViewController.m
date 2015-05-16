//
//  ShowMapImgViewViewController.m
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-3.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "ShowMapImgViewViewController.h"
#import "PostPathViewController.h"
#import "CommonUtility.h"
#import "LineDashPolyline.h"
#import "userDefaultHeader.h"
//const NSString *NavigationViewControllerStartTitle       = @"起点";
//const NSString *NavigationViewControllerDestinationTitle = @"终点";

@interface ShowMapImgViewViewController ()

@property (nonatomic) AMapSearchType searchType;
@property (nonatomic, strong) AMapRoute *route;

/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;

@property (nonatomic, strong) UIBarButtonItem *previousItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;



@end


@implementation ShowMapImgViewViewController
@synthesize searchType  = _searchType;
@synthesize route       = _route;

@synthesize currentCourse = _currentCourse;
@synthesize totalCourse   = _totalCourse;

@synthesize previousItem = _previousItem;
@synthesize nextItem     = _nextItem;

@synthesize startCoordinate         = _startCoordinate;
@synthesize destinationCoordinate   = _destinationCoordinate;
@synthesize thePlacename1 = _thePlacename1;
@synthesize thePlacename2 = _thePlacename2;
@synthesize thePlacename3 = _thePlacename3;



#pragma mark - Utility
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
/* 更新"上一个", "下一个"按钮状态. */
- (void)updateCourseUI
{
    /* 上一个. */
    self.previousItem.enabled = (self.currentCourse > 0);
    
    /* 下一个. */
    self.nextItem.enabled = (self.currentCourse < self.totalCourse - 1);
}

/* 更新"详情"按钮状态. */
- (void)updateDetailUI
{
    self.navigationItem.rightBarButtonItem.enabled = self.route != nil;
}

- (void)updateTotal
{
    NSUInteger total = 0;
    
    if (self.route != nil)
    {
        switch (self.searchType)
        {
            case AMapSearchType_NaviDrive   :
            default: total = 0; break;
        }
    }
    
    self.totalCourse = total;
}

- (BOOL)increaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse < self.totalCourse - 1)
    {
        self.currentCourse++;
        
        result = YES;
    }
    
    return result;
}

- (BOOL)decreaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse > 0)
    {
        self.currentCourse--;
        
        result = YES;
    }
    
    return result;
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    NSArray *polylines = nil;
    
    /* 公交导航. */
    if (self.searchType == AMapSearchType_NaviBus)
    {
        polylines = [CommonUtility polylinesForTransit:self.route.transits[self.currentCourse]];
    }
    /* 步行，驾车导航. */
    else
    {
        polylines = [CommonUtility polylinesForPath:self.route.paths[self.currentCourse]];
    }
    
    [self.mapView addOverlays:polylines];
    
    /* 缩放地图使其适应polylines的展示. */
    self.mapView.visibleMapRect = [CommonUtility mapRectForOverlays:polylines];
    [self initToolBar];
}

/* 清空地图上的overlay. */
- (void)clear
{
    [self.mapView removeOverlays:self.mapView.overlays];
}



#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        polylineRenderer.lineWidth   = 4;
        polylineRenderer.strokeColor = [UIColor magentaColor];
        polylineRenderer.lineDashPattern = @[@5, @10];
        
        return polylineRenderer;
    }
    
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 4;
        polylineRenderer.strokeColor = [UIColor magentaColor];
        
        return polylineRenderer;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *navigationCellIdentifier = @"navigationCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:navigationCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:navigationCellIdentifier];
        }
        poiAnnotationView.canShowCallout = YES;
        if ([[annotation title] isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:ThestartAnnotationCoordinatetitle]])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"起点图标.png"];
        }
        /* 终点. */
        else if([[annotation title] isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:ThedestinationAnnotationCoordinatetitle]])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"终点图标.png"];
        }
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

/* 导航搜索回调. */
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request
                      response:(AMapNavigationSearchResponse *)response
{
    if (self.searchType != request.searchType)
    {
        return;
    }
    
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    [self updateTotal];
    self.currentCourse = 0;
    
    [self updateCourseUI];
    [self updateDetailUI];
    
    [self presentCurrentCourse];
}

#pragma mark - Navigation Search

/* 驾车导航搜索. */
- (void)searchNaviDrive
{
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviDrive;
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapNavigationSearch:navi];
}

/* 根据searchType来执行响应的导航搜索*/
- (void)SearchNaviWithType:(AMapSearchType)searchType
{
    
}

#pragma mark - Handle Action

/* 切换导航搜索类型. */
- (void)searchTypeAction
{
    self.searchType = AMapSearchType_NaviDrive;
    
    self.route = nil;
    self.totalCourse   = 0;
    self.currentCourse = 0;
    
    [self updateDetailUI];
    [self updateCourseUI];
    
    [self clear];
    
    /* 发起导航搜索请求. */
    [self searchNaviDrive];
}



/* 进入详情页面. */
- (void)detailAction
{
    if (self.route == nil)
    {
        return;
    }
    
}

#pragma mark - Initialization

- (void)initToolBar
{
    UIView* bottmButView = [[UIView alloc]init];
    [bottmButView setBackgroundColor:[UIColor whiteColor]];
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        // WithFrame:CGRectMake(0, 430, 320, 568)  <#statements#>
        bottmButView.frame = CGRectMake(0, 417, 320, 180);
    }
    else
    {
        bottmButView.frame = CGRectMake(0, 505, 320, 180);
        
    }
    UIImageView* thePlanImg = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 40, 40)];
    [thePlanImg setImage:[UIImage imageNamed:@"路线规划图标.png"]];
    [bottmButView addSubview:thePlanImg];
    UIView* lineView1 = [[UIView alloc]initWithFrame:CGRectMake(55, 7, 1, 50)];
    [lineView1 setBackgroundColor:[UIColor grayColor]];
    [bottmButView addSubview:lineView1];
    AMapPath* pat = [[AMapPath alloc]init];
    pat = self.route.paths[0];
    self.thePlacename1 = [[UILabel alloc] init];
    self.thePlacename1.text = [NSString stringWithFormat:@"%.1f",pat.distance/1000.f];
    self.thePlacename1.frame =CGRectMake(137, 2, 10+[self.thePlacename1.text length]*10, 35);
    
   // self.thePlacename1.textAlignment = UITextAlignmentLeft;
    self.thePlacename1.text = [NSString stringWithFormat:@"%.1f",pat.distance/1000.f];
    self.thePlacename1.font = [UIFont systemFontOfSize:24.f];
    [self.thePlacename1 setTextColor:[UIColor redColor]];
    [bottmButView addSubview:self.thePlacename1];
    UILabel* thePlacename11 = [[UILabel alloc] initWithFrame:CGRectMake(65, 2, 100, 35)];
    thePlacename11.text = @"全程约";
    thePlacename11.font = [UIFont systemFontOfSize:24.f];
    [bottmButView addSubview:thePlacename11];
    [thePlacename11 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    UILabel* thePlacename12 = [[UILabel alloc] initWithFrame:CGRectMake(142+[self.thePlacename1.text length]*10, 2, 70, 35)];
    thePlacename12.text = @"公里";
    [thePlacename12 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    thePlacename12.font = [UIFont systemFontOfSize:24.f];
    [bottmButView addSubview:thePlacename12];
    
    self.thePlacename2 = [[UILabel alloc] init];
    self.thePlacename2.frame =CGRectMake(148, 30, 15+[self.thePlacename1.text length]*10, 35);
    self.thePlacename2.text = [NSString stringWithFormat:@"%.1f",self.route.taxiCost];
    self.thePlacename2.font = [UIFont systemFontOfSize:21.f];
    [self.thePlacename2 setTextColor:[UIColor redColor]];
    [bottmButView addSubview:self.thePlacename2];
    UILabel* thePlacename21 = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, 130, 35)];
    thePlacename21.text = @"打车约为";
    thePlacename21.font = [UIFont systemFontOfSize:21.f];
    [bottmButView addSubview:thePlacename21];
    [thePlacename21 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    UILabel* thePlacename22 = [[UILabel alloc] initWithFrame:CGRectMake(153+[self.thePlacename2.text length]*10, 30, 20, 35)];
    thePlacename22.text = @"元";
    [thePlacename22 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    thePlacename22.font = [UIFont systemFontOfSize:21.f];
    [bottmButView addSubview:thePlacename22];
    self.thePlacename3 = [[UILabel alloc] initWithFrame:CGRectMake(259, 3, [[NSString stringWithFormat:@"%d",pat.duration/60] length]*9, 35)];
    self.thePlacename3.text = [NSString stringWithFormat:@"%d",pat.duration/60];
   
    self.thePlacename3.font = [UIFont systemFontOfSize:15.f];
    [self.thePlacename3 setTextColor:[UIColor redColor]];
    UILabel* thePlacename31 = [[UILabel alloc] initWithFrame:CGRectMake(229, 3, 30, 35)];
    thePlacename31.text = @"预计";
    thePlacename31.font = [UIFont systemFontOfSize:15.f];
    [bottmButView addSubview:thePlacename31];
    [thePlacename31 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    UILabel* thePlacename32 = [[UILabel alloc] initWithFrame:CGRectMake(258+[self.thePlacename3.text length]*9, 3, 30, 35)];
    thePlacename32.text = @"分钟";
    [thePlacename32 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    thePlacename32.font = [UIFont systemFontOfSize:15.f];
    [bottmButView addSubview:thePlacename32];
    [bottmButView addSubview:self.thePlacename3];
    [self.view addSubview:bottmButView];
}

- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title     = [[NSUserDefaults standardUserDefaults]stringForKey:ThestartAnnotationCoordinatetitle];
   // startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = [[NSUserDefaults standardUserDefaults]stringForKey:ThedestinationAnnotationCoordinatetitle];
    //destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}

#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
    }
    
    return self;
}
-(void)doBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.mapView=[[MAMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.mapView.delegate = self;
    
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    self.mapView.showsUserLocation = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.mapView];
    [self initTitle:@"路线图"];
    UIButton* backBtn = [[UIButton alloc]init];
    self.navigationController.navigationBarHidden = NO;
    backBtn.frame = CGRectMake(0, 0, 25, 20);
    [backBtn setImage:[UIImage imageNamed:@"backBut.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;

    
    [self addDefaultAnnotations];
    
    [self searchTypeAction];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.navigationController.navigationBar.barStyle    = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBack.png"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.toolbar.barStyle      = UIBarStyleBlack;
    //self.navigationController.toolbar.translucent   = YES;
    //[self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBack.png"] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationController setToolbarHidden:YES animated:animated];
}
-(void)tranTosendTopicVC
{
    //转到发帖页面
    PostPathViewController* vc = [[PostPathViewController alloc]init];
    vc.route = self.route;
    [self.navigationController pushViewController:vc animated:NO];
    
}
@end
