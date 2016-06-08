//
//  SingleImageCollectionCell.h
//  Ayibang
//
//  Created by 周际航 on 16/6/7.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewBannerModel.h"

@class SingleImageCollectionCell;
@protocol SingleImageCollectionCellDelegate <NSObject>

- (void)singleImageCollectionCell:(SingleImageCollectionCell *)cell clickedImgWithBannerModel:(NewBannerModel *)bannerModel;

@end

@interface SingleImageCollectionCell : UICollectionViewCell

+ (NSString *)cellIdentify;

@property (nonatomic, weak) id<SingleImageCollectionCellDelegate> delegate;

@property (nonatomic, strong) NewBannerModel *model;

@end
