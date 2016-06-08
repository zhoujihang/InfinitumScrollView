//
//  ScrollBannerViewCell.m
//  Ayibang
//
//  Created by 周际航 on 16/5/11.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import "ScrollBannerViewCell.h"
#import <Masonry/Masonry.h>
#import "ScrollBannerView.h"

@interface ScrollBannerViewCell ()<ScrollBannerViewDelegate>

@property (nonatomic, weak) ScrollBannerView *scrollBannerView;

@end

@implementation ScrollBannerViewCell

+ (NSString *)cellIdentify{
    return NSStringFromClass([self class]);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.preferedWidth = [UIScreen mainScreen].bounds.size.width;
    ScrollBannerView *scrollBannerView = [[ScrollBannerView alloc] init];
    scrollBannerView.scaleHM = 140/375.0;
    scrollBannerView.delegate = self;
    [self.contentView addSubview:scrollBannerView];
    self.scrollBannerView = scrollBannerView;
}
// 设置控件约束关系
- (void)setUpConstraints{
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    __weak typeof(self) weakSelf = self;
    
    [self.scrollBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.contentView);
    }];
}
- (CGFloat)cellHeight{
    self.scrollBannerView.preferedWidth = self.preferedWidth;
    CGSize size = self.scrollBannerView.intrinsicContentSize;
    CGFloat height = ceill(size.height);

    return height;
}
- (void)setListModel:(NewBannerListModel *)listModel{
    _listModel = listModel;
    
    self.scrollBannerView.bannerListModel = listModel;
}

- (void)scrollBannerView:(ScrollBannerView *)view clickedImgWithBannerModel:(NewBannerModel *)bannerModel{
    if ([self.delegate respondsToSelector:@selector(scrollBannerViewCell:clickedImgWithBannerModel:)]) {
        [self.delegate scrollBannerViewCell:self clickedImgWithBannerModel:bannerModel];
    }
}

@end
