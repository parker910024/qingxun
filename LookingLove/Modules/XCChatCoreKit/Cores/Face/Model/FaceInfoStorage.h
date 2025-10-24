//
//  FaceInfoStorage.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceInfoStorage : NSObject

+ (NSMutableArray *)getFaceInfos;
+ (void)saveFaceInfos:(NSString *)json;

@end
