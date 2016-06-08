//
//  ScrollCollectionView.h
//  Ayibang
//
//  Created by 周际航 on 16/6/7.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewBannerModel.h"

@class ScrollCollectionView;
@protocol ScrollCollectionViewDelegate <NSObject>

- (void)scrollCollectionView:(ScrollCollectionView *)scrollCollectionView clickedImgWithBannerModel:(NewBannerModel *)bannerModel;

@end

@interface ScrollCollectionView : UIView

@property (nonatomic, weak) id<ScrollCollectionViewDelegate> delegate;

@property (nonatomic, strong) NewBannerListModel *bannerListModel;

@property (nonatomic, assign) CGFloat preferedWidth;
// 高宽比例
@property (nonatomic, assign) CGFloat scaleHM;

@end
