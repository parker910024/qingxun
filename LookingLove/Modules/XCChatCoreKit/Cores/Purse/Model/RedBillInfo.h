//
//  RedBillInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/20.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

typedef NS_ENUM(NSUInteger, RedBillType) {
    RedBillType_Register = 1, //申请成为分享小能手
    RedBillType_OtherRegisterAfterShare = 3,//分享后用户注册
    RedBillType_RechargeDevide = 4,//充值xcShare
    RedBillType_WithDrawal = 5, //xcGetCF
};

@interface RedBillInfo : BaseObject
@property (strong, nonatomic) NSString * typeStr;
@property (assign, nonatomic) UserID uid;
@property (strong, nonatomic) NSString * packetNum;
@property (assign, nonatomic) double recordTime;
@property (assign, nonatomic) NSInteger date;
@end
