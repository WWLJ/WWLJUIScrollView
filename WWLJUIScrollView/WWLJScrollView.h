//
//  WWLJScrollView.h
//  WWLJUIScrollView
//
//  Created by 武文杰 on 15/8/10.
//  Copyright (c) 2015年 武文杰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WWLJImageView;
@protocol WWLJScrollViewDelegate <NSObject>

@optional
- (void)selectScrollIndex:(NSInteger)index imageView:(WWLJImageView *)imageView;

@end

@interface WWLJScrollView : UIView

@property(nonatomic, assign)id<WWLJScrollViewDelegate>delegate;

/**
 *  接收图片名称的数组或者是model的数组
 *
 *                  实现方法自定义,是否自动滚动,
 *
 *  @param names 照片名的数组
 *
 *  @param state 是否自动循环滚动
 */
- (void)setImages:(NSMutableArray *)names state:(BOOL)state;

@end
