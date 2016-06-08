//
//  PageControl.m
//  Ayibang
//
//  Created by 周际航 on 16/5/9.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import "PageControl.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"

@interface PageControl ()

@property (nonatomic, strong) NSMutableArray *imgViewMArr;

@property (nonatomic, strong) UIImage *normalImage;

@property (nonatomic, strong) UIImage *currentImage;

@end

@implementation PageControl

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
- (void)setUp{
    self.diameter = 6;
    self.padding = 8;
    self.imgViewMArr = [@[] mutableCopy];
    self.normalTintColor = [UIColor whiteColor];
    self.currentTintColor = [UIColor whiteColor];
    
    [self setUpViews];
    [self setUpFrame];
}
#pragma mark - 初始化方法
- (void)clearImageViewMArr{
    for (UIImageView *imgView in self.imgViewMArr) {
        [imgView removeFromSuperview];
    }
    [self.imgViewMArr removeAllObjects];
}
// 创建视图控件
- (void)setUpViews{
    [self clearImageViewMArr];
    for (int i=0; i<self.numberOfPages; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [self normalImage];
        imgView.tintColor = self.normalTintColor;
        [self addSubview:imgView];
        [self.imgViewMArr addObject:imgView];
    }
}
- (void)setUpFrame{
    for (int i=0; i<self.imgViewMArr.count; i++) {
        UIImageView *imgView = self.imgViewMArr[i];
        
        CGFloat x = i*(self.diameter+self.padding);
        CGFloat y = 0;
        
        imgView.frame = CGRectMake(x, y, self.diameter, self.diameter);
    }
    self.size = [self intrinsicContentSize];
}
- (void)setDiameter:(CGFloat)diameter{
    _diameter = diameter;
    
    self.normalImage = nil;
    self.currentImage = nil;
}
- (void)setNumberOfPages:(NSInteger)numberOfPages{
    if (numberOfPages < 0) {return;}
    
    _numberOfPages = numberOfPages;
    [self setUpViews];
    [self setUpFrame];
    self.currentPage = 0;
    
    // 通知视图变化了，重新布局
    [self invalidateIntrinsicContentSize];
}
- (void)setCurrentPage:(NSInteger)currentPage{
    if (currentPage >= self.imgViewMArr.count || currentPage<0) {return;}
    _currentPage = currentPage;
    
    for (UIImageView *imgView in self.imgViewMArr) {
        imgView.image = [self normalImage];
        imgView.tintColor = self.normalTintColor;
    }
    
    UIImageView *imgView = self.imgViewMArr[currentPage];
    imgView.image = [self currentImage];
    imgView.tintColor = self.currentTintColor;
}
#pragma mark - 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setUpFrame];
}
- (CGSize)sizeThatFits:(CGSize)size{
    [super sizeThatFits:size];
    
    return [self intrinsicContentSize];
}
- (CGSize)intrinsicContentSize{
    CGFloat width = (self.diameter+self.padding)*self.imgViewMArr.count - self.padding;
    CGFloat height = self.diameter;
    return CGSizeMake(width, height);
}

#pragma mark - 绘制图片
// 空心圆
- (UIImage *)normalImage{
    if (!_normalImage) {
        _normalImage = [self drawImageWithFill:NO];
    }
    return _normalImage;
}
// 实心圆
- (UIImage *)currentImage{
    if (!_currentImage) {
        _currentImage = [self drawImageWithFill:YES];
    }
    return _currentImage;
}

- (UIImage *)drawImageWithFill:(BOOL)fill{
    UIImage *image = nil;
    CGFloat diameter = self.diameter>0? self.diameter : 1;
    CGFloat onePixel = 1.0/[UIScreen mainScreen].scale;
    CGSize size = CGSizeMake(diameter+onePixel, diameter+onePixel);       // size不可为zero，否则会报警告
    
    // 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    // 取得当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 画圆形边框
    UIColor *borderColor = [UIColor getColor:@"ffffff"];
    [borderColor set];
    CGContextSetLineWidth(ctx,onePixel);
    
    CGFloat radius = diameter * 0.5; // 圆半径
    CGFloat centerX = size.width * 0.5; // 圆心
    CGFloat centerY = size.width * 0.5;
    CGContextAddArc(ctx, centerX, centerY, radius, 0, M_PI * 2, 0);
    CGContextStrokePath(ctx); // 画空心圆
    if (fill) {
        CGContextAddArc(ctx, centerX, centerY, radius, 0, M_PI * 2, 0);
        CGContextFillPath(ctx);   // 画实心圆
    }
    image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    return image;
}


@end






