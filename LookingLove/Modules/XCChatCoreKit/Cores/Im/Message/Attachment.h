//
//  Attachment.h
//  BberryCore
//
//  Created by chenran on 2017/6/4.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import "BaseObject.h"



typedef enum{
    Custom_Noti_Header_TopicNoti_Normal = 391,//话题推送
}CustomNotificationHeaderTopicNoti;

typedef enum{
    Custom_Noti_Header_H5_Normal = 401,//H5推送
}CustomNotificationHeaderH5;

typedef enum {
    Custom_Noti_Header_Nonsupport_Message = -1,//不支持的消息类型, iOS客户端自定义的,
    
    Custom_Noti_Header_Auction = 1,//拍卖
    Custom_Noti_Header_Room_Tip = 2, //房间提示
    Custom_Noti_Header_Gift = 3,//礼物
    Custom_Noti_Header_Micro = 4,//麦序
    Custom_Noti_Header_Account = 5,//账户
    Custom_Noti_Header_CustomMsg = 6, //云信自定义消息
    Custom_Noti_Header_PhoneCall = 7,//密聊订单
    Custom_Noti_Header_Queue = 8, //队列
    Custom_Noti_Header_Face = 9, //表情
    Custom_Noti_Header_News = 10,//推文
    Custom_Noti_Header_RedPacket = 11, //xcRedColor
    Custom_Noti_Header_ALLMicroSend = 12, //全麦送
    Custom_Noti_Header_Turntable = 13, //转盘
    Custom_Noti_Header_NobleNotify = 14,//贵族通知
    Custom_Noti_Header_CarNotify = 15, //座驾
    Custom_Noti_Header_RoomMagic = 16, //房间魔法
    Custom_Noti_Header_Game = 17, //游戏
    Custom_Noti_Header_Kick = 18, //kick
    Custom_Noti_Header_Secretary_Universal = 19, //小秘书通用消息
    Custom_Noti_Header_Update_RoomInfo = 20,//更新房间信息（动画/音质）
    Custom_Noti_Header_Group_RedPacket = 21, //发送xcRedColor
    Custom_Noti_Header_InApp_Share= 22, //应用内分享
    Custom_Noti_Header_Message_Handle = 23,//系统通知，自定义布局消息（带确认、取消）
   
    Custom_Noti_Header_User_UpGrade = 24,//用户升级提醒
    Custom_Noti_Header_Dragon= 25,//龙珠
    Custom_Noti_Header_Box= 26,//开箱子
    Custom_Noti_Header_KTV = 27,//KTV
    Custom_Noti_Header_PublicChatroom = 28,//公聊大厅
    Custom_Noti_Header_CoupleMsg = 29,//组CP消息
    Custom_Noti_Header_ArrangeMic = 30,//排麦
    Custom_Noti_Header_Room_PK = 31,//pk模式
    Custom_Noti_Header_HALL = 32, // 公会模厅消息
    Custom_Noti_Header_CPGAME = 33, // CP房 游戏模式
    Custom_Noti_Header_Mentoring_RelationShip = 34, //师徒关系
    Custom_Noti_Header_CPGAME_PrivateChat = 35,  // 游戏模式，私聊 公聊 发起游戏 都是这个
    Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification = 36, //  私聊游戏模式。系统通知用这种样式。居中，没有头像
    Custom_Noti_Header_CPGAME_PublicChat_Respond = 37, //  公聊游戏模式，接受   取消
    Custom_Noti_Header_SystemNoti = 38, //  萌声 系统通知
    Custom_Noti_Header_AboutMe = 39, //  萌声 社区 与我有关的
    Custom_Noti_Header_Checkin = 41, // 签到
    Custom_Noti_Header_GiftValue = 42, // 礼物值
    Custom_Noti_Header_Room_LeaveMode = 43, // 房间离开模式
    Custom_Noti_Header_PrivateChat_Chatterbox = 44, // 私聊话匣子游戏
    Custom_Noti_Header_Game_VoiceBottle = 45, // 声音瓶子
    Custom_Noti_Header_Game_LittleWorld = 46, // 小世界
    Custom_Noti_Header_Segment_AllMicSend = 47, // 拆分消息全麦送
    Custom_Noti_Header_Room_TeenagerMode = 48, // 青少年房间在线通知
    Custom_Noti_Header_Room_SuperAdmin = 50, // 轻寻超级管理员自定义消息
    Custom_Noti_Header_Room_LittleWorldQuit = 51, //离开小世界
    Custom_Noti_Header_Dynamic = 52, //动态
    Custom_Noti_Header_RoomActivityHot = 53, // 房间高能倒计时
    Custom_Noti_Header_RoomActivityHotBP = 54, // 房间高能倒计时备用（53在其他项目被用了）
    Custom_Noti_Header_RoomPublicScreen = 56, // 房间公屏消息
    Custom_Noti_Header_OfficialAnchorCertification = 57, // 官方主播认证（和23同一套业务逻辑，兼容Android，那边之前把routerValue设置为int，现在需要传string，强转导致crash）
    Custom_Noti_Header_Common_System_Notification = 58, // 通用系统通知
    Custom_Noti_Header_Red = 59,//红包
    Custom_Noti_Header_BP = 60,//被占用，这里占位
    Custom_Noti_Header_Broadcast = 62,//全服通知
    Custom_Noti_Header_Feedback = 63,//举报反馈
    Custom_Noti_Header_NameplateNoti= 70,//铭牌修改
    Custom_Noti_Header_RoomLoveModelFirst = 73, // 相亲房
} CustomNotificationHeader;

typedef NS_ENUM(NSUInteger, Custom_Noti_Sub_Room_LoveModel_Sec) {
    Custom_Noti_Sub_Room_LoveModel_Sec_SrceenMsg = 731, // 开始公屏消息
    Custom_Noti_Sub_Room_LoveModel_Sec_Anmintions = 732, // 动画
    Custom_Noti_Sub_Room_LoveModel_Sec_DownMicToast = 733,  // 下麦提醒
    Custom_Noti_Sub_Room_LoveModel_Sec_SuccessMsg = 734,   // 成功消息
    Custom_Noti_Sub_Room_LoveModel_Sec_PublicLoveEffect = 735,   // 公布心动特效
};

typedef NS_ENUM(NSInteger, Custom_Noti_Sub_NameplateNoti) {
    Custom_Noti_Sub_NameplateNoti_RoomUpdate = 701, //铭牌修改房间更新信息
};

typedef NS_ENUM(NSInteger, Custom_Noti_Sub_Feedback) {
    Custom_Noti_Sub_Feedback_Msg = 631, //举报反馈
};

typedef NS_ENUM(NSInteger, Custom_Noti_Sub_Broadcast) {//原名Custom_Noti_Sub_NotifyGiftType
    Custom_Noti_Sub_Broadcast_Nameplate = 622, //全服铭牌通知(原名Custom_Noti_Sub_NotifyNamePlateType_Full）
    Custom_Noti_Sub_Broadcast_Annual = 623, //全服年度通知
};


typedef NS_ENUM(NSInteger, Custom_Noti_Sub_Red) {
    Custom_Noti_Sub_Red_Room_Current = 591, //当前房间红包
    Custom_Noti_Sub_Red_Room_Other = 592, //其他房间红包
    Custom_Noti_Sub_Red_Room_Draw = 593, //抢到红包
    Custom_Noti_Sub_Red_Authority_All = 594, //全局红包权限开关通知
    Custom_Noti_Sub_Red_Authority_Specific = 595, //指定房间红包权限开关通知
};

typedef NS_ENUM(NSInteger, Custom_Noti_Sub_Common_System_Notification) {
    Custom_Noti_Sub_Common_System_Notification_FirstRecharge = 581, //安卓首充使用(iOS 不用)
};

typedef NS_ENUM(NSInteger, Custom_Noti_Sub_OfficialAnchorCertification) {
    Custom_Noti_Sub_OfficialAnchorCertification_Content = 571, //文本
    Custom_Noti_Sub_OfficialAnchorCertification_Bussiness = 572, //业务
};

typedef NS_ENUM(NSInteger, Custom_Noti_Sub_RoomPublicScreen) {
    Custom_Noti_Sub_RoomPublicScreen_greeting = 561, //进房欢迎语
};

typedef NS_ENUM(NSUInteger, Custom_Noti_Sub_RoomActivityHot) {
    Custom_Noti_Sub_RoomActivityCountDownTime = 531, // 倒计时
};

typedef NS_ENUM(NSUInteger, Custom_Noti_Sub_Dynamic) {
    Custom_Noti_Sub_Dynamic_Unread_Update = 521, // 未读更新
    Custom_Noti_Sub_Dynamic_Ban_Delete = 522, // 违禁删除
    Custom_Noti_Sub_Dynamic_Approved = 523, // 动态审核通过
    Custom_Noti_Sub_Dynamic_ShareDynamic = 524, // app内分享动态
};

typedef NS_ENUM(NSUInteger, Custom_Noti_Sub_Room_LittleWorld) {
    Custom_Noti_Sub_Room_LittleWorldQuit = 511, // 离开小世界
};

typedef enum {
    Custom_Noti_Sub_Room_SuperAdmin_unLimmit = 501, // 解除房间限制
    Custom_Noti_Sub_Room_SuperAdmin_unLock = 502, //  解除房间上锁
    Custom_Noti_Sub_Room_SuperAdmin_LockMic = 503,//  锁麦
    Custom_Noti_Sub_Room_SuperAdmin_noVoiceMic = 504,//  闭麦
    Custom_Noti_Sub_Room_SuperAdmin_DownMic = 505,  //  下麦
    Custom_Noti_Sub_Room_SuperAdmin_Shield = 506,//  拉黑
    Custom_Noti_Sub_Room_SuperAdmin_TickRoom = 507,//  踢出房间
     Custom_Noti_Sub_Room_SuperAdmin_TickManagerRoom = 508,// 踢管理员出房间
    Custom_Noti_Sub_Room_SuperAdmin_CloseChat = 509,// 关闭公屏
    Custom_Noti_Sub_Room_SuperAdmin_CloseRoom = 510//关闭房间
}Custom_Noti_Sub_Room_SuperAdmin;


typedef NS_ENUM(NSUInteger, Custom_Noti_Sub_Room_TeenagerMode) {
    Custom_Noti_Sub_Room_TeenagerMode_OnLineTimesMax = 481, // 青少年房间在线时长达到上限
};

typedef NS_ENUM(NSUInteger, Custom_Noti_Sub_Segment_AllMicSend) {
    
    Custom_Noti_Sub_Segment_AllMicSend_LuckBag = 471, // 拆分消息全麦送全麦送福袋
    
};

typedef NS_ENUM(NSUInteger, Custom_Noti_Sub_Little_World) {
    Custom_Noti_Sub_Little_World_Member_Count = 461,//小世界群聊当前派对人数
    Custom_Noti_Sub_Little_World_Group_Topic = 462,//小世界群聊话题
    Custom_Noti_Sub_Little_World_Room_Notify = 463,//小世界群聊派对通知
    Custom_Noti_Sub_Little_World_Room_Lead_Notify = 464,//  引导加入小世界派对 只是自己显示
    Custom_Noti_Sub_Little_World_Room_Join_Notify = 465,//  加入小世界群聊派对通知
    Custom_Noti_Sub_Little_World_Room_Praise_Notify = 466,//  关注房主消息

};

typedef NS_ENUM(NSUInteger, Custom_Noti_Sub_Voice_Bottle) {
    Custom_Noti_Sub_Voice_Bottle_Hello = 451, // 打招呼
    Custom_Noti_Sub_Voice_Bottle_Recording = 452, // 去我的声音
    Custom_Noti_Sub_Voice_Bottle_Matching = 453, // 匹配
    Custom_Noti_Sub_Voice_Bottle_Heart = 454, // 声音瓶子爱心
};

typedef NS_ENUM(NSUInteger, Custom_Noti_Sub_Room_LeaveMode) {
    Custom_Noti_Sub_Room_LeaveMode_Notice = 431, // 给其他客户端发送房主信息
};

typedef NS_ENUM(NSUInteger, Custom_Noti_Sub_GiftValue) {// 礼物值
    Custom_Noti_Sub_GiftValue_sync = 421,//房间礼物值同步
};

typedef NS_ENUM(NSUInteger, Custom_Noti_Sub_Checkin) {// 签到
    Custom_Noti_Sub_Checkin_Notice = 411,//签到提醒
    Custom_Noti_Sub_Checkin_Draw_second_coin = 412,//二级瓜分金币（所有房间公屏通知）
    Custom_Noti_Sub_Checkin_Draw_third_coin = 413,//三级瓜分金币（全服小秘书通知）
};

typedef enum{
    Custom_Noti_Header_AboutMe_LikeATComment = 391,//（点赞。@。评论）
}CustomNotificationHeaderAboutMe;

typedef enum{
    Custom_Noti_Header_SystemNoti_Communit = 381,//社区  推送
    Custom_Noti_Header_SystemNoti_Topic = 382,// 话题
    Custom_Noti_Header_SystemNoti_H5 = 383,// H5
}CustomNotificationHeaderSystemNoti;


typedef enum {  //  公聊 取消游戏 和 接受游戏
    Custom_Noti_Sub_CPGAME_PublicChat_Respond_Accept = 371, // 接受游戏
    Custom_Noti_Sub_CPGAME_PublicChat_Respond_Cancel = 372, // 取消游戏
}Custom_Noti_Sub_CPGAME_PublicChat_Respond;


typedef enum {  //  私聊取消游戏 和游戏结束
    Custom_Noti_Sub_CPGAME_PrivateChat_SysNoti_CancelGame = 361,//取消游戏
    Custom_Noti_Sub_CPGAME_PrivateChat_SysNoti_GameOver = 362,//游戏结束
    Custom_Noti_Sub_CPGAME_PrivateChat_SysNoti_AnchorOrderTips = 363,//主播订单提醒
}Custom_Noti_Sub_CPGAME_PrivateChat_SystemNotification;

typedef enum {  //  私聊发起游戏
    Custom_Noti_Sub_CPGAME_PrivateChat_LaunchGame = 351,//确认选择游戏
}Custom_Noti_Sub_CPGAME_PrivateChat;

typedef enum {  //  私聊话匣子游戏
    Custom_Noti_Sub_PrivateChat_Chatterbox_launchGame = 441,// 发起游戏
    Custom_Noti_Sub_PrivateChat_Chatterbox_throwPoint = 442,  // 抛点数
      Custom_Noti_Sub_PrivateChat_Chatterbox_Init = 443,  //打招呼
}Custom_Noti_Sub_PrivateChat_Chatterbox;

typedef enum{
    Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Master = 341,//师傅收到的任务1
    Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Apprentice = 342,//徒弟收到的任务1
    Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Tips= 343,//徒弟完成任务-的提示提示
    Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Two_Master = 344,//师傅收到的任务2
    Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Two_Apprentice = 345,//徒弟收到的任务2
    Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Master = 346,//师傅收到的任务3
    Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Three_Apprentice= 347,//徒弟收到的任务3
    Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Four_Master = 348,//师傅收到的任务4
    Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Four_Apprentice = 349,//徒弟收到的任务4
    Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Result = 3410,//收徒结果
    Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_One_Master_Tips = 3411,//师父完成任务一的提示消息
    Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Fail_Tips = 3412, //任务失败的提示
    Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Invite = 3413, //分享房间给徒弟
    Custom_Noti_Header_Sub_Mentoring_RelationShip_Mission_Grab = 3414, //推送了可抢徒弟的消息
}CustomNotificationMentoringRelationShip;



typedef enum {  //  CP房 游戏模式
    Custom_Noti_Sub_CPGAME_Select = 331,//确认选择游戏
    Custom_Noti_Sub_CPGAME_Prepare = 332,// 接受邀请
    Custom_Noti_Sub_CPGAME_Start = 333,//游戏开始
    Custom_Noti_Sub_CPGAME_End = 334,//游戏结束
    Custom_Noti_Sub_CPGAME_Cancel_Prepare = 335,// 取消准备或拒绝
    Custom_Noti_Sub_CPGAME_Open = 336,// 打开游戏模式
    Custom_Noti_Sub_CPGAME_Close = 337,// 关闭游戏模式
    Custom_Noti_Sub_CPGAME_Ai_Enter = 338, // Ai 进入房间
    Custom_Noti_Sub_CPGAME_RoomGame = 339, // 房间内的游戏
}Custom_Noti_Sub_CPGAME;


typedef NS_ENUM(NSUInteger, Custom_Noti_Sub_HALL) {
    Custom_Noti_Sub_HALL_APPLY_JOIN = 321,//申请加入厅
    Custom_Noti_Sub_HALL_MANAGER_INVITE = 322,//管理邀请入厅
    Custom_Noti_Sub_HALL_APPLY_EXIT = 323,//申请退出厅
    Custom_Noti_Sub_HALL_NOTICE = 324,//模厅普通通知
    Custom_Noti_Sub_HALL_BECOME_CHIEF = 325,//成为厅主通知
};


typedef enum{
    Custom_Noti_Header_Room_PK_Non_Empty = 311,//从无人报名pk排麦到有人报名pk排麦
    Custom_Noti_Header_Room_PK_Empty = 312,//从有人报名pk排麦到无人报名pk排麦
    Custom_Noti_Header_Room_PK_Mode_Open = 313,//创建了pk模式
    Custom_Noti_Header_Room_PK_Mode_Close = 314,//关闭pk模式
    Custom_Noti_Header_Room_PK_Start = 315,//pk开始
    Custom_Noti_Header_Room_PK_Result = 316,//pk结果
    Custom_Noti_Header_Room_PK_Re_Start= 317,//重新开始
    Custom_Noti_Header_Room_PK_Manager_Up_Mic = 318,//管理员邀请上麦(只用在客户端)
}CustomNotificationRoomPK;

typedef enum {
    Custom_Noti_Header_ArrangeMic_Non_Empty= 301,//队列从无人排麦到有人排麦
    Custom_Noti_Header_ArrangeMic_Empty= 302,//队列从有人排麦到无人排麦
    Custom_Noti_Header_ArrangeMic_Mode_Open= 303,//开启排麦
    Custom_Noti_Header_ArrangeMic_Mode_Close= 304,//关闭排麦
    Custom_Noti_Header_ArrangeMic_Free_Mic_Open= 305,//将坑位设置成自由麦
    Custom_Noti_Header_ArrangeMic_Free_Mic_Close= 306,//将坑位设置为排麦
    Custom_Noti_Header_ArrangeMic_Up_Mic = 307,//管理员报上麦
}CustomNotiHeaderArrangeMic;

typedef enum {
    Custom_Noti_Header_CoupleMessage = 291, //组CP消息
}Custom_Noti_Header_Couple;


typedef enum {
    Custom_Noti_Sub_PublicChatroom_Send_Gift = 281, //公聊大厅礼物
    Custom_Noti_Sub_PublicChatroom_Send_At = 282,   //公聊大厅@人
    Custom_Noti_Sub_PublicChatroom_Send_Broadcast = 283,//霸屏（预留字段）
    Custom_Noti_Sub_PublicChatroom_Send_Private_At = 284,//私聊@通知
}Custom_Noti_Sub_PublicChatroom;

typedef enum {
    Custom_Noti_Sub_KTV_SwitchMode = 270,//KTV 与 正常模式切换 模式 用于本地
    Custom_Noti_Sub_KTV_SelectedMV = 271,//点MV
    Custom_Noti_Sub_KTV_DeleteUserMV = 272,//删除 单用户单曲MV
    Custom_Noti_Sub_KTV_DeleteUserALLMV = 273,//删除 单用户全部MV
    Custom_Noti_Sub_KTV_SwitchFinishMV = 274,//切MV 演唱完成 服务端发
    Custom_Noti_Sub_KTV_PopMV = 275,//置顶MV
    Custom_Noti_Sub_KTV_FinishMV = 276,//房间MV播放 完   服务端发
    Custom_Noti_Sub_KTV_StopMV = 277,//暂停 MV
    Custom_Noti_Sub_KTV_ContinueMV = 278,//继续播放 MV
    Custom_Noti_Sub_KTV_SwitchMV = 279,//切MV 演唱中途切换
    Custom_Noti_Sub_KTV_FinishSingleMV = 2710,//MV单曲播放完成
    Custom_Noti_Sub_KTV_Close = 2711,//房间关闭KTV
    Custom_Noti_Sub_KTV_Open = 2712,//房间开启KTV
    
}CustomNotificationSubKTV;

typedef enum {
    Custom_Noti_Sub_Box_Me = 261,//自己可见  一级礼物(最小)
    Custom_Noti_Sub_Box_InRoom = 262,//当前房间可见  二级礼物
    Custom_Noti_Sub_Box_AllRoom = 263,//所有房间可见  三级礼物
    Custom_Noti_Sub_Box_AllRoom_Notify = 264,//所有房间可见+小秘书  四级礼物(最大)
    Custom_Noti_Sub_Box_InRoom_NeedAllMicSend = 265,//开箱子开到全麦送 （服务端发）
    Custom_Noti_Sub_Box_InRoom_AllMicSend = 266,//开箱子全麦送 （开箱子本人发)
    
    Custom_Noti_Sub_Box_OpenBoxCirt_Start = 267,//开箱子暴击开始
    Custom_Noti_Sub_Box_OpenBoxCirt_END = 268,//开箱子暴击时间结束
    Custom_Noti_Sub_Box_OpenBoxCirt_Win = 269,//开箱子出暴击
    
}CustomNotificationSubBox;

typedef enum {
    Custom_Noti_Sub_Dragon_Start = 251,//开始龙珠游戏（本局龙珠开始）
    Custom_Noti_Sub_Dragon_Finish = 252,//展示龙珠（本局龙珠结束）
    Custom_Noti_Sub_Dragon_Cancel = 253,//放弃龙珠游戏 弃牌
    Custom_Noti_Sub_Dragon_Continue = 254,//继续上次游戏
    
}CustomNotificationDragon;



typedef enum {
    Custom_Noti_Sub_User_UpGrade_ExperLevelSeq = 241,//用户等级
    Custom_Noti_Sub_User_UpGrade_CharmLevelSeq = 242,//魅力等级
} CustomNotificationSubUserUpGrade;

typedef enum {
    Custom_Noti_Sub_Header_Message_Handle_Content = 231, //文本
    Custom_Noti_Sub_Header_Message_Handle_Bussiness = 232, //业务
}Custom_Noti_Sub_Header_Message_Handle;

typedef enum {
    
    Custom_Noti_Sub_Share_Room = 221, //房间
    Custom_Noti_Sub_Share_Family = 222, //家族
    Custom_Noti_Sub_Share_Group = 223, //群组
    Custom_Noti_Sub_Share_Commnunity = 224, //社区
    Custom_Noti_Sub_Share_LittleWorld = 225, //小世界
} CustomNotificationSubShare;


typedef enum {
    Custom_Noti_Sub_Header_Group_RedPacket_Send = 211, //发送xcRedColor
    Custom_Noti_Sub_Header_Group_RedPacket_Tips = 212, //抢xcRedColor提示
}Custom_Noti_Sub_Header_Group_RedPacket;


typedef enum {
    Custom_Noti_Sub_Update_RoomInfo_AnimateEffect = 201, //动画开关状态更新
    Custom_Noti_Sub_Update_RoomInfo_AgoraAudioQuity = 202, //声网音质更新
    Custom_Noti_Sub_Update_RoomInfo_MessageState = 203, //公屏开关更新
    Custom_Noti_Sub_Update_RoomInfo_Notice = 204, //通用公屏提示文案, 公屏纯文本展示消息 data[@"tip"]
} CustomNotificationSubUpdateRoomInfo;

typedef enum {
    CustomNotification_Secretary_Universal_Interactive = 191, //转跳页面
}CustomNotification_Secretary_Universal;


typedef enum {
    Custom_Noti_Sub_Kick_BlackList = 182, //拉黑
    Custom_Noti_Sub_Kick_BeKicked = 181, //踢出房间
} CustomNotificationSubKick;

typedef enum {
    Custom_Noti_Sub_Game_Start = 171,//游戏开始
    Custom_Noti_Sub_Game_End = 172, //游戏结束
    Custom_Noti_Sub_Game_Result = 173, //游戏结果
    Custom_Noti_Sub_Game_Attack = 174, //攻击
}CustomNotificationSubGame;


typedef enum {
    Custom_Noti_Sub_Magic_Send = 161,//释魔法
    Custom_Noti_Sub_AllMicro_MagicSend = 162, //全麦释魔法
    Custom_Noti_Sub_Batch_MagicSend = 163, // 非全麦 多人释魔法
} CustomNotificationSubRoomMagic;

typedef enum {
    Custom_Noti_Sub_Car_OutDate = 151, //汽车过期
    Custom_Noti_Sub_Car_EnterRoom = 159, //进房动画
} CustomNotificationSubCar;


typedef enum  {
    Custom_Noti_Sub_NobleNotify_Welocome = 141, //欢迎通知，客户端发
    Custom_Noti_Sub_NobleNotify_Open_Success = 142, //开通成功
    Custom_Noti_Sub_NobleNotify_Renew_Success = 143, //续费成功
    Custom_Noti_Sub_NobleNotify_Almost_OutDate = 144, //快到期
    Custom_Noti_Sub_NobleNotify_Already_OutDate = 145, //已经到期
    Custom_Noti_Sub_NobleNotify_GoodNum_OK = 146, //靓号生效
    Custom_Noti_Sub_NobleNotify_GoodNum_NotOK = 147, //靓号没生效
    Custom_Noti_Sub_NobleNotify_BoardCastBonus = 148, //贵族主播xcShare
    Custom_Noti_Sub_NobleNotify_Recom_room = 149, //推荐房间
} CutomRoomSubNobleNotify;


typedef enum {
    Custom_Noti_Sub_Turntable = 131, //转盘推送
}CustomNotificationSubTurntable;

typedef enum {
    Custom_Noti_Sub_AllMicroSend = 121, //全麦送礼物
    Custom_Noti_Sub_AllMicroLuckySend = 122, //全麦送  福袋 礼物
    Custom_Noti_Sub_AllBatchSend = 123, // 非全麦 多人送礼
}CustomNotificationSubAllMicroSend;


typedef enum {
    Custom_Noti_Sub_NewRedPacket = 111, //xcRedColor
}CustomNotificationRedPacket;


typedef enum {
    Custom_Noti_Sub_News = 101,//推文消息
}CustomNotificationSubNews;


typedef enum {
    Custom_Noti_Sub_Face_Send = 91, //表情
}CustomNotificationSubFace;

typedef enum {
    Custom_Noti_Sub_Queue_Invite = 81,//邀请上麦
    Custom_Noti_Sub_Queue_Kick = 82, //踢下麦
}CustomNotificationSubQueue;


typedef enum {
    Custom_Noti_Sub_Online_alert = 61, //主播上线
}CustomNotificationSubOnline;


typedef enum {
    Custom_Noti_Sub_Account_Changed = 51,//账户余额金币变更
}CustomNotificationSubAccount;


typedef enum {
    Custom_Noti_Sub_Micro_Invite = 411,//房主邀请上麦
    Custom_Noti_Sub_Micro_Accept = 412,//用户同意上麦
    Custom_Noti_Sub_Micro_OwnerKickUser = 413,//房主踢用户下麦
    Custom_Noti_Sub_Micro_UserLeft = 415,//麦序更新
}CustomNotificationSubMicro;

typedef enum {
    Custom_Noti_Sub_Gift_Send = 31,//发送礼物
    Custom_Noti_Sub_Gift_ChannelNotify = 32,//全服发送礼物
    Custom_Noti_Sub_Gift_LuckySend = 33,//发送 福袋 礼物
}CustomNotificationSubGift;

typedef enum {
    Custom_Noti_Header_Room_Tip_ShareRoom = 21, //分享房间
    Custom_Noti_Header_Room_Tip_Attentent_Owner = 22, //关注房主
}CutomRoomSubTip;


typedef enum {
    Custom_Noti_Sub_Auction_Start = 11,//开始拍卖
    Custom_Noti_Sub_Auction_Finish = 12,//结束拍卖
    Custom_Noti_Sub_Auction_Update = 13,//拍卖列表更新
    Custom_Noti_Sub_Auction_Alert = 71, //拍卖完成并且提醒生成订单成功
}CustomNotificationSubAuction;




@interface Attachment : BaseObject<NIMCustomAttachment>
@property (nonatomic,assign) int first;
@property (nonatomic,assign) int second;
@property (nonatomic, strong) id data;

@end


