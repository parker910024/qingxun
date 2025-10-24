//
//  TTDisplayModelMaker+LittleWorld.h
//  XC_TTRoomMoudle
//
//  Created by apple on 2019/7/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTDisplayModelMaker (LittleWorld)

- (TTMessageDisplayModel *)makeLittleWorldWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model;

@end

NS_ASSUME_NONNULL_END
