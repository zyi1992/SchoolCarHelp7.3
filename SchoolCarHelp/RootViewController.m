//
//  RootViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 6/26/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "postCenterViewViewController.h"
//#import "PersonViewController.h"
#import "TheMessageCenterView.h"
#import "MyPostView.h"
#import  "ViewController.h"
#import  "SetViewControl.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *resevrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resevrBtn.frame = CGRectMake(0, 0, 40, 40);
    [resevrBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"头像%@",[[NSUserDefaults standardUserDefaults] objectForKey:TheCurrentUserInfoAvtor]]] forState:UIControlStateNormal];
       [resevrBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *reserItem = [[UIBarButtonItem alloc] initWithCustomView:resevrBtn];
    self.navigationItem.leftBarButtonItem = reserItem;
      [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBack.png"] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark -
#pragma mark Button actions

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
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked)];
        [ _sideMenu.tableView.tableHeaderView addGestureRecognizer:singleTap];
        _sideMenu.verticalOffset = IS_WIDESCREEN ? 110 : 76;
        _sideMenu.hideStatusBarArea = [AppDelegate OSVersion]<7;
    }
    [_sideMenu show];
}
-(void)UesrClicked
{
    
}
@end
