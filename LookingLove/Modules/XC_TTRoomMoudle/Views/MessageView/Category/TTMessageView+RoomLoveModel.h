//
//  TTMessageView+RoomLoveModel.h
//  CeEr
//
//  Created by jiangfuyuan on 2020/12/22.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTMessageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMessageView (RoomLoveModel)

- (void)handleRoomLoveScreenCell:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model;

@end

NS_ASSUME_NONNULL_END
