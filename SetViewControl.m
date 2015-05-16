//
//  SetViewControl.m
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-17.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "SetViewControl.h"
#import "Sign_inViewController.h"
@interface SetViewControl ()

@end

@implementation SetViewControl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0f];
    [self initTitle:@"设置"];
    if ([UIScreen mainScreen].bounds.size.height>=568) {
         [self initview];
    }else
    {
     [self initviewothers];
    }
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)LogOutCurrentAccout
{
    UIAlertView* alert =[[ UIAlertView alloc]initWithTitle:@"提示" message:@"你确定要退出吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    alert.tag = 555;
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 555) {
        if (buttonIndex == 0) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:TheLastAutoLoginState];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UINavigationController *viewController = [[UINavigationController alloc]initWithRootViewController:[[Sign_inViewController alloc]init]];
            [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
}

-(void)initview
{
    UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Icon"]];
    img.frame = CGRectMake(160-28, 100, 57, 57);
    [self.view addSubview:img];
    UILabel* namelable = [[UILabel alloc]initWithFrame:CGRectMake(110, 160, 120, 20)];
    namelable.text = @"校园拼车助手";
    namelable.textColor  = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
    [self.view addSubview:namelable];
    UILabel* namelable1 = [[UILabel alloc]initWithFrame:CGRectMake(135, 180, 50, 20)];
    namelable1.text = @"V1.0.0";
    namelable1.textColor  = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
    [self.view addSubview:namelable1];
    UILabel* namelable3 = [[UILabel alloc]initWithFrame:CGRectMake(40, 200, 240, 90)];
    namelable3.text = @"校园拼车助手是一款旨在为学生提供贴切生活且保护隐私的拼车服务的软件，致力于为学生排忧解难，解决学生出行由于缺乏交通工具而带来的不便、出行无伴无聊等实际问题。";
    namelable3.font = [UIFont systemFontOfSize:13] ;
    namelable3.textColor  = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
    namelable3.numberOfLines = 0;
    [self.view addSubview:namelable3];
    NSArray* arr = [[NSArray alloc]initWithObjects:@"功能介绍",@"检查更新",@"意见反馈",@"系统通知",nil];
    for (int i = 0; i<4; i++) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 340+i*40, 320, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 90, 20)];
        la.textColor = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
        la.text = [arr objectAtIndex:i];
        if (i==3) {
            UILabel* but = [[UILabel alloc]initWithFrame:CGRectMake(240, 10, 60, 20)];
            but.textColor = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:0.4];
            [view addSubview:but];
            but.text = @"已开启";
            //[but setImage:[UIImage imageNamed:@"campus_homepage_school_more_info_icon"] forState:UIControlStateNormal];
            //[but setTitle:@"已开启" forState:UIControlStateNormal];
            //but.titleLabel.textColor = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
            //but.titleLabel.font = [UIFont systemFontOfSize:14];
                       // but.tag = i;
            ///[but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];


        }
        else
        {
        UIButton* but = [[UIButton alloc]initWithFrame:CGRectMake(290, 10, 20, 20)];
        [but setImage:[UIImage imageNamed:@"campus_homepage_school_more_info_icon"] forState:UIControlStateNormal];
            but.tag = i;
            [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];

        [view addSubview:but];
        }
              [view addSubview:la];
        [self.view addSubview:view];
        UIView* lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 340+i*40, 320, 1)];
        lineview.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        [self.view addSubview:lineview];
    }
    UIView* lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 340+4*40, 320, 1)];
    lineview.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    [self.view addSubview:lineview];
    UIButton *telBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 512, 300, 50)];
    [telBackBtn setBackgroundImage:[UIImage imageNamed:@"我要加入图标"] forState:UIControlStateNormal];
    [telBackBtn addTarget:self action:@selector(LogOutCurrentAccout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:telBackBtn];
    UIButton *telBtn = [[UIButton alloc]initWithFrame:CGRectMake(90, 13, 120, 30)];
    [telBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [telBtn addTarget:self action:@selector(LogOutCurrentAccout) forControlEvents:UIControlEventTouchUpInside];
    telBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [telBackBtn addSubview:telBtn];
}
-(void)initviewothers
{
    UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Icon"]];
    img.frame = CGRectMake(160-28, 80, 57, 57);
    [self.view addSubview:img];
    UILabel* namelable = [[UILabel alloc]initWithFrame:CGRectMake(110, 140, 120, 20)];
    namelable.text = @"校园拼车助手";
    namelable.textColor  = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
    [self.view addSubview:namelable];
    UILabel* namelable1 = [[UILabel alloc]initWithFrame:CGRectMake(135, 160, 50, 20)];
    namelable1.text = @"V1.0.0";
    namelable1.textColor  = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
    [self.view addSubview:namelable1];
    UILabel* namelable3 = [[UILabel alloc]initWithFrame:CGRectMake(40, 180, 240, 90)];
    namelable3.text = @"校园拼车助手是一款旨在为学生提供贴切生活且保护隐私的拼车服务的软件，致力于为学生排忧解难，解决学生出行由于缺乏交通工具而带来的不便、出行无伴无聊等实际问题。";
    namelable3.font = [UIFont systemFontOfSize:13] ;
    namelable3.textColor  = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
    namelable3.numberOfLines = 0;
    [self.view addSubview:namelable3];
    NSArray* arr = [[NSArray alloc]initWithObjects:@"功能介绍",@"检查更新",@"意见反馈",@"系统通知",nil];
    for (int i = 0; i<4; i++) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 280+i*33, 320, 33)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 90, 20)];
        la.textColor = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
        la.text = [arr objectAtIndex:i];
        if (i==3) {
            UILabel* but = [[UILabel alloc]initWithFrame:CGRectMake(240, 10, 60, 20)];
            but.textColor = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:0.4];
            [view addSubview:but];
            but.text = @"已开启";
            //[but setImage:[UIImage imageNamed:@"campus_homepage_school_more_info_icon"] forState:UIControlStateNormal];
            //[but setTitle:@"已开启" forState:UIControlStateNormal];
            //but.titleLabel.textColor = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
            //but.titleLabel.font = [UIFont systemFontOfSize:14];
            // but.tag = i;
            ///[but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        else
        {
            UIButton* but = [[UIButton alloc]initWithFrame:CGRectMake(290, 10, 20, 20)];
            [but setImage:[UIImage imageNamed:@"campus_homepage_school_more_info_icon"] forState:UIControlStateNormal];
            but.tag = i;
            [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:but];
        }
        [view addSubview:la];
        [self.view addSubview:view];
        UIView* lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 280+i*33, 320, 1)];
        lineview.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        [self.view addSubview:lineview];
    }
    UIView* lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 280+4*33, 320, 1)];
    lineview.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    [self.view addSubview:lineview];
    UIButton *telBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 432, 300, 40)];
    [telBackBtn setBackgroundImage:[UIImage imageNamed:@"我要加入图标"] forState:UIControlStateNormal];
    [telBackBtn addTarget:self action:@selector(LogOutCurrentAccout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:telBackBtn];
    UIButton *telBtn = [[UIButton alloc]initWithFrame:CGRectMake(90, 7, 120, 30)];
    [telBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [telBtn addTarget:self action:@selector(LogOutCurrentAccout) forControlEvents:UIControlEventTouchUpInside];
    telBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [telBackBtn addSubview:telBtn];
}

-(void)butClick:(UIButton*)but
{
    if (but.tag == 0) {
        ViewController* view = [[ViewController alloc]init];
        view.flag = 11;
        [self.navigationController pushViewController:view animated:YES];
    }
    else if(but.tag == 1)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂时没有发现更新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (but.tag == 2)
    {
        AdViceView *view = [[AdViceView alloc]init];
        [self.navigationController pushViewController:view animated:YES];
//       UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
//        alert.title = @"输入你的意见";
//        [alert show];
        
    }
}
@end
