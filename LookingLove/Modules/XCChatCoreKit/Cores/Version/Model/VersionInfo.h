//
//  VersionInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/11/20.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

typedef enum : NSUInteger {
    Version_Online = 1,
    Version_Loading = 2,
    Version_ForceUpdate = 3,
    Version_Suggest = 4,
    Version_IsDeleted = 5
} VersionType;

@interface VersionInfo : BaseObject
@property (assign, nonatomic)VersionType status;
@property (copy, nonatomic)NSString *updateVersionDesc;
@property (copy, nonatomic)NSString *updateVersion;
@property (nonatomic, strong) NSString *tips;
@property (nonatomic, assign) BOOL showWechat;
@property (nonatomic, assign) BOOL showQq;
@end
