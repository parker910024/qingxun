//
//  TTRoomPositionConfig.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTPositionViewUIProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTRoomPositionConfig : NSObject
@property (nonatomic, assign) CGFloat PositionPaddingAndNickHeight;//坑位下padding与昵称的总高度
@property (nonatomic, assign) CGFloat NormalOwnerItemWidth;//房主坑宽
@property (nonatomic, assign) CGFloat NormalOwnerItemHeight;//房主坑高
@property (nonatomic, assign) CGFloat NormalItemWidth;//普通坑宽
@property (nonatomic, assign) CGFloat NormalItemHeight;//普通坑高

@property (nonatomic, assign) CGFloat padding;//item上下距离
@property (nonatomic, assign) CGFloat messageAndPositonPadding;//公屏与位置view的距离
@property (nonatomic, assign) CGFloat kSpeakingAnimationDuration;//光圈动画时长

@property (nonatomic, assign) CGFloat headwearVSAvater;//头饰vs头像 的比例
/** 坑位的高度*/
@property (nonatomic, assign) CGFloat positionHeight;

+ (TTRoomPositionConfig*)globalConfig;

- (void)tutuPositionItemConfig;

// 相亲房坑位
- (void)loveRoomPositionItemConfig;

/** 更新整体麦位的高度*/
- (CGFloat)updateTTPositionHeight:(TTRoomPositionViewLayoutStyle)style positionType:(TTRoomPositionViewType)positionType;

@end

NS_ASSUME_NONNULL_END
