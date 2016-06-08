//
//  ScrollPageViewCell.m
//  Ayibang
//
//  Created by 周际航 on 16/6/6.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import "ScrollPageViewCell.h"
#import <Masonry/Masonry.h>

@interface ScrollPageViewCell()<ScrollPageViewDelegate>

@property (nonatomic, weak) ScrollPageView *scrollPageView;

@end

@implementation ScrollPageViewCell

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
    
    ScrollPageView *scrollPageView = [[ScrollPageView alloc] init];
    scrollPageView.scaleHM = 140/375.0;
    scrollPageView.delegate = self;
    [self.contentView addSubview:scrollPageView];
    self.scrollPageView = scrollPageView;
}
// 设置控件约束关系
- (void)setUpConstraints{
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    __weak typeof(self) weakSelf = self;
    
    [self.scrollPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.contentView);
    }];
}
- (CGFloat)cellHeight{
    self.scrollPageView.preferedWidth = self.preferedWidth;
    CGSize size = self.scrollPageView.intrinsicContentSize;
    CGFloat height = ceill(size.height);
    
    return height;
}
- (void)setListModel:(NewBannerListModel *)listModel{
    _listModel = listModel;
    
    self.scrollPageView.bannerListModel = listModel;
}
- (ScrollPageViewController *)scrollPageVC{
    return self.scrollPageView.scrollPageVC;
}

- (void)scrollPageView:(ScrollPageView *)view clickedImgWithBannerModel:(NewBannerModel *)bannerModel{
    if ([self.delegate respondsToSelector:@selector(scrollPageViewCell:clickedImgWithBannerModel:)]) {
        [self.delegate scrollPageViewCell:self clickedImgWithBannerModel:bannerModel];
    }
}

@end
