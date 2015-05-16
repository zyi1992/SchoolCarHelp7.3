//
//  AppDelegate.m
//  SchoolCarHelp
//
//  Created by OurEDA on 14-8-5.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "PostPathViewController.h"
#import "PostDetailsViewContrViewController.h"
#import "Sign_inViewController.h"
#import "TheMessageCenterView.h" 
#import  "ViewController.h"
#import "SetViewControl.h"
//#define kAppId           @"CJJfKPn2Wt9YHsvL4w8583"
//#define kAppKey          @"Z2bhS9ncAj8tXUs6spnCJ5"
//#define kAppSecret       @"tlAw3Soz1X7xugq73CFDS2"
@implementation AppDelegate

- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}
+ (NSInteger)OSVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MAMapServices sharedServices].apiKey =@"d56fb1d618d24ce8becc0835adbf5dfe";
    //NSLog(@"%@",launchOptions);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (launchOptions) {
        ///获取到推送相关的信息
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if ([[NSUserDefaults standardUserDefaults] arrayForKey:TheCurrentUserMessageArray]) {
            NSMutableArray* arr = [[NSMutableArray alloc]init];
            [[NSUserDefaults standardUserDefaults] setObject:arr forKey:TheCurrentUserMessageArray];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        NSMutableArray* arr1 =[[NSMutableArray alloc]init];
        arr1 = [[NSUserDefaults standardUserDefaults]  objectForKey:TheCurrentUserMessageArray];
        [arr1 addObject:userInfo];
        [[NSUserDefaults standardUserDefaults] setObject:arr1 forKey:TheCurrentUserMessageArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"userInfo：%@",[[NSUserDefaults standardUserDefaults]  objectForKey:TheCurrentUserMessageArray]);
    }
        //MainViewController* mainview = [[MainViewController alloc]init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IfIsTheFirstTimeToLogTheSofe]) {
    }
    else
    {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
        //[self]
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IfIsTheFirstTimeToLogTheSofe];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
   
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    //[XGPush registerPush];  //注册Push服务，注册后才能收到推送
    
    //[XGPush setAccount:@"testAccount1"];
    
    //推送反馈(app不在前台运行时，点击推送激活时)
    //[XGPush handleLaunching:launchOptions];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //清除所有通知(包含本地通知)
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    //[XGPush unRegisterDevice];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:TheLastAutoLoginState]) {
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    }else
    {
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[Sign_inViewController alloc] init]];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    NSLog(@"%@",str);
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma getui---
//- (void) registerNofitication {
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
//}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * deviceTokenStr = [XGPush registerDevice: deviceToken];
    //打印获取的deviceToken的字符串
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:TheCurrentUserDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"++++++++++++++++deviceTokenStr is %@",deviceTokenStr);
    //UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"tishi" message:[NSString stringWithFormat:@"%@",deviceToken] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //[alert show];
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSDictionary* dd = [[NSDictionary alloc]initWithObjectsAndKeys:@"欢迎使用拼车系统",@"alert", nil];
        NSDictionary* dic1 = [[NSDictionary alloc]initWithObjectsAndKeys:dd,@"aps",@"0",@"Avator",@"系统",@"NickName",@"1410668402",@"Time", nil];
        NSArray*arr = [[NSArray alloc]initWithObjects:dic1,userInfo, nil];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:TheCurrentUserMessageArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
    //NSMutableArray* arr1 =[[NSMutableArray alloc]init];
   // arr1 = [[NSUserDefaults standardUserDefaults]  objectForKey:TheCurrentUserMessageArray];
   // [arr1 addObject:userInfo];
   // NSLog(@"arr1 = %@",arr1);
   // [[NSUserDefaults standardUserDefaults] setObject:arr1 forKey:TheCurrentUserMessageArray];
   // [[NSUserDefaults standardUserDefaults] synchronize];
   // NSLog(@"userInfo：%@",[[NSUserDefaults standardUserDefaults]  objectForKey:TheCurrentUserMessageArray]);
    if (application.applicationState == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新消息提示" message:[NSString stringWithFormat:@"\n%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    [XGPush handleReceiveNotification:userInfo];
    TheMessageCenterView *secondViewController = [[TheMessageCenterView alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    [self.window setRootViewController:navigationController];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    TheMessageCenterView *secondViewController = [[TheMessageCenterView alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    [self.window setRootViewController:navigationController];
}
@end
