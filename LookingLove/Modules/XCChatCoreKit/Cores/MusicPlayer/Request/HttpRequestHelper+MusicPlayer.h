//
//  HttpRequestHelper+MusicPlayer.h
//  XCChatCoreKit
//
//  Created by apple on 2018/11/2.
//

#import "HttpRequestHelper.h"
#import "MusicInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestHelper (MusicPlayer)


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
                                failure:(void (^)(NSString *message))failure;


/**
 记录添加音乐
 
 @param musicId 音乐id
 */
+ (void)requestMusicOnlineAddMusicClick:(NSInteger)musicId
                                success:(void (^)(void))success
                                failure:(void (^)(NSString *message))failure;


/**
 房主上报当前播放音乐
 
 @param songName 歌曲名称
 */
+ (void)requestStrangerMusicName:(NSString *)songName
                         success:(void (^)(void))success
                         failure:(void (^)(NSString *message))failure;
@end

NS_ASSUME_NONNULL_END
