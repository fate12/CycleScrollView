//
//  ViewController.m
//  无限轮播
//
//  Created by 刘元元 on 2017/8/25.
//  Copyright © 2017年 刘元元. All rights reserved.
//

#import "ViewController.h"
#import "LYYCycleScrollView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface ViewController ()<clickDeleage>{
    LYYCycleScrollView *view;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSArray *images = @[@"main_banner1.jpg",@"main_banner2.jpg"];
    view = [LYYCycleScrollView initWithScrollView:images frame:CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_WIDTH * 11/27) pagesCycleTime:2];
    view.delegate = self;
    [self.view addSubview:view];
    
}

- (void)cyclePageClickAction:(NSInteger)clickIndex
{
    NSLog(@"点击了第%ld个图片",clickIndex);
}

@end
