//
//  RegisterViewController.h
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-9.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
{
    int flag;
}
@property(nonatomic)UITextField *verifyTf;
@property(nonatomic)UITextField *telTf;
@property(nonatomic)UIButton *verifyBtn;
@property(nonatomic)UIButton *selectBtn;

@end
