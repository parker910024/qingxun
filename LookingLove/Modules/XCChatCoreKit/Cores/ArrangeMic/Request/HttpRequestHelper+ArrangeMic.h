//
//  HttpRequestHelper+ArrangeMic.h
//  XCChatCoreKit
//
//  Created by gzlx on 2018/12/13.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "ArrangeMicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (ArrangeMic)
/**
 房间开启或者关闭排麦
 @param roomId 房间的UId
 @param arrangeStatus 0 是关闭 1 是开启
 @param success 成功
 @param failure 失败
 */
+ (void)openOrCloseArrangeMicWith:(UserID)roomId
                          operUid:(UserID)operUid
                    arrangeStatus:(BOOL)arrangeStatus
                          success:(void(^)(NSDictionary * arrangeMicStatus))success
                             fail:(void(^)(NSString * message, NSNumber * failCode))failure;


/**
 取消排麦/开始排麦
 
 @param roomUid 排麦的人id
 @param userStatus 1 开始排麦 0 取消排麦
 @Param operUid 报名的那个人id
 @param success 成功
 @param failure 失败
 */
+ (void)beginOrCancleArrangeMicWith:(UserID)roomUid
                            operUid:(UserID)operUid
                         userStatus:(int)userStatus
                            success:(void(^)(NSDictionary *stateDic))success
                            failure:(void(^)(NSString * message, NSNumber * failCode))failure;

/**
 获取排麦列表

 @param roomUid 房主的uid
 @param operUid 操作者的UId
 @param success 成功
 @param failure 失败
 */
+ (void)getUserArrangeMicListWith:(UserID)roomUid
                          operUid:(UserID)operUid
                             page:(int)page
                         pageSize:(int)pageSize
                          success:(void(^)(ArrangeMicModel *model))success
                          failure:(void(^)(NSString * message, NSNumber * failureCode))failure;


/**
 获取排麦队列的长度
 @param roomUid 房主的uid
 @param success 成功
 @param failure 失败
 */
+ (void)getUserArrangeMicListSizeWith:(UserID)roomUid
                              success:(void(^)(NSNumber * count))success
                              failure:(void(^)(NSString * message, NSNumber * failureCode))failure;




@end

NS_ASSUME_NONNULL_END
