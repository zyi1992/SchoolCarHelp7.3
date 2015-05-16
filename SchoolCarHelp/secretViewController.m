//
//  secretViewController.m
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-9.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "secretViewController.h"
#import "RegisterViewController.h"
#import "AvatarViewController.h"
#import "userDefaultHeader.h"
@interface secretViewController ()

@end

@implementation secretViewController
@synthesize passwordTf;
@synthesize rePasswordTf;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
   
    }
    return self;
}

- (void)initTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.textColor        = [UIColor whiteColor];
    titleLabel.text             = title;
    titleLabel.font = [UIFont systemFontOfSize:20.f];
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

- (void)secretViewLoad
{
    for (int i = 0; i < 2; i ++) {
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 90 + i*80, 320, 50)];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.userInteractionEnabled = YES;
        [self.view addSubview:whiteView];
        
        if (i == 0) {
            UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 30)];
            telLabel.text = @"密码";
            telLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
            [whiteView addSubview:telLabel];
            
            passwordTf = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, 160, 30)];
            passwordTf.placeholder = @"请输入密码";
            [passwordTf becomeFirstResponder];
            passwordTf.returnKeyType = UIReturnKeyDone;
            passwordTf.secureTextEntry = YES;
            [whiteView addSubview:passwordTf];
            
        } else {
            
            UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 30)];
            telLabel.text = @"重复密码";
            telLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
            [whiteView addSubview:telLabel];
            
            rePasswordTf = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, 160, 30)];
            rePasswordTf.placeholder = @"请确认密码";
            rePasswordTf.returnKeyType = UIReturnKeyDone;
            rePasswordTf.secureTextEntry = YES;
            [whiteView addSubview:rePasswordTf];
            

        }
    }
    
    UIButton *landBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, 300, 45)];
    [landBtn setBackgroundImage:[UIImage imageNamed:@"确认下一步button"] forState:UIControlStateNormal];
    [landBtn setTitle:@"确认下一步" forState:UIControlStateNormal];
    [landBtn addTarget:self action:@selector(landIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:landBtn];


}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    [self initTitle:@"设置密码"];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 30)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backToLand) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDo)];
    [self.view addGestureRecognizer:singleTap];
    
    [self secretViewLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Target
-(void)backToLand
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapDo
{
    [rePasswordTf resignFirstResponder];
    [passwordTf resignFirstResponder];
}

-(void)landIn
{
    if ([self.passwordTf.text isEqualToString:self.rePasswordTf.text]) {
   
        [[NSUserDefaults standardUserDefaults] setObject:self.passwordTf.text forKey:TheRegistPassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
        AvatarViewController *viewController = [[AvatarViewController alloc]init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入的密码不一致！" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
