//
//  Sign_inViewController.h
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-9.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "userDefaultHeader.h"
#import "ReTextField.h"
#import "RegisterViewController.h"
@interface Sign_inViewController : UIViewController<UITextFieldDelegate,NSURLConnectionDataDelegate>
{
    UIView *blackView;
    UIActivityIndicatorView *activityView;
}

@property(nonatomic) UIImageView *imgBack;
@property (nonatomic) UIView *clearView ;
@property(nonatomic) UIView *clearBlackView;
@property (nonatomic) ReTextField *account;
@property (nonatomic) UITextField *password;
@property (nonatomic) NSString *accountStr;
@property (nonatomic) NSUserDefaults *defaults;
@property (nonatomic) NSString *accountDef;
@property (nonatomic) NSString *passWordDef;
@property(nonatomic,strong) NSMutableData *_datas;

@end
