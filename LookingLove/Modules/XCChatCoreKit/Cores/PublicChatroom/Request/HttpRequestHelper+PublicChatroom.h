//
//  HttpRequestHelper+PublicChatroom.h
//  XCChatCoreKit
//
//  Created by 卫明 on 2018/11/5.
//  Copyright © 2018 KevinWang. All rights reserved.
//

#import "HttpRequestHelper.h"

//NIM
#import <NIMSDK/NIMSDK.h>

//userinfo
#import "SearchResultInfo.h"

typedef enum : NSUInteger {
    TTPublicHistoryMessageDataProviderType_AtMe = 1, //at我的消息
    TTPublicHistoryMessageDataProviderType_FromMe = 2,//我发出的消息
} TTPublicHistoryMessageDataProviderType;

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (PublicChatroom)

/**
 搜索好友，关注，粉丝

 @param success 成功
 @param failure 失败
 */
+ (void)searchAtFriendNoticeFansKey:(NSString *)key
                            Success:(void (^)(NSArray<SearchResultInfo *> *result))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 获取公聊大厅的消息

 @param type 消息类型
 @param chatroomId 聊天室ID
 @param count 每页数量
 @param pageCount 页码
 @param success 成功
 @param failure 失败
 */
+ (void)fetchPublicMessageWithType:(TTPublicHistoryMessageDataProviderType)type
                      byChatroomid:(NSString *)chatroomId
                             count:(NSInteger)count
                         pageCount:(NSInteger)pageCount
                           success:(void (^)(NSArray<NIMMessage *> *messages))success
                           failure:(void (^)(NSNumber *resCode, NSString *message))failure;


/**
 公聊大厅禁言
 
 @param targetUid 禁言用户uid
 @param duration 禁言时间(秒)
 @param remark 禁言原因
 */
+ (void)repuestPublicChatRoomNotMessage:(UserID)targetUid
                               duration:(int)duration
                                 remark:(NSString *)remark
                                success:(void (^)(void))success
                                failure:(void (^)(NSNumber *resCode, NSString *message))failure;
@end

NS_ASSUME_NONNULL_END
