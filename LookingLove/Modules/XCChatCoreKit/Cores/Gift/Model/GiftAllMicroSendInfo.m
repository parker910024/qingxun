//
//  GiftAllMicroSendInfo.m
//  BberryCore
//
//  Created by 卫明何 on 2017/10/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "GiftAllMicroSendInfo.h"

@implementation GiftAllMicroSendInfo

#pragma mark - NSCoding

//- (id)copyWithZone:(NSZone *)zone {
//    GiftAllMicroSendInfo *info = [[GiftAllMicroSendInfo allocWithZone:zone] init];
//    info.uid = self.uid;
//    info.nick = self.nick;
//    info.giftInfo = self.giftInfo;
//    info.isBatch = self.isBatch;
//    info.avatar = self.avatar;
//    info.giftNum = self.giftNum;
//    info.targetNick = self.targetNick;
//    return info;
//}
//
//- (id)mutableCopyWithZone:(nullable NSZone *)zone {
//    
//    GiftAllMicroSendInfo *info = [[GiftAllMicroSendInfo allocWithZone:zone] init];
//    info.uid = self.uid;
//    info.nick = self.nick;
//    info.giftInfo = self.giftInfo;
//    info.isBatch = self.isBatch;
//    info.avatar = self.avatar;
//    info.giftNum = self.giftNum;
//    return info;
//}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"targetUsers" : [UserInfo class],
             @"giftValueVos" : [RoomOnMicGiftValueDetail class]
             };
    
}

@end
