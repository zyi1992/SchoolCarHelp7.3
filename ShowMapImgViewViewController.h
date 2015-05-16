//
//  ShowMapImgViewViewController.h
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-3.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "BaseMapViewController.h"

@interface ShowMapImgViewViewController : BaseMapViewController

@property(nonatomic,retain)UILabel* thePlacename1;
@property(nonatomic,retain)UILabel* thePlacename2;
@property(nonatomic,retain)UILabel* thePlacename3;
/* 起始点经纬度. */
@property (nonatomic,assign) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic,assign) CLLocationCoordinate2D destinationCoordinate;

@end
