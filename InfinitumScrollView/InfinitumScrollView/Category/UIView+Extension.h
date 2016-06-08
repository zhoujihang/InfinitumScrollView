//
//  UIView+Extension.h
//  Ayibang
//
//  Created by 阿姨帮 on 15/7/8.
//  Copyright (c) 2015年 ayibang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

#pragma mark - 便捷修改，访问UIView的frame属性的分类 ConvenienceFrame
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;

- (CGFloat)maxX;
- (CGFloat)maxY;

#pragma mark - 获取视图的控制器
- (UIViewController*)ext_viewController;

// 设置view内所有的btn独享点击事件
- (void)allBtnSetExclusiveTouch;
// 移除内部所有子控件
- (void)ext_removeAllSubviews;

@end
