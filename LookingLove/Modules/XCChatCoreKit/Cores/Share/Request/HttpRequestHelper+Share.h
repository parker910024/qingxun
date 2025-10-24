//
//  HttpRequestHelper+Share.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/25.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"

@interface HttpRequestHelper (Share)


/**
 分享成功后调用

 @param shareType 分享类型，1微信好友，2微信朋友圈，3QQ好友，4QQ空间
 @param sharePageId 分享页面，1直播间，2H5
 @param targetUid 如果被分享房间，传被分享房间UID
 @param shareUrl    回传给后台的url
 @param success 成功
 @param failure 失败
 */
+ (void)postShareSuccessWithShareType:(NSInteger)shareType
                          sharePageId:(NSInteger)sharePageId
                            targetUid:(NSInteger)targetUid
                             shareUrl:(NSString *)shareUrl
                              success:(void (^)(NSString *packetNum))success
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure;

/**
 分享社区作品成功后调用
 
 @param shareType 分享类型，1微信好友，2微信朋友圈，3QQ好友，4QQ空间
 @param worksId 社区的作品id
 @param uid 分享的人 uid
 @param success 成功
 @param failure 失败
 */
+ (void)postShareSuccessWithShareType:(NSInteger)shareType
                              worksId:(NSString *)worksId
                              success:(void (^)(NSString *packetNum))success
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure;



@end
