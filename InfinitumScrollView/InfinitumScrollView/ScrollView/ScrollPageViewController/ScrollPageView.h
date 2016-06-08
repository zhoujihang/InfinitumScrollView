//
//  ScrollPageView.h
//  Ayibang
//
//  Created by 周际航 on 16/6/6.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollPageViewController.h"

@class ScrollPageView;
@protocol ScrollPageViewDelegate <NSObject>

- (void)scrollPageView:(ScrollPageView *)scrollPageView clickedImgWithBannerModel:(NewBannerModel *)bannerModel;

@end

@interface ScrollPageView : UIView

@property (nonatomic, weak) id<ScrollPageViewDelegate> delegate;

@property (nonatomic, strong, readonly) ScrollPageViewController *scrollPageVC;

@property (nonatomic, strong) NewBannerListModel *bannerListModel;

@property (nonatomic, assign) CGFloat preferedWidth;
// 高宽比例
@property (nonatomic, assign) CGFloat scaleHM;

@end
