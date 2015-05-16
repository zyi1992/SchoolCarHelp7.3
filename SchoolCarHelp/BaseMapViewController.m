//
//  BaseMapViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "BaseMapViewController.h"
#import "userDefaultHeader.h"
@implementation BaseMapViewController
@synthesize mapView = _mapView;
@synthesize search  = _search;

#pragma mark - Utility

- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
}

- (void)clearSearch
{
    self.search.delegate = nil;
}

#pragma mark - Handle Action

- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [self clearMapView];
    
    [self clearSearch];
}

#pragma mark - AMapSearchDelegate

- (void)search:(id)searchRequest error:(NSString *)errInfo
{
    NSLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [searchRequest class], errInfo);
}

#pragma mark - Initialization

- (void)initMapView
{
    self.mapView=[[MAMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.mapView.delegate = self;
    
    //self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
   // self.mapView.centerCoordinate = CLLocationCoordinate2DMake([[NSUserDefaults standardUserDefaults] doubleForKey:ThestartAnnotationCoordinatelatitude], [[NSUserDefaults standardUserDefaults] doubleForKey:ThestartAnnotationCoordinatelongitude]);
   // [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([[NSUserDefaults standardUserDefaults] doubleForKey:ThestartAnnotationCoordinatelatitude], [[NSUserDefaults standardUserDefaults] doubleForKey:ThestartAnnotationCoordinatelongitude])];
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //设置 为地图跟着位置移动
    
    //[self searchReGeocodeWithCoordinate:self.mapView.userLocation.location.coordinate];

}

- (void)initSearch
{
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    self.search.delegate = self;
}

- (void)initBaseNavigationBar
{
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                            // style:UIBarButtonItemStyleBordered
                                                                          //  target:self
                                                                          //  action:@selector(returnAction)];
}

- (void)initTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.textColor        = [UIColor whiteColor];
    titleLabel.text             = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self initTitle:self.title];
    
    [self initBaseNavigationBar];
    
    [self initMapView];
    
    [self initSearch];
}

@end
