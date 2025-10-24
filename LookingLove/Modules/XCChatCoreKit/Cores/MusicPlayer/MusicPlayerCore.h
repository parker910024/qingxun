//
//  MusicPlayerCore.h
//  AFNetworking
//
//  Created by apple on 2018/11/2.
//

#import "BaseCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface MusicPlayerCore : BaseCore

/**
 在线音乐列表
 
 @param pageNum 页面
 @param pageSize 一页多少数据
 @param songName 搜索歌手名字
 */
- (void)requestMusicOnlineListWithpageNum:(NSUInteger)pageNum
                                 pageSize:(NSUInteger)pageSize
                                 songName:(NSString *)songName;


/**
 记录添加音乐
 
 @param musicId 音乐id
 */
- (void)requestMusicOnlineAddMusicClick:(NSInteger)musicId;


/**
 房主上报当前播放音乐
 
 @param songName 歌曲名称
 */
- (void)requestStrangerMusicName:(NSString *)songName;
@end

NS_ASSUME_NONNULL_END
