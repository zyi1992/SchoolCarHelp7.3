//
//  PersonViewController.m
//  SchoolCarHeipMa
//
//  Created by OurEDA on 14-9-4.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "PersonViewController.h"
#import "userDefaultHeader.h"
#import  "Sign_inViewController.h"
#import "HomeViewController.h"
#import "postCenterViewViewController.h"
//#import "PersonViewController.h"
#import "TheMessageCenterView.h"
#import "MyPostView.h"
#import "ViewController.h"
#import "SetViewControl.h"
@interface PersonViewController ()

@end

@implementation PersonViewController
@synthesize WhetherIsTheUserSelfPost;
@synthesize Userid;
@synthesize _scroll;
@synthesize boyBtn;
@synthesize girlBtn;
@synthesize nameTf;
@synthesize personTf;
@synthesize nameLabel;
@synthesize schoolLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.view.backgroundColor = [UIColor whiteColor];
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
-(void)getInfo
{
    //NSDictionary* dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:TheCurrentUserInfo];
    //if (![[dict objectForKey:@"UserId"] isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"TheCUrrentUserId"]]) {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://cai.chinacloudsites.cn/CAI/CAI/GetUser"]];
    NSMutableData* body = [NSMutableData data];
    NSString* a = [[NSUserDefaults standardUserDefaults] stringForKey:@"TheCUrrentUserId"];
    NSLog(@"%@",a);
    [body appendData:[[NSString stringWithFormat:@"Id=%@",a]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [request setTimeoutInterval:10];
    // NSError *error = [[NSError alloc]init];
    //NSURLResponse* a = [[NSURLResponse alloc]init];
    NSData * returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (returnData) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
        if (![[dic  objectForKey:@"Avator"] isEqual:[NSNull null]] )
        {
            [avaterBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"头像%@",[dic objectForKey:@"Avator"]]] forState:UIControlStateNormal] ;
            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"Avator"] forKey:TheCurrentUserPicnum];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
            if (![[dic  objectForKey:@"NickName"] isEqual:[NSNull null]] ) {
                nameLabel.text = [dic  objectForKey:@"NickName"];
            }
            else
            {
                nameLabel.text = @"未知";
            }
            if (![[dic objectForKey:@"Phone"] isEqual:[NSNull null]]) {
                numberLabel.text = [dic objectForKey:@"Phone"];
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"Phone"] forKey:ThePostUserPhoneNum];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                numberLabel.text =@"未知";
            }
            if (![[dic objectForKey:@"School"] isEqual:[NSNull null]]) {
                schoolLabel.text = [dic objectForKey:@"School"];
            }
            else
            {
                schoolLabel.text =@"未知";
            }

            if (![[dic objectForKey:@"Sex"] isEqual:[NSNull null]]) {
                if ([[dic objectForKey:@"Sex"] isEqual:[NSNumber numberWithInt:1]]) {
                  
                    
                    girlBtn = [[UIButton alloc]initWithFrame:CGRectMake(145, 102, 25, 25)];
                      [girlBtn setBackgroundImage: [UIImage imageNamed:@"Person_female_press"] forState:UIControlStateNormal];
                    [contentView addSubview:girlBtn];
                    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:TheCurrentUserSex];
                }
                else
                {
                    boyBtn = [[UIButton alloc]initWithFrame:CGRectMake(105, 102, 25, 25)];
                    [boyBtn setBackgroundImage: [UIImage imageNamed:@"Person_male_press"] forState:UIControlStateNormal];
                    [contentView addSubview:boyBtn];
                    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:TheCurrentUserSex];
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                boyBtn = [[UIButton alloc]initWithFrame:CGRectMake(105, 102, 25, 25)];
                [boyBtn setBackgroundImage: [UIImage imageNamed:@"Person_male_press"] forState:UIControlStateNormal];
                [contentView addSubview:boyBtn];
            }
            if (![[dic objectForKey:@"Name"] isEqual:[NSNull null]]) {
                nameTf.text =[dic objectForKey:@"Name"] ;
            }
            else
            {
                nameTf.text  = @"未填写";
            }
            if (![[dic objectForKey:@"Motto"] isEqual:[NSNull null]]) {
                personTf.text = [dic objectForKey:@"Motto"];
            }
            
        }
    [blackView removeFromSuperview];

}
-(void)_scrollViewLoad
{
        boyFlag = 1;
        girlFlag = 1;
        _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _scroll.contentSize = CGSizeMake(320, 610);
        _scroll.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_scroll];

        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDo)];
        [self.view addGestureRecognizer:singleTap];
    
        UIImageView *avaterBackImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 240)];
        avaterBackImgView.backgroundColor = [UIColor whiteColor];
        avaterBackImgView.image = [UIImage imageNamed:@"Person_background"];
        avaterBackImgView.userInteractionEnabled = YES;
        [_scroll addSubview:avaterBackImgView];
    
        avaterBtn = [[UIButton alloc]initWithFrame:CGRectMake(116,74, 89, 89)];
        [avaterBackImgView addSubview:avaterBtn];
    
        nameLabel = [[UITextField alloc]initWithFrame:CGRectMake(0, 170, 320, 40)];
        [nameLabel setEnabled:NO];
        nameLabel.tag = 113;
        nameLabel.delegate = self;
            nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        [avaterBackImgView addSubview:nameLabel];
    
    UIButton *arrowBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 25, 25*154/62.0, 25)];
    [arrowBtn setBackgroundImage:[UIImage imageNamed:@"Person_arrow"] forState:UIControlStateNormal];
    [arrowBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [avaterBackImgView addSubview:arrowBtn];
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 240, 320, 262)];
    contentView.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:contentView];
    NSArray *contentArray = [NSArray arrayWithObjects:@"手机号码",@"所处院校",@"性别",@"真实姓名",@"个性签名",nil];
    
    for (int i = 0; i < 4; i++) {
         UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 46 + 46 * i, 320, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:1.0];
        lineView.alpha = 0.3;
        [contentView addSubview:lineView];
    }
    
    for (int i = 0; i < 5;  i++) {
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 + 46 * i, 75, 26)];
        contentLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        contentLabel.text = (NSString *)[contentArray objectAtIndex:i];
        contentLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
        [contentView addSubview:contentLabel];
    }
    
        numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 13, 200, 25)];
        numberLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        numberLabel.textColor = [UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:1.0];
        [contentView addSubview:numberLabel];
    
        UIImageView *numVerify = [[UIImageView alloc]initWithFrame:CGRectMake(275, 18, 40, 12)];
        numVerify.image = [UIImage imageNamed:@"Person_verify"];
        [contentView addSubview:numVerify];
        schoolLabel = [[UITextField alloc]initWithFrame:CGRectMake(105, 59, 200, 25)];
        schoolLabel.tag = 112;
        schoolLabel.delegate =self;
        [schoolLabel setEnabled:NO];
          schoolLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        schoolLabel.textColor = [UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:1.0];
        [contentView addSubview:schoolLabel];
        UIImageView *schoolVerify = [[UIImageView alloc]initWithFrame:CGRectMake(275, 64, 40, 12)];
        schoolVerify.image = [UIImage imageNamed:@"Person_verify"];
        [contentView addSubview:schoolVerify];
        nameTf = [[UITextField alloc]initWithFrame:CGRectMake(105, 151, 200, 25)];
        nameTf.tag = 114;
        [nameTf setEnabled:NO];
        nameTf.textColor =[UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:1.0];
        nameTf.delegate = self;
        [contentView addSubview:nameTf];
    
        personTf = [[UITextView alloc]initWithFrame:CGRectMake(105, 189, 200, 65)];
        personTf.delegate = self;
        [personTf setEditable:NO];
        personTf.textColor = [UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:1.0];
        personTf.font = [UIFont systemFontOfSize:16];
        //    personTf.backgroundColor = [UIColor redColor];
            [contentView addSubview:personTf];
    if (!WhetherIsTheUserSelfPost) {
        UIButton *resevrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        resevrBtn.frame = CGRectMake(0, 0, 40, 40);
        //[resevrBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [resevrBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [resevrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [resevrBtn addTarget:self action:@selector(tranToExit) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *reserItem = [[UIBarButtonItem alloc] initWithCustomView:resevrBtn];
        self.navigationItem.rightBarButtonItem = reserItem;
    }
    else
    {
        UIButton *telBackBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 512, 300, 50)];
        [telBackBtn setBackgroundImage:[UIImage imageNamed:@"我要加入图标"] forState:UIControlStateNormal];
        [telBackBtn addTarget:self action:@selector(makeAPhoneCall) forControlEvents:UIControlEventTouchUpInside];
        [_scroll addSubview:telBackBtn];
        UIButton *telBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 13, 120, 30)];
        [telBtn setTitle:@"我要联系他" forState:UIControlStateNormal];
        [telBtn addTarget:self action:@selector(makeAPhoneCall) forControlEvents:UIControlEventTouchUpInside];
        telBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        [telBackBtn addSubview:telBtn];
        self.navigationController.navigationBarHidden = YES;
        UIButton* backBtn = [[UIButton alloc]init];
        backBtn.frame = CGRectMake(10, 10, 30, 25);
        [backBtn setImage:[UIImage imageNamed:@"backBut.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
        [_scroll addSubview:backBtn];
    }
    blackView = [[UIView alloc]initWithFrame:CGRectMake(110, ([[UIScreen mainScreen]bounds].size.height-100)/2.0,100, 100)];
    [[blackView layer] setCornerRadius:10.0];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.6;
    [self. view addSubview:blackView];
    
    UILabel *wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 100, 20)];
    wordLabel.text = @"正在加载...";
    wordLabel.textColor = [UIColor whiteColor];
    wordLabel.textAlignment = NSTextAlignmentCenter;
    wordLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [blackView addSubview:wordLabel];
    
    activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(50, 40);
    [activityView startAnimating];
    [blackView addSubview:activityView];
   }
-(void)doBack
{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden =NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
       [self initTitle:@"个人中心"];
    UIButton *resevrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resevrBtn.frame = CGRectMake(0, 0, 40, 40);
    //[resevrBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [resevrBtn setTitle:@"菜单" forState:UIControlStateNormal];
    [resevrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resevrBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *reserItem = [[UIBarButtonItem alloc] initWithCustomView:resevrBtn];
    self.navigationItem.leftBarButtonItem = reserItem;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBack.png"] forBarMetrics:UIBarMetricsDefault];
    [self _scrollViewLoad];
    [self performSelector:@selector(getInfo) withObject:nil afterDelay:0.3];
}
-(void)tranToExit
{
    [nameLabel setEnabled:YES];
    [schoolLabel setEnabled:YES];
    [nameTf setEnabled:YES];
    [personTf setEditable:YES];
    UIButton *resevrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resevrBtn.frame = CGRectMake(0, 0, 40, 40);
    //[resevrBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [resevrBtn setTitle:@"确定" forState:UIControlStateNormal];
    [resevrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resevrBtn addTarget:self action:@selector(tranTosure) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *reserItem = [[UIBarButtonItem alloc] initWithCustomView:resevrBtn];
    self.navigationItem.rightBarButtonItem = reserItem;
}
-(void)tranTosure
{
    [nameLabel setEnabled:NO];
    [schoolLabel setEnabled:NO];
    [nameTf setEnabled:NO];
    [personTf setEditable:NO];
    UIButton *resevrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resevrBtn.frame = CGRectMake(0, 0, 40, 40);
    //[resevrBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [resevrBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [resevrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resevrBtn addTarget:self action:@selector(tranTosure) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *reserItem = [[UIBarButtonItem alloc] initWithCustomView:resevrBtn];
    self.navigationItem.rightBarButtonItem = reserItem;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://cai.chinacloudsites.cn/CAI/CAI/UpdateUser"]];
    NSMutableData* body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"Id=%@&NickName=%@&Name=%@&Avator=%@&Sex=%d&School=%@&Phone=%@&Motto=%@&Password=%@",[[NSUserDefaults standardUserDefaults] stringForKey:TheCUrrentUserId],nameLabel.text,nameTf.text,[[NSUserDefaults standardUserDefaults] objectForKey:TheCurrentUserPicnum],[[NSUserDefaults standardUserDefaults] integerForKey:TheCurrentUserSex],schoolLabel.text,[[NSUserDefaults standardUserDefaults] stringForKey:theLastLoginphone],personTf.text,[[NSUserDefaults standardUserDefaults] stringForKey:theLastLoginPassword]]dataUsingEncoding:NSUTF8StringEncoding]];
    [[NSUserDefaults standardUserDefaults] setObject:nameLabel.text forKey:thecurrentuserNickName];
    [[NSUserDefaults standardUserDefaults] setObject:personTf.text forKey:TheCurrentUserMotto];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [request setTimeoutInterval:10];
    // NSError *error = [[NSError alloc]init];
    //NSURLResponse* a = [[NSURLResponse alloc]init];
    NSData * returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* returnStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@000000000000000",returnStr);
    if ([returnStr isEqualToString:@"Ok"]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)makeAPhoneCall
{
    NSString* str = [NSString stringWithFormat:@"你将要给%@打电话",[[NSUserDefaults standardUserDefaults] stringForKey:ThePostUserPhoneNum]];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 56;
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Target Action
-(void)backBtnClicked
{
    //这里是返回按钮；
    NSLog(@"hhhhhh");
}

-(void)telephone
{
    //打电话在这里
    NSLog(@"llllllllll");
}

-(void)boyBtnClicked
{
    if (boyFlag) {
        [boyBtn setBackgroundImage:[UIImage imageNamed:@"Person_male_press"] forState:UIControlStateNormal];
         [girlBtn setBackgroundImage:[UIImage imageNamed:@"Person_female"] forState:UIControlStateNormal];
        boyFlag = 0;
        girlFlag = 1;
        
    }
    
}

-(void)girlBtnClicked
{
    if (girlFlag) {
        [boyBtn setBackgroundImage:[UIImage imageNamed:@"Person_male"] forState:UIControlStateNormal];
        [girlBtn setBackgroundImage:[UIImage imageNamed:@"Person_female_press"] forState:UIControlStateNormal];
        boyFlag = 1;
        girlFlag = 0;
    }
}
-(void)tapDo
{
    [nameTf resignFirstResponder];
    [personTf resignFirstResponder];
    [nameLabel resignFirstResponder];
    [schoolLabel resignFirstResponder];
    [self _scrollReturn];
}

#pragma mark - UITextField
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   // NSLog(@"------------%d",textField.tag);
    if (textField.tag == 114) {
        [self nameTfUp];
    }
    else if(textField.tag == 112)
    {
        [self nameTfUp1];
    }
}

#pragma mark - UITextView
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView isEqual:personTf]) {
        [self personTfUp];
    }
}

#pragma mark - UIView
-(void)nameTfUp
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.view.center = CGPointMake(160, 130);
    [UIView commitAnimations];
}
-(void)nameTfUp1
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.view.center = CGPointMake(160, 200);
    [UIView commitAnimations];
}


-(void)personTfUp
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
   self.view.center = CGPointMake(160, 110);
    [UIView commitAnimations];
}

-(void)_scrollReturn
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.view.center = CGPointMake(160, 568/2);
    [UIView commitAnimations];
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==56) {
        if (buttonIndex == 0) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[[NSUserDefaults standardUserDefaults] stringForKey:ThePostUserPhoneNum]]]];
            NSLog(@"asdasdasd");
        }
    }
}
- (void)showMenu
{
    if (!_sideMenu) {
        RESideMenuItem* mainView = [[RESideMenuItem alloc]initWithTitle:@"主页" image:[UIImage imageNamed:@"主页图标"] highlightedImage:[UIImage imageNamed:@"主页图标"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            HomeViewController *viewController = [[HomeViewController alloc] init];
            viewController.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [menu setRootViewController:navigationController];
        }];
        RESideMenuItem* messageView = [[RESideMenuItem alloc]initWithTitle:@"消息中心" image:[UIImage imageNamed:@"消息中心图标"] highlightedImage:[UIImage imageNamed:@"消息中心图标"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            TheMessageCenterView *secondViewController = [[TheMessageCenterView alloc] init];
            secondViewController.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
            [menu setRootViewController:navigationController];
        }];
        RESideMenuItem* mypostView = [[RESideMenuItem alloc]initWithTitle:@"我的拼车帖" image:[UIImage imageNamed:@"我的拼车帖图标"] highlightedImage:[UIImage imageNamed:@"我的拼车帖图标"]action:^(RESideMenu *menu, RESideMenuItem *item) {
            MyPostView*secondViewController1 = [[MyPostView alloc] init];
            secondViewController1.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController1];
            [menu setRootViewController:navigationController];
            
        }];
        RESideMenuItem* postView = [[RESideMenuItem alloc]initWithTitle:@"帮助" image:[UIImage imageNamed:@"用户指南图标"] highlightedImage:[UIImage imageNamed:@"用户指南图标"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            ViewController *secondViewController2 = [[ViewController alloc] init];
            secondViewController2.title = item.title;
            secondViewController2.flag=10;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController2];
            [menu setRootViewController:navigationController];
        }];
        RESideMenuItem* personself = [[RESideMenuItem alloc]initWithTitle:@"个人中心" image:[UIImage imageNamed:@"退出账号图标"] highlightedImage:[UIImage imageNamed:@"退出账号图标"]  action:^(RESideMenu *menu, RESideMenuItem *item) {
            PersonViewController *secondViewController3 = [[PersonViewController alloc] init];
            secondViewController3.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController3];
            [menu setRootViewController:navigationController];
        }];
        RESideMenuItem* aaa = [[RESideMenuItem alloc]initWithTitle:@"设置" image:[UIImage imageNamed:@"设置图标"] highlightedImage:[UIImage imageNamed:@"设置图标"] action:^(RESideMenu *menu, RESideMenuItem *item) {
            SetViewControl *secondViewController4 = [[SetViewControl alloc] init];
            secondViewController4.title = item.title;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController4];
            [menu setRootViewController:navigationController];
            
        }];
        _sideMenu = [[RESideMenu alloc] initWithItems:@[mainView, personself,mypostView,messageView,postView,aaa]];
       // UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked)];
       // [ _sideMenu.tableView.tableHeaderView addGestureRecognizer:singleTap];
        _sideMenu.verticalOffset = IS_WIDESCREEN ? 110 : 76;
        _sideMenu.hideStatusBarArea = [AppDelegate OSVersion]<7;
    }
    [_sideMenu show];
}

//- (void)showMenu
//{
//    if (!_sideMenu) {
//        RESideMenuItem* mainView = [[RESideMenuItem alloc]initWithTitle:@"主页" image:[UIImage imageNamed:@"主页图标"] highlightedImage:[UIImage imageNamed:@"主页图标"] action:^(RESideMenu *menu, RESideMenuItem *item) {
//            HomeViewController *viewController = [[HomeViewController alloc] init];
//            viewController.title = item.title;
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//            [menu setRootViewController:navigationController];
//        }];
//        RESideMenuItem* messageView = [[RESideMenuItem alloc]initWithTitle:@"消息中心" image:[UIImage imageNamed:@"消息中心图标"] highlightedImage:[UIImage imageNamed:@"消息中心图标"] action:^(RESideMenu *menu, RESideMenuItem *item) {
//            TheMessageCenterView *secondViewController = [[TheMessageCenterView alloc] init];
//            secondViewController.title = item.title;
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
//            [menu setRootViewController:navigationController];
//        }];
//        RESideMenuItem* mypostView = [[RESideMenuItem alloc]initWithTitle:@"我的拼车帖" image:[UIImage imageNamed:@"我的拼车帖图标"] highlightedImage:[UIImage imageNamed:@"我的拼车帖图标"]action:^(RESideMenu *menu, RESideMenuItem *item) {
//            MyPostView*secondViewController1 = [[MyPostView alloc] init];
//            secondViewController1.title = item.title;
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController1];
//            [menu setRootViewController:navigationController];
//            
//        }];
//        RESideMenuItem* postView = [[RESideMenuItem alloc]initWithTitle:@"关于我们" image:[UIImage imageNamed:@"用户指南图标"] highlightedImage:[UIImage imageNamed:@"用户指南图标"] action:^(RESideMenu *menu, RESideMenuItem *item) {
//            postCenterViewViewController *secondViewController1 = [[postCenterViewViewController alloc] init];
//            secondViewController1.title = item.title;
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController1];
//            [menu setRootViewController:navigationController];
//        }];
//        RESideMenuItem* personself = [[RESideMenuItem alloc]initWithTitle:@"个人中心" image:[UIImage imageNamed:@"退出账号图标"] highlightedImage:[UIImage imageNamed:@"退出账号图标"]  action:^(RESideMenu *menu, RESideMenuItem *item) {
//            PersonViewController *secondViewController = [[PersonViewController alloc] init];
//            secondViewController.title = item.title;
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
//            [menu setRootViewController:navigationController];
//        }];
//        RESideMenuItem* aaa = [[RESideMenuItem alloc]initWithTitle:@"设置" image:[UIImage imageNamed:@"设置图标"] highlightedImage:[UIImage imageNamed:@"设置图标"] action:^(RESideMenu *menu, RESideMenuItem *item) {
//            //
//        }];
//        
//        _sideMenu = [[RESideMenu alloc] initWithItems:@[mainView, personself,mypostView,messageView,postView,aaa]];
//               _sideMenu.verticalOffset = IS_WIDESCREEN ? 110 : 76;
//        _sideMenu.hideStatusBarArea = [AppDelegate OSVersion]<7;
//    }
//    [_sideMenu show];
//}

@end
