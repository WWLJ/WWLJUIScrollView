//
//  WWLJScrollView.m
//  WWLJUIScrollView
//
//  Created by 武文杰 on 15/8/10.
//  Copyright (c) 2015年 武文杰. All rights reserved.
//

#import "WWLJScrollView.h"
#import "WWLJImageView.h"
#import "UIImageView+WebCache.h"

@interface WWLJScrollView ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *scroll;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, strong)UIPageControl *pageC;

@end

@implementation WWLJScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.page = 1;

    }
    return self;
}



#pragma mark -
#pragma  mark 给scroll提供图片名字,添加图片
- (void)setImages:(NSMutableArray *)names state:(BOOL)state
{
    if (state == YES) {
        // 计时器,每隔几秒干什么事(实现自动滚动功能)
        if (self.timer) {
            [self stopTimer];
            [self startTimer];
            _page = 1;
        }else{
            [self startTimer];
        }
    }
    // 循环滚动需要多俩张图片   头和脚
    NSDictionary *firstName = [names firstObject];
    NSDictionary *lastName = [names lastObject];
    [names insertObject:lastName atIndex:0];
    [names addObject:firstName];
    // 设置可以滚动的范围大小
    [self.scroll setContentSize:CGSizeMake(self.scroll.frame.size.width * names.count, 0)];
    // 整页滚动
    self.scroll.pagingEnabled = YES;
    
    int count = 0;
    for (NSString *na in names) {
        // 自定义的地方(可以自定义整个滚动要展示的界面)
        
        WWLJImageView *view = [[WWLJImageView alloc] initWithFrame:CGRectMake(self.scroll.frame.size.width * count, 0, self.scroll.frame.size.width, self.scroll.frame.size.height)];
        //如果是网络请求
//        [view sd_setImageWithURL:[NSURL URLWithString:[na objectForKey:@"focus"]] placeholderImage:[UIImage imageNamed:@"place.png"]];
        
        //如果是本地
        view.image = [UIImage imageNamed:na];
        
        view.userInteractionEnabled = YES;
        [self.scroll addSubview:view];

        
        //点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [view addGestureRecognizer:tap];
        count++;
    }
    
    self.pageC.numberOfPages = names.count - 2;
    
    [self.scroll setContentOffset:CGPointMake(self.scroll.frame.size.width, 0)];
}


#pragma mark --
#pragma mark privateMethod
- (void)timeAction:(NSTimer *)timer
{
    // 触发之后页数+1
    self.page++;
    self.pageC.currentPage = self.page - 1;
    // 设置偏移量
    CGFloat offWidth = self.page * self.scroll.frame.size.width;
    
    
    // 加动画
    [UIView animateWithDuration:1.0f animations:^{
        // 改变偏移量,一页一页翻动
        [self.scroll setContentOffset:CGPointMake(offWidth, 0)];
    }];
    
    NSInteger number = self.scroll.contentSize.width / self.scroll.frame.size.width;
    if (self.page == number - 1) {
        self.page = 1;
        self.scroll.contentOffset = CGPointMake(self.scroll.frame.size.width, 0);
        self.pageC.currentPage = 0;
    }
}

- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    [self.timer invalidate];//停止
    self.timer = nil;
}

#pragma mark -
#pragma mark 协议方法,实现循环滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
     [self stopTimer];
    // 判断为最后一张时,改变偏移量
    CGPoint point = scrollView.contentOffset;
    CGSize size = scrollView.contentSize;
    CGFloat width = scrollView.frame.size.width;
    
    self.page = point.x / width;
    
    if (point.x == size.width - width) {
        self.page = 1;
        scrollView.contentOffset = CGPointMake(width, 0);
    }else if (point.x == 0){
        scrollView.contentOffset = CGPointMake(size.width - 2 * width, 0);
        self.page = self.scroll.contentSize.width / self.scroll.frame.size.width - 2;
    }
    self.pageC.currentPage = self.scroll.contentOffset.x / self.scroll.frame.size.width - 1;
    self.scroll.contentOffset = CGPointMake(self.scroll.contentOffset.x, 0);
    [self startTimer];
}

#pragma mark -
#pragma mark 手势触发的事件
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    WWLJImageView *aView = (WWLJImageView *)tap.view;
    NSInteger currentPage = self.page;
    // 加入当前是滚动到第0下标的那张图片,则返回到调用界面所提供的照片的最后一个
    if (currentPage == 0) {
        currentPage = self.scroll.contentSize.width / self.scroll.frame.size.width - 3;
        if ([self.delegate respondsToSelector:@selector(selectScrollIndex:imageView:)]) {
            [self.delegate selectScrollIndex:currentPage imageView:aView];
        }
        NSLog(@"%ld", currentPage);
        return;
    }
    // 如果滚到最后一张图片,则返回的是提供的第一张图片
    if (currentPage == self.scroll.contentSize.width / self.scroll.frame.size.width - 1){
        currentPage = 0;
        if ([self.delegate respondsToSelector:@selector(selectScrollIndex:imageView:)]) {
            [self.delegate selectScrollIndex:currentPage imageView:aView];
        }
        NSLog(@"%ld", currentPage);
        return;
    }
    // 假如不符合以上俩种情况,则说明在中间,只需要减一即可
    currentPage--;
    if ([self.delegate respondsToSelector:@selector(selectScrollIndex:imageView:)]) {
        [self.delegate selectScrollIndex:currentPage imageView:aView];
    }
    NSLog(@"%ld", currentPage);
    return;
    
}


#pragma mark --
#pragma mark 懒加载
-(UIScrollView *)scroll
{
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scroll.delegate = self;
        _scroll.bounces = NO;
        _scroll.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scroll];
    }
    return _scroll;
}

-(UIPageControl *)pageC
{
    if (!_pageC) {
        _pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 30)];
        _pageC.userInteractionEnabled = NO;
        [self addSubview:_pageC];
    }
    return _pageC;
}



@end
