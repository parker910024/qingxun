//
//  TTRoomRoleListController.h
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseTableViewController.h"

/**
 房间角色类型

 - TTRoomRoleManager: 管理员
 - TTRoomRoleBlacklist: 黑名单
 */
typedef NS_ENUM(NSUInteger, TTRoomRole) {
    TTRoomRoleManager,
    TTRoomRoleBlacklist
};

@interface TTRoomRoleListController : BaseTableViewController

/**
 当前请求列表的房间角色类型
 */
@property (nonatomic, assign) TTRoomRole role;

@end
