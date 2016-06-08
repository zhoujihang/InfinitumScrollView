//
//  ScrollBannerView.h
//  Ayibang
//
//  Created by 周际航 on 16/5/11.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewBannerModel.h"

@class ScrollBannerView;

@protocol ScrollBannerViewDelegate <NSObject>

- (void)scrollBannerView:(ScrollBannerView *)view clickedImgWithBannerModel:(NewBannerModel *)bannerModel;

@end

@interface ScrollBannerView : UIView

@property (nonatomic, weak) id<ScrollBannerViewDelegate> delegate;

@property (nonatomic, strong) NewBannerListModel *bannerListModel;

@property (nonatomic, assign) CGFloat preferedWidth;
// 高宽比例
@property (nonatomic, assign) CGFloat scaleHM;

@end
