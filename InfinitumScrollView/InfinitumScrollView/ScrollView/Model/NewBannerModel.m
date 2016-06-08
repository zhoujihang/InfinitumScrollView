//
//  NewBannerModel.m
//  Ayibang
//
//  Created by 周际航 on 16/5/11.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import "NewBannerModel.h"

@implementation NewBannerListModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"bannerArr" : @"bannerList"
             };
}
+ (NSDictionary *)objectClassInArray{
    return @{
             @"bannerArr" : [NewBannerModel class]
             };
}

+ (instancetype)fakeModel{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Banner.json" ofType:nil];
    NSString *jsonStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    NewBannerListModel *model = [NewBannerListModel mj_objectWithKeyValues:jsonStr];
    
    for (int i=0; i<model.bannerArr.count; i++) {
        NewBannerModel *m = model.bannerArr[i];
        UIImage *localImg = i==0 ? [UIImage imageNamed:@"1"] : i==1 ? [UIImage imageNamed:@"2"] : [UIImage imageNamed:@"3"];
        m.localImage = localImg;
    }
    
    return model;
}

@end

@implementation NewBannerModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id"
             };
}




@end
