//
//  TTDisplayModelMaker+NormalGame.h
//  TTPlay
//
//  Created by new on 2019/3/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDisplayModelMaker (RoomNormalGame)

- (TTMessageDisplayModel *)makeRoomNormalGameWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model;

@end

NS_ASSUME_NONNULL_END
