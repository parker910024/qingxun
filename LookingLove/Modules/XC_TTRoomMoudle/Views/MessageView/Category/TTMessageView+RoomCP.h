//
//  TTMessageView+RoomCP.h
//  TuTu
//
//  Created by new on 2019/1/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//


#import "TTMessageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMessageView (RoomCP)

- (void)handleCPGameCell:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model;

@end

NS_ASSUME_NONNULL_END
