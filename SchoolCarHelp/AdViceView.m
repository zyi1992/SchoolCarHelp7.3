//
//  AdViceView.m
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-18.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "AdViceView.h"

@interface AdViceView ()

@end

@implementation AdViceView

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    UIButton *resevrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resevrBtn.frame = CGRectMake(0, 0, 40, 40);
    //[resevrBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [resevrBtn setTitle:@"提交" forState:UIControlStateNormal];
    [resevrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resevrBtn addTarget:self action:@selector(tranTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *reserItem = [[UIBarButtonItem alloc] initWithCustomView:resevrBtn];
    self.navigationItem.rightBarButtonItem = reserItem;
    UIButton* backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(0, 0, 25, 20);
    [backBtn setImage:[UIImage imageNamed:@"backBut.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    [self initTitle:@"意见反馈"];
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, 280, 30)];
    lable.text = @"在下面写下你的反馈意见：";
    lable.font = [UIFont systemFontOfSize:19.f];
   lable.textColor = [UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
    [self.view addSubview:lable];
    textview = [[UITextView alloc]initWithFrame:CGRectMake(20, 110, 280, 180)];
    textview.delegate = self;
    textview.backgroundColor = [UIColor whiteColor];
    textview.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:textview];
    // Do any additional setup after loading the view.
}
-(void)doBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tranTo
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@" 提示" message:@"你的反馈已提交成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        self.view.center = CGPointMake(160, 568/2);
        [UIView commitAnimations];
        
        return NO;
    }
    return YES;
}




@end
