//
//  Target_TTRoomModule.h
//  TuTu
//
//  Created by KevinWang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//
/*
 0. baseVc
 1. springView
 2. finshView
 3. pwdView
 4. mainVc
 5. 坑位
 6. toolBar
 7. 用户卡片
 8. 礼物
 9. 表情
 10. 一起玩
 
 11. 贡献榜
 12. 在线列表
 13. 抱他上麦
 
 14. 房间设置
 15. 管理员、黑名单
 
 16. 音乐播放器
 17. 公屏
 18. box
 19. KTV
 20. 抽奖转盘
 */
#import <UIKit/UIKit.h>

@interface Target_TTRoomModule : NSObject
/**
 进入房间
 */
- (void)Action_TTRoomModulePresentRoomViewController:(NSDictionary *)params;

/**
 开启自己房间
 */
- (void)Action_TTRoomModuleOpenRoomViewController:(NSDictionary *)params;

/**
 最小化后进入房间
 */
- (void)Action_TTRoomModuleMaxRoomViewController:(NSDictionary *)params;

/**
 关闭房间
 */
- (void)Action_TTRoomModuleCloseRoomViewController;


/**
 最小化房间
 */
- (void)Action_TTRoomModuleMinRoomViewController:(NSDictionary *)params;

@end
