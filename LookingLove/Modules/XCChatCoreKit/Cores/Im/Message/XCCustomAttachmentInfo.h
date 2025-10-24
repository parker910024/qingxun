//
//  XCCustomAttachmentInfo.h
//  Bberry
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//
// 小秘书消息ui协议

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>

@class NIMKitBubbleStyleObject;


typedef NS_ENUM(NSInteger,XCCustomMessageType){
    CustomMessageTypeOpenLiveAlert  = 1, //开播提醒
    CustomMessageTypeGift   = 2, //礼物
    CustomMessageTypeNews   = 3, //推文
    CustomMessageTypeRedPacket  = 4, //xcRedColor消息
    CustomMessageTypeInviteMic = 5,//邀请上麦
};

@protocol XCCustomAttachmentInfo <NSObject>

@optional

- (NSString *)cellContent:(NIMMessage *)message;

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width;

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message;

- (NSString *)formatedMessage;

- (UIImage *)showCoverImage;

- (BOOL)shouldShowAvatar;

- (void)setShowCoverImage:(UIImage *)image;

- (BOOL)canBeRevoked;

- (BOOL)canBeForwarded;

@end
