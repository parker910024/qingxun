//
//  GiftSendInfo.m
//  BberryCore
//
//  Created by 卫明何 on 2017/8/24.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "GiftSendInfo.h"

@implementation GiftSendInfo

- (NSDictionary *)encodeAttachemt {
    NSDictionary *dict = @{
                           @"uid"          :  @(self.uid),
                           @"targetUid"    :  @(self.targetUid),
                           @"giftId"       :  @(self.giftId),
                           @"nick"         :  self.nick,
                           @"avatar"       : self.avatar,
                           @"targetNick" : self.targetNick,
                           @"targetAvatar" : self.targetAvatar,
                           @"giftNum"   : @(self.giftNum)
                           };
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
//                                                       options:0
//                                                         error:nil];
//    return [[NSString alloc] initWithData:jsonData
//                                 encoding:NSUTF8StringEncoding];
    return dict;
}

@end
