//
//  LYYCycleScrollView.m
//  无限轮播
//
//  Created by 刘元元 on 2017/8/25.
//  Copyright © 2017年 刘元元. All rights reserved.
//

#import "LYYCycleScrollView.h"

@interface LYYCycleScrollView()<UIScrollViewDelegate>{
    
    NSInteger currentIndex;
    
}

@property (nonatomic, strong)UIImageView * leftImageView;
@property (nonatomic, strong)UIImageView * middleImageView;
@property (nonatomic, strong)UIImageView * rightImageView;
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, readwrite, strong)UIPageControl *pageControl;

@end


@implementation LYYCycleScrollView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        currentIndex = 0;
        
        [self addSubview:self.scrollView];
        
        [self addTapGesture];
        

    }
    return self;
}

+(instancetype)initWithScrollView:(NSArray *)images frame:(CGRect)frame pagesCycleTime:(NSTimeInterval)time{
    
    LYYCycleScrollView *view = [[self alloc] initWithFrame:frame];
    
    
    view.pagesCycleTime = time;
    view.imagesGroup = [NSMutableArray arrayWithArray:images];
    
    return view;
    
}

-(void)setImagesGroup:(NSArray *)imagesGroup{
    
    _imagesGroup = imagesGroup;
    
    NSLog(@"%@",_imagesGroup);
    
    [self initCycleImage];//开始时图片的位置
    [self addPageControl];
    
    
}

-(UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.contentSize = CGSizeMake(3*_scrollView.frame.size.width, _scrollView.frame.size.height);
        _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0)//显示中间图片
        ;
        _scrollView.backgroundColor = [UIColor grayColor];
        self.leftImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0  , _scrollView.frame.size.width, _scrollView.frame.size.height)];
        
        self.middleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width, 0  , _scrollView.frame.size.width, _scrollView.frame.size.height)];
        self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        
        
        [_scrollView addSubview:_leftImageView];
        [_scrollView addSubview:_rightImageView];
        [_scrollView addSubview:_middleImageView];
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        
    }
    
    return _scrollView;
}

-(void)addTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer   alloc]initWithTarget:self action:@selector(clickPageAction)];
    [self addGestureRecognizer:tap];
}

- (void)initCycleImage{
    
    
    //判断图片小于两张
    
    NSInteger currentID = (currentIndex + _imagesGroup.count)%_imagesGroup.count;//当期的图片index
    NSInteger nextID = (currentIndex + 1 + _imagesGroup.count)%_imagesGroup.count;//下一个
    NSInteger lastID = (currentIndex - 1 + _imagesGroup.count)%_imagesGroup.count;//上一个
    
    _middleImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imagesGroup[currentID]]];
    _leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imagesGroup[lastID]]];
    _rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imagesGroup[nextID]]];
    
    [self addTimer];//添加计时器
}

- (void)addTimer{

    //将定时器放入主进程的RunLoop中
    self.timer = [NSTimer timerWithTimeInterval:self.pagesCycleTime target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)timeChanged
{

    currentIndex = (currentIndex + 1 + _imagesGroup.count)%_imagesGroup.count;//计时器开始一次，将下一个图片的index赋值给当期currentIndex
    self.pageControl.currentPage = currentIndex;
    [self changeImageViewWith:currentIndex];
    
}
- (void)changeImageViewWith:(NSInteger)index
{
    
    NSInteger currentID = (index + _imagesGroup.count)%_imagesGroup.count;
    NSInteger nextID = (index + 1 + _imagesGroup.count)%_imagesGroup.count;
    NSInteger lastID = (index - 1 + _imagesGroup.count)%_imagesGroup.count;
    
    
    _middleImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imagesGroup[currentID]]];
    _leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imagesGroup[lastID]]];
    _rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imagesGroup[nextID]]];
    

    [_scrollView setContentOffset:CGPointMake(2 * _scrollView.frame.size.width, 0) animated:YES];//有个向左推动的效果
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.origin.x, 0);//始终中间显示_middleImageView
    
    
}

- (void)pageChangeAnimationType:(NSInteger)animationType
{
    if (animationType == 0) {
        return;
    }else if (animationType == 1) {
        
    }else if (animationType == 2){
        _scrollView.contentOffset = CGPointMake(2*self.frame.size.width, 0);
        [UIView animateWithDuration:_pagesCycleTime delay:0.0f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
        } completion:^(BOOL finished) {
        }];
        
    }
    
    
}

- (void)addPageControl
{
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.currentPage = 0;
    _pageControl.frame = CGRectMake(0, _scrollView.frame.origin.y + _scrollView.frame.size.height-20, self.frame.size.width, 20);
    [self addSubview:_pageControl];
    _pageControl.numberOfPages = _imagesGroup.count;
}
#pragma mark ---------tapGesture 方法

- (void)clickPageAction
{
    if ([self.delegate respondsToSelector:@selector(cyclePageClickAction:)]) {
        [self.delegate cyclePageClickAction:currentIndex];
    }
}
#pragma mark - ScrollView  Delegate
//当用户手动轮播时 关闭定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"开始手动");
    [self.timer invalidate];
}

//当用户手指停止滑动图片时 启动定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"开始自动");
    [self addTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = [_scrollView contentOffset];
    
    if (offset.x == 2*_scrollView.frame.size.width) {
        currentIndex =  (currentIndex + 1 + _imagesGroup.count)%_imagesGroup.count;

    } else if (offset.x == 0){
        currentIndex =  (currentIndex - 1 + _imagesGroup.count)%_imagesGroup.count;
;
    }else{
        return;
    }
    
    self.pageControl.currentPage = currentIndex;
    [self changeImageViewWith:currentIndex];
    
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, _scrollView.frame.origin.y);
    
}


@end
