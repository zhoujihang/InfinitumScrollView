//
//  ScrollPageViewController.h
//  Ayibang
//
//  Created by 周际航 on 16/6/6.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewBannerModel.h"

@class ScrollPageViewController;
@protocol ScrollPageViewControllerDelegate <NSObject>

- (void)scrollPageViewController:(ScrollPageViewController *)vc clickedImgWithBannerModel:(NewBannerModel *)bannerModel;

@end

@interface ScrollPageViewController : UIPageViewController

+ (instancetype)horizontalScrollPageViewController;

@property (nonatomic, weak) id<ScrollPageViewControllerDelegate> scrollPageDelegate;

@property (nonatomic, strong) NewBannerListModel *bannerListModel;

@end
