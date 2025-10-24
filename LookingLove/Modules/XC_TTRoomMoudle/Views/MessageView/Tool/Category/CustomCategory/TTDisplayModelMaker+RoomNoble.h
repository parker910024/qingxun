//
//  TTDisplayModelMaker+RoomNoble.h
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDisplayModelMaker (RoomNoble)

- (TTMessageDisplayModel *)makeNobleContentWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model;

@end

NS_ASSUME_NONNULL_END
