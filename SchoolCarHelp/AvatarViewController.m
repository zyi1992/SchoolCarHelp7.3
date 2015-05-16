//
//  AvatarViewController.m
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-10.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "AvatarViewController.h"
#import "secretViewController.h"
#import "name_Btn.h"
#import "userDefaultHeader.h"
@interface AvatarViewController ()

@end

@implementation AvatarViewController
@synthesize avaterBtn;
@synthesize nameTf;
@synthesize boyBtn;
@synthesize girlBtn;
@synthesize blackView;
@synthesize blackBackView;
@synthesize avatorView;
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

- (void)avaterViewLoad
{
    avaterBtn = [[UIButton alloc]initWithFrame:CGRectMake(110, 82, 100, 100)];
    [avaterBtn setBackgroundImage:[UIImage imageNamed:@"选择头像"] forState:UIControlStateNormal];
    [avaterBtn addTarget:self action:@selector(setAvater) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:avaterBtn];
    
    UILabel *avaterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 170, 320, 40)];
    avaterLabel.text = @"设置头像";
    avaterLabel.textAlignment = NSTextAlignmentCenter;
    avaterLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    [self.view addSubview:avaterLabel];
    
    for (int i = 0; i < 2; i ++) {
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 250 + i*50, 320, 50)];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.userInteractionEnabled = YES;
        [self.view addSubview:whiteView];
        
        if (i == 0) {
            UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 30)];
            telLabel.text = @"昵称";
            telLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
            [whiteView addSubview:telLabel];
            
            nameTf = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, 160, 30)];
            nameTf.placeholder = @"请写下昵称";
            nameTf.returnKeyType = UIReturnKeyDone;
            [whiteView addSubview:nameTf];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 50, 305, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
            [whiteView addSubview:lineView];
            
        } else {
            
            UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 30)];
            telLabel.text = @"性别";
            telLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
            [whiteView addSubview:telLabel];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, 305, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
            [whiteView addSubview:lineView];
            
            boyBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 10, 30, 30)];
            [boyBtn setBackgroundImage:[UIImage imageNamed:@"group_ic_sex_male_prs"] forState:UIControlStateNormal];
            [boyBtn addTarget:self action:@selector(boyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:boyBtn];
            
            girlBtn = [[UIButton alloc]initWithFrame:CGRectMake(160, 10, 30, 30)];
            [girlBtn setBackgroundImage:[UIImage imageNamed:@"group_ic_sex_female_"] forState:UIControlStateNormal];
            [girlBtn addTarget:self action:@selector(girlBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:girlBtn];
            
        }
    }
    
    UIButton *landBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 400, 300, 45)];
    [landBtn setBackgroundImage:[UIImage imageNamed:@"确认下一步button"] forState:UIControlStateNormal];
    [landBtn setTitle:@"确认注册" forState:UIControlStateNormal];
    [landBtn addTarget:self action:@selector(landIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:landBtn];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    boyFlag = 1;
    girlFlag = 2;
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    
    [self initTitle:@"设置头像"];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 30)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backToLand) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDo)];
    [self.view addGestureRecognizer:singleTap];
    [self avaterViewLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Target
-(void)landIn
{
    NSMutableString *urll = [NSMutableString stringWithString:TheRequestUrl];
    [urll appendFormat:@"Register"];
    NSURL *url = [NSURL URLWithString:urll];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSMutableData* body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"Phone=%@&NickName=%@&Sex=%d&Password=%@&Avator=%d",[[NSUserDefaults standardUserDefaults] stringForKey:TheRegistPhoneNum],nameTf.text,boyFlag, [[NSUserDefaults standardUserDefaults] stringForKey:TheRegistPassword],[[NSUserDefaults standardUserDefaults] integerForKey:TheRegistAvatorname]] dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",[NSString stringWithFormat:@"Phone=%@&NickName=%@&Sex=%d&Password=%@&Avator = %d",[[NSUserDefaults standardUserDefaults] stringForKey:TheRegistPhoneNum],nameTf.text,boyFlag, [[NSUserDefaults standardUserDefaults] stringForKey:TheRegistPassword],[[NSUserDefaults standardUserDefaults] integerForKey:TheRegistAvatorname]]);
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [request setTimeoutInterval:10];
    NSData * returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *response = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"+++++++++++++++++++++%@",response);
    if ([response length]>0) {
        
        UIAlertView* aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        aler.tag = 777;
        [aler show];
    }else
    {
        UIAlertView* aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        aler.tag = 776;
        [aler show];
    }

 
    
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 777) {
          [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)backToLand
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapDo
{
    [nameTf resignFirstResponder];
}

- (void)boyBtnClicked
{
    if (boyFlag) {
        [boyBtn setBackgroundImage:[UIImage imageNamed:@"Person_male_press"] forState:UIControlStateNormal];
        [girlBtn setBackgroundImage:[UIImage imageNamed:@"Person_female"] forState:UIControlStateNormal];
        boyFlag = 0;
        girlFlag = 1;
    }

}

- (void)girlBtnClicked
{
    if (girlFlag) {
        [boyBtn setBackgroundImage:[UIImage imageNamed:@"Person_male"] forState:UIControlStateNormal];
        [girlBtn setBackgroundImage:[UIImage imageNamed:@"Person_female_press"] forState:UIControlStateNormal];
        boyFlag = 1;
        girlFlag = 0;
    }
}

-(void)setAvater
{
    
    blackBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    blackBackView.backgroundColor = [UIColor clearColor];
    blackBackView.userInteractionEnabled = YES;
    [self.view addSubview:blackBackView];
    
    UITapGestureRecognizer *tapBlack = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBlackDo)];
    [blackBackView addGestureRecognizer:tapBlack];
    
    blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.0;
    [blackBackView addSubview:blackView];
    
    avatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 568, 320, 130)];
    avatorView.backgroundColor = [UIColor whiteColor];
    [blackBackView addSubview:avatorView];
    
    for (int i = 0 ;  i < 10; i ++) {
        if (i < 5) {
            name_Btn *nameBtn = [[name_Btn alloc]initWithFrame:CGRectMake(70/6.0+(50 +70/6.0)*i, 10, 50, 50)];
            nameBtn.name = [NSString stringWithFormat:@"头像%d",i+11];
            nameBtn.tag = i+11;
            [nameBtn addTarget:self action:@selector(changeAvater:) forControlEvents:UIControlEventTouchUpInside];
            [nameBtn setBackgroundImage:[UIImage imageNamed:nameBtn.name] forState:UIControlStateNormal];
            [avatorView addSubview:nameBtn];
        } else {
            name_Btn *nameBtn = [[name_Btn alloc]initWithFrame:CGRectMake(70/6.0+(50 +70/6.0)*(i-5), 70, 50, 50)];
            nameBtn.name = [NSString stringWithFormat:@"头像%d",i+11];
            nameBtn.tag = i+11;
            [nameBtn setBackgroundImage:[UIImage imageNamed:nameBtn.name] forState:UIControlStateNormal];
            [nameBtn addTarget:self action:@selector(changeAvater:) forControlEvents:UIControlEventTouchUpInside];
            [avatorView addSubview:nameBtn];
        }
    }
    
    [self avatorViewUp];
    
    
}

- (void)tapBlackDo
{
    [self avatorViewDown];
    
    [blackBackView removeFromSuperview];
//    [blackView removeFromSuperview];
//    [avatorView removeFromSuperview];
}

-(void)changeAvater:(name_Btn *)nameBtn
{
    [avaterBtn setBackgroundImage:[UIImage imageNamed:nameBtn.name] forState:UIControlStateNormal];
    [self avatorViewDown];
    [blackBackView removeFromSuperview];
    [[NSUserDefaults standardUserDefaults]setInteger:nameBtn.tag forKey:TheRegistAvatorname];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UIView
-(void)avatorViewUp
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    avatorView.frame = CGRectMake(0, 205, 320, 130) ;
    blackView.alpha = 0.5;
    [UIView commitAnimations ];
}

-(void)avatorViewDown
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    avatorView.frame = CGRectMake(0, 568, 320, 130) ;
    blackView.alpha = 0.0;
    [UIView commitAnimations ];
}

@end
