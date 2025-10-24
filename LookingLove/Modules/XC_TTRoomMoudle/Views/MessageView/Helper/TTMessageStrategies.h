//
//  TTMessageStrategies.h
//  TuTu
//
//  Created by KevinWang on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTMessageView.h"
#import "TTMessageTextCell.h"
#import "Attachment.h"

@interface TTMessageStrategies : NSObject

+ (instancetype)defaultStrategy;

- (NSInvocation *)strategyByMessageHeader:(CustomNotificationHeader)messageHeader target:(TTMessageView *)target cell:(TTMessageTextCell *)cell model:(TTMessageDisplayModel *)model;


@end
