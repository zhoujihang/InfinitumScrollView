//
//  ScrollPageView.m
//  Ayibang
//
//  Created by 周际航 on 16/6/6.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import "ScrollPageView.h"
#import <Masonry/Masonry.h>
#import "UIView+Extension.h"

@interface ScrollPageView() <ScrollPageViewControllerDelegate>

@property (nonatomic, strong, readwrite) ScrollPageViewController *scrollPageVC;

@end

@implementation ScrollPageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
- (void)setUp{
    self.preferedWidth = -1;
    self.scaleHM = 112/375.0;   // 默认比例
    [self setUpViews];
    [self setUpConstraints];
}
// 创建视图控件
- (void)setUpViews{
    self.scrollPageVC = [ScrollPageViewController horizontalScrollPageViewController];
    self.scrollPageVC.scrollPageDelegate = self;
    [self addSubview:self.scrollPageVC.view];
}
// 设置控件约束关系
- (void)setUpConstraints{
    __weak typeof(self) weakSelf = self;
    [self.scrollPageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
}

- (CGSize)intrinsicContentSize{
    if (self.preferedWidth == -1) {
        return  CGSizeMake(-1, -1);
    }
    
    CGFloat height = self.preferedWidth * self.scaleHM;
    CGSize size = CGSizeMake(self.preferedWidth, height);
    return size;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.preferedWidth == -1){
        self.preferedWidth = self.width;
        [self invalidateIntrinsicContentSize];
    }
    
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}
- (void)setBannerListModel:(NewBannerListModel *)bannerListModel{
    _bannerListModel = bannerListModel;
    
    // 设置好默认 placeholder 图片
    for (int i=0; i<bannerListModel.bannerArr.count; i++) {
        NewBannerModel *model = bannerListModel.bannerArr[i];
        model.placeHolderImage = [UIImage imageNamed:@"home_toprecommend_placehold"];
    }
    self.scrollPageVC.bannerListModel = bannerListModel;
}
- (void)setPreferedWidth:(CGFloat)preferedWidth{
    _preferedWidth = preferedWidth;
    
    CGSize size = [self intrinsicContentSize];
    self.bounds = CGRectMake(0, 0, size.width, size.height);
}

-  (void)scrollPageViewController:(ScrollPageViewController *)vc clickedImgWithBannerModel:(NewBannerModel *)bannerModel{
    if([self.delegate respondsToSelector:@selector(scrollPageView:clickedImgWithBannerModel:)]) {
        [self.delegate scrollPageView:self clickedImgWithBannerModel:bannerModel];
    }
}


@end
