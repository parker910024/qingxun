//
//  TTPositionView.m
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTPositionView.h"
#import "TTPositionCoreManager.h"
#import "TTPositionUIManager.h"

#import "TTPositionViewUIImpl.h"
#import "TTPositionViewDatasourceImpl.h"
//core
#import "ImRoomCoreV2.h"
#import "RoomCoreV2.h"

@interface TTPositionView ()<TTPositionUIManagerDelegate>

/**
 *core的工具管理类
 */
@property (nonatomic, strong) TTPositionCoreManager *coreManager;

/**
 *UI的工具管理类
 */
@property (nonatomic, strong) TTPositionUIManager *uiManager;


/**
 *链接positionView和 UIManager
 */
@property (nonatomic,weak)  id<TTPositionViewUIProtocol> layout;


/**
 *链接positionView和CoreManager
 */
@property (nonatomic,weak)  id<TTPositionViewUIProtocol> coreInteracor;


@end

@implementation TTPositionView

#pragma mark - life cycle
- (void)dealloc {
    [self.layout positionViewDelloc];
    [self.coreInteracor positionViewDelloc];
}


- (instancetype)initWithPositonViewStyle:(TTRoomPositionViewLayoutStyle)style positonViewType:(TTRoomPositionViewType)positonViewType {
    if (self = [super init]) {
        self.style = style;
        self.positonViewType = positonViewType;
        [self initView];
    }
    return self;
}

#pragma mark - public methods
- (void)updateRoomPositionViewStyle:(TTRoomPositionViewLayoutStyle)style {
    self.style = style;
    self.coreManager.style = self.style;
}

/** 相亲房房间信息变更*/
- (void)onCurrentRoomInfoUpdate {
    [self.uiManager onCurrentRoomInfoUpdate];
}

/** 进入房间成功 */
- (void)enterChatRoomSuccess {
    [self.uiManager enterChatRoomSuccess];
}

// 相亲房当管理员在主持麦位。被取消管理员或者是普通用户在主持麦位被设置了管理员
- (void)updateCurrentUserRole:(BOOL)isManager {
    [self.uiManager updateCurrentUserRole:isManager];
}

#pragma mark - delegate
#pragma mark - event response
#pragma mark - private method
//初始化core管理类
- (void)initCoreManager {
    self.coreManager = [TTPositionCoreManager shareCoreManager];
    self.coreManager.positonViewType = self.positonViewType;
    self.coreManager.style = self.style;
    self.coreManager.uiInteractor = [[TTPositionViewUIImpl alloc] initPositionUIImplStyle:self.style positonViewType:self.positonViewType];
    self.coreManager.dataInteractor = [[TTPositionViewDatasourceImpl alloc] initDatasourceImplStyle:self.style positonViewType:self.positonViewType];
    self.coreInteracor = self.coreManager;
    
    self.coreManager.showGiftValue = [GetCore(ImRoomCoreV2) canOpenGiftValue] && GetCore(RoomCoreV2).getCurrentRoomInfo.showGiftValue;
    [self.coreManager initCoreManagerConfig];
}
//初始化UI管理类
- (void)initUIManager {
    self.uiManager = [TTPositionUIManager shareUIManager];
    self.uiManager.positionView = self;
    self.layout = self.uiManager;
    [self.uiManager initPositionItemWith:self.style roomType:self.positonViewType];
    
    self.uiManager.delegate = self;
}

- (void)initView {
      [self initUIManager];
    [self initCoreManager];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.coreInteracor positionViwLayoutSubViews];
}

#pragma mark - TTPositionUIManagerDelegate
- (void)didClickPositionViewTopicLabel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(roomPositionViewDidClickTopicLabel:)]) {
        [self.delegate roomPositionViewDidClickTopicLabel:self];
    }
}

/** 点击了空的坑位*/
- (void)ttPositionUIManagerDidClickEmptyPosition:(NSString *)position sequence:(ChatRoomMicSequence *)sequence {
    if (self.delegate && [self.delegate respondsToSelector:@selector(roomPositionView:didClickEmptyPosition:sequence:)]) {
        [self.delegate roomPositionView:self didClickEmptyPosition:position sequence:sequence];
    }
}

/** 点击了麦上有人的*/
- (void)ttPositionUIManagerDidSelectedUser:(UserID)userUid {
    if (self.delegate && [self.delegate respondsToSelector:@selector(roomPositionView:didSelectedUser:)]) {
        [self.delegate roomPositionView:self didSelectedUser:userUid];
    }
}

#pragma mark - getters and setters

@end
