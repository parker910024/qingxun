//
//  FaceCore.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"
#import "FaceInfo.h"
#import "FaceConfigInfo.h"
#import "Attachment.h"

typedef enum : NSUInteger {
    RoomFaceTypeNormal,
    RoomFaceTypeNoble,
} RoomFaceType;

@interface FaceCore : BaseCore

@property (copy, nonatomic) NSString *version;
@property (copy, nonatomic) NSString *zipMd5;
@property (strong, nonatomic) NSURL *zipUrl;

@property (assign, nonatomic) BOOL isShowingFace;
@property (copy, nonatomic) NSString *destinationUrl;
@property (assign, nonatomic) BOOL isLoadFace;
@property (nonatomic, strong) FaceConfigInfo  *dragonConfigInfo;//龙族资源
@property (nonatomic, assign) BOOL  isSendingDragon;//是否正在发送 龙珠  也就是是否 发送云信消息 成功
@property (nonatomic, assign) BOOL canPlayTogether; //是否可以一起玩

/**
 清除表情的内存缓存（收到内存警告的时候使用）
 */
- (void)cleanFaceMemoryCache;

/**
 获取表情列表

 @return 表情列表
 */
- (NSMutableArray *)getFaceInfosType:(RoomFaceType)faceType;



/**
 是否正在播放表情

 @return <#return value description#>
 */
- (BOOL)getShowingFace;


/**
 群发表情

 @param faceInfo 表情信息
 */
- (void)sendAllFace:(FaceConfigInfo *)faceInfo;


/**
 单独发表情

 @param faceInfo 表情信息
 */
- (void)sendFace:(FaceConfigInfo *)faceInfo;

/**
 发送表情给cp

 @param faceInfo 表情信息
 */
- (void)sendToCpFace:(FaceConfigInfo *)faceInfo;
/**
 发送龙珠
 
 @param state 龙珠状态
 */
- (void)sendDragonWithState:(CustomNotificationDragon)state;

/**
 获取一起玩表情（骰子）

 @return 表情信息
 */
- (FaceConfigInfo *)getPlayTogetherFace;


/**
 通过表情ID找表情

 @param faceId 表情ID
 @return 表情信息
 */
- (FaceConfigInfo *)findFaceInfoById:(NSInteger)faceId;


/**
 通过表情ID查到图片对象

 @param faceId 表情ID
 @return 表情图片对象
 */
- (UIImage *)findFaceIconImageById:(NSInteger)faceId;


/**
 通过表情ID与Index找图片对象

 @param faceId 表情ID
 @param index 表情Index
 @return 表情对象
 */
- (UIImage *)findFaceImageById:(NSInteger)faceId index:(NSInteger)index;


/**
 通过表情ConfigInfo查找图片

 @param configInfo 表情配置
 @param index 位置pos
 @return 表情图片对象
 */
- (UIImage *)findFaceImageByConfig:(FaceConfigInfo *)configInfo index:(NSInteger)index;



/**
 通过Config查找图片数组

 @param configInfo 表情配置
 @return 表情图片对象数组
 */
- (NSMutableArray<UIImage *> *)findFaceFrameArrByConfig:(FaceConfigInfo *)configInfo;


/**
 通过FaceId查找图片对象数组

 @param faceId 表情ID
 @return 图片对象数组
 */
- (NSMutableArray<UIImage *> *)findFaceFrameArrByFaceId:(NSInteger)faceId;


/**
 请求Face数据
 */
//- (void)requestFaceJson;


/**
 测试使用接口，发送一起玩表情
 */
- (void)startFaceTimer;
- (void)cancelFaceTimer;
@end
