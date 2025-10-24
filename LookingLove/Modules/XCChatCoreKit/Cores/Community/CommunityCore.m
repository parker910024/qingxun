//
//  CommunityCore.m
//  XCChatCoreKit
//
//  Created by KevinWang on 2019/2/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "CommunityCore.h"
#import "CommunityCoreClient.h"
#import "HttpRequestHelper+Community.h"
#import "CommunityCoreClient.h"

@interface CommunityCore ()

@end

@implementation CommunityCore

/** 校验用户是否拥有发布权限*/
- (RACSignal *)requestUserPublishPermission{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestUserPublishPermissionSuccess:^(BOOL hasPermission) {
            [subscriber sendNext:@(hasPermission)];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            [subscriber sendError:CORE_API_ERROR(@"Community", resCode.integerValue, message)];
        }];
        return nil;
    }];
}



/**
 随机获取一个作品
 */
- (void)requestCommunityWorksRandomWorks{
    
    [HttpRequestHelper requestCommunityWorksRandomWorksSuccess:^(NSArray<CommunityInfo *> * _Nonnull infoList) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityWorksRandomWorksSuccess:), onRequestCommunityWorksRandomWorksSuccess:infoList);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityWorksRandomWorksFailth:), onRequestCommunityWorksRandomWorksFailth:message);
    }];
}

/**
 根据id获取社区作品
 @param worksId 作品id
 */
- (void)requestCommunityWorksWithWorksID:(NSString *)worksId{
    
    [HttpRequestHelper requestCommunityWorksWithWorksID:worksId success:^(CommunityInfo * _Nonnull info) {
       
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityWorksWithWroksIDSuccess:), onRequestCommunityWorksWithWroksIDSuccess:info);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityWorksWithWroksIDFailth:), onRequestCommunityWorksWithWroksIDFailth:message);
    }];
}



/**
 自增作品播放量接口 works/play(POST)
 @param worksId 作品id
 */
- (void)reportCommunityWorksPlay:(NSString *)worksId{
    
    [HttpRequestHelper reportCommunityWorksPlayWithWorksID:worksId success:^(BOOL isSucess) {
        //no handle
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        //no handle
    }];
}



/**
 点赞/取消点赞
 @param communityInfo 作品
 */
- (void)requestCommunityWorksLikeWorksByCommunityInfo:(CommunityInfo *)communityInfo className:(NSString *)className{
    
    [HttpRequestHelper requestCommunityWorksLikeWorksByWorksId:communityInfo.ID success:^(BOOL success) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityWorksLikeWorksSuccess:className:), onRequestCommunityWorksLikeWorksSuccess:communityInfo className:className);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityWorksLikeWorksFailth:className:), onRequestCommunityWorksLikeWorksFailth:message className:className);
    }];
}



/**
 评论列表
 @param worksId    作品Id
 @param page       页码
 @param state 0 结束头部刷新。  1 结束底部刷新
 */
- (void)requestCommunityWorksCommentListByWorksID:(NSString *)worksId page:(int)page state:(int)state{
    
    [HttpRequestHelper requestCommunityWorksCommentListByWorksID:worksId page:page success:^(NSArray<CommunityCommentInfo *> * _Nonnull commentList) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityWorksCommentListSussceState:page:commentList:), onRequestCommunityWorksCommentListSussceState:state page:page commentList:commentList);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityWorksCommentListFailthState:page:message:), onRequestCommunityWorksCommentListFailthState:state page:page message:message);
    }];
}

/**
 评论作品
 @param publishCommentInfo    评论模型
 */
- (void)publishCommunityWorksCommentByPublishCommentInfo:(CommunityPublishCommentInfo *)publishCommentInfo{
    
    [HttpRequestHelper publishCommunityWorksCommentByPublishCommentInfo:publishCommentInfo success:^(CommunityCommentInfo * _Nonnull commentInfo) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onPublishCommunityWorksCommentSuccess:worksCommentType:), onPublishCommunityWorksCommentSuccess:commentInfo worksCommentType:publishCommentInfo.worksCommentType);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onPublishCommunityWorksCommentFailth:), onPublishCommunityWorksCommentFailth:message);
    }];
}

/**
 点赞评论:works/comment/like(POST)
 @param commentInfo 评论模型
 */
- (void)requestCommunityWorksLikeCommentByCommentInfo:(CommunityCommentInfo *)commentInfo indexPath:(NSIndexPath *)indexPath{
    
    [HttpRequestHelper requestCommunityWorksLikeCommentByCommentId:commentInfo.ID success:^(BOOL success) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityWorksLikeCommentSuccess:indexPath:), onRequestCommunityWorksLikeCommentSuccess:commentInfo indexPath:indexPath);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityWorksLikeCommentFailth:), onRequestCommunityWorksLikeCommentFailth:message);
    }];
}

/**
 删除评论:works/comment/del(POST)
 @param targetUid 删除人uid，可能是作品
 @param commentId 评论id
 */
- (void)requestCommunityWorksDeleteComment:(UserID)targetUid commentId:(NSString *)commentId{
    
    [HttpRequestHelper requestCommunityWorksDeleteComment:targetUid commentId:commentId success:^(BOOL success) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityWorksDeleteCommentSuccess), onRequestCommunityWorksDeleteCommentSuccess);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityWorksDeleteCommentFailth:), onRequestCommunityWorksDeleteCommentFailth:message);
    }];
}

/**
 获取回复列表:works/comment/reply/list(get)
 @param commentId    评论id（主评论）    是    [string]
 @param page    页码    是    [int]
 @param size    数量    是    [int]
 @param state 0 结束头部刷新。  1 结束底部刷新
 */
- (void)requestCommunityWorksCommentListByCommentId:(NSString *)commentId page:(int)page size:(int)size state:(int)state{
    
    [HttpRequestHelper requestCommunityWorksCommentListByCommentId:commentId page:page size:size success:^(NSArray<CommunityCommentInfo *> * _Nonnull replyList) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(requestCommunityWorksCommentListSuccessState:replyList:), requestCommunityWorksCommentListSuccessState:state replyList:replyList);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(requestCommunityWorksCommentListFailthState:message:), requestCommunityWorksCommentListFailthState:state message:message);
    }];
}






/** 背景音乐接口*/
- (void)requestCommunityBackgroundMusicGroup{
    [HttpRequestHelper requestCommunityBackgroundMusicGroupSuccess:^(NSArray<CommunityMusicData *> * _Nonnull musicGroupList) {
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityBackgroundMusicGroupSuccess:), onRequestCommunityBackgroundMusicGroupSuccess:musicGroupList);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityBackgroundMusicGroupFailth:), onRequestCommunityBackgroundMusicGroupFailth:message);
    }];
}

/**
 获取指定分类的背景音乐列表
 @param catalogId 分类id
 @param page 页码
 @param state 0 结束头部刷新。  1 结束底部刷新
 */
- (void)requestCommunityBackgroundMusicByCatalogId:(NSString *)catalogId page:(int)page state:(int)state{
    
    [HttpRequestHelper requestCommunityBackgroundMusicByCatalogId:catalogId page:page success:^(NSArray<CommunityMusicInfo *> * _Nonnull musicList) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityBackgroundMusicSuccessState:musicList:), onRequestCommunityBackgroundMusicSuccessState:state musicList:musicList);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityBackgroundMusicFailthState:message:), onRequestCommunityBackgroundMusicFailthState:state message:message);
    }];
}





/**

 社区作品发布
 @param publishInfo 发布信息
 */
- (void)publishCommunityWorksByCommunityPublishInfo:(CommunityPublishInfo *)publishInfo{
    
    [HttpRequestHelper publishCommunityWorksByCommunityPublishInfo:publishInfo success:^(BOOL success) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onPublishCommunityWorksSuccess), onPublishCommunityWorksSuccess);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        
        NotifyCoreClient(CommunityCoreClient, @selector(onPublishCommunityWorksFailth:), onPublishCommunityWorksFailth:message);
    }];
}



/*统计用户的作品数和点赞数
 @param targetUid 目标用户uid
 */
- (RACSignal *)requestCommunityUserTotalTargetUid:(NSString*)targetUid {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestCommunityUserTotalTargetUid:targetUid success:^(NSString * _Nonnull likeCount, NSString * _Nonnull worksCount) {
            [subscriber sendNext:@[worksCount,likeCount]];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            [subscriber sendError:CORE_API_ERROR(@"Community", resCode.integerValue, message)];

        }];
        return nil;
    }];
}


/*关注 多个用户
 @param targetUids 目标用户uid    是    [array]
 */
- (RACSignal *)requestCommunityFollowUserTargetUids:(NSArray<NSString *> *)targetUids {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [HttpRequestHelper requestCommunityFollowUserTargetUids:targetUids success:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            [subscriber sendError:CORE_API_ERROR(@"Community", resCode.integerValue, message)];
        }];
        return nil;
    }];
}



/**
 随机 获取可以关注的用户
 @param size 当前页
 */
- (void)requestCommunityFollowUserSize:(int)size {
    [HttpRequestHelper requestCommunityFollowUserSize:size success:^(NSArray<UserInfo *> * _Nonnull userArray) {
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityFollowUserSize:success:), onRequestCommunityFollowUserSize:size success:userArray);

    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityFollowUserSizeFailth:), onRequestCommunityFollowUserSizeFailth:message);

    }];
}



/**
 获取 关注 用户的 社区作品 列表
 
 @param page 当前页数
 @param pageSize 每一页的数量
 @param state 加载状态 上啦 下啦
 */
- (void)requestCommunityFollowUserProductPage:(int)page  pageSize:(int)pageSize state:(int)state {
    [HttpRequestHelper requestCommunityFollowUserProductListPage:page pageSize:pageSize success:^(NSArray<CommunityInfo *> * _Nonnull productArray) {
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityFollowUserProductListPage:state:success:), onRequestCommunityFollowUserProductListPage:page state:state success:productArray);

    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityFollowUserProductListfailth:), onRequestCommunityFollowUserProductListfailth:message);

    }];
}

/**获取用户的 社区作品b列表
 
 @param targetuid 需要获取的用户uid
 @param page 当前页数
 @param pageSize 每一页的数量
 */
- (void)requestCommunityUserProductWithTargetUid:(UserID)targetuid page:(int)page pageSize:(int)pageSize state:(int)state {
    
    [HttpRequestHelper requestCommunityUserProductListWithTargetUid:targetuid page:page pageSize:pageSize success:^(NSArray<CommunityProductInfo *> * _Nonnull productArray) {
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityUserProductListTargetUid:page:state:success:), onRequestCommunityUserProductListTargetUid:targetuid page:page state:state success:productArray);
    } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
        NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityUserProductListTargetUid:failth:), onRequestCommunityUserProductListTargetUid:targetuid failth:message);
    }];
}

/**
 获取用户 点赞/喜欢  社区作品列表
 
 @param targetUid 要获取的用户
 @param page 当前页
 @param pageSize 每一页的数量
 @param state 加载状态
 */

- (void)requestCommunityUserLikeListWithTargetUid:(UserID)targetUid page:(int)page pageSize:(int)pageSize state:(int)state {
    
    [HttpRequestHelper requestCommunityUserLikeListWithTargetUid:targetUid page:page pageSize:pageSize success:^(NSArray<CommunityProductInfo *> *productArray) {
            NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityUserLikeListTargetUid:page:state:success:), onRequestCommunityUserLikeListTargetUid:targetUid page:page state:state success:productArray);

    } failure:^(NSNumber * errorCode, NSString * message) {
            NotifyCoreClient(CommunityCoreClient, @selector(onRequestCommunityUserLikeListTargetUid:failth:), onRequestCommunityUserLikeListTargetUid:targetUid failth:message);
    }];
 
}

/**
 根据类型 获取 社区 消息
 
 @param type 消息类型. 1-点赞，2-At，3-评论
 @param page 当前页码
 @param pageSize 每页数量
 @param state 加载状态

 */

- (void)requestCommunityMessageListWithType:(int)type page:(int)page pageSize:(int)pageSize state:(int)state {
    
    [HttpRequestHelper requestCommunityMessageListWithType:type page:page pageSize:pageSize success:^(NSArray<CommunityMessageInfo *> * messageArray) {
        NotifyCoreClient(CommunityCoreClient, @selector(requestCommunityMessageListWithType:page:state:success:), requestCommunityMessageListWithType:type page:page state:state success:messageArray);

    } failure:^(NSNumber * errorCode, NSString * message) {
        NotifyCoreClient(CommunityCoreClient, @selector(requestCommunityMessageListWithType:failth:), requestCommunityMessageListWithType:type failth:message);

    }];
    
}


/**
 弹幕列表
 @param worksId 作品ID
 
 */

- (RACSignal *)requestCommunityCommentBarrageListWithWorksId:(NSString *)worksId {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [HttpRequestHelper requestCommunityCommentBarrageListWithWorksId:worksId success:^(NSArray<CommunityCommentInfo *> * commentList) {
//            [subscriber sendNext:@[worksId,commentList]];
            [subscriber sendNext:commentList];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            [subscriber sendError:CORE_API_ERROR(@"Community", resCode.integerValue, message)];

        }];
        return nil;
    }];
    
}

/**
 获取消息计数器
 */

- (RACSignal *)requestCommunitycounter {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestCommunitycounterSuccess:^(NSDictionary * _Nonnull dic) {
            [subscriber sendNext:dic];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            [subscriber sendError:CORE_API_ERROR(@"Community", resCode.integerValue, message)];
        }];
        return nil;
    }];
}


/**
 删除作品
 */
- (RACSignal *)requestCommunityDeleteWorksId:(NSString *)worksId {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [HttpRequestHelper requestCommunityDeleteWorksId:worksId success:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        } failure:^(NSNumber * _Nonnull resCode, NSString * _Nonnull message) {
            [subscriber sendError:CORE_API_ERROR(@"Community", resCode.integerValue, message)];

        }];
        return nil;
    }];

}

@end
