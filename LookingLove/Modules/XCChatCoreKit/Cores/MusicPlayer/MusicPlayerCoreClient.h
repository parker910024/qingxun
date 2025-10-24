//
//  MusicPlayerCoreClient.h
//  Pods
//
//  Created by apple on 2018/11/2.
//

#import <Foundation/Foundation.h>

@protocol MusicPlayerCoreClient <NSObject>
@optional
/**在线音乐列表*/
- (void)onMusicOnlineListSuccess:(NSArray *)musicList;
- (void)onMusicOnlineListFailth:(NSString *)msg;

/**点击添加音乐*/
- (void)onMusicOnlineAddMusicClickSuccess;
- (void)onMusicOnlineAddMusicClickFailth:(NSString *)msg;


/**房主上报音乐成功*/
- (void)onStrangerMusicNameSuccess;
- (void)onStrangerMusicNameSuccessFailth:(NSString *)msg;
@end
