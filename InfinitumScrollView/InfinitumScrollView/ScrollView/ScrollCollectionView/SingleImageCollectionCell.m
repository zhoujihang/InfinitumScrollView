//
//  SingleImageCollectionCell.m
//  Ayibang
//
//  Created by 周际航 on 16/6/7.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import "SingleImageCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

@interface SingleImageCollectionCell()

@property (nonatomic, weak) UIImageView *imgView;

@end

@implementation SingleImageCollectionCell

+ (NSString *)cellIdentify{
    return NSStringFromClass([self class]);
}
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
    self.backgroundView = [[UIView alloc] init];
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imgView];
    self.imgView = imgView;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
    [self.imgView addGestureRecognizer:tapGes];
    self.imgView.userInteractionEnabled = YES;
}

// 设置控件约束关系
- (void)setUpConstraints{
    __weak typeof(self) weakSelf = self;
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
}
- (void)setModel:(NewBannerModel *)model{
    _model = model;
    
    if (!model) {return;}
    
    if (model.localImage) {
        self.imgView.image = model.localImage;
        return;
    }
    
    self.imgView.contentMode = UIViewContentModeCenter;
    __weak typeof(self) weakSelf = self;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:model.placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            weakSelf.imgView.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
}
- (void)tapImage{
    if ([self.delegate respondsToSelector:@selector(singleImageCollectionCell:clickedImgWithBannerModel:)]) {
        [self.delegate singleImageCollectionCell:self clickedImgWithBannerModel:self.model];
    }
}

@end
