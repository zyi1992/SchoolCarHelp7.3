//
//  AppDelegate.h
//  SchoolCarHelp
//
//  Created by OurEDA on 14-8-5.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGPush.h"
#import <MAMapKit/MAMapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,MAMapViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;


+ (NSInteger)OSVersion;

@end
