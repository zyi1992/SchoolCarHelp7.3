//
//  Sign_inViewController.m
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-9.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "Sign_inViewController.h"
#import  "userDefaultHeader.h"
@interface Sign_inViewController ()

@end

@implementation Sign_inViewController

@synthesize imgBack;
@synthesize clearView;
@synthesize clearBlackView;
@synthesize password;
@synthesize account;
@synthesize _datas;
@synthesize defaults;
@synthesize passWordDef;
@synthesize accountDef;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        
    }
    return self;
}

- (void)Sign_inViewLoad
{
    
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapClicked:)];
    [clearView addGestureRecognizer:singleTap];
    
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(75.5, [[UIScreen mainScreen]bounds].size.height/5.0-15.5, 166.5, 151.5)];
    logoView.image = [UIImage imageNamed:@"logo"];
    [clearView addSubview:logoView];
    
    UIButton *registBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"register"] forState:UIControlStateNormal];
    registBtn.frame = CGRectMake(75, [[UIScreen mainScreen]bounds].size.height *2.0/3.0+20,50, 50);
    [registBtn addTarget:self action:@selector(registBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:registBtn];
    
    UILabel *registLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, [[UIScreen mainScreen]bounds].size.height *4.0/5.0, 60, 20)];
    registLabel.text = @"注册";
    registLabel.textColor = [UIColor whiteColor];
    registLabel.textAlignment = NSTextAlignmentCenter;
    registLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [clearView addSubview:registLabel];
    
    
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    loginBtn.frame = CGRectMake(205, [[UIScreen mainScreen]bounds].size.height *2.0/3.0+20,50, 50);
    [loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:loginBtn];
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, [[UIScreen mainScreen]bounds].size.height *4.0/5.0, 60, 20)];
    loginLabel.text = @"登录";
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [clearView addSubview:loginLabel];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(280, [[UIScreen mainScreen]bounds].size.height+35, 25, 25)];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn addTarget:self action:@selector(cancelBtnDo) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:cancelBtn];
    
    for (int i = 0 ;i <2 ;i++) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(60, [[UIScreen mainScreen]bounds].size.height *4.0/3.0 -15 +50*i, 200, 2)];
        lineView.backgroundColor = [UIColor whiteColor];
        [clearView addSubview:lineView];
    }
    
    account=[[ReTextField alloc] initWithFrame:CGRectMake(90, [[UIScreen mainScreen]bounds].size.height *4.0/3.0-50 , 180, 35)];
    account.borderStyle=UITextBorderStyleNone;
    account.placeholder=@"请输入用户名";
    account.textColor = [UIColor whiteColor];
    account.delegate = self;
    account.clearButtonMode=UITextFieldViewModeWhileEditing;
    account.backgroundColor=[UIColor clearColor];
    [clearView addSubview:account];
    
    UIImageView *accountView = [[UIImageView alloc]initWithFrame:CGRectMake(60, [[UIScreen mainScreen]bounds].size.height *4.0/3.0-45, 20, 20)];
    accountView.image = [UIImage imageNamed:@"account"];
    [clearView addSubview:accountView];
    
    password=[[ReTextField alloc] initWithFrame:CGRectMake(90, [[UIScreen mainScreen]bounds].size.height *4.0/3.0 ,200, 35)];
    password.placeholder=@"请输入密码";
    password.clearButtonMode=UITextFieldViewModeWhileEditing;
    password.secureTextEntry=YES;
    password.textColor = [UIColor whiteColor];
    password.delegate = self;
    password.backgroundColor=[UIColor clearColor];
    password.borderStyle=UITextBorderStyleNone;
    [clearView addSubview:password];
    
    UIImageView *passwordView = [[UIImageView alloc]initWithFrame:CGRectMake(60, [[UIScreen mainScreen]bounds].size.height *4.0/3.0+5, 20, 20)];
    passwordView.image = [UIImage imageNamed:@"password"];
    [clearView addSubview:passwordView];
    
    UIButton *landBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    landBtn.frame = CGRectMake(60, [[UIScreen mainScreen]bounds].size.height *3.0/2.0, 200, 40);
    [landBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [landBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    landBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    [[landBtn layer] setMasksToBounds:YES];
    [[landBtn layer] setCornerRadius:2.0];
    [[landBtn layer] setBorderWidth:1.0];
    [[landBtn layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [landBtn setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3]];
    [landBtn addTarget:self action:@selector(landBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [clearView addSubview:landBtn];
    
    
    UIButton *forgetBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([UIScreen mainScreen].bounds.size.height>=568) {
         forgetBtn.frame = CGRectMake(185,  [[UIScreen mainScreen]bounds].size.height *3.0/2.0-60, 100, 35);
    }else
    {
         forgetBtn.frame = CGRectMake(185,  [[UIScreen mainScreen]bounds].size.height *3.0/2.0-50, 100, 35);
    }
   
    forgetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
    [clearView addSubview:forgetBtn];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    imgBack.image = [UIImage imageNamed:@"登陆页面底板s5.jpg"];
    imgBack.userInteractionEnabled = YES;
    [self.view addSubview:imgBack];
    
    clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen]bounds].size.height*2)];
    clearView.backgroundColor = [UIColor clearColor];
    clearView.userInteractionEnabled = YES;
    [self.view addSubview:clearView];
    
    clearBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen]bounds].size.height*2)];
    clearBlackView.backgroundColor =[UIColor blackColor];
    clearBlackView.alpha = 0.0;
    [clearView addSubview:clearBlackView];
    
    [self Sign_inViewLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Target
//手势单击屏幕的事件
-(void)singleTapClicked:(UIGestureRecognizer*)gestureRecognizer
{
    //账号密码textField取消第一响应
    [account resignFirstResponder];
    [password resignFirstResponder];
}

//圆圆的登录button
-(void)loginBtnClicked
{
    [self clearViewDown];
}

//cancelBtn
-(void)cancelBtnDo
{
    [self clearViewUp];
}

//登录进入主页面
-(void)landBtnClicked
{   
    if ([account.text isEqual:@""] || [password.text isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码要填哦！" delegate:nil cancelButtonTitle:@"重新填写" otherButtonTitles:nil];
        alertView .backgroundColor = [UIColor clearColor];
        [alertView show];
        
    } else {
        //风火轮
        
        blackView = [[UIView alloc]initWithFrame:CGRectMake(110, ([[UIScreen mainScreen]bounds].size.height-100)/2.0,100, 100)];
        [[blackView layer] setCornerRadius:10.0];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.6;
        [self.view addSubview:blackView];
        
        UILabel *wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 100, 20)];
        wordLabel.text = @"请稍候...";
        wordLabel.textColor = [UIColor whiteColor];
        wordLabel.textAlignment = NSTextAlignmentCenter;
        wordLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        [blackView addSubview:wordLabel];
        
        activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.center = CGPointMake(50, 40);
        [activityView startAnimating];
        [blackView addSubview:activityView];
        NSUserDefaults *defualts = [[NSUserDefaults alloc]init];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:TheLastAutoLoginState];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if(![defualts boolForKey:TheLastAutoLoginState])
        {
            [defualts setObject:account.text forKey:theLastLoginphone];
            [defualts setObject:password.text forKey:theLastLoginPassword];
            [defualts synchronize];
        }
        NSString *strUrl ;
        if ([[NSUserDefaults standardUserDefaults] stringForKey:TheCurrentUserDeviceToken] ) {
            strUrl = [[NSString alloc] initWithFormat:@"http://cai.chinacloudsites.cn/CAI/CAI/Login?Phone=%@&Password=%@&DeviceToken=%@",account.text,password.text,[[NSUserDefaults standardUserDefaults] stringForKey:TheCurrentUserDeviceToken]];

        }
        else
        {
            strUrl = [[NSString alloc] initWithFormat:@"http://cai.chinacloudsites.cn/CAI/CAI/Login?Phone=%@&Password=%@&DeviceToken=ebcbdc48371875c2655f67f866c2fcf406aabad15763adde0239373475a48ada",account.text,password.text];
        }
       NSLog(@"%@",strUrl);
        NSURL *url = [NSURL URLWithString:strUrl];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
        [request setHTTPMethod:@"POST"];
        //[request setHTTPBody:body];
        [request setTimeoutInterval:10];
        // NSError *error = [[NSError alloc]init];
        //NSURLResponse* a = [[NSURLResponse alloc]init];
        NSData * returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (returnData) {
      
          NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
       // NSLog(@"%@",dic);
        if (dic&&[[dic objectForKey:@"Phone"] isEqualToString:account.text])
        {
            //--------------------------
            UINavigationController *viewController = [[UINavigationController alloc]initWithRootViewController:[[HomeViewController alloc]init]];
            [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:viewController animated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TheLastAutoLoginState];
            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"Id"] forKey:TheCUrrentUserId];
            NSLog(@"%@",[dic  objectForKey:@"Avator"]);
            NSString* s = [dic  objectForKey:@"Avator"];
            [[NSUserDefaults standardUserDefaults] setObject:s forKey:TheCurrentUserInfoAvtor];
            if (![[dic objectForKey:@"Motto"] isEqual:[NSNull null]]) {
                 [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"Motto"] forKey:TheCurrentUserMotto];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"未知" forKey:TheCurrentUserMotto];
            }
           
            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"NickName"] forKey:thecurrentuserNickName];
            //NSLog(@"%@",[dic objectForKey:@"Id"] );
            [[NSUserDefaults standardUserDefaults] synchronize];
            [blackView removeFromSuperview];
        }
        else
        {
            [blackView removeFromSuperview];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
        else
        {
            [blackView removeFromSuperview];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];

        }
    }
  
}

- (void)registBtnClicked
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBack"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController setNavigationBarHidden:NO];
    RegisterViewController *RegisterView = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:RegisterView animated:YES];
    
}

#pragma mark - UIView
-(void)clearViewDown
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    clearView.frame = CGRectMake(0, -[[UIScreen mainScreen]bounds].size.height, 320, [[UIScreen mainScreen]bounds].size.height*2) ;
    clearBlackView.alpha = 0.2;
    [UIView commitAnimations ];
}

-(void)clearViewUp
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    clearView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen]bounds].size.height*2) ;
    clearBlackView.alpha = 0;
    [UIView commitAnimations ];
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
