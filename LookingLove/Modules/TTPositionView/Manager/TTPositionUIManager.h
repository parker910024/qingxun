//
//  TTPositionUIManager.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <Foundation/Foundation.h>
//view
#import "TTPositionView.h"
#import "TTPositionFaceView.h"
#import "TTPositionDragView.h"
#import "TTPositionSpeakingView.h"
#import "TTPositionVipView.h"

#import "TTPositionViewUIProtocol.h"

#import <YYText/YYLabel.h>

@protocol TTPositionUIManagerDelegate <NSObject>
/** 点击了*/
- (void)didClickPositionViewTopicLabel;

/** 点击了麦位上有的人*/
- (void)ttPositionUIManagerDidSelectedUser:(UserID)userUid;
/** 点击了空坑*/
- (void)ttPositionUIManagerDidClickEmptyPosition:(NSString *)position sequence:(ChatRoomMicSequence*)sequence;

@end



NS_ASSUME_NONNULL_BEGIN
@interface TTPositionUIManager : NSObject<TTPositionViewUIProtocol>

+ (instancetype)shareUIManager;
/** 房间话题*/
@property (nonatomic, strong) YYLabel *topicLabel;
/** 麦位的View*/
@property (nonatomic, weak) TTPositionView *positionView;
/** 土豪位*/
@property (nonatomic, strong) TTPositionVipView * positionVipView;
/** 存放光圈view的数组*/
@property (nonatomic,strong) NSMutableArray<TTPositionSpeakingView *> *speakingAnimationViews;
/** 存放表情View的数组*/
@property (nonatomic,strong) NSMutableArray<TTPositionFaceView *> *faceImageViewArr;
/** 存放龙珠View的数组*/
@property (nonatomic,strong) NSMutableArray<TTPositionDragView *> *dragonImageViewArr;
/**存放所有麦位位置的数组*/
@property (nonatomic,strong) NSMutableArray *positionLoactionArray;
/**存放所有的麦位的数组*/
@property (nonatomic,copy) NSArray *positionItems;


/** 代理到position*/
@property (nonatomic,assign) id<TTPositionUIManagerDelegate> delegate;

- (void)initPositionItemWith:(TTRoomPositionViewLayoutStyle)style roomType:(TTRoomPositionViewType)type;

/** 更新所有子View的frame*/
- (void)setupContainerVeiwConstraints;

/** 相亲房房间信息变更*/
- (void)onCurrentRoomInfoUpdate;

/** 进入房间成功 */
- (void)enterChatRoomSuccess;

// 相亲房当管理员在主持麦位。被取消管理员或者是普通用户在主持麦位被设置了管理员
- (void)updateCurrentUserRole:(BOOL)isManager;

#pragma mark  获取我自己是否上麦的状态
// 获取我自己是否上麦的状态
- (void)getRoomOnMicStatus:(RoomQueueUpateType)type position:(int)position;
@end

NS_ASSUME_NONNULL_END
