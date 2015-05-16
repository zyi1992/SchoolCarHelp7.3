//
//  TieZiViewController.m
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-5.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "TheMessageCenterView.h"

@interface TheMessageCenterView ()

@end

@implementation TheMessageCenterView
@synthesize _scroll;
@synthesize instantLine;
@synthesize appointLine;
@synthesize instantIvt;
@synthesize appointIvt;
@synthesize signBtn;
@synthesize signLable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.view.backgroundColor = [UIColor whiteColor];
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

-(void)_scrollLoad
{
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, 320, 504)];
    _scroll.backgroundColor = [UIColor colorWithRed:243/255.f green:243/255.f blue:236/255.f alpha:1.0f];
    _scroll.contentSize = CGSizeMake(320, 480);
    _scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scroll];
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    arr = [[NSUserDefaults standardUserDefaults] objectForKey:TheCurrentUserMessageArray];
    //NSDictionary* dic1 = [[NSDictionary alloc]initWithObjectsAndKeys:@"加入了你的帖子 ",@"alert",@"11",@"Avator",@"小周周",@"NickName",@"1410668402",@"Time", nil];
    //[arr addObject:@"妹子跟人跑了"];
    //[arr addObject:@"学长让学妹给拐走了"];
   // [arr addObject:dic1];
    //[arr addObject:dic1];
    int i = 0;
    NSLog(@"------------%@",arr);
    if ([arr count]==0) {
        UIView* vie = [[UIView alloc]initWithFrame:CGRectMake(0, -40, 320, 568)];
        [vie setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景板"]]];
        [_scroll addSubview:vie];
         }
    for ( i =0;  i<[arr count]; i++) {
        NSDictionary* dicc =arr[i];
     //   NSInteger a= (NSInteger)[dicc objectForKey:@"Avator"];
       UIView *blockView = [[UIView alloc]initWithFrame:CGRectMake(0, 0+60*i, 320, 60)];
     [_scroll addSubview:blockView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0+60*i, 320, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    [_scroll addSubview:lineView];
    
    UIButton *headBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 50,50)];
    [headBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"头像%@",[dicc objectForKey:@"Avator"]]] forState:UIControlStateNormal];
    [blockView addSubview:headBtn];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 3,90, 30)];
    nameLabel.text = [dicc objectForKey:@"NickName"];
    //nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.font = [UIFont systemFontOfSize:20.f];
    [blockView addSubview:nameLabel];
    UILabel* textlable = [[UILabel alloc]init];
    textlable.text = [[dicc objectForKey:@"aps"] objectForKey:@"alert"];
    textlable.textColor =[UIColor colorWithRed:150/255.f green:150/255.f blue:150/255.f alpha:1.0f];
    textlable.frame = CGRectMake(80, 29, 200, 30);
        [blockView addSubview:textlable];
        UILabel* timelable = [[UILabel alloc]initWithFrame:CGRectMake(240, 5, 120, 10)];
        NSString *string2 = [dicc objectForKey:@"Time"];
        long long dq =[string2 longLongValue];
        NSDate *dd = [[NSDate alloc]initWithTimeIntervalSince1970:dq];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
        dateFormatter.dateFormat = @"MM-dd  HH:MM";
        timelable.text = [dateFormatter stringFromDate:dd];
        [timelable setFont:[UIFont systemFontOfSize:12.f]];
        timelable.textColor = [UIColor colorWithRed:150/255.f green:150/255.f blue:150/255.f alpha:1.0f];
    
        [blockView addSubview:timelable];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 60+60*i, 320, 1)];
    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    [_scroll addSubview:line];
    }
    if (i*63 <1136/2) {
        _scroll.contentSize =CGSizeMake(320, 500);
    }
    else
    {
    _scroll.contentSize = CGSizeMake(320, i*63);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTitle:@"消息中心"];
    //self.view.backgroundColor = [UIColor colorWithRed:243/255.f green:243/255.f blue:236/255.f alpha:1.0f];
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBack.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    flag = 1;
    [self _scrollLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
