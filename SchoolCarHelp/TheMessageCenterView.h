//
//  postCenterViewViewController.h
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-10.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "RootViewController.h"
#import "userDefaultHeader.h"
@interface TheMessageCenterView : RootViewController<UIScrollViewDelegate>
{
    int flag ;
}
@property(nonatomic)UIScrollView * _scroll ;
@property(nonatomic) UIView *instantLine;
@property(nonatomic) UIView *appointLine;
@property(nonatomic) UIButton *instantIvt;
@property(nonatomic) UIButton *appointIvt;
@property(nonatomic) UIButton *signBtn;
@property(nonatomic) UILabel *signLable;
@end
