//
//  PublicChatroomCore.h
//  AFNetworking
//
//  Created by 卫明 on 2018/11/1.
//

#import "BaseCore.h"

#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    
    ImPublicChatroomErrorType_Black = 13003, //黑名单
} ImPublicChatroomErrorType; //错误码类型

@interface ImPublicChatroomCore : BaseCore

@property (nonatomic,assign) NSInteger publicChatroomId;

@property (nonatomic, assign) NSInteger publicChatRoomLevelNo;
//进入房间NIM返回的错误码
@property (nonatomic, assign) ImPublicChatroomErrorType errorType;

@property (nonatomic,assign) UserID publicChatroomUid;

/** 限制群聊回话的*/
@property (nonatomic,assign) UserID privateChatLevelNo;

@property (strong, nonatomic) NIMChatroomMember *publicMe;

/**
 进入聊天室

 @param roomId 房间id
 @return 成功：聊天室实体
 */
- (RACSignal *)enterPublicChatroomRoomId:(NSString *)roomId;



/**
 根据uid获取NIMChatroomMember
 
 @param uid 需要查询的用户id
 */
- (RACSignal *)rac_queryPublicChartRoomMemberByUid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
