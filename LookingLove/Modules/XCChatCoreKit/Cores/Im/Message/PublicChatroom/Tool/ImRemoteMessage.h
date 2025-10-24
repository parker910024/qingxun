//
//  ImRemoteMessage.h
//  AFNetworking
//
//  Created by 卫明 on 2018/11/14.
//

#import "BaseObject.h"

#import <NIMSDK/NIMMessage.h>

typedef enum : NSUInteger {
    ImRemoteMessageEventType_conversation = 1,//表示CONVERSATION消息，即会话类型的消息（目前包括P2P聊天消息，群组聊天消息，群组操作，好友操作）
    ImRemoteMessageEventType_login = 2,//表示LOGIN消息，即用户登录事件的消息
    ImRemoteMessageEventType_logout = 3,//表示LOGOUT消息，即用户登出事件的消息
    ImRemoteMessageEventType_chatroom = 4,//表示CHATROOM消息，即聊天室中聊天的消息
    ImRemoteMessageEventType_audio = 5,//表示AUDIO/VEDIO/DataTunnel消息，即汇报实时音视频通话时长、白板事件时长的消息
    ImRemoteMessageEventType_video = 6,//表示音视频/白板文件存储信息，即汇报音视频/白板文件的大小、下载地址等消息
    ImRemoteMessageEventType_P2Pcallback = 7,//表示单聊消息撤回抄送
    ImRemoteMessageEventType_Groupcallback = 8,//表示群聊消息撤回抄送
    ImRemoteMessageEventType_ChatroomInOut = 9,//表示CHATROOM_INOUT信息，即汇报主播或管理员进出聊天室事件消息
} ImRemoteMessageEventType;

NS_ASSUME_NONNULL_BEGIN

@interface ImRemoteMessage : NSObject

/**
 事件类型
 */
@property (nonatomic,assign) ImRemoteMessageEventType eventType;

/**
 消息内容
 */
@property (nonatomic,copy) NSString *attach;

/**
 第三方扩展字段
 */
@property (nonatomic,copy) NSString *ext;

/**
 消息发送者的账号，字符串类型
 */
@property (nonatomic,copy) NSString *fromAccount;

/**
 发送者的头像，字符串类型
 */
@property (nonatomic,copy) NSString *fromAvator;

/**
 发送者身份的扩展字段
 */
@property (nonatomic,copy) NSString *fromExt;

/**
 发送方昵称
 */
@property (nonatomic,copy) NSString *fromNick;

/**
 消息发送的时间戳
 */
@property (nonatomic,copy) NSString *msgTimestamp;

/**
 消息类型:NIMMessageType
 */
@property (nonatomic,copy) NSString *msgType;

/**
 客户端生成的消息id
 */
@property (nonatomic,copy) NSString *msgidClient;

/**
 消息所属的聊天室id
 */
@property (nonatomic,copy) NSString *roomId;

@end

NS_ASSUME_NONNULL_END
