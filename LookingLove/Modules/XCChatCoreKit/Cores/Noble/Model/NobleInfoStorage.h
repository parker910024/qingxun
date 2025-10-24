//
//  NobleInfoStorage.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/10.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NobleInfoStorage : NSObject
+ (NSMutableDictionary *)getNobleInfos;
+ (void)saveNobleInfos:(NSMutableDictionary *)nobleDict;
@end
