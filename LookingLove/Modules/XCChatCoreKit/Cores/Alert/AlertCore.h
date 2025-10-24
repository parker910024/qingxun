//
//  AlertCore.h
//  BberryCore
//
//  Created by 卫明何 on 2017/9/26.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"


@interface AlertCore : BaseCore

/**
 获取弹窗配置

 @param type 弹窗位置，1首页，2直播间右下角
 */
- (void)requestAlertInfoByType:(NSInteger)type;

@end
