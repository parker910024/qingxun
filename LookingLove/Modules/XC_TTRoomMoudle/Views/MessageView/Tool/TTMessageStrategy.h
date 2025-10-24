//
//  TTMessageStrategy.h
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TTDisplayModelMaker.h"
#import "TTMessageDisplayModel.h"
#import "Attachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMessageStrategy : NSObject

+ (instancetype)defaultStrategy;

- (NSInvocation *)strategyByMessageHeader:(CustomNotificationHeader)messageHeader target:(TTDisplayModelMaker *)target model:(TTMessageDisplayModel *)model message:(NIMMessage *)message;

@end

NS_ASSUME_NONNULL_END
