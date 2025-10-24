//
//  GiftSendInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/8/24.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Attachment.h"
#import <NIMSDK/NIMSDK.h>

@interface GiftSendInfo : Attachment
@property(nonatomic, assign)UserID uid;
@property(nonatomic, assign)UserID targetUid;
@property(nonatomic, assign)NSInteger giftId;
@property(nonatomic, strong)NSString *nick;
@property(nonatomic, strong)NSString *avatar;
@property(nonatomic, copy) NSString  *targetNick;
@property(nonatomic, copy) NSString *targetAvatar;
@property(nonatomic, assign)NSInteger giftNum;
@property(nonatomic, strong)NSDictionary *encodeAttachemt;
@end
