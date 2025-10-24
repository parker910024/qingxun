//
//  ShareCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/7/6.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

//1 直播间，2 H5 3 888 转盘抽奖
typedef enum : NSUInteger {
    SharePageIdRoom = 1,
    SharePageIdH5 = 2,
    SharePageIdUserDraw = 888,
} SharePageId;

@protocol ShareCoreClient <NSObject>
@optional
- (void)onShareRoomSuccess;
- (void)onShareRoomFailth;

- (void)onShareH5Success;
- (void)onShareH5Failth:(NSString *)message;

- (void)onShareImageSuccess;
- (void)onShareImageFailure:(NSString *)message;

/**
 分享社区
 */
- (void)onShareCommunitySuccess;
- (void)onShareCommunityFailth:(NSString *)message;


- (void)receiveRedPacketWith:(NSString *)packetNum;

/**
 分享成功后, 回调服务器接口成功后的回调
 
 @param shareType 分享类型，1微信好友，2微信朋友圈，3QQ好友，4QQ空间
 @param sharePageId 分享页面，1 直播间，2 H5 3 888 转盘抽奖
 @param targetUid 如果被分享房间，传被分享房间UID
 */
- (void)postShareSuccessNetworkSuccessDataShareType:(NSInteger)shareType sharePageId:(SharePageId)sharePageId targetUid:(NSInteger)targetUid;
@end

