//
//  ViewController.m
//  cai
//
//  Created by zbj on 16/3/31.
//  Copyright © 2016年 zbj. All rights reserved.
//

#import "ViewController.h"
#import "HexagonView.h"
#import "JHChainableAnimations.h"

@interface ViewController ()

@property (nonatomic, strong) HexagonView *myImage;//匹配视图
@property (nonatomic, strong) HexagonView *youView;//对手头像视图
@property (nonatomic, strong) HexagonView *myView;//我的头像视图

@property (nonatomic, strong) UILabel *yourNameLabel;//对手名字
@property (nonatomic, strong) UILabel *myNameLabel;//我的名字

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:bgImg];
    bgImg.image = [UIImage imageNamed:@"赏金底"];
    
    UIButton *one = [UIButton buttonWithType:UIButtonTypeCustom];
    [one addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    one.frame = CGRectMake(40, 300, 80, 100);
    [one setImage:[UIImage imageNamed:@"100"] forState:UIControlStateNormal];
    one.tag = 1;
    [self.view addSubview:one];
    UIButton *two = [UIButton buttonWithType:UIButtonTypeCustom];
    [two addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    two.frame = CGRectMake(140, 300, 80, 100);
    [two setImage:[UIImage imageNamed:@"500"] forState:UIControlStateNormal];
    [self.view addSubview:two];
    two.tag = 2;
    UIButton *three = [UIButton buttonWithType:UIButtonTypeCustom];
    [three addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    three.frame = CGRectMake(240, 300, 80, 100);
    [three setImage:[UIImage imageNamed:@"3000"] forState:UIControlStateNormal];
    three.tag = 3;
    [self.view addSubview:three];
}

- (void)click:(UIButton *)button
{
    __weak ViewController *weakSelf = self;
    button.userInteractionEnabled = NO;
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
#pragma mark -添加阴影
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.376];
    [window addSubview:bgView];
    
    _myView = [[HexagonView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, [UIScreen mainScreen].bounds.size.height / 2 - 50, 100, 100)];
    _myView.image = [UIImage imageNamed:@"ima2"];
    [window addSubview:_myView];
    
    _youView = [[HexagonView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, [UIScreen mainScreen].bounds.size.height / 2 - 50, 100, 100)];
    _youView.image = [UIImage imageNamed:@"ima1"];
    [window addSubview:_youView];
    
#pragma mark -匹配图片切换动画
    _myImage = [[HexagonView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, [UIScreen mainScreen].bounds.size.height / 2 - 50, 100, 100)];
    NSArray *arr = [NSArray arrayWithObjects:[UIImage imageNamed:@"3000"],[UIImage imageNamed:@"100"],[UIImage imageNamed:@"500"], nil];
    [_myImage setAnimationImages:arr];
    [_myImage setAnimationDuration:3];
    [_myImage setAnimationRepeatCount:1];
    [window addSubview:_myImage];
    [_myImage startAnimating];
    _myImage.makeScale(1.0).animate(3.0);
    
#pragma mark -匹配完成后调用的动画
    _myImage.animationCompletion = JHAnimationCompletion(){
        UIBezierPath *myPath = [weakSelf.myView bezierPathForAnimation];
        [myPath addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width / 2 - 50 + 150, [UIScreen mainScreen].bounds.size.height / 2 - 50 + 150)];
        weakSelf.myView.moveOnPath(myPath).animate(1.0);
        weakSelf.myView.animationCompletion = JHAnimationCompletion(){
#pragma mark -我的头像第一次移动的动画完成后调用的动画
            weakSelf.myNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 400, 150, 40)];
            weakSelf.myNameLabel.text = @"我的名字";
            weakSelf.myNameLabel.textColor = [UIColor whiteColor];
            weakSelf.myNameLabel.backgroundColor = [UIColor colorWithRed:0.427 green:0.859 blue:1.000 alpha:0.816];
            [window addSubview:weakSelf.myNameLabel];
            weakSelf.myView.makeScale(1.0).animate(1.0);
#pragma mark -移除文字,我的头像横移后移出动画
            weakSelf.myView.animationCompletion = JHAnimationCompletion(){
                weakSelf.myNameLabel.alpha = 0.0;
                UIBezierPath *myPath = [weakSelf.myView bezierPathForAnimation];
                [myPath addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 - 50 + 150)];
                [myPath addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height + 100)];
                weakSelf.myView.moveOnPath(myPath).animate(1.0);
                weakSelf.myView.animationCompletion = JHAnimationCompletion(){
                    NSLog(@"弹出新视图");
                };
            };
        };
        
        UIBezierPath *yourPath = [weakSelf.youView bezierPathForAnimation];
        [yourPath addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width / 2 - 50 - 50, [UIScreen mainScreen].bounds.size.height / 2 - 50 - 50)];
        weakSelf.youView.moveOnPath(yourPath).animate(1.0);
        weakSelf.youView.animationCompletion = JHAnimationCompletion(){
#pragma mark -对手的头像第一次移动的动画完成后调用的动画
            weakSelf.yourNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, [UIScreen mainScreen].bounds.size.height / 2 - 120, 150, 40)];
            weakSelf.yourNameLabel.text = @"你的对手名字";
            weakSelf.yourNameLabel.textColor = [UIColor whiteColor];
            weakSelf.yourNameLabel.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.549];
            [window addSubview:weakSelf.yourNameLabel];
            weakSelf.youView.makeScale(1.0).animate(1.0);
#pragma mark -移除文字,对手头像横移后移出动画
            weakSelf.youView.animationCompletion = JHAnimationCompletion(){
                weakSelf.yourNameLabel.alpha = 0.0;
                UIBezierPath *yourPath = [weakSelf.youView bezierPathForAnimation];
                [yourPath addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 - 50 - 50)];
                [yourPath addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width / 2, -100)];
                weakSelf.youView.moveOnPath(yourPath).animate(1.0);
            };
        };
        
    };
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
