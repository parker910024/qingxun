//
//  AdInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/12/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

typedef enum : NSUInteger {
    SplashInfoSkipTypePage = 1,
    SplashInfoSkipTypeRoom = 2,
    SplashInfoSkipTypeWeb = 3,
} SplashInfoSkipType;

@interface AdInfo : BaseObject

@property (nonatomic, strong) NSString *link;
@property (nonatomic, assign) SplashInfoSkipType type;// 1跳app页面，2跳聊天室，3跳h5页面
@property (nonatomic, copy)   NSString *pict;
@end
