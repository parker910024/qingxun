//
//  HttpRequestHelper+RoomMagic.h
//  BberryCore
//
//  Created by Mac on 2018/3/16.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "RoomMagicInfo.h"

@interface HttpRequestHelper (RoomMagic)

/**
 *  加载房间魔法列表
 */
+ (void)requestRoomMagicList:(void (^)(NSArray *))success
                     failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 请求个人页魔法礼物墙
 
 @param uid 用户uid
 @param success 成功
 @param failure 失败
 */
+ (void)requesrPersonMagicListWithUid:(UserID)uid success:(void (^)(NSArray *))success
                              failure:(void (^)(NSNumber *, NSString *))failure;

/**
 *  全麦送房间魔法
 @param targetUids 对方id
 @param magicId 魔法id
 @param roomUid 房主id
 */
+ (void)sendAllMicroMagicByUids:(NSString *)targetUids
                        magicId:(NSInteger)magicId
                        roomUid:(NSInteger)roomUid
                        success:(void (^)(RoomMagicInfo *info))success
                        failure:(void (^)(NSNumber *resCode, NSString *message))failure;
/**
 *  房间内p2p送房间魔法
 @param magicId 魔法id
 @param targetUid 对方id
 @param roomUid 房主id
 */
+ (void)sendMaigc:(NSInteger)magicId
        targetUid:(UserID)targetUid
          roomUid:(NSInteger)roomUid
          success:(void (^)(RoomMagicInfo *info))success
          failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 房间内赠送多人魔法
 
 @param targetUids 接受者的uid
 @param magicId 魔法的id
 @param roomUid 房间的id
 @param success 成功的回调
 @param failure 失败的回调
 */
+ (void)sendBatchMagicByUids:(NSString *)targetUids
                     magicId:(NSInteger)magicId
                     roomUid:(NSInteger)roomUid
                     success:(void (^)(RoomMagicInfo *info, NSDictionary *dataM))success
                     failure:(void (^)(NSNumber *resCode, NSString *message))failure;

@end
