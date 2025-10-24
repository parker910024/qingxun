//
//  TTPositionCoreManager.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTPositionViewUIProtocol.h"
#import "TTPositionViewDatasourceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTPositionCoreManager : NSObject<TTPositionViewUIProtocol, TTPositionViewDatasourceProtocol>

+ (instancetype)shareCoreManager;

/** 坑位的样式*/
@property (nonatomic, assign) TTRoomPositionViewLayoutStyle  style;
/** 房间的模式*/
@property (nonatomic, assign) TTRoomPositionViewType positonViewType;

/**
 *链接core和UImanager的连接器
 */
@property (nonatomic, strong) id<TTPositionViewUIProtocol> uiInteractor;

/**
 *修改数据的连接器
 */
@property (nonatomic, strong) id<TTPositionViewDatasourceProtocol> dataInteractor;

/**
 是否显示礼物值，默认：NO
 */
@property (nonatomic, assign, getter=isShowGiftValue) BOOL showGiftValue;

/** 初始化一些配置*/
- (void)initCoreManagerConfig;

@end

NS_ASSUME_NONNULL_END
