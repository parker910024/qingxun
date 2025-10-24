//
//  TTStatisticsServiceEvents.h
//  TTPlay
//
//  Created by lvjunhang on 2019/1/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#ifndef TTStatisticsServiceEvents_h
#define TTStatisticsServiceEvents_h

//页面    页面名    按钮    事件名    类型    备注

#pragma mark - 首页
//家族tab    home_family_click    计数
static NSString *const TTStatisticsServiceEventFamilyTabClick = @"home_family_click";

#pragma mark - 家族
//家族    family    加入家族按钮    join_family_click    计数    家族主页
static NSString *const TTStatisticsServiceEventFamilyJoinClick = @"join_family_click";
//家族广场    family_familySquare_click    计数
static NSString *const TTStatisticsServiceEventFamilySquareClick = @"family_familySquare_click";
//我的家族    family_myFamily_click    计数    家族页
static NSString *const TTStatisticsServiceEventMyFamilyClick = @"family_myFamily_click";
//我的家族入口    my_family_click    计数    我的页
static NSString *const TTStatisticsServiceEventMyFamilyEntranceClick = @"my_family_click";

#pragma mark - 模厅
//我的厅入口    my_hall_click    计数
static NSString *const TTStatisticsServiceEventHallEntranceClick = @"my_hall_click";
//收入统计入口    hall_income_click    计数
static NSString *const TTStatisticsServiceEventIncomeDailyClick = @"hall_income_click";
//切换每周统计    hall_income_weekly_click    计数
static NSString *const TTStatisticsServiceEventIncomeWeeklyClick = @"hall_income_weekly_click";
//点击查看成员收入详细    hall_income_detail_click    计数
static NSString *const TTStatisticsServiceEventIncomeDetailClick = @"hall_income_detail_click";
//申请入厅按钮    join_hall_click    计数    厅主个人主页
static NSString *const TTStatisticsServiceEventJoinHallClick = @"join_hall_click";
//加入公开群按钮    join_hall_openGroup_click    计数    厅主个人主页
static NSString *const TTStatisticsServiceEventJoinOpenGroupClick = @"join_hall_openGroup_click";

#pragma mark - 房间
//厅管理入口    room_my_hall_click    计数
static NSString *const TTStatisticsServiceRoomHallManagerClick = @"room_my_hall_click";
//我要上推荐    room_recommend_click    计数
static NSString *const TTStatisticsServiceRoomGoRecommendClick = @"room_recommend_click";

///以下房间的埋点分为陪伴房和普通房
//分享房间    mp_room_share_click cp_room_share_click   计数
static NSString *const TTStatisticsServiceRoomShareClick = @"room_share_click";
//砸蛋入口    mp_room_smashEgg_click cp_room_smashEgg_click   计数
static NSString *const TTStatisticsServiceRoomSmashEggClick = @"room_smashEgg_click";
//房间榜    mp_room_rankingList_click cp_room_rankingList_click   计数
static NSString *const TTStatisticsServiceRoomRankingListClick = @"room_rankingList_click";
//音乐    mp_room_music_click cp_room_music_click  计数
static NSString *const TTStatisticsServiceRoomMusicClick = @"room_music_click";
//设置房间话题    mp_room_setTopic_click cp_room_setTopic_click    计数
static NSString *const TTStatisticsServiceRoomTopicClick = @"room_setTopic_click";
//关闭麦克风    mp_room_close_mic_click cp_room_close_mic_click    计数
static NSString *const TTStatisticsServiceRoomCloseMicClick = @"room_close_mic_click";
//关闭声音    mp_room_close_sound_click cp_room_close_sound_click   计数
static NSString *const TTStatisticsServiceRoomCloseSoundClick = @"room_close_sound_click";
//表情面板按钮    mp_room_emoticon_click cp_room_emoticon_click   计数
static NSString *const TTStatisticsServiceRoomEmojiClick = @"room_emoticon_click";
//更多面板按钮    mp_room_more_click cp_room_more_click    计数
static NSString *const TTStatisticsServiceRoomMoreClick = @"room_more_click";
//礼物面板按钮    mp_room_gift_click cp_room_gift_click   计数
static NSString *const TTStatisticsServiceRoomGiftClick = @"room_gift_click";
// 房间类型         room_list_type
static NSString *const TTStatisticsServiceRoomListType = @"room_list_type";
// 房间标签  room_list_label
static NSString *const TTStatisticsServiceRoomListLabel = @"room_list_label";
#pragma mark - 我的
//我的推荐位    my_recommend_click    计数
static NSString *const TTStatisticsServiceMyRecommendClick = @"my_recommend_click";

#pragma mark - H5推荐卡页
//使用推荐卡    h5_recommend_used    计数
static NSString *const TTStatisticsServiceH5RecommendUsedClick = @"h5_recommend_used";

#pragma mark - 厅管理
//添加成员-兔兔ID    hall_addMembers_userid_click    计数
static NSString *const TTStatisticsServiceHallAddMemberIDClick = @"hall_addMembers_userid_click";
//添加成员-微信导入    hall_addMembers_wx_click    计数
static NSString *const TTStatisticsServiceHallAddMemberWXClick = @"hall_addMembers_wx_click";
//添加成员-QQ导入    hall_addMembers_qq_click    计数
static NSString *const TTStatisticsServiceHallAddMemberQQClick = @"hall_addMembers_qq_click";
//分享暗号到微信    hall_password_share_wx    计数
static NSString *const TTStatisticsServiceHallShareMemberWXClick = @"hall_password_share_wx";
//分享暗号到QQ    hall_password_share_qq    计数
static NSString *const TTStatisticsServiceHallShareMemberQQClick = @"hall_password_share_qq";
//通过暗号加入厅    jion_hall_password_event    计数
static NSString *const TTStatisticsServiceHallJoinFromPwdClick = @"jion_hall_password_event";

#pragma mark - 公会三期数据埋点
//签到按钮-签到弹窗    popup_sign_in_click    计数
static NSString *const TTStatisticsServiceEventHomePopupSign = @"popup_sign_in_click";
//房间最小化关闭按钮    room_minimize_closed    计数
static NSString *const TTStatisticsServiceEventRoomMinimizeClosed = @"room_minimize_closed";

//签到-首页    game_homepage_sign_click    计数
static NSString *const TTStatisticsServiceEventHomeSign = @"game_homepage_sign_click";

//签到-发现页    find_sign_click    计数
static NSString *const TTStatisticsServiceEventFindSign = @"find_sign_click";

//任务中心    find_task_click    计数
static NSString *const TTStatisticsServiceEventFindTaskCenter = @"find_task_click";

//签到-分享    sign_share_click    计数
static NSString *const TTStatisticsServiceEventSignShare = @"sign_share_click";

//累计奖励-分享    sign_reward_share_click    计数
static NSString *const TTStatisticsServiceEventSignRewardShare = @"sign_reward_share_click";

//签到提醒开关    sign_remind_switch    计数    区分状态
static NSString *const TTStatisticsServiceEventSignRemindSwitch = @"sign_remind_switch";

//签到按钮-签到页    sign_in_click    计数
static NSString *const TTStatisticsServiceEventSignIn = @"sign_in_click";

//任务中心    task    去完成按钮    task_toFinsh_click    计数    区分任务
static NSString *const TTStatisticsServiceEventFindTaskToFinish = @"task_toFinsh_click";

//我的萝卜    my_radish_click    计数
static NSString *const TTStatisticsServiceEventMyRadish = @"my_radish_click";

#pragma mark - 公会线3.3.1数据埋点
//首页    home    签到弹窗关闭按钮    popup_sign_closed    计数
static NSString *const TTStatisticsServiceEventHomePopupSignClosed = @"popup_sign_closed";

//签到    sign    签到成功    sign_success    计数    区分签到入口（弹窗、发现页）
static NSString *const TTStatisticsServiceEventSignSuccess = @"sign_success";

//任务中心    task    成就任务去完成按钮    cjtask_toFinsh_click    计数    区分任务，只统计支持版本
static NSString *const TTStatisticsServiceEventTaskToFinish = @"cjtask_toFinsh_click";

//每日任务领取按钮    task_get_click    计数    区分任务
static NSString *const TTStatisticsServiceEventTaskRoutineGet = @"task_get_click";

//成就任务领取按钮    cjtask_get_click    计数    区分任务
static NSString *const TTStatisticsServiceEventTaskAchieveGet = @"cjtask_get_click";

//语音房    room    礼物值开关    room_giftValue_switch    计数    区分开关状态
static NSString *const TTStatisticsServiceEventRoomGiftValueSwitch = @"room_giftValue_switch";

//资料卡片    data_card    资料卡片-清除礼物值    data_card_clean_giftValue    计数
static NSString *const TTStatisticsServiceEventRoomGiftValueCardClean = @"data_card_clean_giftValue";

//厅管理    hall    厅收入统计    hall_hallincome_click    计数
static NSString *const TTStatisticsServiceEventHallIncome = @"hall_hallincome_click";

//添加成员    hall_addMembers_click    计数    区分入口（面板、成员列表）
static NSString *const TTStatisticsServiceEventHallAddMembers = @"hall_addMembers_click";

#pragma mark - 房主离线收益、补签
//语音房    room    开启离开模式    open_leave_mode
static NSString *const TTStatisticsServiceEventOpenLeaveMode = @"open_leave_mode";
//签到    sign    补签成功    re_sign_success    计数    区分第几次补签
static NSString *const TTStatisticsServiceEventCheckinResignSuccess = @"re_sign_success";

#pragma mark - 去充值
// 礼物面板 giftView 礼物面板_去充值 gift_panel_to_recharge  区分私聊、群聊、公聊大厅、房间
static NSString *const TTStatisticsServiceEventGiftViewToRecharge = @"gift_panel_to_recharge";
// 余额不足_去充值  not_enough_to_recharge  区分送礼物、买座驾、买头饰
static NSString *const TTStatisticsServiceEventNotEnoughToRecharge = @"not_enough_to_recharge";
#endif /* TTStatisticsServiceEvents_h */
