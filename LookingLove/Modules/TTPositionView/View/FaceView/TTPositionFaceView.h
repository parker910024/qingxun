//
//  TTPositionFaceView.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/20.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTPositionContainView.h"
#import <FLAnimatedImage/FLAnimatedImageView.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTPositionFaceView : TTPositionContainView

/** 显示动画的View*/
@property (nonatomic,strong) FLAnimatedImageView * flanimationView;

@end

NS_ASSUME_NONNULL_END
