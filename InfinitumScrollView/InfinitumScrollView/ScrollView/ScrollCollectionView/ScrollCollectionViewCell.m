//
//  ScrollCollectionViewCell.m
//  Ayibang
//
//  Created by 周际航 on 16/6/7.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import "ScrollCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "ScrollCollectionView.h"

@interface ScrollCollectionViewCell ()<ScrollCollectionViewDelegate>

@property (nonatomic, weak) ScrollCollectionView *scrollCollectionView;

@end

@implementation ScrollCollectionViewCell

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
    ScrollCollectionView *scrollCollectionView = [[ScrollCollectionView alloc] init];
    scrollCollectionView.scaleHM = 140/375.0;
    scrollCollectionView.delegate = self;
    [self.contentView addSubview:scrollCollectionView];
    self.scrollCollectionView = scrollCollectionView;
}
// 设置控件约束关系
- (void)setUpConstraints{
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    __weak typeof(self) weakSelf = self;
    
    [self.scrollCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.contentView);
    }];
}
- (CGFloat)cellHeight{
    self.scrollCollectionView.preferedWidth = self.preferedWidth;
    CGSize size = self.scrollCollectionView.intrinsicContentSize;
    CGFloat height = ceill(size.height);
    
    return height;
}
- (void)setListModel:(NewBannerListModel *)listModel{
    _listModel = listModel;
    
    self.scrollCollectionView.bannerListModel = listModel;
}
- (void)scrollCollectionView:(ScrollCollectionView *)scrollCollectionView clickedImgWithBannerModel:(NewBannerModel *)bannerModel{
    if ([self.delegate respondsToSelector:@selector(scrollCollectionViewCell:clickedImgWithBannerModel:)]) {
        [self.delegate scrollCollectionViewCell:self clickedImgWithBannerModel:bannerModel];
    }
}

@end
