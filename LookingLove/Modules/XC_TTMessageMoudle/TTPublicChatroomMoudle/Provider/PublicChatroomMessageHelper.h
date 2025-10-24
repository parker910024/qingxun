//
//  PublicChatroomMessageHelper.h
//  AFNetworking
//
//  Created by 卫明 on 2018/11/1.
//

#import <Foundation/Foundation.h>

#import <NIMSDK/NIMSDK.h>

#import <ReactiveObjC/ReactiveObjC.h>

#import "NIMMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PublicChatroomMessageHelper : NSObject


/**
 同步生成富文本

 @param message 云信消息实体
 @param model 消息模型
 */
- (void)configAttrSyncWithMessage:(NIMMessage *)message andModel:(NIMMessageModel *)model;

+ (instancetype)shareHelper;


@end

NS_ASSUME_NONNULL_END
