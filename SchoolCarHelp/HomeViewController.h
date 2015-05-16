
//
//  MainViewController.m
//  SchoolCarHelp
//
//  Created by OurEDA on 14-8-5.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "BaseMapViewController.h"
#import "RootViewController.h"
#import "postCenterViewViewController.h"
#import "GetTheNewStartPlaceViewViewController.h"
@interface HomeViewController : RootViewController <MAMapViewDelegate,AMapSearchDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property(nonatomic,strong)UILabel* thePlacename;
@end
