//
//  ScrollCollectionViewCell.h
//  Ayibang
//
//  Created by 周际航 on 16/6/7.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewBannerModel.h"
#import "ScrollPageView.h"

@class ScrollCollectionViewCell;
@protocol ScrollCollectionViewCellDelegate <NSObject>

- (void)scrollCollectionViewCell:(ScrollCollectionViewCell *)cell clickedImgWithBannerModel:(NewBannerModel *)bannerModel;

@end

@interface ScrollCollectionViewCell : UITableViewCell

+ (NSString *)cellIdentify;

@property (nonatomic, weak) id<ScrollCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) NewBannerListModel *listModel;

@property (nonatomic, assign) CGFloat preferedWidth;

- (CGFloat)cellHeight;

@end
