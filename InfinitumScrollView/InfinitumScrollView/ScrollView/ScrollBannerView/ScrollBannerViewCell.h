//
//  ScrollBannerViewCell.h
//  Ayibang
//
//  Created by 周际航 on 16/5/11.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewBannerModel.h"

@class ScrollBannerViewCell;
@protocol ScrollBannerViewCellDelegate <NSObject>

- (void)scrollBannerViewCell:(ScrollBannerViewCell *)cell clickedImgWithBannerModel:(NewBannerModel *)bannerModel;

@end

@interface ScrollBannerViewCell : UITableViewCell

+ (NSString *)cellIdentify;

@property (nonatomic, weak) id<ScrollBannerViewCellDelegate> delegate;

@property (nonatomic, strong) NewBannerListModel *listModel;

@property (nonatomic, assign) CGFloat preferedWidth;

- (CGFloat)cellHeight;

@end


