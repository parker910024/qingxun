//
//  TTMessageView+RoomNormalGame.h
//  TTPlay
//
//  Created by new on 2019/3/2.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMessageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMessageView (RoomNormalGame)

- (void)handleNormalGameModelCell:(TTMessageTextCell *)newCell  model:(TTMessageDisplayModel *)model;

@end

NS_ASSUME_NONNULL_END
