//
//  HttpRequestHelper+MusicPlayer.m
//  XCChatCoreKit
//
//  Created by apple on 2018/11/2.
//

#import "HttpRequestHelper+MusicPlayer.h"
#import "AuthCore.h"
#import "MusicInfo.h"

@implementation HttpRequestHelper (MusicPlayer)


/**
 在线音乐列表
 
 @param pageNum 页面
 @param pageSize 一页多少数据
 @param songName 搜索歌手名字
 @param success 成功
 @param failure 失败
 */
+ (void)requestMusicOnlineListWithpageNum:(NSUInteger)pageNum
                           pageSize:(NSUInteger)pageSize
                           songName:(NSString *)songName
                            success:(void (^)(NSArray<MusicInfo*>* roomInfoList))success
                            failure:(void (^)(NSString *message))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:[NSNumber numberWithInteger:pageNum] forKey:@"pageNum"];
    [params setObject:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    [params setObject:songName forKey:@"songName"];
    
    NSString *method = @"music/list";
    if (projectType() == ProjectType_Pudding ||
        projectType() == ProjectType_TuTu ||
        projectType() == ProjectType_LookingLove ||
        projectType() == ProjectType_Planet) {
        method = @"api/music/list";
    }

    [HttpRequestHelper POST:method params:params success:^(id data) {
        
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[MusicInfo class] json:data];
        success(dataArray);
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}


/**
 记录添加音乐
 
 @param musicId 音乐id
 */
+ (void)requestMusicOnlineAddMusicClick:(NSInteger)musicId
                                success:(void (^)(void))success
                                failure:(void (^)(NSString *message))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:[NSNumber numberWithInteger:musicId] forKey:@"musicId"];
    NSString *method = @"music/add";
    if (projectType() == ProjectType_Pudding ||
        projectType() == ProjectType_TuTu ||
        projectType() == ProjectType_LookingLove ||
        projectType() == ProjectType_Planet) {
        method = @"api/music/add";
    }
    [HttpRequestHelper POST:method params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

+ (void)requestStrangerMusicName:(NSString *)songName
                         success:(void (^)(void))success
                         failure:(void (^)(NSString *message))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[GetCore(AuthCore) getUid] forKey:@"uid"];
    [params setObject:songName forKey:@"songName"];
    
    [HttpRequestHelper POST:@"room/updateMusic" params:params success:^(id data) {
        success();
    } failure:^(NSNumber *resCode, NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
    
}
@end
