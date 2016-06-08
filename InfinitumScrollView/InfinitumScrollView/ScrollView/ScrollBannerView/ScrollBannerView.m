//
//  ScrollBannerView.m
//  Ayibang
//
//  Created by 周际航 on 16/5/11.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import "ScrollBannerView.h"
#import "PageControl.h"
#import "FixedIntrinsicSizeImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import "UIView+Extension.h"
#import "UIColor+Extension.h"

//static CGFloat const kScaleHM = 140/375.0;

@interface ScrollBannerView ()<UIScrollViewDelegate>

// 控件属性
@property (weak, nonatomic) UIScrollView *scrollView;
// 用于单图时显示
@property (nonatomic, weak) FixedIntrinsicSizeImageView *singleImgView;
@property (weak, nonatomic) PageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *imgViewMArr;

@property (nonatomic, strong) NSTimer *timer;
// 当前显示的图片索引
@property (nonatomic, assign) NSInteger currentImageIndex;

@end

@implementation ScrollBannerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
- (void)setUp{
    [self setUpViews];
    [self setUpConstraints];
}
// 创建视图控件
- (void)setUpViews{
    self.preferedWidth = -1;
    self.scaleHM = 112/375.0;   // 默认比例
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    self.imgViewMArr = [@[] mutableCopy];
    for (int i=0; i<3; i++) {
        UIImageView *imgView = [[FixedIntrinsicSizeImageView alloc]init];
        imgView.backgroundColor = [UIColor getColor:@"eef2f2"];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self.scrollView addSubview:imgView];
        [self.imgViewMArr addObject:imgView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFunction:)];
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:tapGesture];
    }
    
    FixedIntrinsicSizeImageView *singleImgView = [[FixedIntrinsicSizeImageView alloc] init];
    singleImgView.backgroundColor = [UIColor getColor:@"eef2f2"];
    singleImgView.contentMode = UIViewContentModeScaleAspectFill;
    singleImgView.clipsToBounds = YES;
    singleImgView.hidden = YES;
    singleImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFunction:)];
    [singleImgView addGestureRecognizer:tapGesture];
    [self addSubview:singleImgView];
    self.singleImgView = singleImgView;
    
    PageControl *pageControl = [[PageControl alloc] init];
    pageControl.diameter = (6);
    pageControl.padding = (8);
    pageControl.normalTintColor = [UIColor getColor:@"ffffff"];
    pageControl.currentTintColor = [UIColor getColor:@"ffffff"];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}
// 设置控件约束关系
- (void)setUpConstraints{
    
    __weak typeof(self) weakSelf = self;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.singleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-weakSelf.pageControl.diameter);
    }];
    
    // 设置scroll内部子控件约束
    UIView *view1 = [self.imgViewMArr firstObject];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(weakSelf.scrollView);
        make.centerY.equalTo(weakSelf.scrollView);
        make.width.equalTo(weakSelf.scrollView);
    }];
    
    for (int i=1; i<self.imgViewMArr.count; i++) {
        UIView *aView = self.imgViewMArr[i-1];
        UIView *bView = self.imgViewMArr[i];
        
        [bView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(aView.mas_right);
            make.top.bottom.equalTo(aView);
            make.width.equalTo(aView);
        }];
    }
    
    UIView *view3 = [self.imgViewMArr lastObject];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.scrollView);
    }];
    
}
- (CGSize)intrinsicContentSize{
    if (self.preferedWidth == -1) {
        return CGSizeMake(-1, -1);
    }
    
    CGFloat height = self.preferedWidth * self.scaleHM;
    CGSize size = CGSizeMake(self.preferedWidth, height);
    
    return size;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.preferedWidth == -1) {
        self.preferedWidth = self.width;
        [self invalidateIntrinsicContentSize];
    }
    [super layoutSubviews];
    [self layoutIfNeeded];
}
- (void)setPreferedWidth:(CGFloat)preferedWidth{
    _preferedWidth = preferedWidth;
    
    CGSize size = [self intrinsicContentSize];
    self.bounds = CGRectMake(0, 0, size.width, size.height);
    [self setUpContentOffset];
}
// 设置初始化时contentoffset的值
- (void)setUpContentOffset{
    CGSize size = self.scrollView.size;
    self.scrollView.contentOffset = CGPointMake(size.width, 0);
}
- (void)showSingleImgView{
    if (self.bannerListModel.bannerArr.count != 1) {return;}
    self.singleImgView.hidden = NO;
    
    NewBannerModel *model = self.bannerListModel.bannerArr[0];
    if (model.localImage) {
        self.singleImgView.image = model.localImage;
        self.singleImgView.contentMode = UIViewContentModeScaleAspectFill;
        return;
    }
    
    NSURL *url = [NSURL URLWithString:model.image];
    self.singleImgView.contentMode = UIViewContentModeCenter;
    UIImage *placeholder = [UIImage imageNamed:@"home_toprecommend_placehold"];
    __weak typeof(self) weakSelf = self;
    [self.singleImgView sd_setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            weakSelf.singleImgView.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
}
- (void)setBannerListModel:(NewBannerListModel *)bannerListModel{
    
    _bannerListModel = bannerListModel;
    NSInteger count = self.bannerListModel.bannerArr.count;
    
    if (count == 1) {
        self.pageControl.numberOfPages = 0;
        [self showSingleImgView];
    }else{
        self.singleImgView.hidden = YES;
        self.pageControl.numberOfPages = count>=1 ? count : 0;
        self.pageControl.currentPage = 0;
        self.currentImageIndex = 0;
        [self addTimer];
    }
}

#pragma mark - 图片点击方法
- (void)tapFunction:(UITapGestureRecognizer *)tapGesture{
    NewBannerModel *bannerModel = nil;
    if (self.bannerListModel.bannerArr.count == 0) {return;}
    if (self.currentImageIndex >= self.bannerListModel.bannerArr.count) {return;}
    
    if (self.bannerListModel.bannerArr.count == 1) {
        bannerModel = self.bannerListModel.bannerArr[0];
    }else{
        bannerModel = self.bannerListModel.bannerArr[self.currentImageIndex];
    }
    if ([self.delegate respondsToSelector:@selector(scrollBannerView:clickedImgWithBannerModel:)]) {
        [self.delegate scrollBannerView:self clickedImgWithBannerModel:bannerModel];
    }
}

#pragma mark - scrollview 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = self.scrollView.contentOffset.x;
    if (offsetX == self.scrollView.width*2 || offsetX == 0) {
        [self resetScrollViewContentOffset];
    }
}
// 重置contentOffset,让其指向中间的图片
- (void)resetScrollViewContentOffset{
    CGPoint offsetPoint = self.scrollView.contentOffset;
    NSInteger currentImageIndex = self.currentImageIndex;
    if (offsetPoint.x == 0) {
        // 左滑
        currentImageIndex = currentImageIndex-1 >= 0 ? currentImageIndex-1 : self.bannerListModel.bannerArr.count-1;
    }else if (offsetPoint.x == self.scrollView.width*2){
        // 右滑
        currentImageIndex = currentImageIndex+1 >= self.bannerListModel.bannerArr.count ? 0 : currentImageIndex+1;
    }
    self.currentImageIndex = currentImageIndex;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, 0) animated:NO];
}

// 设置当前展示图片的索引，切换了3个图片视图的图片内容和pagecontrol的索引
- (void)setCurrentImageIndex:(NSInteger)currentImageIndex{
    _currentImageIndex = currentImageIndex;
    NSInteger bannerCount = self.bannerListModel.bannerArr.count;
    UIImageView *imageView0 = self.imgViewMArr[0];
    UIImageView *imageView1 = self.imgViewMArr[1];
    UIImageView *imageView2 = self.imgViewMArr[2];
    
    NSInteger imageIndex0 = currentImageIndex-1 >= 0 ? currentImageIndex-1 : self.bannerListModel.bannerArr.count-1;
    NSInteger imageIndex1 = currentImageIndex;
    NSInteger imageIndex2 = currentImageIndex+1 >= self.bannerListModel.bannerArr.count ? 0 : currentImageIndex+1;
    if (bannerCount == 0) {
        imageIndex0 = 0;
        imageIndex1 = 0;
        imageIndex2 = 0;
    }
    
    NewBannerModel *banner0 = imageIndex0<bannerCount ? self.bannerListModel.bannerArr[imageIndex0] : nil;
    NewBannerModel *banner1 = imageIndex1<bannerCount ? self.bannerListModel.bannerArr[imageIndex1] : nil;
    NewBannerModel *banner2 = imageIndex2<bannerCount ? self.bannerListModel.bannerArr[imageIndex2] : nil;
    
    UIImage *placeholder = [UIImage imageNamed:@"home_toprecommend_placehold"];
    NSURL *imageUrl0 = [NSURL URLWithString:banner0.image];
    NSURL *imageUrl1 = [NSURL URLWithString:banner1.image];
    NSURL *imageUrl2 = [NSURL URLWithString:banner2.image];
    imageView0.contentMode = UIViewContentModeCenter;
    imageView1.contentMode = UIViewContentModeCenter;
    imageView2.contentMode = UIViewContentModeCenter;
    [imageView0 sd_setImageWithURL:imageUrl0 placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            imageView0.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
    [imageView1 sd_setImageWithURL:imageUrl1 placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            imageView1.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
    [imageView2 sd_setImageWithURL:imageUrl2 placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            imageView2.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
    
    self.pageControl.currentPage = currentImageIndex;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}
#pragma mark - 定时器相关代码
- (void)addTimer{
    if (self.timer) {
        [self removeTimer];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerTask) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)timerTask{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*2, 0) animated:YES];
}
@end