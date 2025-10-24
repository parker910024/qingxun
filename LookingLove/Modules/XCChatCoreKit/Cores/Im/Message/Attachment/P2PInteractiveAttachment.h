//
//  P2PInteractive.h
//  BberryCore
//
//  Created by 卫明何 on 2018/4/9.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "Attachment.h"
#import "XCCustomAttachmentInfo.h"

typedef enum : NSUInteger {
    P2PInteractive_SkipType_Room        = 1,      //房间页 传参：uid
    P2PInteractive_SkipType_H5          = 2,      //H5
    P2PInteractive_SkipType_Purse       = 3,      //钱包页
    P2PInteractive_SkipType_Red         = 4,      //xcRedColor
    P2PInteractive_SkipType_Recharge    = 5,      //充值页
    P2PInteractive_SkipType_Person      = 6,      //个人页 传参：uid
    P2PInteractive_SkipType_Car         = 7,      //座驾 传参：0（装扮商城） 或者 1（车库）
    P2PInteractive_SkipType_Headwear     = 8,      //头饰 传参：0（装扮商城） 或者 1（头饰库）

    P2PInteractive_SkipType_SystemMessage  = 9,    //系统消息
    P2PInteractive_SkipType_Family     = 10,      //家族
    P2PInteractive_SkipType_Group     = 11,      //群组
    P2PInteractive_SkipType_Background     = 12,      //背景 传参：0（装扮商城） 或者 1（背景库）
    //哈哈使用 新秀玩友
    P2PInteractive_SkipType_New_User     = 13,      //新秀玩友
    P2PInteractive_SkipType_Invite_Friend    = 14,      //邀请好友
    P2PInteractive_SkipType_PublicChat =15,         //公聊大厅
    P2PInteractive_SkipType_BindingXCZAccount = 16, // 绑定 zxc 账号
    P2PInteractive_SkipType_BindingPhoneNum = 17,  // 绑定手机号
    P2PInteractive_SkipType_SettingPayPwd = 18,     // 设置支付密码
    P2PInteractive_SkipType_WithdrawBillList = 19, // 跳转账单记录
    //萌声 推荐位
    P2PInteractive_SkipType_Recommend = 20, // 我的推荐位
    //
    P2PInteractive_SkipType_Box = 21, // 开箱子
    
    //兔兔-公会
    P2PInteractive_SkipType_Guild_Hall = 22, // 模厅消息
    
    P2PInteractive_SkipType_Community_Share = 23, // 萌声 社区引用内分享 消息
    P2PInteractive_SkipType_Community_Page = 24, // 萌声 社区 作品e内页
    P2PInteractive_SkipType_Topic= 25, // 萌声 话题 消息

    P2PInteractive_SkipType_Checkin = 26, // 签到
    P2PInteractive_SkipType_Mission = 27, // 任务
    P2PInteractive_SkipType_GameTab = 29, // 游戏主页
    P2PInteractive_SkipType_Mentoring_Ship= 28, //跳到师徒主页
    P2PInteractive_SkipType_UpLoad_UserIcon = 30, // 跳转到上传头像页面
    P2PInteractive_SkipType_UpLoad_MyVoice = 41, // 跳转到我的声音列表
    P2PInteractive_SkipType_UpLoad_VoiceMatching = 42, // 跳转到声音匹配
    P2PInteractive_SkipType_HeartbeatMatch = 43, // 跳转到心动匹配
    P2PInteractive_SkipType_ChatParty = 44, // 嗨聊派对
    P2PInteractive_SkipType_CityMatch = 45, // 城市匹配
    P2PInteractive_SkipType_GameMatch = 46, // 游戏匹配
    P2PInteractive_SkipType_LittleWorld = 47, // 小世界
    P2PInteractive_SkipType_Test = 48, // 测一测
    P2PInteractive_SkipType_LittleWorldGuestPage = 49, // 小世界客态页
    P2PInteractive_SkipType_CustomMessageDynamicDetail = 50, // 小世界动态详情(自定义消息里本地使用的, 用于跳转小世界详情)
    P2PInteractive_SkipType_LittleWorldPostDynamic = 51, // 发布动态页
    P2PInteractive_SkipType_FeedbackPage = 52, // 意见反馈页面
    P2PInteractive_SkipType_Nameplate = 53, // 铭牌
    P2PInteractive_SkipType_SecretaryJumpChat = 54, // 小秘书消息点击跳转到和某某私聊
} P2PInteractive_SkipType;

@interface P2PInteractiveAttachment : Attachment <NIMCustomAttachment,XCCustomAttachmentInfo>
@property (nonatomic,strong) NSString                   *msg;
@property (nonatomic,assign) P2PInteractive_SkipType    routerType;
@property (nonatomic,strong) NSString                   *routerValue; //(转跳当前界面需要传的参)
@property (nonatomic,strong) NSString                   *title;//显示标题
@end
