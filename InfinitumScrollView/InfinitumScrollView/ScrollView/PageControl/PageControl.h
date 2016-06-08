//
//  PageControl.h
//  Ayibang
//
//  Created by 周际航 on 16/5/9.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageControl : UIView

@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPage;

// 球的直径
@property (nonatomic, assign) CGFloat diameter;
// 球的间隔
@property (nonatomic, assign) CGFloat padding;

@property (nonatomic, strong) UIColor *normalTintColor;

@property (nonatomic, strong) UIColor *currentTintColor;

@end
