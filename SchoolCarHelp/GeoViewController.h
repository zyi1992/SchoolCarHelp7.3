//
//  GeoViewController.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "BaseMapViewController.h"
#import "CustomAnnotationView.h"

@interface GeoViewController :BaseMapViewController<UIGestureRecognizerDelegate>
@property(nonatomic,assign)BOOL whetherGetTheEndPoint;
@property(nonatomic)NSInteger flag;
@end
