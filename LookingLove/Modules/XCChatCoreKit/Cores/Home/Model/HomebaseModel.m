//
//  HomebaseModel.m
//  BberryCore
//
//  Created by Apple on 2018/4/27.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HomebaseModel.h"

@implementation HomebaseModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"panelList" : PanelInfor.class,
             @"topBannerList" : BannerInfo.class,
             };
}

@end
