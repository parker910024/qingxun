//
//  NIMSessionViewController.h
//  NIMKit
//
//  Created by NetEase.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMSDK/NIMSDK.h>
#import "NIMKitUtil.h"
#import "NIMSessionConfig.h"
#import "NIMMessageCellProtocol.h"
#import "NIMSessionConfigurateProtocol.h"
#import "NIMInputView.h"
#import "TTPublicChatInputView.h"

@interface NIMSessionViewController : UIViewController<NIMSessionInteractorDelegate,NIMInputActionDelegate,NIMMessageCellDelegate,NIMChatManagerDelegate,NIMConversationManagerDelegate>

@property (nonatomic, strong)  UITableView *tableView;

//默认的输入框
@property (nonatomic, strong)  NIMInputView *sessionInputView;

@property (nonatomic, strong)  NIMSession *session;
//config
@property (nonatomic,weak)    id<NIMSessionInteractor> interactor;

/**
 是不是房间内消息
 */
@property (nonatomic, assign) BOOL isRoomMessage;

/**
 *  当前当初的菜单所关联的消息
 *
 *  @discussion 在菜单点击方法中，想获取所点的消息，可以调用此接口
 */
@property (nonatomic, strong, readonly)     NIMMessage *messageForMenu;

/**
 *  初始化方法
 *
 *  @param session 所属会话
 *
 *  @return 会话页实例
 */
- (instancetype)initWithSession:(NIMSession *)session;


#pragma mark - 界面
/**
 *  是不是关注了
 */
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, copy) NSString *nick;
/**
 *  会话页导航栏标题
 */
- (NSMutableAttributedString *)sessionTitle;

/// 会话页导航栏标题
/// @param nick 传入昵称
- (NSMutableAttributedString *)sessionTitle:(NSString *)nick;
/**
 *  会话页导航栏子标题
 */
- (NSString *)sessionSubTitle;

/// 会话页导航栏子标题富文本，如果有值优先显示
- (NSAttributedString *)sessionSubTitleAttributedString;

/**
 *  刷新导航栏标题，刷新就好了，标题传入不会赋值
 */
- (void)refreshSessionTitle:(NSMutableAttributedString *)title;

/**
 *  刷新导航子栏标题，刷新就好了，标题传入不会赋值
 */
- (void)refreshSessionSubTitle:(NSString *)title;

/**
 *  会话页长按消息可以弹出的菜单
 *
 *  @param message 长按的消息
 *
 *  @return 菜单，为UIMenuItem的数组
 */
- (NSArray *)menusItems:(NIMMessage *)message;

/**
 *  会话页详细配置
 */
- (id<NIMSessionConfig>)sessionConfig;


#pragma mark - 消息接口
/**
 *  发送消息
 *
 *  @param message 消息
 */
- (void)sendMessage:(NIMMessage *)message;

#pragma mark - 录音接口
/**
 *  录音失败回调
 *
 *  @param error 失败原因
 */
- (void)onRecordFailed:(NSError *)error;

/**
 *  录音内容是否可以被发送
 *
 *  @param filepath 录音路径
 *
 *  @return 是否允许发送
 *
 *  @discussion 在此回调里检查录音时长是否满足要求发送的录音时长
 */
- (BOOL)recordFileCanBeSend:(NSString *)filepath;

/**
 *  语音不能发送的原因
 *
 *  @discussion 可以显示录音时间不满足要求之类的文案
 */
- (void)showRecordFileNotSendReason;

#pragma mark - 操作接口

/**
 *  追加多条消息
 *
 *  @param messages 消息集合
 *
 *  @discussion 不会比较时间戳，直接加在消息列表末尾。不会触发 DB 操作，，请手动调用 SDK 里 saveMessage:forSession:completion: 接口。
 */

- (void)uiAddMessages:(NSArray *)messages;


/**
 *  插入多条消息
 *
 *  @param messages 消息集合
 *
 *  @discussion 会比较时间戳，加在合适的地方，不推荐聊天室这种大消息量场景使用。不会触发 DB 操作，，请手动调用 SDK 里 saveMessage:forSession:completion: 接口。
 */

- (void)uiInsertMessages:(NSArray *)messages;

/**
 *  删除一条消息
 *
 *  @param message 消息
 *
 *  @return 被删除的 MessageModel
 *
 *  @discussion 不会触发 DB 操作，请手动调用 SDK 里 deleteMessage: 接口
 */
- (NIMMessageModel *)uiDeleteMessage:(NIMMessage *)message;

/**
 *  更新一条消息
 *
 *  @param message 消息
 *
 *  @discussion 不会触发 DB 操作，请手动调用 SDK 里 updateMessage:forSession:completion: 接口
 */
- (void)uiUpdateMessage:(NIMMessage *)message;

/**
 禁言

 @param isMute 是否被禁言
 */
- (void)isMute:(BOOL)isMute;

/**
 输入view初始化方法
 */
- (void)setupInputView;

/**
 是否需要显示输入框

 @return 是否需要显示输入框
 */
- (BOOL)shouldShowInputView;

//是否需要监听感应器事件
- (BOOL)needProximityMonitor;

/**
 配置回话配置器

 @param isPublic 是否是公聊大厅
 */
- (void)setupConfigurator:(BOOL)isPublic childVC:(NIMSessionViewController *)childVC;


/**
 布局tableview
 */
- (void)setupTableView;

/**
 配置器
 */
- (void)setupConfigurator;

/**
 添加监听
 */
- (void)addListener;

/**
 是不是显示是否是好友的提示
 */
- (void)updateTableViewFrame:(BOOL)isFriend;

@end
