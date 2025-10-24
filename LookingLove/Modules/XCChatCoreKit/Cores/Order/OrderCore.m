//
//  OrderCore.m
//  BberryCore
//
//  Created by chenran on 2017/6/12.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "OrderCore.h"
#import "OrderCoreClient.h"
#import "UserCore.h"
#import "ImMessageCore.h"
#import "Attachment.h"
#import "AuthCore.h"
#import "ImMessageCoreClient.h"
#import "PhoneCallCore.h"
#import "NotificationCoreClient.h"
#import "PhoneCallCoreClient.h"
#import "CustomProtolInfo.h"
#import "HttpRequestHelper+Order.h"

@interface OrderCore()<PhoneCallCoreClient, ImMessageCoreClient>

@property (nonatomic, assign)BOOL isStart;
@property (nonatomic, strong) dispatch_source_t timer; //计时器
@end
@implementation OrderCore
- (instancetype)init
{
    self = [super init];
    if (self) {
        AddCoreClient(PhoneCallCoreClient, self);
        AddCoreClient(ImMessageCoreClient, self);
    }
    return self;
}

- (void)dealloc
{
    RemoveCoreClient(ImMessageCoreClient, self);
    RemoveCoreClient(PhoneCallCoreClient, self);
}

- (void)requestOrderService
{
    if (self.current == nil) {
        return;
    }
    
    UInt64 channelId = [GetCore(PhoneCallCore) currentCallID];
    if (channelId == 0){
        return;
    }
    
    UserID uid = [GetCore(AuthCore) getUid].userIDValue;
    
    [HttpRequestHelper requestOrderService:self.current.orderId uid:uid channelId:channelId success:^(OrderInfo *orderInfo) {
        
    } failure:^(NSNumber *resCode, NSString *message) {
        [GetCore(PhoneCallCore) hangup];
    }];
}

- (void)requestOrderList:(UserID)uid
{
    if (uid <= 0) {
        return;
    }
    
    [HttpRequestHelper requestOrderList:uid success:^(NSArray *orderList) {
        NotifyCoreClient(OrderCoreClient, @selector(onRequestOrderListSuccess:), onRequestOrderListSuccess:orderList);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(OrderCoreClient, @selector(onRequestOrderListFailth:), onRequestOrderListFailth:message);
    }];
}

- (void)requestOrderStart:(OrderInfo *)orderInfo
{
    if (orderInfo == nil) {
        return;
    }
    self.current = orderInfo;
    self.isStart = YES;
    UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
    UserID other = 0;
    if (orderInfo.uid == myUid) {
        other = orderInfo.prodUid;
    } else {
        other = orderInfo.uid;
    }

    UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:myUid];
    
    [GetCore(PhoneCallCore) startPhoneCall:other extendMsg:userInfo.nick];

}

#pragma mark - PhoneCallCoreClient
- (void)onRecievePhoneCall:(NSString *)from uid:(NSString *)uid extend:(NSString *)extend
{
    if (extend.length > 0) {
        CustomProtolInfo *info = [CustomProtolInfo yy_modelWithJSON:extend];
        if (info.customType == Custom_Type_Request_Order) {
            OrderInfo *order = [OrderInfo yy_modelWithJSON:info.extendMsg];
            if (order != nil && order.orderId != nil) {
                self.current = order;
                NotifyCoreClient(OrderCoreClient, @selector(onOrderStartRequest:from:), onOrderStartRequest:uid from:from);
            }
        }
    }
}

- (void)onCallDisconnected {
    [self stopTimer];
    self.current = nil;
    self.isStart = NO;
}

- (void)onHangup:(NSString *)from
{
    [self stopTimer];
    self.current = nil;
    self.isStart = NO;
}

- (void)onCallEstablished
{
//    [self startPhoneCallTimer:(short)self.current.leftServDura];
    [self startPhoneCallTimer];
    if (self.current != nil && self.isStart) {
        [self requestOrderService];
    }
}

- (void)stopTimer {
    if (self.timer) {
        dispatch_cancel(self.timer);
    }
    self.timer = nil;
}

- (void)startPhoneCallTimer {
    
//    __block int count = minutes * 60;
    __block int count = 0;
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"------------%@", [NSThread currentThread]);
        count++;
        int seconds = count % 60;
        int minutes = (count / 60) % 60;
        int hours = count / 3600;
        NSString *strTime;
        if (minutes > 0) {
            strTime = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        } else if (hours > 0) {
            strTime = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
        } else {
            strTime = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        }
        NotifyCoreClient(OrderCoreClient, @selector(updateTimer:), updateTimer:strTime);

    });
    
    // 启动定时器
    dispatch_resume(self.timer);
}

- (void)requestFinishOrder:(NSString *)orderId
{
    [HttpRequestHelper requestFinishOrder:orderId success:^{
        NotifyCoreClient(OrderCoreClient, @selector(onRequestFinishOrderSuccess), onRequestFinishOrderSuccess);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(OrderCoreClient, @selector(onRequestFinishOrderFailth), onRequestFinishOrderFailth);
    }];
}


#pragma mark - ImMessageCoreClient

- (void)onRecvP2PCustomMsg:(NIMMessage *)msg {
    NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
    if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
        Attachment *attachment = (Attachment *)obj.attachment;
        if (attachment.first == Custom_Noti_Header_PhoneCall) {
            if (attachment.second == Custom_Noti_Sub_Auction_Alert) { //拍卖生成订单成功
                if (attachment.data != nil) {
                    [self setBadgeStore:YES];
                }
            }
        }
        
        
    }
}

#pragma mark - Private Method

- (void)setBadgeStore:(BOOL)show {
    _showBadge = show;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:show forKey:@"BadgeShow"];
}

- (BOOL)showBadge {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"BadgeShow"] == YES) {
        return YES;
    }else {
        return NO;
    }
}

@end
