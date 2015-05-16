//
//  PostDetailsViewContrViewController.m
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-4.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "PostDetailsViewContrViewController.h"
#import "postCenterViewViewController.h"
#import "userDefaultHeader.h"
@interface PostDetailsViewContrViewController ()

@end

@implementation PostDetailsViewContrViewController
@synthesize WhetherThePostUserSelf;
@synthesize thePlacename1 = _thePlacename1;
@synthesize thePlacename2 = _thePlacename2;
@synthesize thePlacename3 = _thePlacename3;
@synthesize timelable = _timelable;
@synthesize thePostId = _thePostId;
@synthesize type;
@synthesize WheTherTheUserIsIn;
@synthesize _scroll;

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   // [self.navigationController.navigationBar setTranslucent:NO];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    _scroll.contentSize = CGSizeMake(320, 610);
    _scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scroll];
    
    [self initTitle:@"帖子详情"];
   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBack.png"] forBarMetrics:UIBarMetricsDefault];
    [self addAnimated];
    [self performSelector:@selector(initView) withObject:nil afterDelay:0.5f];
    
    
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initParticipant
{
    
    NSURL *url = [NSURL URLWithString:@"http://cai.chinacloudsites.cn/CAI/CAI/GetPostLists"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSMutableData* body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"PostId=%@&Type=%d",self.thePostId,self.type-1] dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",[NSString stringWithFormat:@"PostId=%@&Type=%d",self.thePostId,self.type-1] );
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [request setTimeoutInterval:10];
    NSData * returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSArray* dic = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
    //NSLog(@"%@",[dic objectAtIndex:0]);
    if ([dic count] == 0) {
        UILabel *markLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 505, 300, 40)];
        markLabel.text = @"还没人加入你的帖子＝ ＝";
        markLabel.textAlignment = NSTextAlignmentCenter;
        markLabel.textColor = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
        [_scroll addSubview:markLabel];
    } else {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 505, 300, 20)];
        label.text = @"已经加入的小伙伴:";
        label.textColor = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
        [_scroll addSubview:label];
        
        for (int i = 0 ; i<[dic count]; i++) {
            UIButton *View = [[UIButton alloc]initWithFrame:CGRectMake(10+60*i, 525, 50, 50)];

            NSLog(@"%@",[(NSDictionary *)[(NSArray *)dic objectAtIndex:0] objectForKey:@"Avator"]);
            [View setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"头像%@",[(NSDictionary *)[(NSArray *)dic objectAtIndex:i] objectForKey:@"Avator"]]] forState:UIControlStateNormal];
            [_scroll addSubview:View];
            
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+60*i, 580, 50, 20)];
            nameLabel.text = [NSString stringWithFormat:@"%@",[(NSDictionary *)[(NSArray *)dic objectAtIndex:i] objectForKey:@"NickName"]];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.textColor = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
            nameLabel.font = [UIFont systemFontOfSize:14];
            [_scroll addSubview:nameLabel];
        }
        

        
    }
    
//    UIImageView *View = [[UIImageView alloc]initWithFrame:CGRectMake(10, 505, 50, 50)];
//    View.backgroundColor = [UIColor redColor];
//    [_scroll addSubview:View];
}

-(void)sendMessAge
{
    NSString* str = [NSString stringWithFormat:@"您确定向%@发送信息吗？",[[NSUserDefaults standardUserDefaults] stringForKey:ThePostUserPhoneNum]];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 49;
    [alert show];
    
}
-(void)makeAcall
{
    NSString* str = [NSString stringWithFormat:@"您确定向%@打电话吗？",[[NSUserDefaults standardUserDefaults] stringForKey:ThePostUserPhoneNum]];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 50;
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==50) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[[NSUserDefaults standardUserDefaults] stringForKey:ThePostUserPhoneNum]]]];
            //NSLog(@"asdasdasd");
        }
    }
    else if (alertView.tag == 49)
    {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",[[NSUserDefaults standardUserDefaults] stringForKey:ThePostUserPhoneNum]]]];
            //NSLog(@"asdasdasd");
        }

    }
}
-(void)initView
{
    NSURL *url = [NSURL URLWithString:@"http://cai.chinacloudsites.cn/CAI/CAI/GetPost"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSMutableData* body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"Id=%@&Type=%d",self.thePostId,self.type-1] dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",[NSString stringWithFormat:@"Id=%@&Type=%d",self.thePostId,self.type-1] );
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [request setTimeoutInterval:4];
    NSData * returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
    if (![dic isEqual:[NSNull  null]])
    {
    NSDictionary* post = [dic objectForKey:@"Post"];
    NSDictionary* User = [dic objectForKey:@"User"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[User objectForKey:@"Phone"] forKey:ThePostUserPhoneNum];
        [[NSUserDefaults standardUserDefaults]synchronize];
      //  NSLog(@"%@%@",User,post);
    CGSize scsize = [UIScreen mainScreen].bounds.size;
    UIView* imgview  = [[UIView alloc]initWithFrame:CGRectMake(0, -20, scsize.width, (scsize.height)*39/100.0+20)];
   // [imgview setBackgroundColor:[UIColor colorWithRed:200/255.f green:0.f blue:0.f alpha:0.7f]];
        if (type==1) {
                [imgview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"xn02帖子详情底板1.png"]]];
        }
        else
        {
                [imgview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"f42l帖子详情底板2.png"]]];
        }
      UIImageView* headimagView = [[UIImageView alloc]initWithFrame:CGRectMake(imgview.frame.size.width/2.0-50, imgview.frame.size.height/5.0, 100, 100)];
    [imgview setContentMode:UIViewContentModeScaleToFill];
        if (![[User objectForKey:@"Avator"] isEqual:[NSNull null]])
        {
            [headimagView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"头像%@",[User objectForKey:@"Avator"]]]];
        }
        else
        {
            [headimagView setImage:[UIImage imageNamed:@"头像0"]];
        }
    [imgview addSubview:headimagView];
    UILabel* nameLable = [[UILabel alloc]initWithFrame:CGRectMake(imgview.frame.size.width/2.0-100, imgview.frame.size.height*3/4.0, 200 , 40)];
        if (![[User objectForKey:@"NickName"] isEqual:[NSNull null]]) {
            nameLable.text = [User objectForKey:@"NickName"];
        }
        else
        {
            nameLable.text = @"未设置";
        }
    nameLable.font = [UIFont fontWithName:@"HelveticaNeue" size:22.f];
    nameLable.textColor = [UIColor whiteColor];
    nameLable.textAlignment = NSTextAlignmentCenter;
    [imgview addSubview:nameLable];
    
    UIButton* sendMesgBut = [[UIButton alloc]initWithFrame:CGRectMake(15,  imgview.frame.size.height*3/4.0-10, 50, 50)];
    
        UIImageView* imgg1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"发消息.png"]];
        imgg1.frame = CGRectMake(10, 10, 32, 32);
        [sendMesgBut setBackgroundColor:[UIColor whiteColor]];
        [sendMesgBut addSubview:imgg1];
      
        sendMesgBut.layer.masksToBounds = YES;
        sendMesgBut.layer.cornerRadius = 25;
        [sendMesgBut addTarget:self action:@selector(sendMessAge) forControlEvents:UIControlEventTouchUpInside];
        
  
    UIButton* callphoneBut = [[UIButton alloc]initWithFrame:CGRectMake(260,  imgview.frame.size.height*3/4.0-10, 50, 50)];
        [callphoneBut addTarget:self action:@selector(makeAcall) forControlEvents:UIControlEventTouchUpInside];
    [callphoneBut setBackgroundColor:[UIColor whiteColor]];
    callphoneBut.layer.masksToBounds = YES;
    callphoneBut.layer.cornerRadius = 25;
   
    UIImageView* imgg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"联系他.png"]];
    imgg.frame = CGRectMake(10, 10, 32, 32);
    [callphoneBut addSubview:imgg];
    [_scroll addSubview:imgview];
    
    UIView* bottmButView = [[UIView alloc]init];
    [bottmButView setBackgroundColor:[UIColor whiteColor]];
    bottmButView.frame = CGRectMake(0 , (scsize.height-64)*39/100.0+30, 320, (scsize.height-64)*15/100.0);
    self.thePlacename1 = [[UILabel alloc] init];
        if (![[post objectForKey:@"Distance"] isEqual:[NSNull null]]) {
            NSString* str = [post objectForKey:@"Distance"];
            double a = [str doubleValue];
            NSLog(@"%f",a);
             self.thePlacename1.text = [NSString stringWithFormat:@"%.1f",a];//距离负值--------------------
        }else
        {
            self.thePlacename1.text = @"0";
        }
    self.thePlacename1.frame =CGRectMake(77, 2, 10+[self.thePlacename1.text length]*10, 35);
    self.thePlacename1.font = [UIFont systemFontOfSize:22.f];
    [self.thePlacename1 setTextColor:[UIColor redColor]];
    [bottmButView addSubview:self.thePlacename1];
    
    UILabel* thePlacename11 = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 35)];
    thePlacename11.text = @"全程约";
    thePlacename11.font = [UIFont systemFontOfSize:22.f];
    [bottmButView addSubview:thePlacename11];
    [thePlacename11 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
   
    UILabel* thePlacename12 = [[UILabel alloc] initWithFrame:CGRectMake(142-60+[self.thePlacename1.text length]*10, 2, 70, 35)];
    thePlacename12.text = @"公里";
    [thePlacename12 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    thePlacename12.font = [UIFont systemFontOfSize:22.f];
    [bottmButView addSubview:thePlacename12];
    
    self.thePlacename2 = [[UILabel alloc] init];
    self.thePlacename2.frame =CGRectMake(148-15, 30, 15+[self.thePlacename1.text length]*10, 35);
    //打车费用负值－－－－－－－－－
        if (![[post objectForKey:@"Cost"] isEqual:[NSNull null]]) {
            NSString* str = [post objectForKey:@"Cost"];
            double a = [str doubleValue];
            NSLog(@"%f",a);
            self.thePlacename2.text = [NSString stringWithFormat:@"%.1f",a];
        }else
        {
            self.thePlacename2.text = @"0";
        }
        NSLog(@"--------------%@",self.thePlacename2.text);
              self.thePlacename2.font = [UIFont systemFontOfSize:20.f];
    [self.thePlacename2 setTextColor:[UIColor redColor]];
    [bottmButView addSubview:self.thePlacename2];
    
    UILabel* thePlacename21 = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 130, 35)];
    thePlacename21.text = @"打的车费约为";
    thePlacename21.font = [UIFont systemFontOfSize:20.f];
    [bottmButView addSubview:thePlacename21];
    [thePlacename21 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    UILabel* thePlacename22 = [[UILabel alloc] initWithFrame:CGRectMake(153-15+[self.thePlacename2.text length]*10, 30, 20, 35)];
    thePlacename22.text = @"元";
    [thePlacename22 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    thePlacename22.font = [UIFont systemFontOfSize:20.f];
    [bottmButView addSubview:thePlacename22];
    
    UILabel* TheRemainingPersNum = [[UILabel alloc]initWithFrame:CGRectMake(210, 38, 100, 20)];
               TheRemainingPersNum.text = @"剩余车位：";
    TheRemainingPersNum.font = [UIFont systemFontOfSize:17.f];
    TheRemainingPersNum.textColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f] ;
    [bottmButView addSubview:TheRemainingPersNum];
    self.personNumlable = [[UILabel alloc]initWithFrame:CGRectMake(290, 38, 30, 20)];
        if (![[post objectForKey:@"RestCount"] isEqual:[NSNull null]]) {
             self.personNumlable.text =[NSString stringWithFormat:@"%@",[post objectForKey:@"RestCount"]];
        }else
        {
             self.personNumlable.text = @"0";
        }
    self.personNumlable.textColor = [UIColor redColor];
    [bottmButView addSubview:self.personNumlable];
    //打车时间负值－－－－－－－
    NSString* str = [NSString stringWithFormat:@"%@",[post objectForKey:@"Time"]];
    self.thePlacename3 = [[UILabel alloc] initWithFrame:CGRectMake(242, 3, [str length]*9, 35)];
    self.thePlacename3.text = str;
    self.thePlacename3.font = [UIFont systemFontOfSize:15.f];
    [self.thePlacename3 setTextColor:[UIColor redColor]];
    UILabel* thePlacename31 = [[UILabel alloc] initWithFrame:CGRectMake(179, 3, 60, 35)];
    thePlacename31.text = @"预计行驶";
    thePlacename31.font = [UIFont systemFontOfSize:15.f];
    [bottmButView addSubview:thePlacename31];
    [thePlacename31 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    UILabel* thePlacename32 = [[UILabel alloc] initWithFrame:CGRectMake(245+[self.thePlacename3.text length]*9, 3, 30, 35)];
    thePlacename32.text = @"分钟";
    [thePlacename32 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    thePlacename32.font = [UIFont systemFontOfSize:15.f];
    [bottmButView addSubview:thePlacename32];
    [bottmButView addSubview:self.thePlacename3];
    //---------------------------
       UIButton* reservationBut = [[UIButton alloc]initWithFrame:CGRectMake(10, (scsize.height-64)*(39+49)/100.0+63, 300, 50)];
    [reservationBut setBackgroundImage:[UIImage imageNamed:@"查看路线规划图标.png"] forState:UIControlStateNormal];
    [reservationBut addTarget:self action:@selector(joinInTheTopicMethond) forControlEvents:UIControlEventTouchUpInside];
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 100, 40)];
        if (WheTherTheUserIsIn) {
            lable.text = @"我要退出";
        }
        else
        {
            lable.text = @"我要加入";
        }
    [lable setTextColor:[UIColor whiteColor]];
    lable.font = [UIFont systemFontOfSize:25.f];
    [reservationBut addSubview:lable];
    //[bottmButView addSubview:reservationBut];
    [_scroll addSubview:bottmButView];
    //------------------------－－－－－－－－－－－－－－－－
    UIView* positionView = [[UIView alloc]init];
    [positionView setBackgroundColor:[UIColor whiteColor]];
    positionView.frame = CGRectMake(0,  (scsize.height-64)*(39+15)/100.0+30, 320, (scsize.height-64)*16/100.0+64);
    UIButton* starpointBut =[[UIButton alloc]initWithFrame:CGRectMake(270, 15, 34, 34)];
    //starpointBut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"campus_homepage_school_more_info_icon.png"]];
    [starpointBut setBackgroundImage:[UIImage imageNamed:@"查看地图图标.png"] forState:UIControlStateNormal];
    [starpointBut addTarget:self action:@selector(showMapPathImage) forControlEvents:UIControlEventTouchUpInside];
    [positionView addSubview:starpointBut];
    UILabel* lableq = [[UILabel alloc]initWithFrame:CGRectMake(267, 45, 40, 25)];
    lableq.text = @"显示地图";
    lableq.textColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.8f];
    lableq.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    [positionView addSubview:lableq];
    UIImage* img = [UIImage imageNamed:@"起点.png"];
    UIImageView* StarPoint_imgview = [[UIImageView alloc]initWithImage:img];
    StarPoint_imgview.frame = CGRectMake(10, 10, 25, 25);
    [positionView addSubview:StarPoint_imgview];
    //当前选择的位置显示
    UILabel* thestartPlacename = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 200, 40)];
    thestartPlacename.text = [post objectForKey:@"Origin"];//.........
    thestartPlacename.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    thestartPlacename.textColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.8f];
    [positionView addSubview:thestartPlacename];
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 260, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.1f];
    [positionView addSubview:lineView];
    
    UIImage* img1 = [UIImage imageNamed:@"终点.png"];
    UIImageView* desPoint_imgview = [[UIImageView alloc]initWithImage:img1];
    desPoint_imgview.frame = CGRectMake(10, 47, 25, 27);
    
    [positionView addSubview:desPoint_imgview];
    //当前选择的位置显示
    UILabel* thedesPlacename = [[UILabel alloc]initWithFrame:CGRectMake(40, 43, 200, 35)];
    thedesPlacename.text = [post objectForKey:@"Terminal"];//.........
    thedesPlacename.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    thedesPlacename.textColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.8f];
    [positionView addSubview:thedesPlacename];
    [_scroll addSubview:positionView];
    
    
    UIView* timeView = [[UIView alloc]initWithFrame:CGRectMake(0, (scsize.height-64)*(39+31)/100.0+30,320,  (scsize.height-64)*9/100.0+64)];
    UILabel* lable1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 200, 30)];
       
    lable1.textColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.8f];
    lable1.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    [timeView addSubview:lable1];
    UIImageView* img3 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"沙漏图标.png"]];
    img3.frame = CGRectMake(10, 13, 20, 20);
    [timeView addSubview:img3];
    UILabel* lable2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 170, 30)];
        if (type ==1 ) {
            lable1.text = @"报名时间倒计时";
            lable2.frame = CGRectMake(200, 10, 80, 30);
            NSDate*date = [NSDate date];
            long long da = [date timeIntervalSince1970];
            long long db = [[post objectForKey:@"CreateTime"]  longLongValue];
            long long dd = [[post objectForKey:@"TimeLimitation"] longLongValue]*60;
            long long dc =dd -  (da - db);
            NSLog(@"%@  %lld   %lld   %lld    %lld",[post objectForKey:@"TimeLimitation"],da,db,dd,dc);
            if (dc <=0) {
                    lable2.text = @"已截止";
            }
            else
            {
                lable2.text = [NSString stringWithFormat:@"%lld分钟",dc/60];
            }
            //NSLog(@"报名时间倒计时:%@",[post objectForKey:@"TimeLimitation"]);
        }
        else
        {
            lable2.frame = CGRectMake(150, 10, 170, 30);
            lable1.text = @"预计发车时间";
            NSString *string2 = [post objectForKey:@"BookTime"];
            long long dq =[string2 longLongValue];
            NSDate *dd = [[NSDate alloc]initWithTimeIntervalSince1970:dq];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
            dateFormatter.dateFormat = @"yyyy-MM-dd  HH:MM";
            // NSLog(@"%@",[dateFormatter stringFromDate:dd]);
            lable2.text = [dateFormatter stringFromDate:dd];
        }
        lable2.textColor = [UIColor redColor];
    lable2.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    [timeView addSubview:lable2];
    [_scroll addSubview:timeView];
    UIView* messageView = [[UIView alloc]initWithFrame:CGRectMake(0, (scsize.height-64)*(39+40)/100.0+30,320,  (scsize.height-64)*9/100.0+64)];
    UIImageView* img4 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"备注图标.png"]];
    img4.frame = CGRectMake(10, 13, 20, 20);
    [messageView addSubview:img4];
    UILabel*lable21 = [[UILabel alloc]initWithFrame:CGRectMake(40, 5,270,  (scsize.height-64)*12/100.0)];
        if (![[post objectForKey:@"Message"] isEqual:[NSNull null]]) {
             lable21.text = [post objectForKey:@"Message"];
        }
        else
        {
       lable21.text =@"";
        }
    lable21.lineBreakMode = NSLineBreakByWordWrapping;
    lable21.adjustsFontSizeToFitWidth = YES;
    lable21.numberOfLines = 0;
    lable21.textColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.8f];
    //lable21.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    [messageView addSubview:lable21];
    [_scroll addSubview:messageView];
    
        UIView* linview1 = [[UIView alloc]initWithFrame:CGRectMake(0, (scsize.height-64)*(39+15)/100.0+30, 320, 1)];
        linview1.backgroundColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.1f];
        [_scroll addSubview:linview1];
        UIView* linview2= [[UIView alloc]initWithFrame:CGRectMake(0, (scsize.height-64)*(39+31)/100.0+30, 320, 1)];
        linview2.backgroundColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.1f];
        [_scroll addSubview:linview2];
        UIView* linview3 = [[UIView alloc]initWithFrame:CGRectMake(0, (scsize.height-64)*(39+40)/100.0+30, 320, 1)];
        linview3.backgroundColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.1f];
        [_scroll addSubview:linview3];
        UIView* linview4 = [[UIView alloc]initWithFrame:CGRectMake(260, (scsize.height-64)*(39+15)/100.0+30, 1, (scsize.height-64)*16/100.0)];
        linview4.backgroundColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.1f];
        [_scroll addSubview:linview4];
        UIView* linview5 = [[UIView alloc]initWithFrame:CGRectMake(0, (scsize.height-64)*(39+49)/100.0+50, 320, 1)];
        linview5.backgroundColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.1f];
        [_scroll addSubview:linview5];
    
        UIButton* but = [[UIButton alloc]initWithFrame:CGRectMake(10, 25, 77*2/3.0, 31*2/3.0)];
        [but setImage:[UIImage imageNamed:@"0x02箭头.png"] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(butClicked) forControlEvents:UIControlEventTouchUpInside];
        [_scroll addSubview:but];
        NSString* strr = [post objectForKey:@"OriginLatitude"];
        startCoordinate.latitude =[strr doubleValue];
        strr = [post objectForKey:@"OriginLongitude"];
        startCoordinate.longitude = [strr doubleValue];
        strr = [post objectForKey:@"TerminalLatitude"];
        destinationCoordinate.latitude = [strr doubleValue];
        strr = [post objectForKey:@"TerminalLongitude"];
        destinationCoordinate.longitude = [strr doubleValue];
        
        if (WhetherThePostUserSelf) {
            //判断  自己的帖子
            [self initParticipant];
        }
        else
        {
            //他人的帖子
            [imgview addSubview:callphoneBut];
            [imgview addSubview:sendMesgBut];
            [_scroll addSubview:reservationBut];
        }
    }

}
-(void)addAnimated
{
    blackView = [[UIView alloc]initWithFrame:CGRectMake(110, ([[UIScreen mainScreen]bounds].size.height-100)/2.0,100, 100)];
    [[blackView layer] setCornerRadius:10.0];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.6;
    [_scroll addSubview:blackView];
    
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
-(void)joinInTheTopicMethond
{
    //点击我要加入的方
    if (WhetherThePostUserSelf) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你不能加入自己创建的帖子" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if (WheTherTheUserIsIn) {
            NSURL *url = [NSURL URLWithString:@"http://cai.chinacloudsites.cn/CAI/CAI/Out"];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            NSMutableData* body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"UserId=%@&PostId=%@&type=%d",[[NSUserDefaults standardUserDefaults]stringForKey:TheCUrrentUserId],self.thePostId,self.type-1] dataUsingEncoding:NSUTF8StringEncoding]];
            NSLog(@"%@",[NSString stringWithFormat:@"UserId=%@&PostId=%@&type=%d",[[NSUserDefaults standardUserDefaults]stringForKey:TheCUrrentUserId],self.thePostId,self.type-1] );
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:body];
            [request setTimeoutInterval:4];
            NSData * returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString* returnStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            if ([returnStr isEqualToString:@"Ok"]) {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"成功退出" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 30;
                [alert show];
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"退出失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 31;
                [alert show];
            }
        }
        else
        {
            NSURL *url = [NSURL URLWithString:@"http://cai.chinacloudsites.cn/CAI/CAI/Jion"];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            NSMutableData* body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"UserId=%@&PostId=%@&type=%d",[[NSUserDefaults standardUserDefaults]stringForKey:TheCUrrentUserId],self.thePostId,self.type-1] dataUsingEncoding:NSUTF8StringEncoding]];
            NSLog(@"%@",[NSString stringWithFormat:@"UserId=%@&PostId=%@&type=%d",[[NSUserDefaults standardUserDefaults]stringForKey:TheCUrrentUserId],self.thePostId,self.type-1] );
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:body];
            [request setTimeoutInterval:4];
            NSData * returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString* returnStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            if ([returnStr isEqualToString:@"Ok"]) {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"加入成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 30;
                [alert show];
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"加入失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 31;
                [alert show];
            }
        }
    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{

}
-(void)showMapPathImage
{
    ShowMapImgViewViewController* vc = [[ShowMapImgViewViewController alloc]init];
    vc.startCoordinate = startCoordinate;
    vc.destinationCoordinate =destinationCoordinate;
    [self.navigationController pushViewController:vc animated:YES];
}


//大箭头
-(void)butClicked
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBack.png"] forBarMetrics:UIBarMetricsDefault];
}
@end
