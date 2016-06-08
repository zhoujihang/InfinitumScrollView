//
//  ScrollCollectionView.m
//  Ayibang
//
//  Created by 周际航 on 16/6/7.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import "ScrollCollectionView.h"
#import "PageControl.h"
#import "SingleImageCollectionCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+Extension.h"
#import "UIView+Extension.h"
#import "FixedIntrinsicSizeImageView.h"

@interface ScrollCollectionView() <UICollectionViewDelegate,UICollectionViewDataSource,SingleImageCollectionCellDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, weak) FixedIntrinsicSizeImageView *singleImgView;

@property (nonatomic, weak) PageControl *pageControl;

@property (nonatomic, assign) NSInteger currentItemIndex;

@property (nonatomic, assign) NSInteger centerItemIndex;

@property (nonatomic, strong) NSTimer *timer;

@end


@implementation ScrollCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
- (void)setUp{
    self.preferedWidth = -1;
    self.scaleHM = 112/375.0;   // 默认比例
    self.centerItemIndex = 1000000;
    [self setUpViews];
    [self setUpConstraints];
}
// 创建视图控件
- (void)setUpViews{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout = flowLayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView registerClass:[SingleImageCollectionCell class] forCellWithReuseIdentifier:[SingleImageCollectionCell cellIdentify]];
    
    PageControl *pageControl = [[PageControl alloc] init];
    pageControl.diameter = (6);
    pageControl.padding = (8);
    pageControl.normalTintColor = [UIColor getColor:@"ffffff"];
    pageControl.currentTintColor = [UIColor getColor:@"ffffff"];;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    FixedIntrinsicSizeImageView *singleImgView = [[FixedIntrinsicSizeImageView alloc] init];
    singleImgView.clipsToBounds = YES;
    singleImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:singleImgView];
    self.singleImgView = singleImgView;
    self.singleImgView.hidden = YES;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
    [self.singleImgView addGestureRecognizer:tapGes];
    self.singleImgView.userInteractionEnabled = YES;
    
}
// 设置控件约束关系
- (void)setUpConstraints{
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.singleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(-(6));
    }];
}
- (CGSize)intrinsicContentSize{
    if (self.preferedWidth == -1) {
        return CGSizeMake(-1, -1);
    }
    
    CGFloat height = self.preferedWidth * self.scaleHM;
    height = ceill(height);
    CGSize size = CGSizeMake(self.preferedWidth, height);
    return size;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.preferedWidth == -1) {
        self.preferedWidth = self.width;
        [self invalidateIntrinsicContentSize];
    }
    
    self.flowLayout.itemSize = self.size;
    [self.flowLayout invalidateLayout];
    
    [self updateConstraints];
    [self layoutIfNeeded];
}
- (void)setPreferedWidth:(CGFloat)preferedWidth{
    _preferedWidth = preferedWidth;
    
    CGSize size = [self intrinsicContentSize];
    self.bounds = CGRectMake(0, 0, size.width, size.height);
}
- (void)setBannerListModel:(NewBannerListModel *)bannerListModel{
    _bannerListModel = bannerListModel;
    // 设置空视图
    if (_bannerListModel.bannerArr.count == 0) {
        self.bannerListModel = [self placeholderBannerListModel];
        return;
    }
    
    // 设置好默认 placeholder 图片
    for (int i=0; i<bannerListModel.bannerArr.count; i++) {
        NewBannerModel *model = bannerListModel.bannerArr[i];
        model.placeHolderImage = [UIImage imageNamed:@"home_toprecommend_placehold"];
    }
    
    // 处理图片个数为一个的情形
    NSInteger count = _bannerListModel.bannerArr.count;
    if (count == 1) {
        self.pageControl.numberOfPages = 0;
        [self showSingleImgView];
    }else{
        self.singleImgView.hidden = YES;
        self.pageControl.numberOfPages = count>=1 ? count : 0;
        self.pageControl.currentPage = 0;
        [self addTimer];
    }
    
    // scrollToCenterIndexPath 方法需要再下一个运行循环中执行，此时 reloadData 还未能改变bounds
    [self.collectionView reloadData];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf scrollToCenterIndexPath];
    });
    // 或者这么写
//    dispatch_group_t group = dispatch_group_create();
//    [self.collectionView reloadData];
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        [weakSelf scrollToCenterIndexPath];
//    });
    [self addTimer];
}
- (void)scrollToCenterIndexPath{
    if (self.bannerListModel.bannerArr.count == 0) {return;}
    NSIndexPath *startIndex = [NSIndexPath indexPathForItem:self.centerItemIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:startIndex atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    self.currentItemIndex = startIndex.item;
}
#pragma mark - function
- (void)tapImage{
    NewBannerModel *model = [self.bannerListModel.bannerArr firstObject];
    if (!model) {return;}
    
    if ([self.delegate respondsToSelector:@selector(scrollCollectionView:clickedImgWithBannerModel:)]) {
        [self.delegate scrollCollectionView:self clickedImgWithBannerModel:model];
    }
}

- (void)showSingleImgView{
    if (self.bannerListModel.bannerArr.count != 1) {return;}
    
    self.singleImgView.hidden = NO;
    NewBannerModel *model = self.bannerListModel.bannerArr[0];
    
    if (model.localImage) {
        self.singleImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.singleImgView.image = model.localImage;
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    self.singleImgView.contentMode = UIViewContentModeCenter;
    [self.singleImgView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:model.placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            weakSelf.singleImgView.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
}
- (NSInteger)modelIndexForItemIndex:(NSInteger)itemIndex{
    NSInteger offset = itemIndex - self.centerItemIndex;
    NSInteger count = self.bannerListModel.bannerArr.count;
    NSInteger mod = offset % count;
    NSInteger modelIndex = (mod + count) % count;
    return modelIndex;
}
#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.bannerListModel.bannerArr.count == 0) {return 0;}
    
    NSInteger count = self.centerItemIndex * 2;
    return count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger modelIndex = [self modelIndexForItemIndex:indexPath.item];
    
    NewBannerModel *model = self.bannerListModel.bannerArr[modelIndex];
    SingleImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SingleImageCollectionCell cellIdentify] forIndexPath:indexPath];
    cell.model = model;
    cell.delegate = self;
    
    return cell;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSArray *items = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *currentItemIndex = [items firstObject];
    self.currentItemIndex = currentItemIndex.item;
}
// 只负责 pagecontrol 的页数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat width = scrollView.width;
    
    NSInteger targetPage = (offsetX+width/2)/width;
    NSInteger modelIndex = [self modelIndexForItemIndex:targetPage];
    self.pageControl.currentPage = modelIndex;
}
#pragma mark cell click
- (void)singleImageCollectionCell:(SingleImageCollectionCell *)cell clickedImgWithBannerModel:(NewBannerModel *)bannerModel{
    if (!bannerModel) {return;}
    
    if ([self.delegate respondsToSelector:@selector(scrollCollectionView:clickedImgWithBannerModel:)]) {
        [self.delegate scrollCollectionView:self clickedImgWithBannerModel:bannerModel];
    }
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
    if (self.currentItemIndex >= self.centerItemIndex*2) {return;}
    
    // 重置到中心位置
    if (self.currentItemIndex != self.centerItemIndex) {
        NSInteger count = self.bannerListModel.bannerArr.count;
        NSInteger mod = (self.currentItemIndex-self.centerItemIndex)%count;
        if (mod == 0) {
            // 跳转到中心
            [self scrollToCenterIndexPath];
        }
    }
    
    // 自动跳到下一个
    NSInteger nextItemIndex = self.currentItemIndex+1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:nextItemIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    NSLog(@"xxx now:%ld  next:%ld",self.currentItemIndex,nextItemIndex);
    self.currentItemIndex = nextItemIndex;
}

#pragma mark - 默认数据
- (NewBannerListModel *)placeholderBannerListModel{
    NewBannerModel *model = [[NewBannerModel alloc] init];
    model.placeHolderImage = [UIImage imageNamed:@"home_toprecommend_placehold"];
    NewBannerListModel *listModel = [[NewBannerListModel alloc] init];
    listModel.bannerArr = @[model];
    return listModel;
}

@end
