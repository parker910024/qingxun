//
//  TTDisplayModelMaker+NonsupportMessage.h
//  TTPlay
//
//  Created by Macx on 2019/3/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDisplayModelMaker (NonsupportMessage)
- (TTMessageDisplayModel *)makeRoomNonsupportMessageContentWithMessage:(NIMMessage *)message model:(TTMessageDisplayModel *)model;
@end

NS_ASSUME_NONNULL_END
