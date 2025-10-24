//
//  TTDisplayModelMaker+TextMessage.h
//  TTPlay
//
//  Created by 卫明 on 2019/3/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker.h"
#import "TTMessageDisplayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDisplayModelMaker (TextMessage)

- (TTMessageDisplayModel *)makeTextContentWithMessage:(NIMMessage *)message withModel:(TTMessageDisplayModel *)model;

@end

NS_ASSUME_NONNULL_END
