//
//  PostPathViewController.h
//  SchoolCarHelp
//
//  Created by OurEDA on 14-8-31.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMapViewController.h"
#import "ShowMapImgViewViewController.h"
@interface PostPathViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    NSString* bookTime;
    NSInteger limittime;
}

@property(nonatomic,retain)UILabel* thePlacename1;
@property(nonatomic,retain)UILabel* thePlacename2;
@property(nonatomic,retain)UILabel* thePlacename3;
@property(nonatomic,retain)UILabel* timelable;
@property(nonatomic,retain)UILabel* personNumlable;
@property (nonatomic, strong) AMapRoute *route;
@property(nonatomic ,retain)NSMutableArray* pickarray;
@property(nonatomic ,retain)UIPickerView*pickview;
@property(nonatomic ,retain)UITextView* textview;
@property(nonatomic,retain)UIImageView* imgview;
@property(nonatomic,retain)UIView* moreinfoView;
@property(nonatomic,retain)UIView* lineView;
@property(nonatomic,retain)UIButton* immediatelBut;
@property(nonatomic,retain)UIButton*appointmentBut;
@property(nonatomic,retain)UIView* thetimeview;
@property(nonatomic,retain)UIDatePicker* datePick;
@property(nonatomic,retain)NSDate* datetime;
@property(nonatomic) UIActivityIndicatorView *activityView;
@property(nonatomic) UIView *blackView;
@end
