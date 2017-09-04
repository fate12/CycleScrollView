//
//  LYYCycleScrollView.h
//  无限轮播
//
//  Created by 刘元元 on 2017/8/25.
//  Copyright © 2017年 刘元元. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol clickDeleage <NSObject>

- (void)cyclePageClickAction:(NSInteger)clickIndex;

@end
@interface LYYCycleScrollView : UIView

@property (nonatomic,strong) NSArray *imagesGroup;
@property (nonatomic,assign) NSTimeInterval pagesCycleTime;
+(instancetype)initWithScrollView:(NSArray *)images frame:(CGRect)frame pagesCycleTime:(NSTimeInterval)time;
@property (nonatomic, weak)id<clickDeleage>delegate;

@end
