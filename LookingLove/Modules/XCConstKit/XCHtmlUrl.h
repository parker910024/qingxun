//
//  XCHtmlUrl.h
//  XC_HHMessageMoudle
//
//  Created by gzlx on 2018/8/30.
//  Copyright © 2018年 fengshuo. All rights reserved.
//

#ifndef XCHtmlUrl_h
#define XCHtmlUrl_h

#import "XCMacros.h"

typedef NS_ENUM(NSUInteger,UrlType){
    kImageDomainURL, //7N,
    kOfficialURL, //官网
    kPrivacyURL,// 隐私政策
    kRankURL, //萌声排行榜
    kBoxRankURL,//箱子排行榜
    kWebOauthLoginURL, //web授权登录页面
    //-----贵族
    kNobilityIntroURL,//贵族介绍
    lNobilityAuthorityURL,//贵族特权
    kNobilitySuccessURL, // 贵族成功
    kNobilityQuestionURL, // 贵族币说明
    kNobilityOpenNobleURL,//开通贵族
    kNobilityGoodNumURL,//靓号问题
    //-------发现--------
    kInvitationDetailURL, //邀请人数详情
    kRevenueDetailURL, // xcShare详情
    kInvitationRankURL, //萌声邀请排行榜
    kInviteFightRuleURL, //邀请大作战规则
    kInvitationCheatsURL,//奖励秘籍
    kTurntableURL,  //draw转盘
    kPickYourLove,  //选择你爱的主播
    kGiftRankList,//礼物周星榜
    kFamilyMoneyRule,//家族币问题
    kFamilyGuide,
    kFamilyCreate,
    kShareFamilyURL,//分享家族链接
    kInviteFriendURL,//邀请好友来玩app
    kCheckinRuleURL,//签到规则
    
    //-------我的页面-------
    kLevelURL,//我的等级
    kCharmURL, //魅力等级
    kFAQURL,//常见问题
    kContactUsURL,//联系官方
    kUserProtocalURL, //用户协议
    kQQloginGuideURL, //qq引导
    kIdentityURL,//实人认证
    kSkillsURL, // 技能认证
    kNurseryURL, // 护苗计划
    kLogOutURL,//注销
    kWalletHelperURL,//钱包说明
    kOfficialAnchorCertificationURL,//官方主播认证
    kEnterRoomFailSolutionURL,//进房失败解决方案
    kAnchorCenterURL,//主播中心
    kAnchorLiveEndURL,//主播结束战绩url
    
    //-------首页游戏排行榜-------
    kGameRankURL,
    //--Recommend
    kRecommendHelpURL,//推荐位帮助
    kRecommendCardURL, // 推荐位仓库
    kCommunityRulesURL, //萌声 社区规范
    kRadishRuleURL, // 萝卜说明
    
    //-------purse-------
    kWithdrawURL , //xcGetCF规则
    kTuTuCodeRedURL , // TuTu OutPut xcCF url
    kZSOutputURL , //  OutPut xcCF url
    kCodeRedQuestionURL ,// xcCF 说明
    
    
    //-------个人中心-------
    kGuradRankURL,//守护榜
    
    //------公聊------
    kReportURL,//举报
    kFaceWallURL,//面壁墙
    kHeadLineURL,//头条
    kPublicChatHelpURL,//公聊帮助
    
    //------房间------
    kRoomSettingsBackgrondURL,//房间背景设置
    
    // ------师徒------
    kMasterRankingURL, // 名师榜
    kMasterStrategyURL, // 师徒攻略
    
    //vkiss
    kActivityURL,//活动页领取
    kActivity520URL,//520活动页领取
    kBuyProtocalURL,//购买协议
    
    // 小世界
    kLittleWorldDescriptionURL, // 小世界说明
    kLittleWorldDynamicShareURL, // 分享小世界动态
    
    //播放器
    kPlayerCopyrightURL,//播放器作品版权
    
    kAnchorOrderRuleURL,//主播订单规则
    
    kRedRuleURL,//房间红包帮助说明
    kRedRecordURL,//红包记录
    
    //直播预告规则
    kAnchorNoticeURL,
    
    //粉丝勋章规则
    kRoomMedalRuleURL,
    //主播粉丝榜
    kRoomAnchorFansURL,
    
    //我的工会
    kRoomCompanyAnchorURL,
    //申请加入
    kRoomJoinCompanyAnchorURL,
    kLoveRoomRule, // 相亲房规则
    kLive800,
};

static force_inline NSString *HtmlUrlKey(UrlType type){
    NSDictionary * dic = @{
                           @"轻寻":@{@(kImageDomainURL) : @"https://img.letusmix.com", //7N
                               @(kOfficialURL): @"ms/activity/msInvite/download.html" ,//官网
                               @(kPrivacyURL) : @"modules/rule/privacy-wap.html",//隐私政策
                               @(kInvitationDetailURL) : @"modules/bonus/invitation.html",//邀请人数详情
                               @(kRevenueDetailURL): @"modules/bonus/revenue.html",// xcShare详情
                               @(kInvitationRankURL):@"modules/bonus/rankList.html",//邀请排行榜
                               @(kInviteFightRuleURL): @"modules/bonus/fight.html",//邀请大作战规则
                               @(kInvitationCheatsURL): @"modules/bonus/secret.html",//奖励秘籍
                               @(kTurntableURL): @"activity/double12/index.html", //draw
                               @(kPickYourLove): @"activity/vote/pick.html", //选择喜欢的主播
                               @(kRankURL): @"modules/rank/index.html",//tutu排行榜
                               @(kWebOauthLoginURL): @"modules/login/login.html",//web授权登录页面
                               //---贵族
                               @(kNobilityIntroURL):@"modules/nobles/intro.html",//贵族介绍
                               @(lNobilityAuthorityURL):@"modules/nobles/homepage.html",//贵族特权
                               @(kNobilitySuccessURL):@"modules/nobles/paySuccess.html", // 贵族成功
                               @(kNobilityQuestionURL):@"modules/nobles/faq.html?quesIndex=4", // 贵族币说明
                               @(kNobilityOpenNobleURL):@"modules/nobles/order.html",//开通贵族
                               @(kNobilityGoodNumURL):@"modules/nobles/numApply.html",//靓号的问题
                               
                               //------发现页面-------
                               @(kCheckinRuleURL) : @"modules/rule/rule-popup.html", // 签到说明
                               
                               //-------我的页面-------
                               @(kLogOutURL):@"modules/logout-account/index.html",//注销
                               @(kLevelURL) : @"modules/level/my-level.html?type=user",//我的等级
                               @(kCharmURL) : @"modules/level/my-level.html?type=charm",//魅力等级
                               @(kFAQURL) : @"modules/guide/guide.html",//常见问题
                               @(kContactUsURL) : @"modules/contact/contact.html",//联系官方
                               @(kUserProtocalURL) : @"modules/guide/protocol.html", //用户协议
                               @(kQQloginGuideURL) : @"modules/rule/login_tips.html", //qq引导
                               @(kIdentityURL):@"modules/identity/new.html",//实人认证
                               @(kSkillsURL):@"activity/tutu101-2/index.html",// 技能认证
                               @(kNurseryURL):@"modules/rule/adult.html", // 护苗计划
                               @(kCommunityRulesURL):@"modules/rule/community-norms.html",//社区画规范
                               @(kRecommendCardURL):@"modules/recommend-card/index.html",  // 推荐位仓库 H5
                               @(kRecommendHelpURL):@"modules/recommend-card/help.html",    // 推荐位帮助
                               @(kRadishRuleURL) : @"modules/rule/radish.html", // 萝卜说明
                               @(kOfficialAnchorCertificationURL) : @"modules/certification/index.html", // 官方主播认证

                               //-------首页游戏排行榜-------
                               @(kGameRankURL) : @"modules/erbanRank/game_rank.html?type=week", // 排行榜
                               //----------家族------------
                               @(kFamilyMoneyRule) : @"modules/family/faq.html",//家族币的页面
                               @(kFamilyCreate) : @"modules/family/create.html",//创建家族
                               @(kFamilyGuide) : @"modules/family/handbook.html",//家族指南
                               @(kShareFamilyURL) : @"modules/share/share_family.html",//分享家族链接
                               //-------purse-------
                               @(kWithdrawURL) : @"ms/modules/rules/withdraw.html", //xcGetCF规则
                               @(kTuTuCodeRedURL) : @"modules/output/index.html", // xcCF 链接
                               @(kCodeRedQuestionURL) : @"modules/guide/output.html", // xcCF 说明
                               //-------个人中心-------
                               @(kGuradRankURL) : @"ms/modules/guardRank/index.html",//守护榜
                               //------公聊-------//
                               @(kReportURL)    : @"modules/inform/index.html",//举报
                               @(kHeadLineURL)  : @"modules/headNews/index.html",//头条
                               @(kFaceWallURL)  : @"modules/inform/inform-list.html",//面壁墙
                               @(kPublicChatHelpURL) : @"modules/inform/help.html",//公聊
                               //------房间------
                               @(kRoomSettingsBackgrondURL): @"modules/nobles/roomBgList.html",//房间背景
                               //------师徒------
                               @(kMasterRankingURL): @"modules/strategy/teacher-list.html",//名师榜
                               @(kMasterStrategyURL): @"modules/strategy/strategy.html",//师徒攻略
                               @(kLittleWorldDescriptionURL):@"modules/world-rule/index.html", // 小世界说明
                               @(kLittleWorldDynamicShareURL):@"/modules/world/share-page/index.html", // 小世界动态分享
                               @(kAnchorOrderRuleURL):@"modules/rule/rule-instruction.html", // 主播订单规则
                               @(kRedRuleURL):@"modules/guide/envelope.html", // 房间红包帮助说明
                               @(kRedRecordURL):@"modules/envelope/index.html", // 红包记录
                               @(kLoveRoomRule) : @"modules/guide/xq-introduction.html",
                               @(kLive800):@"modules/user-service/index.html",  //live800客服
                               },
                           @"默默":@{@(kImageDomainURL) : @"https://img.letusmix.com", //7N
                                     @(kOfficialURL): @"ms/activity/msInvite/download.html" ,//官网
                                     @(kPrivacyURL) : @"modules/rule/privacy-wap.html",//隐私政策
                                     @(kInvitationDetailURL) : @"modules/bonus/invitation.html",//邀请人数详情
                                     @(kRevenueDetailURL): @"modules/bonus/revenue.html",// xcShare详情
                                     @(kInvitationRankURL):@"modules/bonus/rankList.html",//邀请排行榜
                                     @(kInviteFightRuleURL): @"modules/bonus/fight.html",//邀请大作战规则
                                     @(kInvitationCheatsURL): @"modules/bonus/secret.html",//奖励秘籍
                                     @(kTurntableURL): @"activity/double12/index.html", //draw
                                     @(kPickYourLove): @"activity/vote/pick.html", //选择喜欢的主播
                                     @(kRankURL): @"modules/rank/index.html",//tutu排行榜
                                     @(kWebOauthLoginURL): @"modules/login/login.html",//web授权登录页面
                                     //---贵族
                                     @(kNobilityIntroURL):@"modules/nobles/intro.html",//贵族介绍
                                     @(lNobilityAuthorityURL):@"modules/nobles/homepage.html",//贵族特权
                                     @(kNobilitySuccessURL):@"modules/nobles/paySuccess.html", // 贵族成功
                                     @(kNobilityQuestionURL):@"modules/nobles/faq.html?quesIndex=4", // 贵族币说明
                                     @(kNobilityOpenNobleURL):@"modules/nobles/order.html",//开通贵族
                                     @(kNobilityGoodNumURL):@"modules/nobles/numApply.html",//靓号的问题
                                     
                                     //------发现页面-------
                                     @(kCheckinRuleURL) : @"modules/rule/rule-popup.html", // 签到说明
                                     
                                     //-------我的页面-------
                                     @(kLevelURL) : @"modules/level/my-level.html?type=user",//我的等级
                                     @(kCharmURL) : @"modules/level/my-level.html?type=charm",//魅力等级
                                     @(kFAQURL) : @"modules/guide/guide.html",//常见问题
                                     @(kContactUsURL) : @"modules/contact/contact.html",//联系官方
                                     @(kUserProtocalURL) : @"modules/guide/protocol.html", //用户协议
                                     @(kQQloginGuideURL) : @"modules/rule/login_tips.html", //qq引导
                                     @(kIdentityURL):@"modules/identity/new.html",//实人认证
                                     @(kSkillsURL):@"activity/tutu101-2/index.html",// 技能认证
                                     @(kNurseryURL):@"modules/rule/adult.html", // 护苗计划
                                     @(kCommunityRulesURL):@"modules/rule/community-norms.html",//社区画规范
                                     @(kRecommendCardURL):@"modules/recommend-card/index.html",  // 推荐位仓库 H5
                                     @(kRecommendHelpURL):@"modules/recommend-card/help.html",    // 推荐位帮助
                                     @(kRadishRuleURL) : @"modules/rule/radish.html", // 萝卜说明
                                     //-------首页游戏排行榜-------
                                     @(kGameRankURL) : @"modules/erbanRank/game_rank.html?type=week", // 排行榜
                                     //----------家族------------
                                     @(kFamilyMoneyRule) : @"modules/family/faq.html",//家族币的页面
                                     @(kFamilyCreate) : @"modules/family/create.html",//创建家族
                                     @(kFamilyGuide) : @"modules/family/handbook.html",//家族指南
                                     @(kShareFamilyURL) : @"modules/share/share_family.html",//分享家族链接
                                     //-------purse-------
                                     @(kWithdrawURL) : @"ms/modules/rules/withdraw.html", //xcGetCF规则
                                     @(kTuTuCodeRedURL) : @"modules/output/index.html", // xcCF 链接
                                     @(kCodeRedQuestionURL) : @"modules/guide/output.html", // xcCF 说明
                                     //-------个人中心-------
                                     @(kGuradRankURL) : @"ms/modules/guardRank/index.html",//守护榜
                                     //------公聊-------//
                                     @(kReportURL)    : @"modules/inform/index.html",//举报
                                     @(kHeadLineURL)  : @"modules/headNews/index.html",//头条
                                     @(kFaceWallURL)  : @"modules/inform/inform-list.html",//面壁墙
                                     @(kPublicChatHelpURL) : @"modules/inform/help.html",//公聊
                                     //------房间------
                                     @(kRoomSettingsBackgrondURL): @"modules/nobles/roomBgList.html",//房间背景
                                     //------师徒------
                                     @(kMasterRankingURL): @"modules/strategy/teacher-list.html",//名师榜
                                     @(kMasterStrategyURL): @"modules/strategy/strategy.html",//师徒攻略
                                     @(kLittleWorldDescriptionURL):@"modules/world-rule/index.html", // 小世界说明
                                     },
                            @"耳萌":@{@(kImageDomainURL) : @"https://img.kuaixiangwl.com", //7N
                                    @(kPrivacyURL) : @"modules/rule/privacy-wap.html",//隐私政策
                                    @(kRankURL): @"modules/erbanRank/index.html",//排行榜
                                    @(kWebOauthLoginURL): @"modules/login/login.html",//web授权登录页面
                                    @(kPickYourLove): @"activity/vote/pick.html", //选择喜欢的主播
                                    //-------我的页面-------
                                    @(kLevelURL) : @"modules/level/my-level.html?type=user",//我的等级
                                    @(kCharmURL) : @"modules/level/my-level.html?type=charm",//魅力等级
                                    @(kFAQURL) : @"modules/guide/guide.html",//常见问题
                                    @(kContactUsURL) : @"modules/contact/contact.html",//联系官方
                                    @(kUserProtocalURL) : @"modules/guide/protocol.html", //用户协议
                                    @(kIdentityURL):@"modules/identity/new.html",//实人认证
                                    @(kNurseryURL):@"modules/rule/adult.html", // 护苗计划
                                    @(kCommunityRulesURL):@"modules/rule/community-norms.html",//社区规范
                                    @(kReportURL)    : @"modules/inform/index.html",//举报
                                    @(kTuTuCodeRedURL) : @"modules/output/index.html", // xcCF 链接
                                    @(kLogOutURL)   :@"modules/guide/loginout.html",//注销
                                    @(kWalletHelperURL):@"modules/rule/wallet-rule-ios.html",//钱包说明
                                    @(kEnterRoomFailSolutionURL):@"modules/solution/index.html",//进房失败解决方案
                                    @(kAnchorCenterURL):@"modules/anchor-center/index.html",//主播中心
                                    @(kAnchorLiveEndURL):@"modules/end-broadcast/index.html",//主播结束战绩url
                                    //------播放器-----
                                    @(kPlayerCopyrightURL):@"modules/appeal/index.html",//版权
                                    @(kAnchorNoticeURL) :@"modules/noticerule/index.html",
                                    @(kRoomMedalRuleURL):@"modules/medal/index.html",//勋章规则
                                    @(kRoomAnchorFansURL):@"modules/person-room-ranklist/index.html",
                                    @(kRoomCompanyAnchorURL):@"modules/guild-application/my-guild.html",
                                    @(kRoomJoinCompanyAnchorURL):@"modules/guild-application/index.html",
                                },
                           };
    NSDictionary *urlKeys = [dic objectForKey:MyAppName];
    return [urlKeys objectForKey:@(type)];
}

#endif /* XCHtmlUrl_h */

