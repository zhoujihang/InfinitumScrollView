//
//  ScrollPageViewController.m
//  Ayibang
//
//  Created by 周际航 on 16/6/6.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import "ScrollPageViewController.h"
#import "SingleImagePageViewController.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "PageControl.h"
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import "FixedIntrinsicSizeImageView.h"

@interface ScrollPageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,SingleImagePageViewControllerDelegate>

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray *imageVCArray;

@property (nonatomic, weak) FixedIntrinsicSizeImageView *singleImgView;

@property (nonatomic, strong) SingleImagePageViewController *currentVC;
@property (nonatomic, strong) NSArray *vcArray;

@property (nonatomic, weak) PageControl *pageControl;

@end

@implementation ScrollPageViewController

+ (instancetype)horizontalScrollPageViewController{
    NSDictionary *options = @{
                              UIPageViewControllerOptionInterPageSpacingKey : @(0)
                              };
    ScrollPageViewController *pageVC = [[ScrollPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    pageVC.dataSource = pageVC;
    pageVC.delegate = pageVC;
    return pageVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpViews];
    [self setUpData];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self layoutPosition];
}
// 创建视图控件
- (void)setUpViews{
    PageControl *pageControl = [[PageControl alloc] init];
    pageControl.diameter = (6);
    pageControl.padding = (8);
    pageControl.normalTintColor = [UIColor getColor:@"ffffff"];
    pageControl.currentTintColor = [UIColor getColor:@"ffffff"];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    FixedIntrinsicSizeImageView *singleImgView = [[FixedIntrinsicSizeImageView alloc] init];
    singleImgView.clipsToBounds = YES;
    singleImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:singleImgView];
    self.singleImgView = singleImgView;
    self.singleImgView.hidden = YES;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSingleImage)];
    [self.singleImgView addGestureRecognizer:tapGes];
    self.singleImgView.userInteractionEnabled = YES;
}
// 为兼容iOS7 ，此处控件不可用约束
- (void)layoutPosition{
    CGSize size = self.view.size;
    self.singleImgView.frame = CGRectMake(0, 0, size.width, size.height);
    CGFloat bottomSpace = self.pageControl.diameter + (6);
    self.pageControl.center = CGPointMake(size.width/2, size.height - bottomSpace);
}
// 设置默认数据
- (void)setUpData{
    if (self.bannerListModel.bannerArr.count == 0) {
        self.bannerListModel = [self placeholderBannerListModel];
    }
}

- (void)setBannerListModel:(NewBannerListModel *)bannerListModel{
    _bannerListModel = bannerListModel;
    
    if (_bannerListModel.bannerArr.count == 0) {
        self.bannerListModel = [self placeholderBannerListModel];
        return;
    }

    if (_bannerListModel.bannerArr.count <= 1) {
        [self showSingleImageView];
        self.pageControl.numberOfPages = 0;
    }else{
        self.singleImgView.hidden = YES;
        self.pageControl.numberOfPages = _bannerListModel.bannerArr.count;
        self.pageControl.currentPage = 0;
    }
    
    [self createVCArray];
    [self selectFirstVC];
    [self addTimer];
}
- (void)createVCArray{
    NSMutableArray *marr = [@[] mutableCopy];
    for (int i=0; i<self.bannerListModel.bannerArr.count; i++) {
        NewBannerModel *model = self.bannerListModel.bannerArr[i];
        SingleImagePageViewController *vc = [[SingleImagePageViewController alloc] init];
        vc.model = model;
        vc.delegate = self;
        [marr addObject:vc];
    }
    self.vcArray = [marr copy];
}

#pragma mark - function
- (void)showSingleImageView{
    if (self.bannerListModel.bannerArr.count != 1) {return;}
    
    NewBannerModel *model = self.bannerListModel.bannerArr[0];
    self.singleImgView.hidden = NO;
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
- (void)selectFirstVC{
    [self selectSingleViewController:[self.vcArray firstObject] animated:NO];
}
- (void)selectSingleViewController:(SingleImagePageViewController *)vc animated:(BOOL)animated{
    if (![self.vcArray containsObject:vc]) {return;}
    
    // 此方法不会触动代理方法
    [self setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:animated completion:nil];
    self.currentVC = vc;
    [self selectCurrentPageControl];
}
- (void)selectCurrentPageControl{
    if (![self.vcArray containsObject:self.currentVC]) {return;}
    
    NSInteger index = [self.vcArray indexOfObject:self.currentVC];
    self.pageControl.currentPage = index;
}
#pragma mark - 视图点击
- (void)tapSingleImage{
    if (self.bannerListModel.bannerArr.count != 1) {return;}
    
    if ([self.scrollPageDelegate respondsToSelector:@selector(scrollPageViewController:clickedImgWithBannerModel:)]) {
        [self.scrollPageDelegate scrollPageViewController:self clickedImgWithBannerModel:self.bannerListModel.bannerArr[0]];
    }
}

- (void)singleImagePageViewController:(SingleImagePageViewController *)vc clickedImgWithBannerModel:(NewBannerModel *)bannerModel{
    if ([self.scrollPageDelegate respondsToSelector:@selector(scrollPageViewController:clickedImgWithBannerModel:)]) {
        [self.scrollPageDelegate scrollPageViewController:self clickedImgWithBannerModel:bannerModel];
    }
}
#pragma mark - datasource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    SingleImagePageViewController *vc = (SingleImagePageViewController *)viewController;
    SingleImagePageViewController *beforeVC = [self beforeVCWithVC:vc];
    return beforeVC;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    SingleImagePageViewController *vc = (SingleImagePageViewController *)viewController;
    SingleImagePageViewController *afterVC = [self afterVCWithVC:vc];
    return afterVC;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    SingleImagePageViewController *vc = (SingleImagePageViewController *)[pendingViewControllers firstObject];
    self.currentVC = vc;
    [self removeTimer];
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    SingleImagePageViewController *previousVC = (SingleImagePageViewController *)[previousViewControllers firstObject];
    self.currentVC = completed ? self.currentVC : previousVC;
    [self selectCurrentPageControl];
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
    self.currentVC = [self afterVCWithVC:self.currentVC];
    [self selectSingleViewController:self.currentVC animated:YES];
}

#pragma mark - 模型和vc的顺序
- (SingleImagePageViewController *)currentVC{
    if (!_currentVC) {
        _currentVC = [self.vcArray firstObject];
    }
    return _currentVC;
}
- (SingleImagePageViewController *)beforeVCWithVC:(SingleImagePageViewController *)vc{
    if (![self.vcArray containsObject:vc]) {
        return nil;
    }
    
    NSInteger currentIndex = [self.vcArray indexOfObject:vc];
    NSInteger beforeIndex = currentIndex-1 < 0 ? self.vcArray.count-1 : currentIndex-1;
    SingleImagePageViewController *beforeVC = self.vcArray[beforeIndex];
    return beforeVC;
}
- (SingleImagePageViewController *)afterVCWithVC:(SingleImagePageViewController *)vc{
    if (![self.vcArray containsObject:vc]) {
        return nil;
    }
    
    NSInteger currentIndex = [self.vcArray indexOfObject:vc];
    NSInteger afterIndex = currentIndex+1 > self.vcArray.count-1 ? 0 : currentIndex+1;
    SingleImagePageViewController *afterVC = self.vcArray[afterIndex];
    return afterVC;
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
