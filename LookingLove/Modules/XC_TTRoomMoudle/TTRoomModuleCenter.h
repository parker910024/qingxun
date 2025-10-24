//
//  TTRoomModuleCenter.h
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserID.h"
#import "RoomCoreV2.h"

@interface TTRoomModuleCenter : NSObject

@property(nonatomic, strong) UINavigationController *currentNav;
@property(nonatomic, assign) BOOL systemOperationStatusBarIsShow;
@property (nonatomic,assign) UserID recommendUid;
//是否已经弹出过推荐房间的框
@property (nonatomic,assign) BOOL hadShowRecommendRoomView;
//是都已经弹出过新人红包
@property (nonatomic,assign) BOOL hadShowRedView;

@property(nonatomic, strong) RoomInfo *currentRoomInfo;

+ (instancetype)defaultCenter;

//开启指定类型房间
- (void)openRoonWithType:(RoomType)type;
//根据房间info present房间
- (void)presentRoomViewWithRoomInfo:(RoomInfo *)roomInfo;
//根据房间所有者id。获取房间信息
- (void)presentRoomViewWithRoomOwnerUid:(UserID)ownerUid
                                success:(void (^)(RoomInfo *roomInfo))successBlock
                                   fail:(void (^)(NSString *errorMsg))failBlock;


//退出房间
- (void)dismissChannelViewWithQuitCurrentRoom:(BOOL)isQuit;
- (void)dismissChannelViewWithQuitCurrentRoom:(BOOL)isQuit animation:(BOOL)animation;

/** 最小化房间带Block*/
- (void)dismissChannelViewWithQuitCurrentRoom:(BOOL)isQuit animation:(BOOL)animation completion:(void(^)(void))completion;
@end
