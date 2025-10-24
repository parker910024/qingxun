//
//  TTUserCardFunctionItemConfig.h
//  TuTu
//
//  Created by 卫明 on 2018/11/19.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

//item
#import "TTUserCardFunctionItem.h"

//vc
#import "TTPublicNIMChatroomController.h"
#import "TTLittleWorldSessionViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTPublicChatUserCardFunctionItemConfig : NSObject

+ (NSMutableArray<TTUserCardFunctionItem *> *)getFunctionItemsInPublicChatRoomWithUid:(UserID)uid;

+ (RACSignal *)getCenterFunctionItemsInPublicChatRoomWithUid:(UserID)uid vc:(TTPublicNIMChatroomController *)vc;


+ (RACSignal *)getCenterFunctionItemsInLittleWorldTeamWithUid:(UserID)uid vc:(TTLittleWorldSessionViewController *)vc;
@end

NS_ASSUME_NONNULL_END
