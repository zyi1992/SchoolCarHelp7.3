//
//  RegisterViewController.m
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-9.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "RegisterViewController.h"
#import "Sign_inViewController.h"
#import "secretViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize telTf;
@synthesize verifyTf;
@synthesize verifyBtn;
@synthesize selectBtn;

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

-(void)RegisterViewLoad
{
    for (int i = 0; i < 2; i ++) {
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 90 + i*80, 320, 50)];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.userInteractionEnabled = YES;
        [self.view addSubview:whiteView];
        
        if (i == 0) {
            UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 130, 30)];
            telLabel.text = @"手机号码   ＋86";
            telLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
            [whiteView addSubview:telLabel];
            
            telTf = [[UITextField alloc]initWithFrame:CGRectMake(140, 10, 160, 30)];
            telTf.placeholder = @"请输入您的手机号码";
            [telTf becomeFirstResponder];
            [whiteView addSubview:telTf];
        
        } else {
            verifyTf = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 160, 30)];
            verifyTf.placeholder = @"等待获取验证码";
            [verifyTf setEnabled:NO];
            [whiteView addSubview:verifyTf];
            
            verifyBtn = [[UIButton alloc]initWithFrame:CGRectMake(210, 4, 100, 42)];
            [verifyBtn setBackgroundImage:[UIImage imageNamed:@"获取验证码button"] forState:UIControlStateNormal];
            [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [verifyBtn addTarget:self action:@selector(verify) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:verifyBtn];
        }
    }
    
    
    selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 250, 20, 20)];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"单选框未选择"] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    
    UILabel *selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 250, 100, 20)];
    selectLabel.text = @"阅读并同意";
    selectLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    [self.view addSubview:selectLabel];
    
    UILabel *agreementLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 250, 150, 20)];
    agreementLabel.text = @"《校园拼车助手注册协议》";
    agreementLabel.textColor = [UIColor colorWithRed:76/255.0 green:193/255.0 blue:210/255.0 alpha:1.0];
    agreementLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:agreementLabel];
    UIButton *landBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, 300, 45)];
    [landBtn setBackgroundImage:[UIImage imageNamed:@"确认下一步button"] forState:UIControlStateNormal];
    [landBtn setTitle:@"确认下一步" forState:UIControlStateNormal];
    [landBtn addTarget:self action:@selector(landIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:landBtn];
    

    
}



-(int)getRandomNumber:(int)from to:(int)to
{
     return (int)(from + (arc4random() % (to - from + 1)));
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];

    
    [self initTitle:@"使用手机号注册"];

    
    flag = 1;

    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 30)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backToLand) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDo)];
    [self.view addGestureRecognizer:singleTap];
    
    [self RegisterViewLoad];
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

-(void)verify
{
    verifyTf.text = [NSString stringWithFormat:@"%d",[self getRandomNumber:1000 to:10000]];
    [verifyBtn setBackgroundImage:[UIImage imageNamed:@"已获取button"] forState:UIControlStateNormal];
    [verifyBtn setTitle:@"自动生成"forState:UIControlStateNormal];
    verifyBtn.userInteractionEnabled = NO;
}

-(void)tapDo
{
    [telTf resignFirstResponder];
    [verifyTf resignFirstResponder];
}

-(void)landIn
{
    if ([self.telTf.text length]==11) {
        [[NSUserDefaults standardUserDefaults] setObject:self.telTf.text forKey:TheRegistPhoneNum];
        [[NSUserDefaults standardUserDefaults] synchronize];
        secretViewController *viewController = [[secretViewController alloc]init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入11位的手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
   }

-(void)select
{
    if (flag == 1) {
         [selectBtn setBackgroundImage:[UIImage imageNamed:@"单选框已选择"] forState:UIControlStateNormal];
        flag = 0;
    } else {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"单选框未选择"] forState:UIControlStateNormal];
        flag = 1;
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
