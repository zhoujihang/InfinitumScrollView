//
//  ScrollPageViewCell.h
//  Ayibang
//
//  Created by 周际航 on 16/6/6.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScrollPageViewController.h"
#import "NewBannerModel.h"
#import "ScrollPageView.h"

@class ScrollPageViewCell;
@protocol ScrollPageViewCellDelegate <NSObject>

- (void)scrollPageViewCell:(ScrollPageViewCell *)cell clickedImgWithBannerModel:(NewBannerModel *)bannerModel;

@end

@interface ScrollPageViewCell : UITableViewCell

+ (NSString *)cellIdentify;

@property (nonatomic, weak) id<ScrollPageViewCellDelegate> delegate;

@property (nonatomic, strong, readonly) ScrollPageViewController *scrollPageVC;

@property (nonatomic, strong) NewBannerListModel *listModel;

@property (nonatomic, assign) CGFloat preferedWidth;

- (CGFloat)cellHeight;

@end
