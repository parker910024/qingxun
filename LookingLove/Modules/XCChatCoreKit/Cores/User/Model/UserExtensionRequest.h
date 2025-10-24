//
//  UserExtensionRequest.h
//  BberryCore
//
//  Created by 卫明何 on 2018/7/4.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserCore.h"

typedef enum : NSUInteger {
    QueryUserInfoExtension_Photo        = 1,    //照片
    QueryUserInfoExtension_Noble        = 2,    //贵族
    QueryUserInfoExtension_LevelInfo    = 3,    //等级
    QueryUserInfoExtension_Family       = 4,    //家族
    QueryUserInfoExtension_Car          = 5,    //座驾
    QueryUserInfoExtension_HeadWear     = 6,    //头饰
    QueryUserInfoExtension_Basic        = 7,    //基础信息（除去上面以外的）
    QueryUserInfoExtension_Full         = 8     //全部信息（上面所有）
} QueryUserInfoExtension;

@interface UserExtensionRequest : NSObject

@property (nonatomic,assign) QueryUserInfoExtension type;
@property (nonatomic,assign) BOOL needRefresh;

@end
