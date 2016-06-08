//
//  FixedIntrinsicSizeImageView.m
//  Ayibang
//
//  Created by 周际航 on 16/5/16.
//  Copyright © 2016年 ayibang. All rights reserved.
//

#import "FixedIntrinsicSizeImageView.h"

@implementation FixedIntrinsicSizeImageView

- (CGSize)intrinsicContentSize{
    return CGSizeMake(-1, -1);
}

@end
