//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"

#define kWidth  150.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0

@interface CustomAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation CustomAnnotationView

@synthesize calloutView;
@synthesize portraitImageView   = _portraitImageView;
@synthesize nameLabel           = _nameLabel;

#pragma mark - Handle Action

- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
}

#pragma mark - Override

- (NSString *)name
{
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
//        if (self.calloutView == nil)
//        {
//            /* Construct custom callout. */
//            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
//            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
//                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
//            
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            btn.frame = CGRectMake(10, 10, 40, 40);
//            [btn setTitle:@"Test" forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//            [btn setBackgroundColor:[UIColor whiteColor]];
//            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
//            
//            [self.calloutView addSubview:btn];
//            
//            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 30)];
//            name.backgroundColor = [UIColor clearColor];
//            name.textColor = [UIColor whiteColor];
//            name.text = @"Hello Amap!";
//            [self.calloutView addSubview:name];
//        }
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier title:(NSString*)titlet
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.nameLabel.text = titlet;
        //NSLog(@"%d++++++",[titlet length]);
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        self.backgroundColor = [UIColor clearColor];
        
        /* Create portrait image view and add to view hierarchy. */
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(48, -15, kPortraitWidth, kPortraitHeight)];
        [self addSubview:self.portraitImageView];
        
        /* Create name label. */
        UIView* nameView = [[UIView alloc]init];
        nameView.frame =CGRectMake(kPortraitWidth + kHoriMargin+33,
                                   -15,
                                   kWidth - kPortraitWidth - kHoriMargin+20+[titlet length]*8,
                                   kHeight - 2 * kVertMargin-25);
        NSLog(@"+++++++%d",[titlet length]);
        UIImageView* imag = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"地址信息栏.PNG"]];
        imag.frame =CGRectMake(0,
                        0,
                               kWidth - kPortraitWidth - kHoriMargin+18+[titlet length]*8,
                               kHeight - 2 * kVertMargin-25);
        //kWidth - kPortraitWidth - kHoriMargin+130
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,2,kWidth - kPortraitWidth - kHoriMargin+[titlet length]*8,
                                                                   kHeight - 2 * kVertMargin-30)];
        self.nameLabel.textAlignment    = NSTextAlignmentLeft;
        //self.nameLabel.layer.cornerRadius = 7.0f;
        //[self.nameLabel sizeToFit];
        self.nameLabel.textColor        = [UIColor blueColor];
        self.nameLabel.font             = [UIFont systemFontOfSize:15.f];
        [imag addSubview:self.nameLabel];
        [nameView addSubview:imag];
        [self addSubview:nameView];
    }
    
    return self;
}

@end
