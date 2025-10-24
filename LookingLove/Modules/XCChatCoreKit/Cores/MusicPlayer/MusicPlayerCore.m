//
//  MusicPlayerCore.m
//  AFNetworking
//
//  Created by apple on 2018/11/2.
//

#import "MusicPlayerCore.h"
#import "HttpRequestHelper+MusicPlayer.h"
#import "MusicPlayerCoreClient.h"

@implementation MusicPlayerCore

- (void)requestMusicOnlineListWithpageNum:(NSUInteger)pageNum
                                 pageSize:(NSUInteger)pageSize
                                 songName:(NSString *)songName{
    [HttpRequestHelper requestMusicOnlineListWithpageNum:pageNum pageSize:pageSize songName:songName success:^(NSArray<MusicInfo *> * _Nonnull roomInfoList) {
        NotifyCoreClient(MusicPlayerCoreClient, @selector(onMusicOnlineListSuccess:), onMusicOnlineListSuccess:roomInfoList);
    } failure:^(NSString * _Nonnull message) {
        NotifyCoreClient(MusicPlayerCoreClient, @selector(onMusicOnlineListFailth:), onMusicOnlineListFailth:message);
    }];
}

- (void)requestMusicOnlineAddMusicClick:(NSInteger)musicId{
    [HttpRequestHelper requestMusicOnlineAddMusicClick:musicId success:^{
        NotifyCoreClient(MusicPlayerCoreClient, @selector(onMusicOnlineAddMusicClickSuccess), onMusicOnlineAddMusicClickSuccess);
    } failure:^(NSString * _Nonnull message) {
        NotifyCoreClient(MusicPlayerCoreClient, @selector(onMusicOnlineAddMusicClickFailth:), onMusicOnlineAddMusicClickFailth:message);
    }];
}

- (void)requestStrangerMusicName:(NSString *)songName{
    [HttpRequestHelper requestStrangerMusicName:(NSString *)songName success:^{
        NotifyCoreClient(MusicPlayerCoreClient, @selector(onStrangerMusicNameSuccess), onStrangerMusicNameSuccess);
    } failure:^(NSString * _Nonnull message) {
        NotifyCoreClient(MusicPlayerCoreClient, @selector(onStrangerMusicNameSuccessFailth:), onStrangerMusicNameSuccessFailth:message);
    }];
}
@end
