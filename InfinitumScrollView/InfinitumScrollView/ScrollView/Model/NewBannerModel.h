//
//  NewBannerModel.h
//  Ayibang
//
//  Created by 周际航 on 16/5/11.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
#import <UIKit/UIKit.h>

@class NewBannerModel;
@interface NewBannerListModel : NSObject

@property (nonatomic, strong) NSArray<NewBannerModel *> *bannerArr;

+ (instancetype)fakeModel;

@end

@interface NewBannerModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, assign) NSInteger width;

@property (nonatomic, assign) NSInteger height;

// ---------------------- 如下非网络字段
// 优先采用 本地图片，若无，则使用 image 代表的网络图片
@property (nonatomic, strong) UIImage *localImage;

@property (nonatomic, strong) UIImage *placeHolderImage;

@end
