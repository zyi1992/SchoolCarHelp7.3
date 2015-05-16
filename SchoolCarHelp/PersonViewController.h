//
//  PersonViewController.h
//  SchoolCarHeipMa
//
//  Created by OurEDA on 14-9-4.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RESideMenu.h"
@interface PersonViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    int boyFlag ;
    int girlFlag ;
    UITextField *nameLabel;
    UITextField *schoolLabel;
    UIButton *avaterBtn;
    UILabel *numberLabel;
    UIView *contentView;
    UIView *blackView;
    UIActivityIndicatorView *activityView;
}
@property(nonatomic)UIScrollView * _scroll;
@property(nonatomic)UIButton *boyBtn;
@property(nonatomic)UIButton *girlBtn;
@property(nonatomic)UITextField *nameTf;
@property(nonatomic)UITextView *personTf;
@property(nonatomic) UITextField *schoolLabel;
@property(nonatomic) UITextField *nameLabel;
@property(nonatomic)BOOL WhetherIsTheUserSelfPost;
@property(nonatomic)NSString* Userid;
@property (strong, readonly, nonatomic) RESideMenu *sideMenu;
@end
