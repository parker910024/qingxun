//
//  NobleBroadcastInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2018/1/19.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "SingleNobleInfo.h"
#import "PrivilegeInfo.h"

typedef enum : NSUInteger {
    NobleBroadcastType_Open = 1, //开通
    NobleBroadcastType_Renew = 2, //续费
} NobleBroadcastType;

@interface NobleBroadcastInfo : BaseObject

@property (assign, nonatomic) NobleBroadcastType type;
@property (assign, nonatomic) UserID uid;
@property (copy, nonatomic) NSString *nick;
@property (copy, nonatomic) NSString *avatar;
@property (strong, nonatomic) PrivilegeInfo *nobleInfo;
@property (copy, nonatomic) NSString *roomErbanNo;
@property (copy, nonatomic) NSString *roomTitle;
@end
