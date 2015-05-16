//
//  NavigationViewController.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "BaseMapViewController.h"
#import "PostPathViewController.h"
@interface NavigationViewController : BaseMapViewController<UIAlertViewDelegate>
@property(nonatomic,retain)UILabel* thePlacename1;
@property(nonatomic,retain)UILabel* thePlacename2;
@property(nonatomic,retain)UILabel* thePlacename3;
@property(nonatomic)NSInteger flag;
/* 起始点经纬度. */
@property (nonatomic,assign) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic,assign) CLLocationCoordinate2D destinationCoordinate;

@end
