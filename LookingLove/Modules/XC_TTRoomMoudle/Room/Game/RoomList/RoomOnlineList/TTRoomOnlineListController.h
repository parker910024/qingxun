//
//  TTRoomOnlineListController.h
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  房间 在线列表

#import "BaseTableViewController.h"
#import "UserID.h"

/**
 房间在线列表类型

 - TTRoomOnlineListTypeAll: 全部人
 - TTRoomOnlineListTypeWithoutMicro: 排除在麦上的人
 */
typedef NS_ENUM(NSUInteger, TTRoomOnlineListType) {
    TTRoomOnlineListTypeAll = 0,
    TTRoomOnlineListTypeWithoutMicro
};

typedef void(^SelectUserBlock)(UserID uid);


@class TTRoomOnlineListController;

@protocol TTRoomOnlineListControllerDelegate <NSObject>

@optional

/**
 列表上谁被点击了
 
 @param uid 用户id
 */
- (void)onOnlineList:(TTRoomOnlineListController *)roomOnlineListController didSelectWithUid:(UserID)uid;

@end

@interface TTRoomOnlineListController : BaseTableViewController

/**
 选中一个用户，抱TA上麦，TTRoomOnlineListTypeWithoutMicro 时有效
 */
@property (nonatomic, copy) SelectUserBlock selectUserBlock;

@property (nonatomic, weak) id<TTRoomOnlineListControllerDelegate> delegate;
/**
 初始化在线列表

 @param type 列表类型
 @return 列表控制器实例
 */
- (instancetype)initWithOnlineListType:(TTRoomOnlineListType)type;

@end
