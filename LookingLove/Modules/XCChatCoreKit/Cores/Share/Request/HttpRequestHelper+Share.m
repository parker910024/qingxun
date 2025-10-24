//
//  HttpRequestHelper+Share.m
//  BberryCore
//
//  Created by 卫明何 on 2017/9/25.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper+Share.h"
#import "AuthCore.h"

@implementation HttpRequestHelper (Share)

/**
  分享成功后调用
  
  @param shareType 分享类型，1微信好友，2微信朋友圈，3QQ好友，4QQ空间
  @param sharePageId 分享页面，1直播间，2H5
  @param targetUid 如果被分享房间，传被分享房间UID
  @param success 成功
  @param failure 失败
  */
+ (void)postShareSuccessWithShareType:(NSInteger)shareType
                          sharePageId:(NSInteger)sharePageId
                            targetUid:(NSInteger)targetUid
                             shareUrl:(NSString *)shareUrl
                              success:(void (^)(NSString *packetNum))success
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"usershare/save";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore)getUid];
    NSString *ticket = [GetCore(AuthCore)getTicket];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(shareType) forKey:@"shareType"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:@(sharePageId) forKey:@"sharePageId"];
    if (shareUrl.length > 0) {
        [params setObject:shareUrl forKey:@"shareUrl"];
    }
    if (sharePageId > 0) {
        [params setObject:@(targetUid) forKey:@"targetUid"];
    }
    if (shareUrl.length>0) {
        [params setObject:shareUrl forKey:@"shareUrl"];
    }
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(data[@"packetNum"]);
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
    
    
}

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
                              failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"works/share";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *uid = [GetCore(AuthCore)getUid];
    NSString *ticket = [GetCore(AuthCore)getTicket];
    [params setObject:uid forKey:@"uid"];
    [params setObject:@(shareType) forKey:@"platform"];
    [params setObject:ticket forKey:@"ticket"];
    [params setObject:worksId forKey:@"worksId"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
//        success(data[@"packetNum"]);
        success(@"");
    } failure:^(NSNumber *resCode, NSString *message) {
        failure(resCode,message);
    }];
    
}

@end
