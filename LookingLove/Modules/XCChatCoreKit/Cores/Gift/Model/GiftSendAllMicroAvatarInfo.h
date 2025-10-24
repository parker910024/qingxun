//
//  GiftSendAllMicroAvatarInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/10/26.
//  Copyright © 2017年 chenran. All rights reserved.
//
//  全麦送 头像

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

@interface GiftSendAllMicroAvatarInfo : NSObject
@property (nonatomic, assign) BOOL  isAllMic;// 是否是全麦
@property (assign, nonatomic) BOOL isSelected;
@property (copy, nonatomic) NSString *position;
@property (strong, nonatomic) NIMChatroomMember *member;
@end
