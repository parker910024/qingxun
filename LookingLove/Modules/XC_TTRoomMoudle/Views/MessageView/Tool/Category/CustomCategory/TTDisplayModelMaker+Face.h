//
//  TTDisplayModelMaker+Face.h
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTDisplayModelMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDisplayModelMaker (Face)

- (NSMutableAttributedString *)creatFaceAttributedWithMsg:(NIMMessage *)message withModel:(TTMessageDisplayModel *)model;

@end

NS_ASSUME_NONNULL_END
