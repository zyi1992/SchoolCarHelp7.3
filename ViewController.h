//
//  ViewController.h
//  SchoolCarHelp
//
//  Created by OurEDA on 14-9-16.
//  Copyright (c) 2014年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sign_inViewController.h"

@interface ViewController : UIViewController<UIScrollViewDelegate,UIApplicationDelegate>
{
    NSArray *imageArray;//存放图片
    //NSTimer *myTimer;//定时器
    
}
@property(nonatomic,retain) UIScrollView *myScrollView;
@property(nonatomic,retain) UIPageControl *pageControl;
@property(nonatomic)NSInteger flag;
@end