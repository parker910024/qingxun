//
//  ArrangeMicCore.h
//  XCChatCoreKit
//
//  Created by gzlx on 2018/12/13.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "BaseCore.h"
#import "ArrangeMicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArrangeMicCore : BaseCore

@property (nonatomic, strong, nullable) ArrangeMicModel * arrangeMicModel;

/** 排麦的对列的个数 如果个数为-1要么是请求失败了 要么后台返回数据有问题*/
@property (nonatomic, assign) int arrangeMicCount;


/**
 管理房间内麦序的状态 是不是开启排麦模式
 @param status NO 是关闭 YES 是开启
 @param roomUid 房主的Uid
 */
- (void)managerRoomMiacStatusWith:(BOOL)status roomUid:(UserID)roomUid;


/**
 取消排麦/开始排麦
 @param status 0 开始排麦 1 取消排麦
 @param roomUid 房主的uid
 */
- (void)userBegainOrCancleArrangeMicWith:(int)status operuid:(UserID)operuid roomUid:(UserID)roomUid;

/**
 获取排麦的列表
 */
- (void)getArrangeMicList:(UserID)roomUid status:(int)status page:(int)page pageSize:(int)pageSize;

/**
 获取排麦的长度
 */
- (void)getArrangeMicListSizeWith:(UserID)roomUid;



@end

NS_ASSUME_NONNULL_END
