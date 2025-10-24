//
//  APNSCore.m
//  BberryCore
//
//  Created by 卫明何 on 2017/9/4.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "APNSCore.h"
#import "APNSCoreClient.h"
#import "ImLoginCoreClient.h"
#import "OrderInfo.h"
#import "NSObject+YYModel.h"
#import "XCLogger.h"
#import "XCRedPckageModel.h"
#import "Attachment.h"

@interface APNSCore () <ImLoginCoreClient>



@end

@implementation APNSCore

+ (void)load{
    GetCore(APNSCore);
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        AddCoreClient(ImLoginCoreClient, self);
    }
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - ImLoginCoreClient
- (void)onRecieveRemoteNotification:(NSDictionary *)payload {
    
    if ([self isMessageTypeNotification:payload]) {
        //处理跳转到消息页面的消息
        NotifyCoreClient(APNSCoreClient, @selector(onReceiveMessageTypeNotification:), onReceiveMessageTypeNotification:payload);
        return;
    }
    
    NSInteger type = [[payload objectForKey:@"skiptype"] integerValue];
    
    if (type == 1) { //转跳APP原生界面
        if (payload[@"data"]) {
            NSString *dataStr = [payload objectForKey:@"data"];
            NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];

            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            
            NSInteger skiproute = [[data objectForKey:@"skiproute"]integerValue];
            
            if (skiproute == 1) { //跳密聊列表
                NotifyCoreClient(APNSCoreClient, @selector(onRequestToPushChatList), onRequestToPushChatList);
            } else if (skiproute == 2) { //直接拉起打电话
                OrderInfo *info = [OrderInfo yy_modelWithDictionary:data[@"orderserv"]];
                NotifyCoreClient(APNSCoreClient, @selector(onRequestToCallWithOrderInfo:), onRequestToCallWithOrderInfo:info);
            }
            [[XCLogger shareXClogger]sendLog:@{@"text":[data yy_modelToJSONString],EVENT_ID:CAPNS} error:nil topic:SystemLog logLevel:XCLogLevelVerbose];
        }
    } else if (type == 2) { //转跳房间内
        NSNumber *uid;
        if ([payload[@"data"] isKindOfClass:[NSDictionary class]]) {
            uid = payload[@"data"][@"uid"];
            [[XCLogger shareXClogger]sendLog:@{@"text":[payload[@"data"] yy_modelToJSONString]} error:nil topic:SystemLog logLevel:XCLogLevelVerbose];
        } else {
            uid = payload[@"data"];
        }
        NotifyCoreClient(APNSCoreClient, @selector(onRequestToOpenRoomWithUid:), onRequestToOpenRoomWithUid:uid.userIDValue);
    } else if (type == 3) { //转跳H5
        NSString *url = [payload objectForKey:@"data"];
        NotifyCoreClient(APNSCoreClient, @selector(onReceiveWebTypeNotificationWithURL:), onReceiveWebTypeNotificationWithURL:url);

    } else if (type == 10){//cp绑定
        BOOL isStranger = NO;
        if ([[payload objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {//前台接收
            NSDictionary *dataStr = [payload objectForKey:@"data"];
            isStranger = [[dataStr objectForKey:@"second"] boolValue];
        }else{//远程推送
            NSString *dataStr = [payload objectForKey:@"data"];
            NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            isStranger = [[data objectForKey:@"second"] boolValue];
        }
        NotifyCoreClient(APNSCoreClient, @selector(onRequestToPushWithBindCP:),onRequestToPushWithBindCP:isStranger);

    }else if (type == 11){//cp解绑
        
        NSString * message = @"";
        if ([[payload objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {//前台接收
            NSDictionary *dataStr = [payload objectForKey:@"data"];
            message = [dataStr objectForKey:@"message"];
        }else{//远程推送
            NSString *dataStr = [payload objectForKey:@"data"];
            NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            message = [data objectForKey:@"message"];
        }
        NotifyCoreClient(APNSCoreClient, @selector(onRequestToPushWithUnBindCP:), onRequestToPushWithUnBindCP:message);

    }else if (type == 12){//cp签到提醒
        NotifyCoreClient(APNSCoreClient, @selector(onRequestToPushwWithRemindCPSign), onRequestToPushwWithRemindCPSign);
    }else if (type == 13){//请求成为cp
        NotifyCoreClient(APNSCoreClient, @selector(onRequestToPushCPRequest), onRequestToPushCPRequest);
    }else if (type == 15){////签到奖励
        XCRedPckageModel * info ;
        if ([[payload objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {//前台接收
            NSDictionary * dict = [[payload objectForKey:@"data"] objectForKey:@"data"];
            info = [XCRedPckageModel yy_modelWithDictionary:dict];
        }else{//远程推送
            NSString *dataStr = [payload objectForKey:@"data"];
            NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * dict = [data objectForKey:@"data"];
            info = [XCRedPckageModel yy_modelWithDictionary:dict];
        }
        NotifyCoreClient(APNSCoreClient, @selector(onRequestToPushSignReward:), onRequestToPushSignReward:info);
    }else if (type == 16){//陪伴红包
        XCRedPckageModel * info ;
        if ([[payload objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {//前台接收
            NSDictionary * dict = [[payload objectForKey:@"data"] objectForKey:@"data"];
            info = [XCRedPckageModel yy_modelWithDictionary:dict];
        }else{//远程推送
            NSString *dataStr = [payload objectForKey:@"data"];
            NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
             NSDictionary * dict = [data objectForKey:@"data"];
//            NSDictionary * dict = [[payload objectForKey:@"data"] objectForKey:@"data"];
            info = [XCRedPckageModel yy_modelWithDictionary:dict];
        }
        NotifyCoreClient(APNSCoreClient, @selector(onRequestToPushOnlineFinish:), onRequestToPushOnlineFinish:info);
    }else if (type == 17){//切换为文字模式
        NotifyCoreClient(APNSCoreClient, @selector(onRequestToPushChangeTextModel), onRequestToPushChangeTextModel);
    }else if (type == 18){//回到爱窝
        
    }else if (type == 29){  //  CP房 游戏匹配逻辑。匹配到了人

    }else if (type == 31){//评论推送
        NotifyCoreClient(APNSCoreClient, @selector(onRequestToPushComment), onRequestToPushComment);
        
    }else if (type == 32){//点赞推送 first值
        NotifyCoreClient(APNSCoreClient, @selector(onRequestToPushHeart), onRequestToPushHeart);
    }else if (type == 35) {//早晚安收到通知
        NSDictionary * data = [payload objectForKey:@"data"];
        if ([data isKindOfClass:[NSDictionary class]]) {//前台接收
        }else{//远程推送
            NSString *dataStr = [payload objectForKey:@"data"];
            NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        }
        NotifyCoreClient(APNSCoreClient, @selector(onRequestToPushMorningEveningData:), onRequestToPushMorningEveningData:data);
    }else if (type == 34){//定位
        NotifyCoreClient(APNSCoreClient, @selector(onRequestToPushDistance), onRequestToPushDistance);
    }
    else if (type == 37) {//早晚安动态
        NSDictionary * data = [payload objectForKey:@"data"][@"data"];
        if ([data isKindOfClass:[NSDictionary class]]) {//前台接收
        }else{//远程推送
            NSString *dataStr = [payload objectForKey:@"data"];
            NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil][@"data"];
        }
        NotifyCoreClient(APNSCoreClient, @selector(onRequestToPushMorningEveningDynamicsData:), onRequestToPushMorningEveningDynamicsData:data);
    }else if (type == 39) {//分享奖励
        XCRedPckageModel * redPackageModel ;
        if ([[payload objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {//前台接收
            NSDictionary * dict = [[payload objectForKey:@"data"] objectForKey:@"data"];
            redPackageModel = [XCRedPckageModel yy_modelWithDictionary:dict];
        }else{//远程推送
            NSString *dataStr = [payload objectForKey:@"data"];
            NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * dict = [data objectForKey:@"data"];
            //            NSDictionary * dict = [[payload objectForKey:@"data"] objectForKey:@"data"];
            redPackageModel = [XCRedPckageModel yy_modelWithDictionary:dict];
        }
        //通知
        NotifyCoreClient(APNSCoreClient, @selector(onRequestToPushShareRewardWithRedPckageModel:), onRequestToPushShareRewardWithRedPckageModel:redPackageModel);
    }
}

#pragma mark - Public Methods
/// 处理远程系统推送消息
/// @param payload 接收到的通知信息
- (void)handleRemoteNotification:(NSDictionary *)payload {
    
    //动态未读消息更新
    if ([self isDynamicUnreadNotification:payload]) {
        NotifyCoreClient(APNSCoreClient, @selector(onReceiveDynamicMessageUpdateNotification:), onReceiveDynamicMessageUpdateNotification:payload);
        return;
    }
    
    [self onRecieveRemoteNotification:payload];
}

#pragma mark - Private Methods
/// 是否为消息页面类型的通知信息
/// @param payload 接收到的通知信息
/// @discussion 判断此类型为真后处理跳转到消息页面
- (BOOL)isMessageTypeNotification:(NSDictionary *)payload {
    
    id type = [payload objectForKey:@"skiptype"];
    if (type != nil) {
        //如果skiptype，应该是指自定义部分消息推送，非消息页面类型的消息
        return NO;
    }
    
    return YES;
}

/// 是否为动态未读消息的通知信息
/// @param payload 接收到的通知信息
- (BOOL)isDynamicUnreadNotification:(NSDictionary *)payload {
    
    id data = [payload objectForKey:@"data"];
    Attachment *attach = [Attachment modelWithJSON:data];
    
    return attach.first == Custom_Noti_Header_Dynamic && attach.second == Custom_Noti_Sub_Dynamic_Unread_Update;
}

@end
