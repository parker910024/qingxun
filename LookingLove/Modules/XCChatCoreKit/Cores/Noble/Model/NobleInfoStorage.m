//
//  NobleInfoStorage.m
//  BberryCore
//
//  Created by 卫明何 on 2018/1/10.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "NobleInfoStorage.h"
#import "NSObject+YYModel.h"
#define kDataKey @"noblesInfos"
#define kFileName @"NobleInfoList.data"
#import "NobleInfo.h"
#import "NobleCache.h"

@implementation NobleInfoStorage


+ (NSMutableDictionary *)getNobleInfos {
    
    return [[[NobleCache shareCache]getNobleInfoFromCache] mutableCopy];
}

+ (void)saveNobleInfos:(NSMutableDictionary *)nobleDict{
    [[NobleCache shareCache]saveNobleInfo:nobleDict];

}

@end
