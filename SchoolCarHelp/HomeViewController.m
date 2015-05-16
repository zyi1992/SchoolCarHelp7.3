
//
//  MainViewController.m
//  SchoolCarHelp
//
//  Created by OurEDA on 14-8-5.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "HomeViewController.h"
#import "ReGeocodeAnnotation.h"
#import "CommonUtility.h"
#import "GeoViewController.h"
#import "userDefaultHeader.h"
//#import "TieZiViewController.h"
//#import "InvertGeoDetailViewController.h"

@interface HomeViewController ()<UIGestureRecognizerDelegate>

@end

@implementation HomeViewController
@synthesize mapView = _mapView;
@synthesize search  = _search;
@synthesize thePlacename = _thePlacename;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTitle:@"校园拼车助手"];
    CGSize winsize = [[UIScreen mainScreen] bounds].size;
    
       self.mapView=[[MAMapView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, winsize.height)];
    self.mapView.delegate = self;
      self.mapView.showsUserLocation = NO;
    //self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    [self.view addSubview:self.mapView];
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:nil];
    self.search.delegate = self;
    //定位的button
    UIView* bottmButView = [[UIView alloc]init];
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        bottmButView.frame = CGRectMake(0, 350, 320, 150);
        UIButton* locationBut = [[UIButton alloc]initWithFrame:CGRectMake(10, 310, 40, 40)];
        [locationBut setImage:[UIImage imageNamed:@"home_btn_locate_nor.png"] forState:UIControlStateNormal];
        [locationBut addTarget:self action:@selector(getTheCurrentPosition) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:locationBut];
    }
    else
    {
        UIButton* locationBut = [[UIButton alloc]initWithFrame:CGRectMake(10, 390, 40, 40)];
        [locationBut setImage:[UIImage imageNamed:@"home_btn_locate_nor.png"] forState:UIControlStateNormal];
        [locationBut addTarget:self action:@selector(getTheCurrentPosition) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:locationBut];
        bottmButView.frame = CGRectMake(0, 435, 320, 150);
    }
 
    bottmButView.backgroundColor =[UIColor colorWithRed:243/255.f green:243/255.f blue:236/255.f alpha:1.0f];
   // [self.view setBackgroundColor:[UIColor colorWithRed:243/255.f green:243/255.f blue:236/255.f alpha:1.0f]];

    UIButton* starpointBut =[[UIButton alloc]initWithFrame:CGRectMake(280, 10, 30, 30)];
    //starpointBut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"campus_homepage_school_more_info_icon.png"]];
    [starpointBut setBackgroundImage:[UIImage imageNamed:@"campus_homepage_school_more_info_icon.png"] forState:UIControlStateNormal];
    [starpointBut addTarget:self action:@selector(tranToNewStartPlace) forControlEvents:UIControlEventTouchUpInside];
    [bottmButView addSubview:starpointBut];
    UIImage* img = [UIImage imageNamed:@"icon_outset.png"];
    UIImageView* StarPoint_imgview = [[UIImageView alloc]initWithImage:img];
    StarPoint_imgview.frame = CGRectMake(20, 15, 25, 25);
    [bottmButView addSubview:StarPoint_imgview];
    //当前选择的位置显示
    self.thePlacename = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 250, 49)];
    //thePlacename.text = @"某个幼儿园";//.........
    self.thePlacename.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    self.thePlacename.text = @"（长按地图选择一个起点）";
    [bottmButView addSubview:self.thePlacename];
    
    //华丽丽的分割线－－－－－－－－－－－－－－－－－－－－－－
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, 320, 2)];
    lineView.backgroundColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.3f];
    [bottmButView addSubview:lineView];
      //拼车集中营的button
    UIButton* addNewBut = [[UIButton alloc]initWithFrame:CGRectMake(10, 68, 354/2, 106/2)];
        [addNewBut setImage:[UIImage imageNamed:@"button1.png"] forState:UIControlStateNormal];
    [addNewBut addTarget:self action:@selector(tranToInvitation) forControlEvents:UIControlEventTouchUpInside];
    [bottmButView addSubview:addNewBut];
    UIButton* addNewBut1 = [[UIButton alloc]initWithFrame:CGRectMake(5, 10, 45, 28)];
    [addNewBut1 setBackgroundImage:[UIImage imageNamed:@"car.png"] forState:UIControlStateNormal];
    [addNewBut1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //addNewBut1.titleLabel.frame = CGRectMake(10, 10, 100, 40);
    [addNewBut addSubview:addNewBut1];
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(57, 5, 120, 40)];
    lab.text = @"拼车贴集中营";
    lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    lab.textColor = [UIColor whiteColor];
    [addNewBut addSubview:lab];
    //选择终点的but
    UIButton* reservationBut = [[UIButton alloc]initWithFrame:CGRectMake(195, 68, 228/2, 100/2)];
    //reservationBut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yuyue.jpg"]];
    [reservationBut setBackgroundImage:[UIImage imageNamed:@"button2.png"] forState:UIControlStateNormal];
    [reservationBut addTarget:self action:@selector(tranToNewEndPlace) forControlEvents:UIControlEventTouchUpInside];
    UIButton* addNewBut2 = [[UIButton alloc]initWithFrame:CGRectMake(5, 10, 25, 55/2)];
    [addNewBut2 setBackgroundImage:[UIImage imageNamed:@"position.png"] forState:UIControlStateNormal];
    [addNewBut2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //addNewBut1.titleLabel.frame = CGRectMake(10, 10, 100, 40);
    [reservationBut addSubview:addNewBut2];
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(31, 5, 80, 40)];
    lab2.text = @"选择终点";
    lab2.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    lab2.textColor = [UIColor whiteColor];
    [reservationBut addSubview:lab2];
    
    [bottmButView addSubview:reservationBut];
    [self.view addSubview:bottmButView];
    [self initGestureRecognizer];
    //[self performSelector:@selector(getTheCurrentPosition) withObject:nil afterDelay:1.0f];
}
-(void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear: animated];
    self.navigationController.navigationBar.translucent = YES;
    
}

-(void)tranToNewEndPlace //选择终点
{
    if ([self.thePlacename.text isEqualToString:@"（长按地图选择一个起点）"]||[self.thePlacename.text isEqualToString:@"未知地点"]||[self.thePlacename.text length]==0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择一个位置作为你的起点" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        GeoViewController* view = [[GeoViewController alloc]init];
        [self.navigationController pushViewController:view animated:YES];
    }
    
}
- (void)modeAction {
    self.mapView.showsUserLocation = YES;
    //self.mapView.userLocation.title =
    
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //设置 为地图跟着位置移动
    [self.mapView setZoomLevel:16.1 animated:YES];

}
-(void)tranToReservationVC
{
    //预约button点击
}
////获取当前位置＋＋＋＋＋＋＋＋＋＋

-(void)getTheCurrentPosition
{
    [self clearMapView];
    self.thePlacename.text = @"未知地点";
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    [self performSelector:@selector(getTheTitle) withObject:nil afterDelay:1.0f];
}
-(void)getTheTitle
{
       [self searchReGeocodeWithCoordinate:self.mapView.userLocation.location.coordinate];
}
-(void)tranToNewStartPlace
{
        GetTheNewStartPlaceViewViewController* VIEW = [[GetTheNewStartPlaceViewViewController alloc]init];
        VIEW.flag = 1;
        //选择起点位置
        [self.navigationController pushViewController:VIEW animated:YES];
}
-(void)tranToInvitation
{
  
    NSLog(@"---------%@",self.thePlacename.text);
    if ([self.thePlacename.text isEqualToString:@"（长按地图选择一个起点）"]||[self.thePlacename.text isEqualToString:@"未知地点"]||[self.thePlacename.text length]==0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择一个位置作为你的起点" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        postCenterViewViewController* vc = [[postCenterViewViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)gotoDetailForReGeocode:(AMapReGeocode *)reGeocode
{
    if (reGeocode != nil)
    {
    }
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    [self.search AMapReGoecodeSearch:regeo];
    if (self.mapView.userLocation.coordinate.latitude != 0.0) {
        [[NSUserDefaults standardUserDefaults]setDouble:self.mapView.userLocation.coordinate.latitude forKey:ThestartAnnotationCoordinatelatitude];
        [[NSUserDefaults standardUserDefaults]setDouble:self.mapView.userLocation.coordinate.longitude forKey:ThestartAnnotationCoordinatelongitude];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   }

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
    MAAnnotationView *view = views[0];
    if (((NSString*)(id <MAAnnotation>)view.annotation.subtitle).length == 0&&[(NSString*)(id <MAAnnotation>)view.annotation.title length] == 0) {
        UIAlertView* v = [[UIAlertView alloc]initWithTitle:@"提示" message:@"本应用暂不支持国外地图的查询以及定位，请确定你选择的位置在中国境内" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [v show];
        self.thePlacename.text = @"未知地点";
    }
    else
    {
    if (((NSString*)(id <MAAnnotation>)view.annotation.subtitle).length == 0) {
        self.thePlacename.text =(NSString*)(id <MAAnnotation>)view.annotation.title;
        [[NSUserDefaults standardUserDefaults] setObject:self.thePlacename.text forKey:ThestartAnnotationCoordinatetitle];
    }else
    {
        self.thePlacename.text = (NSString*)(id <MAAnnotation>)view.annotation.subtitle;
        [[NSUserDefaults standardUserDefaults] setObject:self.thePlacename.text forKey:ThestartAnnotationCoordinatetitle];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:ThestartAnnotationCoordinatetitle]);
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[ReGeocodeAnnotation class]])
    {
        [self gotoDetailForReGeocode:[(ReGeocodeAnnotation*)view.annotation reGeocode]];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[ReGeocodeAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
  //      if (annotationView == nil)
  //      {
            //annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            annotationView = [[CustomAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier title:annotation.title];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
  //      }
        annotationView.portrait = [UIImage imageNamed:@"起点图标.png"];
        annotationView.name     = annotation.title;
        return annotationView;
    }
    
    return nil;
}
#pragma mark - AMapSearchDelegate

- (void)search:(id)searchRequest error:(NSString *)errInfo
{
    NSLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [searchRequest class], errInfo);
    //UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取位置信息失败，请检查网络状况!" delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:nil,nil]];
    //UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取位置信息失败，请检查网络状况!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //[alert show];
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        ReGeocodeAnnotation *reGeocodeAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate
                                                                                         reGeocode:response.regeocode];
        
        [self.mapView addAnnotation:reGeocodeAnnotation];
        self.navigationController.navigationBar.hidden = NO;
    }
    //self.thePlacename.text =self.mapView.annotations[0].
}

#pragma mark - Handle Gesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        [self clearMapView];
        self.mapView.showsUserLocation = NO;
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[longPress locationInView:self.view]
                                                  toCoordinateFromView:self.mapView];
        [[NSUserDefaults standardUserDefaults] setDouble:coordinate.latitude forKey:ThestartAnnotationCoordinatelatitude];
        [[NSUserDefaults standardUserDefaults] setDouble:coordinate.longitude forKey:ThestartAnnotationCoordinatelongitude];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self searchReGeocodeWithCoordinate:coordinate];
           }
}

#pragma mark - Initialization

- (void)initGestureRecognizer
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(handleLongPress:)];
    longPress.delegate = self;
    longPress.minimumPressDuration = 0.5;
    
    [self.view addGestureRecognizer:longPress];
}

#pragma mark - Life Cycle

    //[super viewWillAppear:animated];
   
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
    //[self clearMapView];
    //[self.navigationController setToolbarHidden:YES animated:animated];
}
- (void)clearMapView
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
}

@end
