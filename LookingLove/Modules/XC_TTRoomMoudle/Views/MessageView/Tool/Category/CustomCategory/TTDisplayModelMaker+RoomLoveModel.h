//
//  TTDisplayModelMaker+RoomLoveModel.h
//  CeEr
//
//  Created by jiangfuyuan on 2020/12/22.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTDisplayModelMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDisplayModelMaker (RoomLoveModel)

- (TTMessageDisplayModel *)makeRoomLoveScreenMsgTipsWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model;

@end

NS_ASSUME_NONNULL_END
