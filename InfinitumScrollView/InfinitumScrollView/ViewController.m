//
//  ViewController.m
//  InfinitumScrollView
//
//  Created by 周际航 on 16/6/8.
//  Copyright © 2016年 zjh. All rights reserved.
//

#import "ViewController.h"
#import "ScrollBannerView.h"
#import "ScrollPageView.h"
#import "ScrollCollectionView.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

@property (nonatomic, weak) ScrollCollectionView *scrollCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    [self setUpConstraints];
    [self setUpData];
}

// 创建视图控件
- (void)setUpViews{
    ScrollCollectionView *scrollCollectionView = [[ScrollCollectionView alloc] init];
    scrollCollectionView.preferedWidth = [UIScreen mainScreen].bounds.size.width;
    scrollCollectionView.scaleHM = 152/375.0;
    [self.view addSubview:scrollCollectionView];
    self.scrollCollectionView = scrollCollectionView;
}
// 设置控件约束关系
- (void)setUpConstraints{
    __weak typeof(self) weakSelf = self;
    [self.scrollCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
    }];
}
- (void)setUpData{
    self.scrollCollectionView.bannerListModel = [NewBannerListModel fakeModel];
}

@end
