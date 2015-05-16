//
//  PostDetailsViewContrViewController.h
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-4.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMapViewController.h"
#import "ShowMapImgViewViewController.h"
@interface PostDetailsViewContrViewController : UIViewController<UIAlertViewDelegate>
{
    CLLocationCoordinate2D startCoordinate;
    /* 终点经纬度. */
    CLLocationCoordinate2D destinationCoordinate;
    UIView *blackView;
    UIActivityIndicatorView *activityView;

}
@property(nonatomic)UIScrollView *_scroll;
@property(nonatomic,retain)UILabel* thePlacename1;
@property(nonatomic,retain)UILabel* thePlacename2;
@property(nonatomic,retain)UILabel* thePlacename3;
@property(nonatomic,retain)UILabel* timelable;
@property(nonatomic,retain)UILabel* personNumlable;
@property(nonatomic)NSString* thePostId;
@property(nonatomic)NSInteger type;
@property(nonatomic)BOOL WhetherThePostUserSelf;
@property(nonatomic)BOOL WheTherTheUserIsIn;
@end
