//
//  AvatarViewController.h
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-10.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarViewController : UIViewController<UIAlertViewDelegate>
{
    int boyFlag ;
    int girlFlag;
}
@property(nonatomic)UIButton *avaterBtn;
@property(nonatomic)UITextField *nameTf;
@property(nonatomic)UIButton *girlBtn;
@property(nonatomic)UIButton *boyBtn;
@property(nonatomic)UIView *blackView;
@property(nonatomic)UIView *blackBackView;
@property(nonatomic)UIView *avatorView;

@end
