//
//  AlertCore.m
//  BberryCore
//
//  Created by 卫明何 on 2017/9/26.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "AlertCore.h"
#import "HttpRequestHelper+Alert.h"
#import "AlertCoreClient.h"

@implementation AlertCore

/**
 获取弹窗配置
 
 @param type 弹窗位置，1首页，2直播间右下角
 */
- (void)requestAlertInfoByType:(NSInteger)type  {
    [HttpRequestHelper requestAlertInfoByTyp:type Success:^(AlertInfo *info) {
        NotifyCoreClient(AlertCoreClient, @selector(requestAlertInfoSuccess:), requestAlertInfoSuccess:info);
    } failure:^(NSNumber *resCode, NSString *message) {
        NotifyCoreClient(AlertCoreClient, @selector(requestAlertInfoFailth:), requestAlertInfoFailth:message);
    }];
}

@end
