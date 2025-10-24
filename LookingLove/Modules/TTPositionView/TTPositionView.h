//
//  TTPositionView.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>
//protocol
#import "TTPositionViewUIProtocol.h"
#import "TTPositionTopicModel.h"

#import "ChatRoomMicSequence.h"

@class TTPositionView;

NS_ASSUME_NONNULL_BEGIN
@protocol TTPositionViewDelegate <NSObject>
/** 点击了房间公告*/
- (void)roomPositionViewDidClickTopicLabel:(TTPositionView *)positionView;
/** 点击了麦位上有的人*/
- (void)roomPositionView:(TTPositionView *)positionView didSelectedUser:(UserID)userUid;
/** 点击了空坑*/
- (void)roomPositionView:(TTPositionView *)positionView didClickEmptyPosition:(NSString *)position sequence:(ChatRoomMicSequence*)sequence;

@end


@interface TTPositionView : UIView
/**
 坑位的样式
 */
@property (nonatomic, assign) TTRoomPositionViewLayoutStyle  style;

/**
 房间的模式
 */
@property (nonatomic, assign) TTRoomPositionViewType positonViewType;


@property (nonatomic,assign) id<TTPositionViewDelegate> delegate;

/**
 @param style 坑位的样式
 @param positonViewType 房间的模式
 */
- (instancetype)initWithPositonViewStyle:(TTRoomPositionViewLayoutStyle)style
                         positonViewType:(TTRoomPositionViewType)positonViewType;


/** 更新房间的坑位样式*/
- (void)updateRoomPositionViewStyle:(TTRoomPositionViewLayoutStyle)style;

/** 相亲房房间信息变更*/
- (void)onCurrentRoomInfoUpdate;

/** 进入房间成功 */
- (void)enterChatRoomSuccess;

// 相亲房当管理员在主持麦位。被取消管理员或者是普通用户在主持麦位被设置了管理员
- (void)updateCurrentUserRole:(BOOL)isManager;
@end

NS_ASSUME_NONNULL_END
