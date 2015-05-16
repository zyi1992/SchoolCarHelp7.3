//
//  postCenterViewViewController.h
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-10.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "RootViewController.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import  "HomeViewController.h"
#import "name_Btn.h"
@interface MyPostView : RootViewController<UIScrollViewDelegate,EGORefreshTableDelegate,UIAlertViewDelegate>
{
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
    int flag ;
    int TheAddTimeNum;
    int TheLastPostNum;
    UIView *blackView;
    UIActivityIndicatorView *activityView;
}
@property(nonatomic)UIScrollView * _scroll ;
@property(nonatomic) UIView *instantLine;
@property(nonatomic) UIView *appointLine;
@property(nonatomic) UIButton *instantIvt;
@property(nonatomic) UIButton *appointIvt;
@property(nonatomic) name_Btn *signBtn;
@property(nonatomic) UILabel *signLable;
@property(nonatomic)NSMutableArray* dataArray;
@end
