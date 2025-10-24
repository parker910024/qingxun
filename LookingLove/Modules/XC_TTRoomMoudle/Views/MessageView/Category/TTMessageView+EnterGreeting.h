//
//  TTMessageView+EnterGreeting.h
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/3/28.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  进房欢迎语

#import "TTMessageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMessageView (EnterGreeting)
- (void)handleEnterGreetingCell:(TTMessageTextCell *)cell model:(TTMessageDisplayModel *)model;
@end

NS_ASSUME_NONNULL_END
