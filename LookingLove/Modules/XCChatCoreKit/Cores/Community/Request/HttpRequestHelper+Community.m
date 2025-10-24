//
//  HttpRequestHelper+Community.m
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/2/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "HttpRequestHelper+Community.h"
#import "AuthCore.h"

@implementation HttpRequestHelper (Community)

/** 校验用户是否拥有发布权限*/
+ (void)requestUserPublishPermissionSuccess:(void (^)(BOOL hasPermission))success
                                    failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"works/check";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        success([data boolValue]);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}



/**
 随机获取一个作品
 */
+ (void)requestCommunityWorksRandomWorksSuccess:(void (^)(NSArray<CommunityInfo *> *))success
                                   failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"works/refresh";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        NSArray *infoList = [CommunityInfo modelsWithArray:data];
        success(infoList);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 根据id获取社区作品
 @param worksId 作品id
 */
+ (void)requestCommunityWorksWithWorksID:(NSString *)worksId
                            success:(void (^)(CommunityInfo *))success
                            failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"works/get";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:worksId forKey:@"worksId"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        CommunityInfo *info = [CommunityInfo modelDictionary:data];
        success(info);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


/**
 自增作品播放量接口 works/play(POST)
 @param worksId 作品id
 */
+ (void)reportCommunityWorksPlayWithWorksID:(NSString *)worksId
                                    success:(void (^)(BOOL isSucess))success
                                    failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"works/play";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:worksId forKey:@"worksId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        success(true);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
  
}




/**
 点赞/取消点赞
 @param worksId 作品id
 */
+ (void)requestCommunityWorksLikeWorksByWorksId:(NSString *)worksId
                                        success:(void (^)(BOOL success))success
                                        failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"works/like";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:worksId forKey:@"worksId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        success(true);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}



/**
 评论列表:works/comment/list(GET)
 @param worksId    作品Id
 @param page       页码
 */
+ (void)requestCommunityWorksCommentListByWorksID:(NSString *)worksId
                                             page:(int)page
                                          success:(void (^)(NSArray<CommunityCommentInfo *> *))success
                                          failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"works/comment/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:worksId forKey:@"worksId"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(10) forKey:@"pageSize"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *infolist = [CommunityCommentInfo modelsWithArray:data];
        success(infolist);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}
/**
 评论作品
 @param publishCommentInfo    评论模型
 */
+ (void)publishCommunityWorksCommentByPublishCommentInfo:(CommunityPublishCommentInfo *)publishCommentInfo
                                                 success:(void (^)(CommunityCommentInfo * _Nonnull))success
                                                 failure:(void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure{
    
    NSString *method = @"works/comment/save";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    
    [params safeSetObject:publishCommentInfo.worksId forKey:@"worksId"];
    [params safeSetObject:publishCommentInfo.pCommentId forKey:@"pCommentId"];
    [params safeSetObject:publishCommentInfo.content forKey:@"content"];
    [params safeSetObject:@(publishCommentInfo.targetUid) forKey:@"targetUid"];
    [params safeSetObject:publishCommentInfo.atUids forKey:@"atUids"];
    [params safeSetObject:@(publishCommentInfo.worksCommentType) forKey:@"type"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
    
        CommunityCommentInfo *commentInfo = [CommunityCommentInfo modelWithJSON:data];
        success(commentInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 点赞评论:works/comment/like(POST)
 @param commentId 评论id
 */
+ (void)requestCommunityWorksLikeCommentByCommentId:(NSString *)commentId
                                            success:(void (^)(BOOL success))success
                                            failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"works/comment/like";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:commentId forKey:@"commentId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        success(true);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 删除评论:works/comment/del(POST)
 @param commentId 评论id
 @param targetUid 删除人uid，可能是作品
 */
+ (void)requestCommunityWorksDeleteComment:(UserID)targetUid
                                 commentId:(NSString *)commentId
                                   success:(void (^)(BOOL success))success
                                   failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"works/comment/del";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params safeSetObject:@(targetUid) forKey:@"targetUid"];
    [params safeSetObject:commentId forKey:@"commentId"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        success(true);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 获取回复列表:works/comment/reply/list(get)
 @param commentId    评论id（主评论）    是    [string]
 @param page    页码    是    [int]
 @param size    数量    是    [int]
 @param state 0 结束头部刷新。  1 结束底部刷新
 */
+ (void)requestCommunityWorksCommentListByCommentId:(NSString *)commentId
                                               page:(int)page
                                               size:(int)size
                                            success:(void (^)(NSArray<CommunityCommentInfo *> *))success
                                            failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"works/comment/reply/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:commentId forKey:@"commentId"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(4) forKey:@"pageSize"];

    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *replyList = [CommunityCommentInfo modelsWithArray:data];
        success(replyList);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}








/** 背景音乐接口*/
+ (void)requestCommunityBackgroundMusicGroupSuccess:(void (^)(NSArray<CommunityMusicData *> *))success
                                            failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"backgroundmusic/group";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *musicGroupList = [CommunityMusicData modelsWithArray:data];
        success(musicGroupList);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 获取指定分类的背景音乐列表
 @param catalogId 分类id
 @param page 页码
 */
+ (void)requestCommunityBackgroundMusicByCatalogId:(NSString *)catalogId
                                              page:(int)page
                                           success:(void (^)(NSArray<CommunityMusicInfo *> *))success
                                           failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"backgroundmusic/query";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:catalogId forKey:@"catalogId"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(10) forKey:@"pageSize"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray *musicList = [CommunityMusicInfo modelsWithArray:data];
        success(musicList);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}






/**
 社区作品发布
 @param publishInfo 发布信息
 */
+ (void)publishCommunityWorksByCommunityPublishInfo:(CommunityPublishInfo *)publishInfo
                                            success:(void (^)(BOOL success))success
                                            failure:(void (^)(NSNumber *resCode, NSString *message))failure{
    NSString *method = @"works/save";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    
    [params safeSetObject:publishInfo.cover forKey:@"cover"];
    [params safeSetObject:publishInfo.url forKey:@"url"];
    [params safeSetObject:@(publishInfo.duration) forKey:@"duration"];
    [params safeSetObject:publishInfo.atUids forKey:@"atUids"];
    [params safeSetObject:@(publishInfo.isPublic) forKey:@"isPublic"];
    [params safeSetObject:publishInfo.address forKey:@"address"];
    [params safeSetObject:publishInfo.topics forKey:@"topics"];
    [params safeSetObject:publishInfo.content forKey:@"content"];
    [params safeSetObject:@(publishInfo.isSave) forKey:@"isSave"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        success(true);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


/**
 统计用户的作品数和点赞数
 @param targetUid 目标用户uid
 @param success 成功的返回
 @param failure 失败
 */
+ (void)requestCommunityUserTotalTargetUid:(NSString *)targetUid
                                    success:(void (^)(NSString *likeCount, NSString *worksCount))success
                                    failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"works/total";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:targetUid forKey:@"targetUid"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success([NSString stringWithFormat:@"%@",data[@"likeCount"]],[NSString stringWithFormat:@"%@",data[@"worksCount"]]);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


/*关注 多个用户
@param targetUids 目标用户uid    是    [array]
@param success 成功的返回
@param failure 失败
*/
+ (void)requestCommunityFollowUserTargetUids:(NSArray<NSString *>*)targetUids
                                     success:(void (^)(BOOL success))success
                                     failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"fans/batchFollow";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    
    NSMutableString *targetUidsString = [NSMutableString stringWithString:@""];
    
    for (int i = 0; i < targetUids.count; i++) {
        NSString *uid = targetUids[i];
        [targetUidsString appendString:uid];
        if (i < targetUids.count-1) {
            [targetUidsString appendString:@","];
        }
    }
    [params safeSetObject:targetUidsString forKey:@"targetUids"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}

/**
 随机 获取可以关注的用户
 @param size 当前页
 @param success 成功的返回
 @param failure 失败
 */
+ (void)requestCommunityFollowUserSize:(int)size
                               success:(void (^)(NSArray<UserInfo *> *userArray))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"user/recoms";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(size) forKey:@"size"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        NSArray<UserInfo *> * array = [UserInfo modelsWithArray:data];
        for (UserInfo *info in array) {
            info.isSelected = YES;
        }
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}


/**
 获取关注的 用户社区作品列表
 @param page 当前页
 @param pageSize 每一页的数量
 @param success 成功的返回
 @param failure 失败
 */
+ (void)requestCommunityFollowUserProductListPage:(int)page
                                         pageSize:(int)pageSize
                                          success:(void (^)(NSArray<CommunityInfo *> *productArray))success
                                          failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"works/follows";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        NSArray<CommunityInfo *> * array = [CommunityInfo modelsWithArray:data];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}


/** 获取用户社区作品列表
 
 @param targetUid 要获取的用户
 @param page 当前页
 @param pageSize 每一页的数量
 @param success 成功的返回
 @param failure 失败
 */
+ (void)requestCommunityUserProductListWithTargetUid:(UserID)targetUid
                                                page:(int)page
                                            pageSize:(int)pageSize
                                             success:(void (^)(NSArray<CommunityProductInfo *> *productArray))success
                                             failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"works/queryByUser";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(targetUid) forKey:@"targetUid"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {

        NSArray<CommunityProductInfo *> * array = [CommunityProductInfo modelsWithArray:data];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 获取用户 点赞/喜欢  社区作品列表
 
 @param targetUid 要获取的用户
 @param page 当前页
 @param pageSize 每一页的数量
 @param success 成功的返回
 @param failure 失败
 */
+ (void)requestCommunityUserLikeListWithTargetUid:(UserID)targetUid page:(int)page pageSize:(int)pageSize success:(void (^)(NSArray<CommunityProductInfo *> * _Nonnull))success failure:(void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure {
    NSString *method = @"works/likeList";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:@(targetUid) forKey:@"targetUid"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        NSArray<CommunityProductInfo *> * array = [CommunityProductInfo modelsWithArray:data];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 根据类型 获取 社区 消息

 @param type 消息类型. 1-点赞，2-At，3-评论
 @param page 当前页码
 @param pageSize 每页数量
 @param success 成功
 @param failure 失败
 */
+ (void)requestCommunityMessageListWithType:(int)type page:(int)page pageSize:(int)pageSize success:(void (^)(NSArray<CommunityMessageInfo *> * _Nonnull))success failure:(void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure {
    
    NSString *method = @"works/msg/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(type) forKey:@"type"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        
        NSArray<CommunityMessageInfo *> * array = [CommunityMessageInfo modelsWithArray:data];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}

/**
 弹幕列表
 @param worksId 作品ID
 
 */

+ (void)requestCommunityCommentBarrageListWithWorksId:(NSString *)worksId
                                              success:(void (^)(NSArray<CommunityCommentInfo *> *))success
                                              failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    
    NSString *method = @"works/comment/barrage/list";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:worksId forKey:@"worksId"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    
    [HttpRequestHelper GET:method params:params success:^(id data) {
        NSArray<CommunityCommentInfo *> * array = [CommunityCommentInfo modelsWithArray:data];
        success(array);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
}


/**
 获取消息计数器
 */

+ (void)requestCommunitycounterSuccess:(void (^)(NSDictionary *dic))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"works/msg/counter";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [HttpRequestHelper GET:method params:params success:^(id data) {
        success(data);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];

}

/**
 删除作品

 @param worksId 作品id
 @param success 成功
 @param failure failure
 */
+ (void)requestCommunityDeleteWorksId:(NSString *)worksId
                              success:(void (^)(BOOL success))success
                               failure:(void (^)(NSNumber *resCode, NSString *message))failure {
    NSString *method = @"works/del";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:worksId forKey:@"worksId"];
    [params safeSetObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params safeSetObject:[GetCore(AuthCore) getTicket] forKey:@"ticket"];
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success(YES);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(resCode, message);
        }
    }];
    
}


@end
