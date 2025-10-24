//
//  DataUtils.h
//  YYFaceAuth
//
//  Created by chenran on 16/10/18.
//  Copyright © 2016年 zhangji. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface GiftInfoStorage : NSObject

+ (NSMutableArray *)getGiftInfos;
+ (void) saveGiftInfos:(NSString *)json;
@end
