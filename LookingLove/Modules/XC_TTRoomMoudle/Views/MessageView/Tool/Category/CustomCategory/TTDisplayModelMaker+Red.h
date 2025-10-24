//
//  TTDisplayModelMaker+Red.h
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/5/18.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  红包

#import "TTDisplayModelMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDisplayModelMaker (Red)

- (TTMessageDisplayModel *)makeRedWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model;

@end

NS_ASSUME_NONNULL_END
