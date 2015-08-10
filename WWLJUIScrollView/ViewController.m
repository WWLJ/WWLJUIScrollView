//
//  ViewController.m
//  WWLJUIScrollView
//
//  Created by 武文杰 on 15/8/10.
//  Copyright (c) 2015年 武文杰. All rights reserved.
//

#import "ViewController.h"
#import "WWLJScrollView.h"

#define WWLJScreenW [[UIScreen mainScreen] bounds].size.width
#define WWLJScreenH [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<UIScrollViewDelegate, WWLJScrollViewDelegate>

@property (nonatomic, strong)WWLJScrollView *ScrollView;

@property (nonatomic, strong)NSMutableArray *imageArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.ScrollView];
    [self.ScrollView setImages:self.imageArray state:YES];
}


- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
        for (int i = 0; i < 8; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%d.jpg",i];
            [_imageArray addObject:imageName];
        }
    }
    return _imageArray;
}

- (WWLJScrollView *)ScrollView
{
    if (!_ScrollView) {
        _ScrollView = [[WWLJScrollView alloc] initWithFrame:CGRectMake(0, 0, WWLJScreenW, WWLJScreenH)];
        _ScrollView.delegate = self;
    }
    return _ScrollView;
}



@end
