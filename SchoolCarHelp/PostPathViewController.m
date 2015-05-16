//
//  PostPathViewController.m
//  SchoolCarHelp
//
//  Created by OurEDA on 14-8-31.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "PostPathViewController.h"
#import "userDefaultheader.h"
#import "NavigationViewController.h"
@interface PostPathViewController ()

@end

@implementation PostPathViewController
@synthesize route       = _route;
@synthesize thePlacename1 = _thePlacename1;
@synthesize thePlacename2 = _thePlacename2;
@synthesize thePlacename3 = _thePlacename3;
@synthesize pickarray = _pickarray;
@synthesize timelable = _timelable;
@synthesize pickview = _pickview;
@synthesize personNumlable = _personNumlable;
@synthesize textview = _textview;
@synthesize imgview = _imgview;
@synthesize moreinfoView =_moreinfoView;
@synthesize lineView =_lineView;
@synthesize immediatelBut = _immediatelBut;
@synthesize appointmentBut = _appointmentBut;
@synthesize thetimeview =_thetimeview;
@synthesize datePick =_datePick;
@synthesize datetime = _date;
@synthesize activityView;
@synthesize blackView;

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
-(void)doBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.05f];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBack"] forBarMetrics:UIBarMetricsDefault];
    UIButton* backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(0, 0, 25, 20);
    [backBtn setImage:[UIImage imageNamed:@"backBut.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [self initTitle:@"发布线路"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;

    self.pickarray = [[NSMutableArray alloc]init];
    for (NSInteger ii = 0; ii<=600; ii++) {
        NSString* num = [NSString stringWithFormat:@"%d",ii];
        [self.pickarray addObject:num];
    }
    [self inittopBut];
   // [self initupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showMapPathImage
{
  ShowMapImgViewViewController* vc = [[ShowMapImgViewViewController alloc]init];
    vc.startCoordinate = CLLocationCoordinate2DMake([[NSUserDefaults standardUserDefaults] doubleForKey:ThestartAnnotationCoordinatelatitude], [[NSUserDefaults standardUserDefaults]doubleForKey:ThestartAnnotationCoordinatelongitude]);
    vc.destinationCoordinate =CLLocationCoordinate2DMake([[NSUserDefaults standardUserDefaults] doubleForKey:ThedestinationAnnotationCoordinatelatitude], [[NSUserDefaults standardUserDefaults]doubleForKey:ThedestinationAnnotationCoordinatelongitude]);
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)inittopBut
{
    UIView* topview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 40)];
    [topview setBackgroundColor:[UIColor whiteColor]];
    self.immediatelBut = [[UIButton alloc]initWithFrame:CGRectMake(30, 5, 100, 40)];
    [self.immediatelBut setTitle:@"即时帖子" forState:UIControlStateNormal];
    //immediatelBut.titleLabel.textColor = ];
    [self.immediatelBut setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbarBack.PNG"]]forState:UIControlStateSelected];
    [self.immediatelBut setTitleColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.7f] forState:UIControlStateNormal];
    [self.immediatelBut addTarget:self action:@selector(immediatelButClick:) forControlEvents:UIControlEventTouchUpInside];
    self.immediatelBut.selected = YES;
    [self.immediatelBut.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:21]];
     self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, 100, 3)];
    self.lineView.backgroundColor = [UIColor  colorWithPatternImage:[UIImage imageNamed:@"navigationbarBack.PNG"]];
    [self.immediatelBut addSubview:self.lineView];
    [topview addSubview:self.immediatelBut];
    self.appointmentBut = [[UIButton alloc]initWithFrame:CGRectMake(190, 5, 100, 40)];
    [self.appointmentBut setTitle:@"预约帖子" forState:UIControlStateNormal];
    //immediatelBut.titleLabel.textColor = ];
     [self.appointmentBut setTitleColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.7f] forState:UIControlStateNormal];
    [self.appointmentBut setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbarBack.PNG"]]forState:UIControlStateSelected];
    [self.appointmentBut addTarget:self action:@selector(appointmentButClick:) forControlEvents:UIControlEventTouchUpInside];
    //[immediatelBut settitl]
    self.appointmentBut.selected = NO;
    [self.appointmentBut.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:21]];
    //immediatelBut.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    //[self.immediatelBut addSubview:self.lineView];
    [topview addSubview:self.appointmentBut];
    [self.view addSubview:topview];
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        [self initimmediateView];
        [self initdifview];
    }
    else
    {
       [self initimmediateViewOthers];
       [self initdifviewOthers];
        
    }
   
    
}
-(void)appointmentButClick:(UIButton*)but
{
  //  UIButton *button = (UIButton *)but;
    //button.selected = !button.selected;
     [self.lineView removeFromSuperview];
    self.immediatelBut.selected = NO ;
    self.appointmentBut.selected = YES;
    if (self.appointmentBut.selected) {
        if ([UIScreen mainScreen].bounds.size.height >=568) {
            [self initdifview];
        }
        else
        {
        [self initdifviewOthers];
        }
            self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, 100, 3)];
        self.lineView.backgroundColor = [UIColor  colorWithPatternImage:[UIImage imageNamed:@"navigationbarBack.PNG"]];
        [self.appointmentBut addSubview:self.lineView];
    }
}
-(void)immediatelButClick:(UIButton*)but
{
  //  UIButton *button = (UIButton *)but;
    self.appointmentBut.selected = NO;
    self.immediatelBut.selected = YES;
    [self.lineView removeFromSuperview];
    //button.selected = !button.selected;
    if (self.immediatelBut.selected ) {
        if ([UIScreen mainScreen].bounds.size.height >=568) {
            [self initdifview];
        }
        else
        {
            [self initdifviewOthers];
        }

        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, 100, 3)];
        self.lineView.backgroundColor = [UIColor  colorWithPatternImage:[UIImage imageNamed:@"navigationbarBack.PNG"]];
        [self.immediatelBut addSubview:self.lineView];
    }
}
-(void)initdifview
{
    CGSize screensize  = [UIScreen mainScreen].bounds.size;//当前屏幕尺寸
    if (self.immediatelBut.selected) {
        self.thetimeview = [[UIView alloc]init];
        [self.thetimeview setBackgroundColor:[UIColor whiteColor]];
        self.thetimeview.frame = CGRectMake(0, screensize.height*22.5/100.0 + 90+2+85+2, 320, 50);
        UILabel* lable1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 170, 30)];
        lable1.text = @"我愿意等待时间(可选)";
        lable1.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        [self.thetimeview addSubview:lable1];
        UIImageView* img3 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"沙漏图标.png"]];
        img3.frame = CGRectMake(10, 13, 20, 20);
        [self.thetimeview addSubview:img3];
        self.timelable = [[UILabel alloc]init];
        self.timelable.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
        self.timelable.frame =CGRectMake(210, 10, 100, 30);
        self.timelable.text = @"0分钟";
        self.timelable.textColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.7f];
        [self.thetimeview addSubview:self.timelable];
        UIButton* timepointBut =[[UIButton alloc]initWithFrame:CGRectMake(290, 10, 30, 30)];
        timepointBut.tag = 200;
        [timepointBut setBackgroundImage:[UIImage imageNamed:@"点击选择48"] forState:UIControlStateNormal];
        [timepointBut setBackgroundImage:[UIImage imageNamed:@"确定按钮48"] forState:UIControlStateSelected];
        [timepointBut addTarget:self action:@selector(addpickview1:) forControlEvents:UIControlEventTouchUpInside];
        [self.thetimeview addSubview:timepointBut];
        [self.view addSubview:self.thetimeview];
    }
    else
    {
        if (self.thetimeview) {
            [self.thetimeview removeFromSuperview];
        }
        self.thetimeview = [[UIView alloc]init];
        [self.thetimeview setBackgroundColor:[UIColor whiteColor]];
        self.thetimeview.frame = CGRectMake(0, screensize.height*22.5/100.0 + 90+2+85+2, 320, 50);
        UILabel* lable1 = [[UILabel alloc]initWithFrame:CGRectMake(38, 10, 140, 30)];
        lable1.text = @"请选择出发时间";
        lable1.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        [self.thetimeview addSubview:lable1];
        UIImageView* img3 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"时钟图标.png"]];
        img3.frame = CGRectMake(10, 13, 24, 24);
        [self.thetimeview addSubview:img3];
        self.timelable = [[UILabel alloc]init];
        //self.timelable.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        self.timelable.frame =CGRectMake(160, 10, 150, 30);
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"MM月dd日HH时mm分"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        self.timelable.text = locationString;
        self.timelable.adjustsFontSizeToFitWidth = YES;
        self.timelable.textColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.7f];
        [self.thetimeview addSubview:self.timelable];
        UIButton* timepointBut =[[UIButton alloc]initWithFrame:CGRectMake(293, 10, 30, 30)];
        [timepointBut setBackgroundImage:[UIImage imageNamed:@"点击选择48"] forState:UIControlStateNormal];
        [timepointBut setBackgroundImage:[UIImage imageNamed:@"确定按钮48"] forState:UIControlStateSelected];
        [timepointBut addTarget:self action:@selector(addpickviewMore:) forControlEvents:UIControlEventTouchUpInside];
        [self.thetimeview addSubview:timepointBut];
        [self.view addSubview:self.thetimeview];
    }

}


-(void)AddActiveView
{
    blackView = [[UIView alloc]initWithFrame:CGRectMake(110, ([[UIScreen mainScreen]bounds].size.height-100)/2.0,100, 100)];
    [[blackView layer] setCornerRadius:10.0];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.6;
    [self. view addSubview:blackView];
    
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
}
- (void)initimmediateView
{
    UIView* bottmButView = [[UIView alloc]init];
    [bottmButView setBackgroundColor:[UIColor whiteColor]];
    bottmButView.frame = CGRectMake(0, 122, 320, 72);
    AMapPath* pat = [[AMapPath alloc]init];
    pat = self.route.paths[0];
    self.thePlacename1 = [[UILabel alloc] init];
    self.thePlacename1.text = [NSString stringWithFormat:@"%.1f",pat.distance/1000.f];
    self.thePlacename1.frame =CGRectMake(77, 2, 10+[self.thePlacename1.text length]*10, 35);
    self.thePlacename1.text = [NSString stringWithFormat:@"%.1f",pat.distance/1000.f];
    self.thePlacename1.font = [UIFont systemFontOfSize:24.f];
    [self.thePlacename1 setTextColor:[UIColor redColor]];
    [bottmButView addSubview:self.thePlacename1];
    UILabel* thePlacename11 = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 35)];
    thePlacename11.text = @"全程约";
    thePlacename11.font = [UIFont systemFontOfSize:24.f];
    [bottmButView addSubview:thePlacename11];
    [thePlacename11 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    UILabel* thePlacename12 = [[UILabel alloc] initWithFrame:CGRectMake(142-60+[self.thePlacename1.text length]*10, 2, 70, 35)];
    thePlacename12.text = @"公里";
    [thePlacename12 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    thePlacename12.font = [UIFont systemFontOfSize:24.f];
    [bottmButView addSubview:thePlacename12];
    
    self.thePlacename2 = [[UILabel alloc] init];
    self.thePlacename2.frame =CGRectMake(148-10, 30, 15+[self.thePlacename1.text length]*10, 35);
    self.thePlacename2.text = [NSString stringWithFormat:@"%.1f",self.route.taxiCost];
    self.thePlacename2.font = [UIFont systemFontOfSize:21.f];
    [self.thePlacename2 setTextColor:[UIColor redColor]];
    [bottmButView addSubview:self.thePlacename2];
    UILabel* thePlacename21 = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 130, 35)];
    thePlacename21.text = @"打的车费约为";
    thePlacename21.font = [UIFont systemFontOfSize:21.f];
    [bottmButView addSubview:thePlacename21];
    [thePlacename21 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    UILabel* thePlacename22 = [[UILabel alloc] initWithFrame:CGRectMake(153-10+[self.thePlacename2.text length]*10, 30, 20, 35)];
    thePlacename22.text = @"元";
    [thePlacename22 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    thePlacename22.font = [UIFont systemFontOfSize:21.f];
    [bottmButView addSubview:thePlacename22];
    self.thePlacename3 = [[UILabel alloc] initWithFrame:CGRectMake(242, 3, [[NSString stringWithFormat:@"%d",pat.duration/60] length]*9, 35)];
    self.thePlacename3.text = [NSString stringWithFormat:@"%d",pat.duration/60];
    // NSLog(@"%@",self.thePlacename3.text);
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
    UIButton* reservationBut = [[UIButton alloc]initWithFrame:CGRectMake(10, 500, 300, 53)];
    
    [reservationBut setBackgroundImage:[UIImage imageNamed:@"查看路线规划图标.png"] forState:UIControlStateNormal];
    [reservationBut addTarget:self action:@selector(tranTosendTopicMethod) forControlEvents:UIControlEventTouchUpInside];
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 100, 40)];
    lable.text = @"发布帖子";
    [lable setTextColor:[UIColor whiteColor]];
    lable.font = [UIFont systemFontOfSize:25.f];
    [reservationBut addSubview:lable];
    //[bottmButView addSubview:reservationBut];
    [self.view addSubview:bottmButView];
    [self.view addSubview:reservationBut];
    //------------------------－－－－－－－－－－－－－－－－
    UIView* positionView = [[UIView alloc]init];
    [positionView setBackgroundColor:[UIColor whiteColor]];
    positionView.frame = CGRectMake(0, 205, 320, 95);
    UIButton* starpointBut =[[UIButton alloc]initWithFrame:CGRectMake(270, 25, 34, 34)];
    //starpointBut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"campus_homepage_school_more_info_icon.png"]];
    [starpointBut setBackgroundImage:[UIImage imageNamed:@"查看地图图标.png"] forState:UIControlStateNormal];
    [starpointBut addTarget:self action:@selector(showMapPathImage) forControlEvents:UIControlEventTouchUpInside];
    [positionView addSubview:starpointBut];
    UILabel* lableq = [[UILabel alloc]initWithFrame:CGRectMake(267, 52, 40, 25)];
    lableq.text = @"显示地图";
    lableq.textColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.6f];
    lableq.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    [positionView addSubview:lableq];
    UIImage* img = [UIImage imageNamed:@"起点.png"];
    UIImageView* StarPoint_imgview = [[UIImageView alloc]initWithImage:img];
    StarPoint_imgview.frame = CGRectMake(20, 15, 25, 25);
    [positionView addSubview:StarPoint_imgview];
    //当前选择的位置显示
   UILabel* thestartPlacename = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 200, 49)];
    thestartPlacename.text = [[NSUserDefaults standardUserDefaults] stringForKey:ThestartAnnotationCoordinatetitle];//.........
    thestartPlacename.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    [positionView addSubview:thestartPlacename];
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 260, 2)];
    lineView.backgroundColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.1f];
    [positionView addSubview:lineView];
    
    UIImage* img1 = [UIImage imageNamed:@"终点.png"];
    UIImageView* desPoint_imgview = [[UIImageView alloc]initWithImage:img1];
    desPoint_imgview.frame = CGRectMake(20, 65, 25, 25);
    [positionView addSubview:desPoint_imgview];
    //当前选择的位置显示
    UILabel* thedesPlacename = [[UILabel alloc]initWithFrame:CGRectMake(50, 50, 200, 49)];
    thedesPlacename.text = [[NSUserDefaults standardUserDefaults] stringForKey:ThedestinationAnnotationCoordinatetitle];//.........
    thedesPlacename.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    [positionView addSubview:thedesPlacename];
    [self.view addSubview:positionView];
//-----------------------------------------------------------------
       //------------------------------------------------
    UIView* thepersonNumview = [[UIView alloc]init];
    [thepersonNumview setBackgroundColor:[UIColor whiteColor]];
    thepersonNumview.frame = CGRectMake(0, 372, 320, 45);
    UILabel* lable2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 195, 30)];
    lable2.text = @"拼车所缺人数（可修改）";
    lable2.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    [thepersonNumview addSubview:lable2];
    UIImageView* img2 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ren.png"]];
    img2.frame = CGRectMake(10, 13, 20, 20);
    [thepersonNumview addSubview:img2];
    [self.view addSubview:thepersonNumview];
    self.personNumlable = [[UILabel alloc]init];
    self.personNumlable.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self.personNumlable.frame =CGRectMake(240, 10, 100, 30);
    self.personNumlable.text = @"3";
    self.personNumlable.textColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.7f];
    UIButton* timepointBut1 =[[UIButton alloc]initWithFrame:CGRectMake(290, 10, 30, 30)];
    //选择拼车人数的but tag值设为100;
    timepointBut1.tag = 100;
    [timepointBut1 setBackgroundImage:[UIImage imageNamed:@"点击选择48"] forState:UIControlStateNormal];
    [timepointBut1 setBackgroundImage:[UIImage imageNamed:@"确定按钮48"] forState:UIControlStateSelected];
    [timepointBut1 addTarget:self action:@selector(addpickview:) forControlEvents:UIControlEventTouchUpInside];
    [thepersonNumview addSubview:timepointBut1];

    [thepersonNumview addSubview:self.personNumlable];
    //----------------------------------------------
     self.moreinfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 428, 320, 60)];
    [self.moreinfoView setBackgroundColor:[UIColor whiteColor]];
    self.textview = [[UITextView alloc]initWithFrame:CGRectMake(30, 5, 280, 40)];
    self.textview.delegate =self;
    self.textview.text = @"在这写下更多的备注信息";
    self.textview.textColor =[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.3f];
    self.textview.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self.imgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"备注图标.png"]];
    self.imgview.frame = CGRectMake(10, 13, 20, 20);
    [self.moreinfoView addSubview:self.imgview];
    [self.moreinfoView addSubview:self.textview];
    [self.view addSubview:self.moreinfoView];
}

//对非640*1136的屏幕进行适配
-(void)initdifviewOthers
{
    CGSize screensize = [UIScreen mainScreen].bounds.size;
    if (self.immediatelBut.selected) {
        self.thetimeview = [[UIView alloc]init];
        [self.thetimeview setBackgroundColor:[UIColor whiteColor]];
        self.thetimeview.frame = CGRectMake(0, screensize.height*22.5/100.0 + 65+2+85+2, 320, 50);
        UILabel* lable1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 170, 30)];
        lable1.text = @"我愿意等待时间(可选)";
        lable1.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        [self.thetimeview addSubview:lable1];
        UIImageView* img3 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"沙漏图标.png"]];
        img3.frame = CGRectMake(10, 13, 20, 20);
        [self.thetimeview addSubview:img3];
        self.timelable = [[UILabel alloc]init];
        self.timelable.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
        self.timelable.frame =CGRectMake(210, 10, 100, 30);
        self.timelable.text = @"0分钟";
        self.timelable.textColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.7f];
        [self.thetimeview addSubview:self.timelable];
        UIButton* timepointBut =[[UIButton alloc]initWithFrame:CGRectMake(290, 10, 30, 30)];
        timepointBut.tag = 200;
        [timepointBut setBackgroundImage:[UIImage imageNamed:@"点击选择48"] forState:UIControlStateNormal];
        [timepointBut setBackgroundImage:[UIImage imageNamed:@"确定按钮48"] forState:UIControlStateSelected];
        [timepointBut addTarget:self action:@selector(addpickview1:) forControlEvents:UIControlEventTouchUpInside];
        [self.thetimeview addSubview:timepointBut];
        [self.view addSubview:self.thetimeview];
    }
    else
    {
        if (self.thetimeview) {
            [self.thetimeview removeFromSuperview];
        }
        self.thetimeview = [[UIView alloc]init];
        [self.thetimeview setBackgroundColor:[UIColor whiteColor]];
        self.thetimeview.frame = CGRectMake(0, screensize.height*22.5/100.0 + 65+2+85+2, 320, 50);
        UILabel* lable1 = [[UILabel alloc]initWithFrame:CGRectMake(38, 10, 140, 30)];
        lable1.text = @"请选择出发时间";
        lable1.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        [self.thetimeview addSubview:lable1];
        UIImageView* img3 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"时钟图标.png"]];
        img3.frame = CGRectMake(10, 13, 24, 24);
        [self.thetimeview addSubview:img3];
        self.timelable = [[UILabel alloc]init];
        //self.timelable.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        self.timelable.frame =CGRectMake(160, 10, 150, 30);
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"MM月dd日HH时mm分"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        self.timelable.text = locationString;
        self.timelable.adjustsFontSizeToFitWidth = YES;
        self.timelable.textColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.7f];
        [self.thetimeview addSubview:self.timelable];
        UIButton* timepointBut =[[UIButton alloc]initWithFrame:CGRectMake(293, 10, 30, 30)];
        [timepointBut setBackgroundImage:[UIImage imageNamed:@"点击选择48"] forState:UIControlStateNormal];
        [timepointBut setBackgroundImage:[UIImage imageNamed:@"确定按钮48"] forState:UIControlStateSelected];
        [timepointBut addTarget:self action:@selector(addpickviewMore:) forControlEvents:UIControlEventTouchUpInside];
        [self.thetimeview addSubview:timepointBut];
        [self.view addSubview:self.thetimeview];
        
        
    }
    
}
//对非640*1168的屏幕适配
- (void)initimmediateViewOthers
{
    CGSize screensize  = [UIScreen mainScreen].bounds.size;//当前屏幕尺寸
    UIView* bottmButView = [[UIView alloc]init];
    [bottmButView setBackgroundColor:[UIColor whiteColor]];
    bottmButView.frame = CGRectMake(0, screensize.height*22.5/100.0, screensize.width, 65);
    AMapPath* pat = [[AMapPath alloc]init];
    pat = self.route.paths[0];
    self.thePlacename1 = [[UILabel alloc] init];
    self.thePlacename1.text = [NSString stringWithFormat:@"%.1f",pat.distance/1000.f];
    self.thePlacename1.frame =CGRectMake(77, 2, 10+[self.thePlacename1.text length]*10, 35);
    self.thePlacename1.text = [NSString stringWithFormat:@"%.1f",pat.distance/1000.f];
    self.thePlacename1.font = [UIFont systemFontOfSize:24.f];
    [self.thePlacename1 setTextColor:[UIColor redColor]];
    [bottmButView addSubview:self.thePlacename1];
    UILabel* thePlacename11 = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 100, 35)];
    thePlacename11.text = @"全程约";
    thePlacename11.font = [UIFont systemFontOfSize:24.f];
    [bottmButView addSubview:thePlacename11];
    [thePlacename11 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    UILabel* thePlacename12 = [[UILabel alloc] initWithFrame:CGRectMake(142-60+[self.thePlacename1.text length]*10, 2, 70, 35)];
    thePlacename12.text = @"公里";
    [thePlacename12 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    thePlacename12.font = [UIFont systemFontOfSize:24.f];
    [bottmButView addSubview:thePlacename12];
    
    self.thePlacename2 = [[UILabel alloc] init];
    self.thePlacename2.frame =CGRectMake(148-10, 30, 15+[self.thePlacename1.text length]*10, 35);
    self.thePlacename2.text = [NSString stringWithFormat:@"%.1f",self.route.taxiCost];
    self.thePlacename2.font = [UIFont systemFontOfSize:21.f];
    [self.thePlacename2 setTextColor:[UIColor redColor]];
    [bottmButView addSubview:self.thePlacename2];
    UILabel* thePlacename21 = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 130, 35)];
    thePlacename21.text = @"打的车费约为";
    thePlacename21.font = [UIFont systemFontOfSize:21.f];
    [bottmButView addSubview:thePlacename21];
    [thePlacename21 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    UILabel* thePlacename22 = [[UILabel alloc] initWithFrame:CGRectMake(153-10+[self.thePlacename2.text length]*10, 30, 20, 35)];
    thePlacename22.text = @"元";
    [thePlacename22 setTextColor:[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.9f]];
    thePlacename22.font = [UIFont systemFontOfSize:21.f];
    [bottmButView addSubview:thePlacename22];
    self.thePlacename3 = [[UILabel alloc] initWithFrame:CGRectMake(242, 3, [[NSString stringWithFormat:@"%d",pat.duration/60] length]*9, 35)];
    self.thePlacename3.text = [NSString stringWithFormat:@"%d",pat.duration/60];
    // NSLog(@"%@",self.thePlacename3.text);
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
        //------------------------－－－－－－－－－－－－－－－－
    UIView* positionView = [[UIView alloc]init];
    [positionView setBackgroundColor:[UIColor whiteColor]];
    positionView.frame = CGRectMake(0, screensize.height*22.5/100.0 + 65+2, screensize.width, 85);
    
    UIButton* starpointBut =[[UIButton alloc]initWithFrame:CGRectMake(270, 20, 34, 34)];
    //starpointBut.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"campus_homepage_school_more_info_icon.png"]];
    [starpointBut setBackgroundImage:[UIImage imageNamed:@"查看地图图标.png"] forState:UIControlStateNormal];
    [starpointBut addTarget:self action:@selector(showMapPathImage) forControlEvents:UIControlEventTouchUpInside];
    [positionView addSubview:starpointBut];
    UILabel* lableq = [[UILabel alloc]initWithFrame:CGRectMake(267, 45, 40, 25)];
    lableq.text = @"显示地图";
    lableq.textColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.6f];
    lableq.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    [positionView addSubview:lableq];
    UIImage* img = [UIImage imageNamed:@"起点.png"];
    UIImageView* StarPoint_imgview = [[UIImageView alloc]initWithImage:img];
    StarPoint_imgview.frame = CGRectMake(20, 15, 25, 25);
    [positionView addSubview:StarPoint_imgview];
    //当前选择的位置显示
    UILabel* thestartPlacename = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 200, 49)];
    thestartPlacename.text = [[NSUserDefaults standardUserDefaults] stringForKey:ThestartAnnotationCoordinatetitle];//.........
    thestartPlacename.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    [positionView addSubview:thestartPlacename];
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, 260, 2)];
    lineView.backgroundColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.1f];
    [positionView addSubview:lineView];
    
    UIImage* img1 = [UIImage imageNamed:@"终点.png"];
    UIImageView* desPoint_imgview = [[UIImageView alloc]initWithImage:img1];
    desPoint_imgview.frame = CGRectMake(20, 60, 25, 25);
    [positionView addSubview:desPoint_imgview];
    //当前选择的位置显示
    UILabel* thedesPlacename = [[UILabel alloc]initWithFrame:CGRectMake(50, 45, 200, 49)];
    thedesPlacename.text = [[NSUserDefaults standardUserDefaults] stringForKey:ThedestinationAnnotationCoordinatetitle];//.........
    thedesPlacename.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    [positionView addSubview:thedesPlacename];
    [self.view addSubview:positionView];
    //-----------------------------------------------------------------
    //------------------------------------------------
    UIView* thepersonNumview = [[UIView alloc]init];
    [thepersonNumview setBackgroundColor:[UIColor whiteColor]];
    thepersonNumview.frame = CGRectMake(0, screensize.height*22.5/100.0 + 65+2+85+2+50+2, 320, 45);
    UILabel* lable2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 195, 30)];
    lable2.text = @"拼车所缺人数（可修改）";
    lable2.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    [thepersonNumview addSubview:lable2];
    UIImageView* img2 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ren.png"]];
    img2.frame = CGRectMake(10, 13, 20, 20);
    [thepersonNumview addSubview:img2];
    [self.view addSubview:thepersonNumview];
    self.personNumlable = [[UILabel alloc]init];
    self.personNumlable.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self.personNumlable.frame =CGRectMake(240, 10, 100, 30);
    self.personNumlable.text = @"3";
    self.personNumlable.textColor = [UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.7f];
    UIButton* timepointBut1 =[[UIButton alloc]initWithFrame:CGRectMake(290, 10, 30, 30)];
    //选择拼车人数的but tag值设为100;
    timepointBut1.tag = 100;
    [timepointBut1 setBackgroundImage:[UIImage imageNamed:@"点击选择48"] forState:UIControlStateNormal];
    [timepointBut1 setBackgroundImage:[UIImage imageNamed:@"确定按钮48"] forState:UIControlStateSelected];
    [timepointBut1 addTarget:self action:@selector(addpickview:) forControlEvents:UIControlEventTouchUpInside];
    [thepersonNumview addSubview:timepointBut1];
    
    [thepersonNumview addSubview:self.personNumlable];
    //----------------------------------------------
    self.moreinfoView = [[UIView alloc]initWithFrame:CGRectMake(0, screensize.height*22.5/100.0 + 65+2+85+2+50+2+45+2, 320, 60)];
    [self.moreinfoView setBackgroundColor:[UIColor whiteColor]];
    self.textview = [[UITextView alloc]initWithFrame:CGRectMake(30, 5, 280, 40)];
    self.textview.delegate =self;
    self.textview.text = @"在这写下更多的备注信息";
    self.textview.textColor =[UIColor colorWithRed:79/255.f green:79/255.f blue:79/255.f alpha:0.3f];
    self.textview.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self.imgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"备注图标.png"]];
    self.imgview.frame = CGRectMake(10, 13, 20, 20);
    [self.moreinfoView addSubview:self.imgview];
    [self.moreinfoView addSubview:self.textview];
    [self.view addSubview:self.moreinfoView];
    //发帖but
    UIButton* reservationBut = [[UIButton alloc]initWithFrame:CGRectMake(10, screensize.height*22.5/100.0 + 65+2+85+2+50+2+45+2+60+3, 300, 53)];
    
    [reservationBut setBackgroundImage:[UIImage imageNamed:@"查看路线规划图标.png"] forState:UIControlStateNormal];
    [reservationBut addTarget:self action:@selector(tranTosendTopicMethod) forControlEvents:UIControlEventTouchUpInside];
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 100, 40)];
    lable.text = @"发布帖子";
    [lable setTextColor:[UIColor whiteColor]];
    lable.font = [UIFont systemFontOfSize:25.f];
    [reservationBut addSubview:lable];
    //[bottmButView addSubview:reservationBut];
    [self.view addSubview:bottmButView];
    [self.view addSubview:reservationBut];

}

-(void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    return;
}
//设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
        return 1;
}
//返回数组总数
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickarray count];//将数据建立一个数组
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{ return [self.pickarray objectAtIndex:row];
    if(row==1)
    { return [self.pickarray objectAtIndex:1];
    }
}
//触发事件
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.pickarray objectAtIndex:row];
    if (thePickerView.tag == 222) {
        self.timelable.text = [NSString stringWithFormat:@"%@分钟",[self.pickarray objectAtIndex:row]];
        limittime = row;
    }
    else if(thePickerView.tag == 111)
    {
        self.personNumlable.text =[NSString stringWithFormat:@"%@",[self.pickarray objectAtIndex:row]];
    }
        //[self.pickview removeFromSuperview];
}
    // 详细操作，请参照例子UICatalog实例。
-(void)addpickviewMore:(UIButton *)autoLoginSave
{
    UIButton *button = (UIButton *)autoLoginSave;
    button.selected = !button.selected;
    if (!button.selected) {
        if (self.datePick) {
            NSDate *selectedDate = [self.datePick date];
            NSTimeInterval time = (long long int)[selectedDate timeIntervalSince1970];
            bookTime = [NSString stringWithFormat:@"%.0f",time];
            NSLog(@"%@",bookTime);
            NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:timeZone];
            [formatter setDateFormat:@"MM月dd日HH时mm分"];
            NSString *dateString = [formatter stringFromDate:selectedDate];
            self.timelable.text = dateString;
            [self.datePick removeFromSuperview];
        }
        [self.datePick removeFromSuperview];
    }
    else
    {
        if ([UIScreen mainScreen].bounds.size.height >=568) {
             self.datePick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 350, 100, 100)];
        }else
        {
             self.datePick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 325, 100, 100)];
        }
       
        [self.datePick setDatePickerMode:UIDatePickerModeDateAndTime];
        [self.datePick setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:self.datePick];
       }
}
-(void)selectDateChange:(id)sender
{
}
-(void)addpickview1:(UIButton *)autoLoginSave
{
    [self.pickview removeFromSuperview];
    UIButton *button = (UIButton *)autoLoginSave;
    button.selected = !button.selected;
    if (!button.selected) {
        [self.pickview removeFromSuperview];
    }
    else
    {
        self.pickview = [[UIPickerView alloc] initWithFrame:CGRectZero];;
        [self.pickview setBackgroundColor:[UIColor whiteColor]];
        self.pickview.frame = CGRectMake(210, [UIScreen mainScreen].bounds.size.height*22.5/100.0 + 65+2+85+2-50,60 , 130);
        self.pickview.showsSelectionIndicator = YES;
        self.pickview.tag = 222;
        self.pickview.delegate = self;
        self.pickview.dataSource =self;
        [self.pickview resignFirstResponder] ;
        self.pickview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.pickview];
    }
}
-(void)addpickview:(UIButton *)autoLoginSave
{
    [self.pickview removeFromSuperview];
    UIButton *button = (UIButton *)autoLoginSave;
    button.selected = !button.selected;
    if (!button.selected) {
        [self.pickview removeFromSuperview];
    }
    else
    {
        self.pickview = [[UIPickerView alloc] initWithFrame:CGRectZero];;
        [self.pickview setBackgroundColor:[UIColor whiteColor]];
        self.pickview.frame = CGRectMake(210,[UIScreen mainScreen].bounds.size.height*22.5/100.0 + 65+2+85+2+50-50 ,60 , 130);
        self.pickview.showsSelectionIndicator = YES;
        self.pickview.tag = 111;
        self.pickview.delegate = self;
        self.pickview.dataSource =self;
        [self.pickview resignFirstResponder] ;
        self.pickview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.pickview];
    }
  }
#pragma mark - UITextView
-(void)textViewDidChange:(UITextView *)textView
{

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        self.view.center = CGPointMake(160, 140);

    }
    else
    {
        self.view.center = CGPointMake(160, 100);

    }
       [UIView commitAnimations];
    self.textview.text = @"";
    [self.imgview removeFromSuperview];
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.textview.text length] == 0) {
        self.imgview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"备注图标.png"]];
        self.imgview.frame = CGRectMake(5, 10, 20, 20);
        [self.moreinfoView addSubview:self.imgview];
        self.textview.text = @"在这写下更多的备注信息";
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    //判断所点击view是否是UITextField或UITextView
    if (![[touch view] isKindOfClass:[UITextView class]]) {
                [self.textview resignFirstResponder];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                [UIView setAnimationDelegate:self];
                self.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
                [UIView commitAnimations];
           }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        self.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        [UIView commitAnimations];

        return NO;
    }
    return YES;
}
-(void)tranTosendTopicMethod
{
    blackView = [[UIView alloc]initWithFrame:CGRectMake(110, ([[UIScreen mainScreen]bounds].size.height-100)/2.0,100, 100)];
    [[blackView layer] setCornerRadius:10.0];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.6;
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
     [self. view addSubview:blackView];
    AMapPath* pat = [[AMapPath alloc]init];
    
    pat = self.route.paths[0];
    if (self.immediatelBut.selected)
    {
        NSMutableString *urll = [NSMutableString stringWithString:TheRequestUrl];
        [urll appendFormat:@"NewNowPost"];
        NSURL *url = [NSURL URLWithString:urll];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSMutableData* body = [NSMutableData data];
        NSUserDefaults* de = [NSUserDefaults standardUserDefaults];
        //判断备注是否填写
        if ([self.textview.text isEqualToString:@"在这写下更多的备注信息"]) {
            self.textview.text = @"该用户没写备注";
        }
            NSString* str = [NSString stringWithFormat:@"TimeLimitation=%d&Message=%@",limittime,self.textview.text];
            [body appendData:[[NSString stringWithFormat:@"UserId=%@&Origin=%@&OriginLongitude=%@&OriginLatitude=%@&Terminal=%@&TerminalLongitude=%@&TerminalLatitude=%@&Distance=%.1f&Time=%.1f&Cost=%.1f&Count=%d&RestCount=%d&%@",[de stringForKey:TheCUrrentUserId],[de stringForKey:ThestartAnnotationCoordinatetitle],[de stringForKey:ThestartAnnotationCoordinatelongitude],[de stringForKey:ThestartAnnotationCoordinatelatitude],[de stringForKey:ThedestinationAnnotationCoordinatetitle],[de stringForKey:ThedestinationAnnotationCoordinatelongitude],[de stringForKey:ThedestinationAnnotationCoordinatelatitude],pat.distance/1000.f,pat.duration/60.f,self.route.taxiCost,[self.personNumlable.text intValue]+1,[self.personNumlable.text intValue],str] dataUsingEncoding:NSUTF8StringEncoding]];
                //NSLog(@"++++++++++++%@",[NSString stringWithFormat:@"UserId=%@&Origin=%@&OriginLongitude=%@&OriginLatitude=%@&Terminal=%@&TerminalLongitude=%@&TerminalLatitude=%@&Distance=%.1f&Time=%.1f&Cost=%.1f&Count=%d&RestCount=%d&%@",[de stringForKey:TheCUrrentUserId],[de stringForKey:ThestartAnnotationCoordinatetitle],[de stringForKey:ThestartAnnotationCoordinatelongitude],[de stringForKey:ThestartAnnotationCoordinatelatitude],[de stringForKey:ThedestinationAnnotationCoordinatetitle],[de stringForKey:ThedestinationAnnotationCoordinatelongitude],[de stringForKey:ThedestinationAnnotationCoordinatelatitude],pat.distance/1000.f,pat.duration/60.f,self.route.taxiCost,[self.personNumlable.text intValue]+1,[self.personNumlable.text intValue],str]);
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:body];
            [request setTimeoutInterval:4];
            //,[self.timelable.text intValue],self.textview.text
            NSData * returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil     error:nil];
            NSString *response = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            NSLog(@"+++++++++++++++++++++%@",response);
            if (response) {
                [blackView removeFromSuperview];
                UIAlertView* aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"帖子发布成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                aler.tag = 522;
                [aler show];
            }else
            {
                [blackView removeFromSuperview];
                UIAlertView* aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"帖子发布失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                aler.tag = 511;
                [aler show];
    }
    }
    else
    {
        NSMutableString *urll = [NSMutableString stringWithString:TheRequestUrl];
        [urll appendFormat:@"NewBookPost"];
        NSURL *url = [NSURL URLWithString:urll];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSMutableData* body = [NSMutableData data];
        NSUserDefaults* de = [NSUserDefaults standardUserDefaults];
        NSString* str = [NSString stringWithFormat:@"BookTime=%@&Message=%@",bookTime,self.textview.text];
        [body appendData:[[NSString stringWithFormat:@"UserId=%@&Origin=%@&OriginLongitude=%@&OriginLatitude=%@&Terminal=%@&TerminalLongitude=%@&TerminalLatitude=%@&Distance=%.1f&Time=%.1f&Cost=%.1f&Count=%d&RestCount=%d&%@",[de stringForKey:TheCUrrentUserId],[de stringForKey:ThestartAnnotationCoordinatetitle],[de stringForKey:ThestartAnnotationCoordinatelongitude],[de stringForKey:ThestartAnnotationCoordinatelatitude],[de stringForKey:ThedestinationAnnotationCoordinatetitle],[de stringForKey:ThedestinationAnnotationCoordinatelongitude],[de stringForKey:ThedestinationAnnotationCoordinatelatitude],pat.distance/1000.f,pat.duration/60.f,self.route.taxiCost,[self.personNumlable.text intValue]+1,[self.personNumlable.text intValue],str] dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:body];
            [request setTimeoutInterval:4];
            //,[self.timelable.text intValue],self.textview.text
            NSData * returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *response = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            if (response) {
                [blackView removeFromSuperview];
                UIAlertView* aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"帖子发布成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                aler.tag = 522;
                [aler show];
            }else
            {
                [blackView removeFromSuperview];
                UIAlertView* aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"帖子发布失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                aler.tag = 511;
                [aler show];
        }
    }
    //点击发帖按钮时调用的方法
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 522) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
