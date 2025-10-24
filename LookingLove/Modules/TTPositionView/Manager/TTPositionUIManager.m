//
//  TTPositionUIManager.m
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTPositionUIManager.h"

//categray
#import "UIView+NTES.h"
#import "NSArray+Safe.h"
//core
#import "TTGameStaticTypeCore.h"
#import "ImRoomCoreV2.h"
#import "RoomQueueCoreV2.h"
#import "AuthCore.h"
#import "TTBlindDateCore.h"
//tool
#import "XCMacros.h"
//config
#import "TTRoomPositionConfig.h"
#import "TTPositionCoreManager.h"
//view
#import "TTPositionContainView.h"
#import "TTPositionItem.h"
#import "TTGameRoomBlidDateView.h"

@interface TTPositionUIManager ()<TTPositionViewUIProtocol, TTPostionItemDelegate>
/** 存放子positionItem的容器view*/
@property (nonatomic, strong) UIView *positionContainerView;
/** 表情包含View*/
@property (nonatomic, strong) TTPositionContainView  *faceContainterView;
/** 龙珠包含View*/
@property (nonatomic, strong) TTPositionContainView  *dragonContainterView;
/** 麦位位置的配置*/
@property (nonatomic,strong) TTRoomPositionConfig *config;
/**存放所有的麦位的数组*/
@property (nonatomic,strong) NSMutableArray *positionArray;
/** 坑位的样式*/
@property (nonatomic, assign) TTRoomPositionViewLayoutStyle  style;
/** 房间的模式*/
@property (nonatomic, assign) TTRoomPositionViewType positonViewType;
/** 相亲房中间操作View*/
@property (nonatomic, strong) TTGameRoomBlidDateView *bildDateView;

@property (nonatomic, assign) BlindDateProcedure procedure; // 相亲流程(1 -- 自我介绍, 2-- 心动选择, 3 -- 心动公布, 4 -- 重新开始);
/** 房间信息。注意此房间信息只用于相亲房第一次进房，需要处理的一些操作，例如第一次进房不展示流程svga。*/
@property (nonatomic, strong) RoomInfo *processInfo;
@end

static TTPositionUIManager * UIManager;
static dispatch_once_t onceToken;

@implementation TTPositionUIManager

+ (instancetype)shareUIManager {
    dispatch_once(&onceToken, ^{
        UIManager = [[TTPositionUIManager alloc] init];
    });
    return UIManager;
}

- (instancetype)init {
    self.config = [TTRoomPositionConfig globalConfig];
    return self;
}
//初始化几个 包含龙珠 坑位 和表情的父 view
- (void)initSubContainView {
    [self.positionView addSubview:self.positionContainerView];
    [self.positionView addSubview:self.bildDateView];
    [self.positionView addSubview:self.dragonContainterView];
    [self.positionView addSubview:self.faceContainterView];
    
}
#pragma mark - public methods
#pragma mark - delegate
#pragma mark - event response
- (void)didTapGestureRecognizer:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPositionViewTopicLabel)]) {
        [self.delegate didClickPositionViewTopicLabel];
    }
}
#pragma mark - private method
- (void)initPositionItemWith:(TTRoomPositionViewLayoutStyle)style roomType:(TTRoomPositionViewType)type {
    //移出所有的子控件
    [self removeAllViews];
    [self clearData];
    self.positonViewType = type;
    self.style = style;
    if (self.style == TTRoomPositionViewLayoutStyleNormal || self.style == TTRoomPositionViewLayoutStyleCP) {
        [self.config tutuPositionItemConfig];
    } else if (self.style == TTRoomPositionViewLayoutStyleLove) {
        [self.config loveRoomPositionItemConfig];
    }
    self.positionArray = [NSMutableArray array];
    self.positionLoactionArray = [NSMutableArray array];
     [self initSubContainView];
    if (style == TTRoomPositionViewLayoutStyleNormal || style == TTRoomPositionViewLayoutStyleLove) {
        //普通房 九个坑位 -1 到 8
        for (int i = -1; i < 8; i++) {
            TTPositionItem *item = [[TTPositionItem alloc] initWithStyle:type position:[NSString stringWithFormat:@"%d", i]];
            item.delegate = self;
            [self.positionContainerView addSubview:item];
            [self.positionArray addObject:item];
        }
        
    }else if (style == TTRoomPositionViewLayoutStyleCP){
        //CP房 两个坑位 -1到1
        for (int i = -1; i < 1; i++) {
            TTPositionItem *item = [[TTPositionItem alloc] initWithStyle:type position:[NSString stringWithFormat:@"%d", i]];
            item.delegate = self;
            [self.positionContainerView addSubview:item];
            [self.positionArray addObject:item];
        }
    }
    if (self.positionArray.count > 0) {
        self.positionItems = [self.positionArray copy];
    }
    [self initContainViewSubViews];
}

//容器布局
- (void)setupContainerVeiwConstraints {
    CGRect bounds = self.positionView.bounds;
    self.positionContainerView.frame = bounds;
    self.faceContainterView.frame = bounds;
    self.dragonContainterView.frame = bounds;

    NSMutableArray *arr = GetCore(RoomCoreV2).positionArr;
    if (arr.count == 0) {
        return;
    }
    for (int i = 0; i < arr.count; i++) {
        NSValue *pointValue = [arr safeObjectAtIndex:i];
        CGPoint point = [pointValue CGPointValue];
        TTPositionDragView *dragonImage = [self.dragonImageViewArr safeObjectAtIndex:i];
        dragonImage.contentMode = UIViewContentModeScaleAspectFit;
        dragonImage.center = point;
    }
    
    for (int i = 0; i < arr.count; i++) {
        NSValue *pointValue = [arr safeObjectAtIndex:i];
        CGPoint point = [pointValue CGPointValue];
        TTPositionFaceView *faceImage = [self.faceImageViewArr safeObjectAtIndex:i];
        faceImage.center = point;
    }
    
    for (int i = 0; i < arr.count; i++) {
        NSValue *pointValue = [arr safeObjectAtIndex:i];
        CGPoint point = [pointValue CGPointValue];
        TTPositionSpeakingView *speakingView = [self.speakingAnimationViews safeObjectAtIndex:i];
        speakingView.center = point;
    }
    
    NSValue *pointValue = [arr lastObject];
    self.positionVipView.center = [pointValue CGPointValue];
}

/** 相亲房房间信息变更*/
- (void)onCurrentRoomInfoUpdate {
    RoomInfo *info = GetCore(ImRoomCoreV2).currentRoomInfo;
    if (self.procedure == info.procedure) {
        self.processInfo = info;
        return;
    } else {
        [self roomInfoUpdateAndUpdateLoveRoomStatus:info];
    }
}

/** 进入房间成功 */
- (void)enterChatRoomSuccess {
    RoomInfo *info = GetCore(ImRoomCoreV2).currentRoomInfo;
    self.procedure = info.procedure;
    if (info.type == RoomType_Love) {
        [self.bildDateView roomInfoUpdateAndUpdateLoveRoomStatus:info];
    }
}

// 相亲房当管理员在主持麦位。被取消管理员或者是普通用户在主持麦位被设置了管理员
- (void)updateCurrentUserRole:(BOOL)isManager {
    if (isManager) {
        [self.bildDateView updateStatusWithHost];
    } else {
        [self.bildDateView updateStatusWithOnMicUser];
    }
}

#pragma mark  获取我自己是否上麦的状态
// 获取我自己是否上麦的状态
- (void)getRoomOnMicStatus:(RoomQueueUpateType)type position:(int)position {
    if (type == RoomQueueUpateTypeAdd) { // 我上麦了
        if (position == -1 && ((GetCore(RoomQueueCoreV2).myMember.type == NIMChatroomMemberTypeCreator) || (GetCore(RoomQueueCoreV2).myMember.type == NIMChatroomMemberTypeManager))) {
            [self.bildDateView updateStatusWithHost];
        } else {
            [self.bildDateView updateStatusWithOnMicUser];
        }
    } else if (type == RoomQueueUpateTypeRemove) {
//        [GetCore(TTBlindDateCore) requestLoveRoomDownMicWithRoomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid uid:GetCore(AuthCore).getUid.userIDValue position:position];
       [self.bildDateView updateStatusWithDownMicUser];
    }
}

- (void)roomInfoUpdateAndUpdateLoveRoomStatus:(RoomInfo *)info {
    self.procedure = info.procedure;
    if (self.procedure == BlindDateProcedure_Indroduce || self.procedure == BlindDateProcedure_selectLove || self.procedure == BlindDateProcedure_selectLoveTimerEnd || self.procedure == BlindDateProcedure_publicLove || self.procedure == BlindDateProcedure_resetIndroduce) {
        [GetCore(ImRoomCoreV2) queryQueueWithRoomId:[NSString stringWithFormat:@"%ld",info.roomId]];
    }
    if (self.processInfo) {
        [self.bildDateView procedureUpdateAndShowProcedureSvga:self.procedure];
    }
    [self.bildDateView roomInfoUpdateAndUpdateLoveRoomStatus:info];
}

#pragma mark - 初始化子view

- (void)initBildDateView {
    self.bildDateView.size = CGSizeMake(65, 120);
    self.bildDateView.top = 94 + 60;
    self.bildDateView.centerX = KScreenWidth / 2;
}

//说话光晕
- (void)initSpeakingView {
    for (TTPositionSpeakingView *speakView in self.speakingAnimationViews) {
        [speakView removeFromSuperview];
    }
    [self.speakingAnimationViews removeAllObjects];
    NSMutableArray *arr = self.positionArray;
    int arrCount = 0;
    if (GetCore(TTGameStaticTypeCore).openRoomStatus == OpenRoomType_CP){
        arrCount = 2;
    }else{
        arrCount = 9;
    }
    for (int i = 0; i < arr.count; i++) {
        TTPositionSpeakingView *speakingView = [[TTPositionSpeakingView alloc] init];
        speakingView.tag = i+100;
        speakingView.userInteractionEnabled = NO;
        speakingView.pulsingCount = 1;
        speakingView.animationDuration = self.config.kSpeakingAnimationDuration;
        [self.speakingAnimationViews addObject:speakingView];
        [self.positionView insertSubview:speakingView belowSubview:self.positionContainerView];
    }
}
//GIF表情
- (void)initFaceView {
    NSMutableArray *arr = self.positionArray;
    [self.faceImageViewArr removeAllObjects];
    for (UIView *subView in self.faceContainterView.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat width = 80;
    for (int i = 0; i < arr.count; i++) {
        if (i == 0) {
            if (self.style == TTRoomPositionViewLayoutStyleLove) {
                width = 90;
            }
        } else {
            width = 80;
        }
        TTPositionFaceView *faceImage = [[TTPositionFaceView alloc]initWithFrame:CGRectMake(0 , 0 , width, width)];
        faceImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.faceImageViewArr addObject:faceImage];
        [self.faceContainterView addSubview:faceImage];
    }
}

//GIF龙珠
- (void)initDragonView {
    NSMutableArray *arr = self.positionArray;
    [self.dragonImageViewArr removeAllObjects];
    for (UIView *subView in self.dragonContainterView.subviews) {
        [subView removeFromSuperview];
    }
    for (int i = 0; i < arr.count; i++) {
        TTPositionDragView *dragonImage = [[TTPositionDragView alloc]initWithFrame:CGRectMake(0 , 0 , 80, 80)];
        dragonImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.dragonImageViewArr addObject:dragonImage];
        [self.dragonContainterView addSubview:dragonImage];
    }
}

//土豪位
- (void)initVipView {
    [self.positionContainerView addSubview:self.positionVipView];
    [self.positionContainerView sendSubviewToBack:self.positionVipView];
}

/** 添加龙珠 说话光晕 表情*/
- (void)initContainViewSubViews {
    [self initTopicLabel];
    [self initBildDateView];
    [self initFaceView];
    [self initDragonView];
    [self initSpeakingView];
    [self initVipView];
}

/**
 移出所有的子view
 */
- (void)removeAllViews {
    [self.positionContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.faceContainterView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.dragonContainterView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   
}

/** 清空保存的数据*/
- (void)clearData {
    [self.positionArray removeAllObjects];
    [self.positionLoactionArray removeAllObjects];
    self.positionItems = @[];
    [self.speakingAnimationViews removeAllObjects];
    [self.faceImageViewArr removeAllObjects];
    [self.dragonImageViewArr removeAllObjects];
}

#pragma mark - TTPositionViewUIProtocol
//坑位销毁的时候
- (void)positionViewDelloc {
   
    UIManager = nil;
    onceToken = 0;
}

//初始化房间公告
- (void)initTopicLabel {
    [self.positionContainerView addSubview:self.topicLabel];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGestureRecognizer:)];
    [self.topicLabel addGestureRecognizer:tap];
}

#pragma mark - TTPostionItemDelegate
- (void)roomPostionItem:(TTPositionItem *)postionItem didSelectItemAtPosition:(NSString *)position {
    // 如果是离开模式的房主位，模拟房主在房主坑位上。
    if (GetCore(RoomCoreV2).getCurrentRoomInfo.leaveMode &&
        [position isEqualToString:@"-1"]) {
        // 房主uid
        UserID uid = GetCore(RoomCoreV2).getCurrentRoomInfo.uid;
        if ([self.delegate respondsToSelector:@selector(ttPositionUIManagerDidSelectedUser:)]) {
            [self.delegate ttPositionUIManagerDidSelectedUser:uid];
        }
        return;
    }
    NSMutableDictionary<NSString *,ChatRoomMicSequence *> * mircoList = GetCore(ImRoomCoreV2).micQueue;
    NIMChatroomMember *member = [mircoList objectForKey:position].chatRoomMember;
    MicroState *state = [mircoList objectForKey:position].microState;
    
    if (state.posState == MicroPosStateFree) {
        
        if (member != nil) {//麦序上有人
            if ([self.delegate respondsToSelector:@selector(ttPositionUIManagerDidSelectedUser:)]) {
                [self.delegate  ttPositionUIManagerDidSelectedUser:member.userId.longLongValue];
            }
        }else { //麦序上没人
            if ([self.delegate respondsToSelector:@selector(ttPositionUIManagerDidClickEmptyPosition:sequence:)]) {
                [self.delegate  ttPositionUIManagerDidClickEmptyPosition:position sequence:[mircoList objectForKey:position]];
            }
        }
    } else if (state.posState == MicroPosStateLock) { //麦序是锁的
        
        if (member != nil) {//麦序上有人
            if ([self.delegate respondsToSelector:@selector(ttPositionUIManagerDidSelectedUser:)]) {
                [self.delegate ttPositionUIManagerDidSelectedUser:member.userId.longLongValue];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(ttPositionUIManagerDidClickEmptyPosition:sequence:)]) {
                [self.delegate ttPositionUIManagerDidClickEmptyPosition:position sequence:[mircoList objectForKey:position]];
            }
        }
    }
}

#pragma mark - getters and setters
- (UIView *)positionContainerView {
    if (!_positionContainerView) {
        _positionContainerView = [[UIView alloc] init];
        _positionContainerView.userInteractionEnabled = YES;
    }
    return _positionContainerView;
}

- (TTGameRoomBlidDateView *)bildDateView {
    if (!_bildDateView) {
        _bildDateView = [[TTGameRoomBlidDateView alloc] init];
        if (self.positonViewType == TTRoomPositionViewTypeLove) {
            _bildDateView.hidden = NO;
        } else {
            _bildDateView.hidden = YES;
        }
    }
    return _bildDateView;
}

- (TTPositionContainView *)faceContainterView{
    if (!_faceContainterView) {
        _faceContainterView = [[TTPositionContainView alloc] init];
    }
    return _faceContainterView;
}

- (TTPositionContainView *)dragonContainterView {
    if (!_dragonContainterView) {
        _dragonContainterView = [[TTPositionContainView alloc] init];
    }
    return _dragonContainterView;
}

- (TTPositionVipView *)positionVipView {
    if (!_positionVipView) {
        _positionVipView = [[TTPositionVipView alloc] init];
        CGFloat width = 90;
        if (projectType() == ProjectType_CeEr || projectType() == ProjectType_LookingLove) {
            width = 80;
        }
        _positionVipView.frame = CGRectMake(0, 0, width, width);
    }
    return _positionVipView;
}

- (YYLabel *)topicLabel {
    if (!_topicLabel) {
        _topicLabel = [[YYLabel alloc] init];
    }
    return _topicLabel;
}


- (NSMutableArray<TTPositionSpeakingView *> *)speakingAnimationViews {
    if (_speakingAnimationViews == nil || _speakingAnimationViews.count == 0) {
        _speakingAnimationViews = [NSMutableArray array];
    }
    return _speakingAnimationViews;
}
- (NSMutableArray<TTPositionDragView *> *)dragonImageViewArr {
    if (_dragonImageViewArr == nil || _dragonImageViewArr.count == 0) {
        _dragonImageViewArr = @[].mutableCopy;
    }
    return _dragonImageViewArr;
}

- (NSMutableArray<TTPositionFaceView *> *)faceImageViewArr {
    if (_faceImageViewArr == nil || _faceImageViewArr.count == 0) {
        _faceImageViewArr = [NSMutableArray array];
    }
    return _faceImageViewArr;
}




@end
