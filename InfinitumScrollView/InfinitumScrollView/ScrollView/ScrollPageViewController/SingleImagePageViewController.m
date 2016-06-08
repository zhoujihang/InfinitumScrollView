//
//  SingleImagePageViewController.m
//  Ayibang
//
//  Created by 周际航 on 16/6/6.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import "SingleImagePageViewController.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface SingleImagePageViewController ()

@property (nonatomic, weak) UIImageView *imgView;

//@property (nonatomic, weak) UIButton *btn;

@end

@implementation SingleImagePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    [self setUpConstraints];
    [self setUpData];
}
// 创建视图控件
- (void)setUpViews{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imgView];
    self.imgView = imgView;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
    [self.imgView addGestureRecognizer:tapGes];
    self.imgView.userInteractionEnabled = YES;
}

// 设置控件约束关系
- (void)setUpConstraints{
    __weak typeof(self) weakSelf = self;
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
}
- (void)setUpData{
    if (!self.model) {return;}
    
    if (self.model.localImage) {
        self.imgView.image = self.model.localImage;
        return;
    }
    
    self.imgView.contentMode = UIViewContentModeCenter;
    __weak typeof(self) weakSelf = self;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.model.image] placeholderImage:self.model.placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            weakSelf.imgView.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
}
- (void)tapImage{
    if ([self.delegate respondsToSelector:@selector(singleImagePageViewController:clickedImgWithBannerModel:)]){
        [self.delegate singleImagePageViewController:self clickedImgWithBannerModel:self.model];
    }
}


@end
