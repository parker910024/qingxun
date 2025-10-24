//
//  BoxCore.m
//  BberryCore
//
//  Created by KevinWang on 2018/7/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BoxCore.h"
#import "HttpRequestHelper+Box.h"
#import "HttpRequestHelper+DiamondBox.h"
#import "HttpRequestHelper+BoxStatus.h"
#import "Attachment.h"

#import "BoxCoreClient.h"
#import "BoxStatusClient.h"
#import "PurseCore.h"
#import "AuthCore.h"
#import "ImMessageCoreClient.h"

@interface BoxCore()<ImMessageCoreClient>

@end

@implementation BoxCore

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        AddCoreClient(ImMessageCoreClient, self);
    }
    return self;
}

#pragma mark - ImMessageCoreClient
//收到自定义消息
- (void)onRecvChatRoomCustomMsg:(NIMMessage *)msg{
    
    [self handlerCustomMsg:msg];
    
}


#pragma mark - puble method
/*
 获取钥匙数量与价格
 */
- (void)getBoxKeysInfo{
    
    [HttpRequestHelper requestBoxKeysInfoSuccess:^(BoxKeyInfoModel *keyInfo) {
        self.keyInfo = keyInfo;
        NotifyCoreClient(BoxCoreClient, @selector(onGetKeysInfoSuccess:), onGetKeysInfoSuccess:keyInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(BoxCoreClient, @selector(onGetKeysInfoFailth:), onGetKeysInfoFailth:message);
    }];
}

/*
 购买钥匙
 keysNum: 钥匙数
 */
- (void)buyBoxKeysByKey:(int)keyNum type:(XCBoxBuyKeyType)type{
    [HttpRequestHelper requestBuyBoxKeysByKey:keyNum success:^(NSDictionary *info) {
        if ([info isKindOfClass:[NSDictionary class]]) {
            int keyNum = [info[@"keyNum"] intValue];
            if (self.keyInfo) {
                self.keyInfo.keyNum = keyNum;
            }else{
                BoxKeyInfoModel *keyInfo = [[BoxKeyInfoModel alloc] init];
                keyInfo.keyNum = keyNum;
                self.keyInfo = keyInfo;
            }
            GetCore(PurseCore).balanceInfo.goldNum = [NSString stringWithFormat:@"%d",[info[@"goldNum"] intValue]];
            NotifyCoreClient(BoxCoreClient, @selector(onbuyBoxKeysType:success:), onbuyBoxKeysType:type success:keyNum);
        }else{
            NotifyCoreClient(BoxCoreClient, @selector(onbuyBoxKeysType:Failth:), onbuyBoxKeysType:type Failth:@"获取钥匙失败，请重试");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(BoxCoreClient, @selector(onbuyBoxKeysType:Failth:), onbuyBoxKeysType:type Failth:message);
    }];
}

/*
 开奖
 keysNum: 钥匙数
 sendMessage: 是否需要发送消息
 type:手动or自动开箱子
 */
- (void)openBoxByKey:(int)keyNum sendMessage:(BOOL)sendMessage type:(XCBoxOpenBoxType)type{
    
    [HttpRequestHelper requestOpenBoxByKey:keyNum sendMessage:sendMessage success:^(NSArray<BoxPrizeModel *> *boxPrizes) {
        
        NotifyCoreClient(BoxCoreClient, @selector(onBoxKeysUpdate), onBoxKeysUpdate);
        NotifyCoreClient(BoxCoreClient, @selector(onOpenBoxByKeyType:success:), onOpenBoxByKeyType:type success:boxPrizes);
        [[XCLogger shareXClogger]sendLog:@{@"uid":[GetCore(AuthCore) getUid],EVENT_ID:@"CBox"} error:nil topic:BussinessLog logLevel:XCLogLevelVerbose];
    } failure:^(NSNumber *resCode, NSString *message) {
        if (resCode.intValue == 10000) {
            [self getBoxKeysInfo];
        }
        NotifyCoreClient(BoxCoreClient, @selector(onOpenBoxByKeyType:failth:), onOpenBoxByKeyType:type failth:message);
        NSDictionary *userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,nil];
        NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:userInfo1];
        [[XCLogger shareXClogger]sendLog:@{EVENT_ID:@"CBox",@"uid":[GetCore(AuthCore)getUid]} error:error topic:BussinessLog logLevel:XCLogLevelError];
    }];
}

/*
 中奖纪录
 state:0 结束头部刷新。  1 结束底部刷新
 page: 页数
 sortType：排序类型
 */
- (void)getBoxDrawRecordByState:(int)state page:(int)page sortType:(BoxDrawRecordSortType)sortType{
    [HttpRequestHelper requestBoxDrawRecordByPage:page sortType:sortType success:^(NSArray<BoxPrizeModel *> *boxPrizes) {
        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxDrawRecordByState:success:), onGetBoxDrawRecordByState:state success:boxPrizes);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxDrawRecordByState:failth:), onGetBoxDrawRecordByState:state failth:message);
    }];
}

/*
 获取背景，规则图片
 */
- (void)getBoxConfigSource{
    if (self.configInfo.backgroundUrl.length > 0 || self.configInfo.ruleUrl.length>0) {
        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxConfigSourceSuccess:), onGetBoxConfigSourceSuccess:self.configInfo);
        return;
    }
    [HttpRequestHelper requestBoxConfigSourceSuccess:^(BoxConfigInfo *configInfo) {
        self.configInfo = configInfo;
        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxConfigSourceSuccess:), onGetBoxConfigSourceSuccess:configInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxConfigSourceFailth:), onGetBoxConfigSourceFailth:message);
    }];
}

/*
 获取奖池
 */
- (void)getBoxPrizes{
    
    if (self.boxPrizes.count) {
        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxPrizesSuccess:), onGetBoxPrizesSuccess:self.boxPrizes);
        return;
    }
    [HttpRequestHelper requestBoxPrizesSuccess:^(NSArray<BoxPrizeModel *> *boxPrizes) {
        self.boxPrizes = boxPrizes;
        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxPrizesSuccess:), onGetBoxPrizesSuccess:boxPrizes);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxPrizesFailth:), onGetBoxPrizesFailth:message);
    }];
}

- (void)clearBoxConfigSource{
    self.configInfo = nil;
    self.keyInfo = nil;
}

/*  ---------------------------------------萌声 宝箱 2.0------------------------------------------------  */
/*
 获取奖池
 */
- (void)getBoxPrizesV2{
//    if (self.boxPrizes.count) {
//        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxPrizesSuccess:), onGetBoxPrizesSuccess:self.boxPrizes);
//        return;
//    }
    [HttpRequestHelper requestBoxPrizesV2Success:^(NSArray<BoxPrizeModel *> *boxPrizes) {
        self.boxPrizes = boxPrizes;
        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxPrizesSuccess:), onGetBoxPrizesSuccess:boxPrizes);

    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxPrizesFailth:), onGetBoxPrizesFailth:message);
    }];

}
/*
 开奖
 keysNum: 钥匙数
 sendMessage: 是否需要发送消息
 type:手动or自动开箱子
 isInRoom:是否在房间开宝箱,如果不是在房间则不需要传房间id
 */
- (void)openBoxV2ByKey:(int)keyNum sendMessage:(BOOL)sendMessage type:(XCBoxOpenBoxType)type isInRoom:(BOOL)isInRoom{
    [HttpRequestHelper requestOpenBoxV2ByKey:keyNum sendMessage:sendMessage isInRoom:isInRoom success:^(NSArray<BoxPrizeModel *> *boxPrizes) {
        
        NotifyCoreClient(BoxCoreClient, @selector(onBoxKeysUpdate), onBoxKeysUpdate);
        NotifyCoreClient(BoxCoreClient, @selector(onOpenBoxByKeyType:success:), onOpenBoxByKeyType:type success:boxPrizes);
        [[XCLogger shareXClogger]sendLog:@{@"uid":[GetCore(AuthCore) getUid],EVENT_ID:@"CBox"} error:nil topic:BussinessLog logLevel:XCLogLevelVerbose];
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(BoxCoreClient, @selector(onOpenBoxByKeyType:failth:), onOpenBoxByKeyType:type failth:message);
        NSDictionary *userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,nil];
        NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:userInfo1];
        [[XCLogger shareXClogger]sendLog:@{EVENT_ID:@"CBox",@"uid":[GetCore(AuthCore)getUid]} error:error topic:BussinessLog logLevel:XCLogLevelError];
    }];

}

/*
 获取奖池概率
 */
- (void)getBoxPrizesV2Probability{
    [HttpRequestHelper requestBoxPrizesProbabilitySuccess:^(NSArray<BoxPrizeModel *> *boxPrizes) {
         NotifyCoreClient(BoxCoreClient, @selector(onGetBoxPrizeProbabilitySuccess:), onGetBoxPrizeProbabilitySuccess:boxPrizes);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxPrizeProbabilityFailth:), onGetBoxPrizeProbabilityFailth:message);
    }];
}


/*  ---------------------------------------开箱子暴击------------------------------------------------  */
/**
 获取暴击活动数据
 */
- (void)getBoxCritActivityData{
    
    [HttpRequestHelper requestBoxCritActivityDataSuccess:^(BoxCirtData *cirtData) {
        
        self.activityStatus = cirtData.status;
        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxCritActivityDataSuccess:), onGetBoxCritActivityDataSuccess:cirtData);
        
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxCritActivityDataFailth:), onGetBoxCritActivityDataFailth:message);
    }];
}

/*  --------------------------------------- 钻石 宝箱 ------------------------------------------------  */
/*
 获取钻石宝箱钥匙数量与价格
 */
- (void)getDiamondBoxKeysInfo {
    [HttpRequestHelper requestDiamondBoxKeysInfoSuccess:^(BoxKeyInfoModel *keyInfo) {
        self.keyInfo = keyInfo;
        NotifyCoreClient(BoxCoreClient, @selector(onGetDiamondBoxKeysInfoSuccess:), onGetDiamondBoxKeysInfoSuccess:keyInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(BoxCoreClient, @selector(onGetDiamondBoxKeysInfoFailth:), onGetDiamondBoxKeysInfoFailth:message);
    }];
}

/*
 购买钥匙
 keysNum: 钥匙数
 */
- (void)buyDiamondBoxKeysByKey:(int)keyNum type:(XCBoxBuyKeyType)type {
    [HttpRequestHelper requestBuyDiamondBoxKeysByKey:keyNum success:^(NSDictionary *info) {
        if ([info isKindOfClass:[NSDictionary class]]) {
            int keyNum = [info[@"keyNum"] intValue];
            if (self.keyInfo) {
                self.keyInfo.keyNum = keyNum;
            }else{
                BoxKeyInfoModel *keyInfo = [[BoxKeyInfoModel alloc] init];
                keyInfo.keyNum = keyNum;
                self.keyInfo = keyInfo;
            }
            GetCore(PurseCore).balanceInfo.goldNum = [NSString stringWithFormat:@"%d",[info[@"goldNum"] intValue]];
            NotifyCoreClient(BoxCoreClient, @selector(onbuyDiamondBoxKeysType:success:), onbuyDiamondBoxKeysType:type success:keyNum);
        }else{
            NotifyCoreClient(BoxCoreClient, @selector(onbuyDiamondBoxKeysType:Failth:), onbuyDiamondBoxKeysType:type Failth:@"获取钥匙失败，请重试");
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(BoxCoreClient, @selector(onbuyDiamondBoxKeysType:Failth:), onbuyDiamondBoxKeysType:type Failth:message);
    }];
}

/*
 开奖
 keysNum: 钥匙数
 sendMessage: 是否需要发送消息
 type:手动or自动开箱子
 */
- (void)openDiamondBoxByKey:(int)keyNum sendMessage:(BOOL)sendMessage type:(XCBoxOpenBoxType)type{
    
    [HttpRequestHelper requestOpenDiamondBoxByKey:keyNum sendMessage:sendMessage success:^(NSArray<BoxPrizeModel *> *boxPrizes) {
        
        NotifyCoreClient(BoxCoreClient, @selector(onDiamondBoxKeysUpdate), onDiamondBoxKeysUpdate);
        NotifyCoreClient(BoxCoreClient, @selector(onOpenDiamondBoxByKeyType:success:), onOpenDiamondBoxByKeyType:type success:boxPrizes);
        [[XCLogger shareXClogger]sendLog:@{@"uid":[GetCore(AuthCore) getUid],EVENT_ID:@"CBox"} error:nil topic:BussinessLog logLevel:XCLogLevelVerbose];
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(BoxCoreClient, @selector(onOpenDiamondBoxByKeyType:failth:), onOpenDiamondBoxByKeyType:type failth:message);
        NSDictionary *userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,nil];
        NSError *error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:[resCode integerValue] userInfo:userInfo1];
        [[XCLogger shareXClogger]sendLog:@{EVENT_ID:@"CBox",@"uid":[GetCore(AuthCore)getUid]} error:error topic:BussinessLog logLevel:XCLogLevelError];
    }];
}

/*
 获取奖池
 */
- (void)getDiamondBoxPrizes {
    
    if (self.diamondBoxPrizes.count) {
        NotifyCoreClient(BoxCoreClient, @selector(onGetDiamondBoxPrizesSuccess:), onGetDiamondBoxPrizesSuccess:self.diamondBoxPrizes);
        return;
    }
    [HttpRequestHelper requestDiamondBoxPrizesSuccess:^(NSArray<BoxPrizeModel *> *boxPrizes) {
        self.diamondBoxPrizes = boxPrizes;
        NotifyCoreClient(BoxCoreClient, @selector(onGetDiamondBoxPrizesSuccess:), onGetDiamondBoxPrizesSuccess:boxPrizes);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(BoxCoreClient, @selector(onGetDiamondBoxPrizesFailth:), onGetDiamondBoxPrizesFailth:message);
    }];
}

/*
 获取钻石宝箱活动状态
 */
- (void)getDiamondBoxActivityStatus {
    [HttpRequestHelper requestDiamondBoxActivityStatus:^(BoxStatus *status) {
        NotifyCoreClient(BoxStatusClient, @selector(onGetDiamondBoxActivityStatusSuccess:), onGetDiamondBoxActivityStatusSuccess:status);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(BoxStatusClient, @selector(onGetDiamondBoxActivityStatusFailth:), onGetDiamondBoxActivityStatusFailth:message);
    }];
}

/*
 获取开箱子活数据
 */
- (void)getBoxOpenActivityDataByBoxType:(XCBoxType)type {
    [HttpRequestHelper requestBoxActivityDataByBoxType:type Success:^(BoxOpenInfo *boxOpenInfo) {
        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxOpenActivityData:success:), onGetBoxOpenActivityData:type success:boxOpenInfo);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(BoxCoreClient, @selector(onGetBoxOpenActivityData:failth:), onGetBoxOpenActivityData:type failth:message);
    }];
}

#pragma mark - private method
//处理聊天室下发通知
- (void)handlerCustomMsg:(NIMMessage *)msg{
    
    NIMCustomObject *obj = (NIMCustomObject *)msg.messageObject;
    if (obj.attachment != nil && [obj.attachment isKindOfClass:[Attachment class]]) {
        
        Attachment *attachment = (Attachment *)obj.attachment;
        if (attachment.first == Custom_Noti_Header_Box) {
            if (attachment.second == Custom_Noti_Sub_Box_OpenBoxCirt_Start) {
                
                self.activityStatus = BoxCirtActivityStatus_Start;
                NotifyCoreClient(BoxCoreClient, @selector(boxCirtActivityStatusUpdate:msg:), boxCirtActivityStatusUpdate:attachment.second msg:msg)
            }else if (attachment.second == Custom_Noti_Sub_Box_OpenBoxCirt_END ){
                
               self.activityStatus = BoxCirtActivityStatus_Finshed;
                NotifyCoreClient(BoxCoreClient, @selector(boxCirtActivityStatusUpdate:msg:), boxCirtActivityStatusUpdate:attachment.second msg:msg)
            }else if (attachment.second == Custom_Noti_Sub_Box_OpenBoxCirt_Win){
                
               self.activityStatus = BoxCirtActivityStatus_Finshed;
               NotifyCoreClient(BoxCoreClient, @selector(boxCirtActivityStatusUpdate:msg:), boxCirtActivityStatusUpdate:attachment.second msg:msg)
            }
        }
    }
}
@end
