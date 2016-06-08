//
//  SingleImagePageViewController.h
//  Ayibang
//
//  Created by 周际航 on 16/6/6.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewBannerModel.h"

@class SingleImagePageViewController;
@protocol SingleImagePageViewControllerDelegate <NSObject>

- (void)singleImagePageViewController:(SingleImagePageViewController *)vc clickedImgWithBannerModel:(NewBannerModel *)bannerModel;

@end

@interface SingleImagePageViewController : UIViewController

@property (nonatomic, weak) id<SingleImagePageViewControllerDelegate> delegate;

@property (nonatomic, strong) NewBannerModel *model;

@end
