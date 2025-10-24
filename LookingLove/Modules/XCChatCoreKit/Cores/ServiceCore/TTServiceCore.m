//
//  TTServiceCore.m
//  TTPlay
//
//  Created by fengshuo on 2019/3/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTServiceCore.h"

//tool
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "XCTheme.h"
//category
#import "UIImage+_1x1Color.h"
#import <NIMSDK/NIMSDK.h>
//core
#import "AuthCore.h"
#import "UserCore.h"
//client
#import "AuthCoreClient.h"
#import "TTServiceCoreClient.h"
#import "UserCoreClient.h"

static NSString * const QYKey = @"key";
static NSString * const QYValue = @"value";
static NSString * const QYHidden = @"hidden";
static NSString * const QYIndex = @"index";
static NSString * const QYLabel = @"label";

@interface TTServiceCore()
<   AuthCoreClient,
//    QYConversationManagerDelegate,
    UserCoreClient
>

@end

@implementation TTServiceCore

- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (id)init{
    if (self = [super init]) {
        AddCoreClient(AuthCoreClient, self);
        AddCoreClient(UserCoreClient, self);
//        [[QYSDK sharedSDK].conversationManager setDelegate:self];
    }
    return self;
}

//- (QYSessionViewController *)getQYSessionViewController{
//
//    UserInfo * info = [GetCore(UserCore) getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue];
//    [GetCore(TTServiceCore) setQYUserinforWith:info];
//
//    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[QYSessionViewController class]];
//    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
//    QYSource *source = [[QYSource alloc] init];
//    NSString * title;
//    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
//        title = @"官方客服";
//    }else {
//        title = @"兔兔客服";
//    }
//    source.title = title;
//    source.urlString = @"https://8.163.com/";
//    sessionViewController.sessionTitle = title;
//    sessionViewController.source = source;
//    sessionViewController.hidesBottomBarWhenPushed = YES;
//    return sessionViewController;
//}

//- (void)configSesstionUIWith:(UserInfo *)infor{
//    QYCustomUIConfig *config =  [QYCustomUIConfig sharedInstance];
//
//    config.serviceMessageTextColor = [XCTheme getTTMainTextColor];
//    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
//         config.customMessageTextColor = [UIColor whiteColor];
//        config.serviceHeadImageUrl = @"https://img.erbanyy.com/new_kficon.png";
//    }else {
//         config.customMessageTextColor = [XCTheme getTTMainTextColor];
//         config.serviceHeadImageUrl = @"https://img.erbanyy.com/icon_tutukf.png";
//    }
//
//    config.customerHeadImageUrl = infor.avatar;
//    config.sessionBackground.image = [UIImage instantiate1x1ImageWithColor:UIColorFromRGB(0xf5f5f5)];
//    config.customerMessageBubbleNormalImage = [[UIImage imageNamed:@"message_public_chat_bubble_orange"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{6,6,6,6}") resizingMode:UIImageResizingModeStretch];;
//    config.customerMessageBubblePressedImage = [[UIImage imageNamed:@"message_public_chat_bubble_orange"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{6,6,6,6}") resizingMode:UIImageResizingModeStretch];;
//    config.serviceMessageBubbleNormalImage = [[UIImage imageNamed:@"message_public_chat_bubble_white"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{6,6,6,6}") resizingMode:UIImageResizingModeStretch];;
//    config.serviceMessageBubblePressedImage = [[UIImage imageNamed:@"message_public_chat_bubble_white"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{6,6,6,6}") resizingMode:UIImageResizingModeStretch];;
//
//}


#pragma mark - QYConversationManagerDelegate
//- (void)onReceiveMessage:(QYMessageInfo *)message{
//    if (message) {
//        NotifyCoreClient(TTServiceCoreClient, @selector(onReceiveQYMessage:), onReceiveQYMessage:message);
//    }
//}

//- (void)onUnreadCountChanged:(NSInteger)count{
//    NotifyCoreClient(TTServiceCoreClient, @selector(onQYUnreadCountChanged:), onQYUnreadCountChanged:count);
//}

#pragma mark - public method
//- (NSInteger)getQYServiceUnreadCount{
//    return [[QYSDK sharedSDK].conversationManager allUnreadCount];
//}

/** 得到回话的最后一条*/
//- (QYSessionInfo *)getLastQYSessionInfo{
// return [[[QYSDK sharedSDK].conversationManager getSessionList] lastObject];
//}

/**更新推送的deviceToken*/
//- (void)updateDeviceTokenWith:(NSData *)deviceToken{
//    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
//}

//- (void)setQYUserinforWith:(UserInfo *)info{
//    if (info== nil || info.uid <= 0) {
//        return;
//    }
//
//    [self configSesstionUIWith:info];
//    QYUserInfo * qyUserInfo = [[QYUserInfo alloc] init];
//    qyUserInfo.userId = [NSString stringWithFormat:@"%lld", info.uid];
//    NSDictionary *realNameDic = @{
//                               QYKey:@"real_name",
//                               QYLabel:@"用户昵称",
//                               QYValue:info.nick.length > 0 ? info.nick : @"我是一只小萌新"
//                               };
//
//    NSDictionary * nickDic = @{
//                               QYKey:@"nick",
//                               QYLabel:@"用户昵称",
//                               QYValue:info.nick.length > 0 ? info.nick : @"我是一只小萌新"
//                               };
//
//    NSDictionary * avatarDic = @{
//                              QYKey:@"avatar",
//                              QYLabel:@"头像",
//                              QYValue:info.avatar && info.avatar.length> 0 ? info.avatar : @"https://img.tutuyuyin.com/ttplay_icon.png"
//                              };
//    NSString * number;
//    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
//        number = @"千寻号";
//    }else {
//        number = @"兔兔号";
//    }
//    NSDictionary * erbanNo = @{
//                               QYKey:@"erbanNo",
//                               QYLabel:number,
//                               QYValue:info.erbanNo ? info.erbanNo : @"无"
//                               };
//
//    NSDictionary * sexDic = @{
//                               QYKey:@"gender",
//                               QYLabel:@"性别",
//                               QYValue:info.gender == UserInfo_Male ? @"女" : @"男"
//                               };
//
//    NSDictionary * noble;
//    if (info.nobleUsers) {
//        noble = @{
//                  QYKey:@"nobleName",
//                  QYLabel:@"爵位名称",
//                  QYValue: info.nobleUsers.nobleName && info.nobleUsers.nobleName.length > 0 ? info.nobleUsers.nobleName : @"平民"
//                  };
//    }else{
//        noble = @{
//                  QYKey:@"nobleName",
//                  QYLabel:@"爵位名称",
//                  QYValue:@"平民"
//                  };
//    }
//
//
//    NSDictionary * phoneDic;
//    NSDictionary * mobile_phoneDic;
//    if (info.isBindPhone) {
//               phoneDic = @{
//                     QYKey:@"phone",
//                     QYLabel:@"手机号",
//                     QYValue:info.phone ? info.phone : @"无"
//                     };
//        mobile_phoneDic = @{
//                     QYKey:@"mobile_phone",
//                     QYLabel:@"手机号",
//                     QYValue:info.phone ? info.phone : @"无"
//                     };
//    }else{
//        phoneDic = @{
//                     QYKey:@"phone",
//                     QYLabel:@"手机号",
//                     QYValue:@"无"
//                     };
//        mobile_phoneDic = @{
//                     QYKey:@"mobile_phone",
//                     QYLabel:@"手机号",
//                     QYValue:@"无"
//                     };
//    }
//
//    NSDictionary * isNew = @{
//                             QYKey:@"newUser",
//                             QYLabel:@"是否是新用户",
//                             QYValue:info.newUser? @"是" : @"否"
//                             };
//
//    NSDictionary * familyName;
//    NSDictionary * familyId;
//    if (info.family) {
//                      familyName = @{
//                                      QYKey:@"familyName",
//                                      QYLabel:@"家族名称",
//                                      QYValue:info.family.familyName ? info.family.familyName : @"无"
//                                      };
//                        familyId = @{
//                                     QYKey:@"familyId",
//                                     QYLabel:@"家族ID",
//                                     QYValue:info.family.familyId ? info.family.familyId : @"无"
//                                     };
//
//    }
//    NSMutableArray * array = [NSMutableArray array];
//    [array addObjectsFromArray:@[realNameDic,nickDic,avatarDic, erbanNo, sexDic, noble, phoneDic,mobile_phoneDic, isNew]];
//    if (info.family) {
//        [array arrayByAddingObjectsFromArray:@[familyName, familyId]];
//    }
//    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
//    if (data) {
//        qyUserInfo.data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    }
//    [[QYSDK sharedSDK] setUserInfo:qyUserInfo];
//}

#pragma mark - UserCoreClient
//- (void)onCurrentUserInfoUpdate:(UserInfo *)userInfo {
//    if (userInfo.uid == [GetCore(AuthCore) getUid].userIDValue) {
//        [self setQYUserinforWith:userInfo];
//    }
//}

#pragma mark - AuthCoreClient

//- (void)onLogout{
//    [[QYSDK sharedSDK] logout:^(BOOL success) {
//
//    }];
//}

@end
