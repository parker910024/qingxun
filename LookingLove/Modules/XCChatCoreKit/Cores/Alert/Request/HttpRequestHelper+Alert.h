//
//  HttpRequestHelper+Alert.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/26.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "AlertInfo.h"

@interface HttpRequestHelper (Alert)

/**
 请求活动弹窗配置

 @param type 弹窗位置，1首页，2直播间右下角
 @param success 成功
 @param failure 失败
 */
+ (void)requestAlertInfoByTyp:(NSInteger)type
                      Success:(void (^)(AlertInfo *info))success
                      failure:(void (^)(NSNumber *resCode, NSString *message))failure;

@end
