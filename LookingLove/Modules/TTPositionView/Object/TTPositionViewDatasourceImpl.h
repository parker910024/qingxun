//
//  TTPositionViewDatasourceImpl.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTPositionViewDatasourceProtocol.h"
#import "TTPositionView.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTPositionViewDatasourceImpl : NSObject<TTPositionViewDatasourceProtocol>

- (instancetype)initDatasourceImplStyle:(TTRoomPositionViewLayoutStyle)style
                         positonViewType:(TTRoomPositionViewType)positonViewType;

@end

NS_ASSUME_NONNULL_END
