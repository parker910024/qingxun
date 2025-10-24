//
//  TTWorldletMainPartyRoomView.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/11/30.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//  语音派对

#import <UIKit/UIKit.h>
#import "LittleWorldPartyRoom.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTWorldletMainPartyRoomView : UIView

@property (nonatomic, strong) NSArray<LittleWorldPartyRoom *> *dataArray;//数据源

@property (nonatomic, copy) void (^selectedBlock)(LittleWorldPartyRoom *room);

@end

@interface TTWorldletMainPartyRoomContentCell : UICollectionViewCell

/// 配置cell数据显示
- (void)configData:(LittleWorldPartyRoom *)data;

@end

NS_ASSUME_NONNULL_END
