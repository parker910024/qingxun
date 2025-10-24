//
//  TTPositionViewUIImpl.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTPositionViewUIProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTPositionViewUIImpl :  NSObject<TTPositionViewUIProtocol>

/** 初始化*/
- (instancetype)initPositionUIImplStyle:(TTRoomPositionViewLayoutStyle)style
                        positonViewType:(TTRoomPositionViewType)positonViewType;

@end

NS_ASSUME_NONNULL_END
