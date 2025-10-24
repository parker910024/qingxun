//
//  TTMessageView+RoomNotification.h
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView.h"

@interface TTMessageView (RoomNotification)

//处理通知消息
- (void)handleNotificationCell:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model notificationBlock:(void(^)(NIMMessage * message))notificationBlock;

@end
