//
//  ShareSendInfo.m
//  BberryCore
//
//  Created by 卫明何 on 2017/10/23.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "ShareSendInfo.h"

//@property (assign, nonatomic) UserID uid;
//@property (copy, nonatomic) NSString *nick;
//@property (assign, nonatomic) UserID targetUid;
//@property (copy, nonatomic) NSString *targetNick;

@implementation ShareSendInfo

- (NSDictionary *)encodeAttachemt {
    
    NSDictionary *dict = @{@"uid" :@(self.uid),
                           @"data":@{
                                   @"nick":self.nick == nil ? @"" : self.nick,
                                     @"targetUid":@(self.targetUid),
                                     @"targetNick":self.targetNick == nil ? @"" : self.targetNick,
                             }
                           };
    return dict;
}

@end
