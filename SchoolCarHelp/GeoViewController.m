//
//  GeoViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "GeoViewController.h"
#import "GeoDetailViewController.h"
#import "CommonUtility.h"
#import "GeocodeAnnotation.h"
#import "userDefaultHeader.h"
#import "NavigationViewController.h"
#import "ReGeocodeAnnotation.h"
#define GeoPlaceHolder @"名称"

@interface GeoViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *displayController;
//@property (nonatomic, strong) UISearchController *displayController;
@property (nonatomic, strong) NSMutableArray *tips;

@end

@implementation GeoViewController
@synthesize tips = _tips;
@synthesize searchBar = _searchBar;
@synthesize displayController = _displayController;
@synthesize whetherGetTheEndPoint = _whetherGetTheEndPoint;
@synthesize flag;
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
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = YES;
    [self.mapView removeFromSuperview];
    //self.navigationController.navigationBar.hidden = YES;
}
/* 地理编码 搜索. */
- (void)searchGeocodeWithKey:(NSString *)key adcode:(NSString *)adcode
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = key;
    //NSArray*arr = [[NSArray alloc]initWithObjects:@"大连", nil];
    //geo.city = arr;
    if (adcode.length > 0)
    {
        geo.city = @[adcode];
    }
    [self.search AMapGeocodeSearch:geo];
    self.navigationController.navigationBarHidden = NO;
}

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    [self.search AMapInputTipsSearch:tips];
}

/* 清除annotation. */
- (void)clear
{
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)clearAndSearchGeocodeWithKey:(NSString *)key adcode:(NSString *)adcode
{
    /* 清除annotation. */
    [self clear];
    
    [self searchGeocodeWithKey:key adcode:adcode];
}

- (void)gotoDetailForGeocode:(AMapGeocode *)geocode
{
    if (geocode != nil)
    {
        GeoDetailViewController *geoDetailViewController = [[GeoDetailViewController alloc] init];
        geoDetailViewController.geocode = geocode;
        
        [self.navigationController pushViewController:geoDetailViewController animated:YES];
    }
}

- (void)search:(id)searchRequest error:(NSString *)errInfo
{
    NSLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [searchRequest class], errInfo);
    //UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取位置信息失败，请检查网络状况!" delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:nil,nil]];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取位置信息失败，请检查网络状况!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    [self.mapView selectAnnotation:view.annotation animated:YES];
    if (((NSString*)(id <MAAnnotation>)view.annotation.subtitle).length == 0) {
       NSString* text =(NSString*)(id <MAAnnotation>)view.annotation.title;
        [[NSUserDefaults standardUserDefaults] setObject:text forKey:ThedestinationAnnotationCoordinatetitle];
    }else
    {
       NSString* text = (NSString*)(id <MAAnnotation>)view.annotation.subtitle;
        [[NSUserDefaults standardUserDefaults] setObject:text forKey:ThedestinationAnnotationCoordinatetitle];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:ThedestinationAnnotationCoordinatetitle]);
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[GeocodeAnnotation class]])
    {
        [self gotoDetailForGeocode:[(GeocodeAnnotation*)view.annotation geocode]];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[GeocodeAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier title:annotation.title];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        
        annotationView.portrait = [UIImage imageNamed:@"终点图标.png"];
        annotationView.name     = annotation.title;
        
        return annotationView;

    }
    else if ([annotation isKindOfClass:[ReGeocodeAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            //annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            annotationView = [[CustomAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier title:annotation.title];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        
        annotationView.portrait = [UIImage imageNamed:@"终点图标.png"];
        annotationView.name     = annotation.title;
        
        return annotationView;
    }

    
    
    return nil;
}

#pragma mark - AMapSearchDelegate

/* 地理编码回调.*/
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    
    NSMutableArray *annotations = [NSMutableArray array];
    
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:obj];
        //[obj.location ];
        //[geocodeAnnotation
        [annotations addObject:geocodeAnnotation];
    }];
    
    if (annotations.count >= 1)
    {
        [self.mapView setCenterCoordinate:[annotations[0] coordinate] animated:YES];
    }
    [self.mapView addAnnotations:annotations];
    [[NSUserDefaults standardUserDefaults]setDouble:[annotations[0] coordinate].latitude forKey:ThedestinationAnnotationCoordinatelatitude];
    [[NSUserDefaults standardUserDefaults] setDouble:[annotations[0] coordinate].longitude forKey:ThedestinationAnnotationCoordinatelongitude];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.whetherGetTheEndPoint = YES;
}
/* 逆地理编码回调. */

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    //NSLog(@"++++++++++++++++++++");
    
    if (response.regeocode != nil)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        ReGeocodeAnnotation *reGeocodeAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate
                                                                                         reGeocode:response.regeocode];
        
        [self.mapView addAnnotation:reGeocodeAnnotation];
    }
    //self.thePlacename.text =self.mapView.annotations[0].
    self.navigationController.navigationBarHidden = NO;
}


/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips setArray:response.tips];
    
    [self.displayController.searchResultsTableView reloadData];
    //[self.displayController]
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    self.searchBar.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 44);
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    self.searchBar.frame = CGRectMake(0, 60, CGRectGetWidth(self.view.bounds), 44);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *key = searchBar.text;
    
    [self clearAndSearchGeocodeWithKey:key adcode:nil];
    
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = key;
    [self initmap];
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchTipsWithKey:searchString];
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
    }
    
    AMapTip *tip = self.tips[indexPath.row];
    
    cell.textLabel.text = tip.name;
    cell.detailTextLabel.text = tip.adcode;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapTip *tip = self.tips[indexPath.row];
    
    [self clearAndSearchGeocodeWithKey:tip.name adcode:tip.adcode];
    
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = tip.name;
    [self initmap];
}

#pragma mark - Initialization

- (void)initSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.bounds), 44)];
    self.searchBar.barStyle     = UIBarStyleDefault;
    self.searchBar.translucent  = YES;
	self.searchBar.delegate     = self;
    self.searchBar.placeholder  = @"查找你的目的地";
    self.searchBar.tag = 10;
    for(id cc in [self.searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
        
    }
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.searchBar];
}

- (void)initSearchDisplay
{
    self.displayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.displayController.delegate                = self;
    self.displayController.searchResultsDataSource = self;
    self.displayController.searchResultsDelegate   = self;
}

#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
        self.tips = [NSMutableArray array];
        self.whetherGetTheEndPoint = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.mapView.frame = self.view.bounds;
    self.mapView.showsUserLocation = NO;
    self.mapView.delegate = self;
    self.mapView.tag = 7;
    UIButton* backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(0, 0, 25, 20);
    [backBtn setImage:[UIImage imageNamed:@"backBut.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
  //  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(tranToFindWwayView)];
    UIButton *resevrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resevrBtn.frame = CGRectMake(0, 0, 40, 40);
    
    //[resevrBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [resevrBtn setTitle:@"确定" forState:UIControlStateNormal];
    [resevrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resevrBtn addTarget:self action:@selector(tranToFindWwayView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *reserItem = [[UIBarButtonItem alloc] initWithCustomView:resevrBtn];
    self.navigationItem.rightBarButtonItem = reserItem;
    [self initSearchBar];
    [self initSearchDisplay];
    [self initTitle:@"选择终点"];
    [self initGestureRecognizer];
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(30, 90, 290, 60)];
    lable.text = @"选择你的目的地（你要去哪里？）";
    lable.textColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.4f];
    lable.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    [self.view addSubview:lable];
    [self.view setBackgroundColor:[UIColor colorWithRed:243/255.f green:243/255.f blue:236/255.f alpha:1.0f]];
}
-(void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initmap
{
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.searchBar];
}

-(void)tranToFindWwayView
{
    if (self.whetherGetTheEndPoint) {
    NavigationViewController* vc1 = [[NavigationViewController alloc]init];
    vc1.startCoordinate  = CLLocationCoordinate2DMake([[NSUserDefaults standardUserDefaults] doubleForKey:ThestartAnnotationCoordinatelatitude], [[NSUserDefaults standardUserDefaults]doubleForKey:ThestartAnnotationCoordinatelongitude]);
    vc1.destinationCoordinate  = CLLocationCoordinate2DMake([[NSUserDefaults standardUserDefaults] doubleForKey:ThedestinationAnnotationCoordinatelatitude], [[NSUserDefaults standardUserDefaults] doubleForKey:ThedestinationAnnotationCoordinatelongitude]);
    [self.navigationController pushViewController:vc1 animated:YES];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择一个起点" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
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
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[longPress locationInView:self.view]
                                                  toCoordinateFromView:self.mapView];
        [[NSUserDefaults standardUserDefaults] setDouble:coordinate.latitude forKey:ThedestinationAnnotationCoordinatelatitude];
        [[NSUserDefaults standardUserDefaults] setDouble:coordinate.longitude forKey:ThedestinationAnnotationCoordinatelongitude];
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
- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    //self.mapView.delegate = nil;
}
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    [self.search AMapReGoecodeSearch:regeo];
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBack.png"] forBarMetrics:UIBarMetricsDefault];
}
@end
