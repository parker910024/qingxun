//
//  TTPositionItem.m
//  TTPositionView
//
//  Created by fengshuo on 2019/5/16.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTPositionItem.h"
//tool

#import <YYImage/YYSpriteSheetImage.h>
#import "SpriteSheetImageManager.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "XCTheme.h"
#import "TTPopup.h"

#import "AuthCore.h"
#import "ImRoomCoreV2.h"
#import "RoomQueueCoreV2.h"

//config
#import "TTRoomPositionConfig.h"
#import "TTPositionHelper.h"

//core
#import "ImRoomExtMapKey.h"
#import "TTBlindDateCore.h"

//categray
#import "NSString+JsonToDic.h"
#import "UIImageView+QiNiu.h"
#import "TTPositionItem+Nick.h"
#import "UIButton+EnlargeTouchArea.h"
//view
#import "TTPositionGiftValueView.h"
#import "MYPositionGiftValueView.h"
#import "TTPositionGiftValueDetailView.h"
#import "TTStatisticsService.h"

@interface TTPositionItem ()<UIGestureRecognizerDelegate>
/** 坑位的普通状态*/
@property (nonatomic, strong) UIImageView *positionStatusNormalBg;
/** 锁坑*/
@property (nonatomic, strong) UIImageView *positionStatusLockBg;
/** 头饰*/
@property (nonatomic, strong) YYAnimatedImageView *positionHeadwearImageView;
/** 头像*/
@property (nonatomic, strong) UIImageView *positionAvatarImageView;
/** 禁麦*/
@property (nonatomic, strong) UIImageView *positionBeBlockMicroImageView;
/** 头饰的精灵动画*/
@property (nonatomic, strong) SpriteSheetImageManager  *manager;
/** 坑位的形式*/
@property (nonatomic, assign) TTRoomPositionViewLayoutStyle style;
/** 房间的模式*/
@property (nonatomic, assign) TTRoomPositionViewType positionViewType;
/** 离开模式*/
@property (nonatomic,strong) UILabel *leaveLabel;
/** 礼物值 */
@property (nonatomic, strong) TTPositionGiftValueView *giftValueView;
/** 相亲房的礼物值 */
@property (nonatomic, strong) MYPositionGiftValueView *loveGiftView;
/** 接收长按手势的遮罩view */
@property(nonatomic, strong) UIView *longPreGetrueMaskView;
/**礼物值更新时间戳*/
@property (nonatomic, copy, readwrite) NSString *giftVauleUpdateTime;
@end


@implementation TTPositionItem
    

/**
 初始化 基本的坑位信息
 
 @param type 房间的模式
 @param position 坑位
 @return 坑位的View
 */
- (instancetype)initWithStyle:(TTRoomPositionViewType)type position:(NSString *)position {
    if (self = [super init]) {
        self.positionViewType = type;
        self.position = position;
        [self initView];
    }
    return self;
}

#pragma mark - public methods
#pragma mark - delegate
#pragma mark - event response
//点击坑位
- (void)tapGestureAction:(UITapGestureRecognizer *)tap {
    [self.delegate roomPostionItem:self didSelectItemAtPosition:self.position];
}

// 长按手势事件
- (void)longPressAction:(UILongPressGestureRecognizer *)longPreGesture {
    
    static NSTimeInterval pressStartTime = 0.0; //
    static BOOL hasShowDetailGiftValueView = NO;   // 是否已经显示
    
    switch (longPreGesture.state) {
        case UIGestureRecognizerStateBegan:
            // do something
            // 标记长按开始时间
            pressStartTime = [NSDate timeIntervalSinceReferenceDate];
            if (!hasShowDetailGiftValueView) {
                [self showDetailGiftValueView];
                hasShowDetailGiftValueView = YES;
            }
            
            break;
        case UIGestureRecognizerStateEnded:
            // do something
            hasShowDetailGiftValueView = NO;
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            
            
        }
            break;
        default:
            break;
    }
}

/** 显示礼物值详情 */
- (void)showDetailGiftValueView {
    // 礼物值
    NSString *giftValue = GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love ? [NSString stringWithFormat:@"%lld", self.loveGiftView.giftValue] : [NSString stringWithFormat:@"%lld", self.giftValueView.giftValue];
    if (giftValue.length < 7) {
        // 如果当前礼物值的数值不够 7 位，则不需要显示全部数据
        return;
    }
    // 显示详细的 view
    TTPositionGiftValueDetailView *detailView  = [[TTPositionGiftValueDetailView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 礼物值数据
    [detailView updateGiftValue:GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love ? self.loveGiftView.giftValue : self.giftValueView.giftValue];
    
    [[UIApplication sharedApplication].keyWindow addSubview:detailView];
    
    // 每行显示 4 个 item。
    if ((self.position.integerValue % 4) == 3) { // 右侧
        [detailView.containView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo((GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love ? self.loveGiftView : self.giftValueView));
            make.bottom.mas_equalTo(self.mas_top).offset(-20);
            make.height.mas_equalTo(34);
        }];
    } else { // 中间的布局
        [detailView.containView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo((GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love ? self.loveGiftView : self.giftValueView));
            make.bottom.mas_equalTo(self.mas_top).offset(-20);
            make.height.mas_equalTo(34);
        }];
    }
    
    [detailView.downArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo((GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love ? self.loveGiftView : self.giftValueView));
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(5);
        make.top.mas_equalTo(detailView.containView.mas_bottom);
    }];
    
    detailView.containView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, 40), CGAffineTransformMakeScale(1.3, 1.3));
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        detailView.containView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

// 公布心动，选为心动点击
- (void)loveRoomNameButtonClick:(UIButton *)sender {
    if ([sender.titleLabel.text containsString:@"选为心动"]) { // 选为心动点击
        if (![self isMeOnMicOrNoMic]) { //  如果我在-1麦 或者不在麦上。此时没有权限选择
            __weak typeof(self) weakSelf = self;
            [TTPopup alertWithMessage:[NSString stringWithFormat:@"设为心动后不可修改，确认选择%d麦为本场心动用户吗？",self.position.intValue + 1] confirmHandler:^{
                UserInfo *userInfo = self.sequence.userInfo;
                [GetCore(TTBlindDateCore) requestLoveRoomChooseLoveWithRoomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid uid:GetCore(AuthCore).getUid.userIDValue position:[GetCore(RoomQueueCoreV2) findThePositionByUid:GetCore(AuthCore).getUid.userIDValue].intValue choosePosition:weakSelf.position.intValue chooseUid:userInfo.uid];
            } cancelHandler:^{
                [TTPopup dismiss];
            }];
        }
    } else { // 公布心动点击
        if ([self isMeOnHostMicAndMeIsActorOrManager]) { // 只有主持人有权限操作
            NSLog(@"公布心动了");
            [TTStatisticsService trackEvent:@"room_blinddate_result" eventDescribe:[NSString stringWithFormat:@"%@的房间-公布心动",GetCore(ImRoomCoreV2).currentRoomInfo.nick]];
            __weak typeof(self) weakSelf = self;
            [TTPopup alertWithMessage:[NSString stringWithFormat:@"公开后房间内所有成员将可以看到TA的心动对象，确认公布%d麦心动选择吗？",self.position.intValue + 1] confirmHandler:^{
                UserInfo *userInfo = self.sequence.userInfo;
                [GetCore(TTBlindDateCore) requestLoveRoomPublicLoveWithRoomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid uid:GetCore(AuthCore).getUid.userIDValue position:[GetCore(RoomQueueCoreV2) findThePositionByUid:GetCore(AuthCore).getUid.userIDValue].intValue choosePosition:weakSelf.position.intValue chooseUid:userInfo.uid targetPosition:userInfo.blindDate.chooseUid targetMic:userInfo.blindDate.chooseMic];
            } cancelHandler:^{
                [TTPopup dismiss];
            }];
            
        }
    }
}

#pragma mark Gift Value Handle
/**
 更新坑位礼物值
 
 @param giftValue 礼物值
 @param updateTime 礼物接收时间
 */
- (void)updateGiftValue:(long long)giftValue updateTime:(NSString *)updateTime {
    
    //若更新的礼物接收时间小于当前保留时间，忽略该次更新
    if (updateTime && self.giftVauleUpdateTime.longLongValue > updateTime.longLongValue) {
        return;
    }
    
    self.giftVauleUpdateTime = updateTime ?: @"0";
    
    if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) {
        [self.loveGiftView updateGiftValue:giftValue];
    } else {
        [self.giftValueView updateGiftValue:giftValue];
    }
}

/**
 重置礼物值
 */
- (void)resetGiftValue {
    self.giftVauleUpdateTime = nil;
    if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) {
        [self.loveGiftView updateGiftValue:0];
    } else {
        [self.giftValueView updateGiftValue:0];
    }
}


#pragma mark - private method
- (void)initView {
     // 头像 光圈 (名字  几号麦)  闭麦  锁坑 头饰
    [self addSubview:self.positionStatusLockBg];
    [self addSubview:self.positionStatusNormalBg];
    [self addSubview:self.positionAvatarImageView];
    [self addSubview:self.positionHeadwearImageView];
    [self addSubview:self.leaveLabel];
    [self addSubview:self.positionBeBlockMicroImageView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.loveRoomNameButton];
    
    if (self.positionViewType == TTRoomPositionViewTypeLove) {
        [self addSubview:self.loveGiftView];
        [self addSubview:self.longPreGetrueMaskView];
        [self.loveGiftView bringSubviewToFront:self];
    } else {
        [self addSubview:self.giftValueView];
        [self addSubview:self.longPreGetrueMaskView];
        [self.giftValueView bringSubviewToFront:self];
    }
    
    [self.giftValueView bringSubviewToFront:self];
    self.positionStatusNormalBg.image = [UIImage imageNamed:@"room_game_position_normal"];
    self.positionStatusLockBg.image = [UIImage imageNamed:@"room_game_position_lock"];
    self.positionBeBlockMicroImageView.image = [UIImage imageNamed:@"room_game_position_mute"];
    [self addViewGestures];
}


- (void)setupSubviewsConstraints {
    
    [self.positionStatusLockBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.mas_width);
        make.top.centerX.equalTo(self);
    }];
    [self.positionStatusNormalBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.positionStatusLockBg);
    }];
   

    [self.positionAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.positionStatusLockBg);
    }];
    [self.positionBeBlockMicroImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.positionStatusLockBg);
    }];
    
    [self.positionHeadwearImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.positionAvatarImageView).multipliedBy([TTRoomPositionConfig globalConfig].headwearVSAvater);
        make.center.equalTo(self.positionStatusLockBg);
    }];
    
    if (self.positionViewType == TTRoomPositionViewTypeLove) {
        self.loveRoomNameButton.hidden = NO;
        self.nickNameLabel.hidden = YES;
        [self.loveRoomNameButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.positionAvatarImageView.mas_bottom);
            make.height.equalTo(@(14));
            make.width.mas_equalTo(self.position.intValue == -1 ? 74 : 58);
        }];
        
        [self.positionBeBlockMicroImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(self.positionStatusLockBg);
            make.bottom.mas_equalTo(self.loveRoomNameButton.mas_top);
        }];
        
        [self.loveGiftView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.positionAvatarImageView);
            make.height.mas_equalTo(14);
            make.top.mas_equalTo(self.positionAvatarImageView.mas_bottom).offset(5);
        }];
        
        [self.longPreGetrueMaskView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.loveGiftView);
            make.left.right.bottom.mas_equalTo(self.loveGiftView).inset(-10);
        }];
    } else {
        [self.positionBeBlockMicroImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.positionStatusLockBg);
        }];
        
        self.loveRoomNameButton.hidden = YES;
        
        [self.nickNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.positionAvatarImageView.mas_bottom).offset(6);
            make.height.equalTo(@(14));
        }];
        
        [self.giftValueView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.positionAvatarImageView.mas_right).offset(-5);
            make.height.mas_equalTo(16);
            make.top.mas_equalTo(self.positionAvatarImageView);
        }];
        
        [self.longPreGetrueMaskView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.giftValueView).inset(-10);
        }];
    }

    [self.leaveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.positionAvatarImageView);
    }];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupSubviewsConstraints];
}

// 在view中重写以下方法，其中 self.longPreGetrueMaskView 就是那个希望被触发点击事件的按钮
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (!view) {
        // 转换坐标系
        CGPoint newPoint = [self.longPreGetrueMaskView convertPoint:point fromView:self];
        // 判断触摸点
        if (CGRectContainsPoint(self.longPreGetrueMaskView.bounds, newPoint)) {
            view = self.longPreGetrueMaskView;
        }
    }
    return view;
}


// 添加长按手势
- (void)addViewGestures {
    // 礼物值view 添加长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPressGesture.delegate = self;
    [self.longPreGetrueMaskView addGestureRecognizer:longPressGesture];
    
    // 自身添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self addGestureRecognizer:tap];
}



#pragma mark - getters and setters
- (void)setShowGiftValue:(BOOL)showGiftValue {
    _showGiftValue = showGiftValue;
    if (GetCore(ImRoomCoreV2).currentRoomInfo.type == RoomType_Love) {
        self.loveGiftView.hidden = !showGiftValue;
        self.longPreGetrueMaskView.hidden = self.loveGiftView.hidden;
    } else {
        self.giftValueView.hidden = !showGiftValue;
        self.longPreGetrueMaskView.hidden = self.giftValueView.hidden;
    }
}

- (void)setISShowLeave:(BOOL)iSShowLeave {
    _iSShowLeave = iSShowLeave;
    self.leaveLabel.hidden = !_iSShowLeave;
}

- (void)setVipItemName:(NSString *)vipItemName {
    _vipItemName = vipItemName;
    if (_vipItemName.length) {
        self.positionStatusNormalBg.image = [UIImage imageNamed:_vipItemName];
    }
}

- (void)setMySequence:(ChatRoomMicSequence *)mySequence {
    _mySequence = mySequence;
    if (!mySequence) {
        self.myUserInfo = nil;
        return;
    }
    UserInfo * userInfo = self.mySequence.userInfo;
    
    //房间成员的所有的信息都放在roomExt的里面
    NSDictionary *roomExt = [[NSString dictionaryWithJsonString:mySequence.chatRoomMember.roomExt] objectForKey:mySequence.chatRoomMember.userId];
    SingleNobleInfo *info = [SingleNobleInfo yy_modelWithJSON:roomExt];
    userInfo.nobleUsers = info;
    
    userInfo.blindDate = [BlindDateInfo modelDictionary:roomExt[@"blindDate"]];
    
    self.myUserInfo = userInfo;
}

- (void)setSequence:(ChatRoomMicSequence *)sequence {
    _sequence = sequence;
    UserInfo *userInfo = sequence.userInfo;
    
    // 离开模式，房主位需要处理房主的信息
    RoomInfo *roomInfo = GetCore(RoomCoreV2).getCurrentRoomInfo;
    if (!roomInfo) {
        return;
    }
    if (roomInfo.leaveMode &&
        [self.position isEqualToString:@"-1"]) {
        // 填充数据
        userInfo = GetCore(ImRoomCoreV2).roomOwnerInfo;
    }
    
    //房间成员的所有的信息都放在roomExt的里面
    NSDictionary *roomExt = [[NSString dictionaryWithJsonString:sequence.chatRoomMember.roomExt] objectForKey:sequence.chatRoomMember.userId];
    SingleNobleInfo *info = [SingleNobleInfo yy_modelWithJSON:roomExt];
    userInfo.nobleUsers = info;
    
    userInfo.blindDate = [BlindDateInfo modelDictionary:roomExt[@"blindDate"]];
    
    NSString *anchorName = [roomExt objectForKey:ImRoomExtKeyOfficialAnchorCertificationName];
    NSString *anchorPic = [roomExt objectForKey:ImRoomExtKeyOfficialAnchorCertificationIcon];
    if (anchorName && anchorPic) {
        UserOfficialAnchorCertification *cert = [[UserOfficialAnchorCertification alloc] init];
        cert.fixedWord = anchorName;
        cert.iconPic = anchorPic;
        userInfo.nameplate = cert;
    }
    
    MicroState *state = sequence.microState;
    
    //是不是闭麦 或者锁麦
  
    self.positionAvatarImageView.hidden = userInfo==nil? YES : NO;
    self.positionHeadwearImageView.hidden = userInfo==nil? YES : NO;
    
    self.positionStatusLockBg.hidden = state.posState == MicroPosStateFree ? YES : NO;
    self.positionStatusNormalBg.hidden = state.posState == MicroPosStateLock ? YES : NO;
    self.positionBeBlockMicroImageView.hidden =  state.micState==MicroMicStateClose ?  NO : YES;
     //给麦位下面的label赋值
    [self setNickContent:userInfo position:sequence.microState.position];
    
    //头像和头饰赋值
    if (userInfo != nil) {
        NSString * defalutAvatar = @"common_default_avatar";
        [self.positionAvatarImageView qn_setImageImageWithUrl:userInfo.avatar placeholderImage:defalutAvatar type:ImageTypeUserIcon];
        self.positionAvatarImageView.layer.cornerRadius = self.frame.size.width/2;
        self.positionAvatarImageView.layer.masksToBounds = YES;
        
        NSString *picString;
        if (roomInfo.type == RoomType_Love) {
            picString = userInfo.blindDate.roomHeadwearVo.effect ? userInfo.blindDate.roomHeadwearVo.effect : userInfo.blindDate.roomHeadwearVo.pic;
            if (picString) {
                self.positionHeadwearImageView.hidden = NO;
                NSURL *headwearURL = [NSURL URLWithString:picString];
                @weakify(self)
                [self.manager loadSpriteSheetImageWithURL:headwearURL frameDurations:userInfo.nobleUsers.timeInterval/1000.0 completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
                    @strongify(self)
                    self.positionHeadwearImageView.image = sprit;
                } failureBlock:^(NSError * _Nullable error) {
                    
                }];
            } else {
                self.positionHeadwearImageView.hidden = YES;
            }
        } else {
            picString = userInfo.nobleUsers.pic;
            if (picString) {
                NSURL *headwearURL = [NSURL URLWithString:picString];
                @weakify(self)
                [self.manager loadSpriteSheetImageWithURL:headwearURL frameDurations:userInfo.nobleUsers.timeInterval/1000.0 completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
                    @strongify(self)
                    self.positionHeadwearImageView.image = sprit;
                } failureBlock:^(NSError * _Nullable error) {
                    
                }];
            } else {
                if (!userInfo.nobleUsers.headwear) {
                    self.positionHeadwearImageView.hidden = YES;
                }else{
                    self.positionHeadwearImageView.hidden = NO;
                    [TTPositionHelper handlerImageView:self.positionHeadwearImageView soure:userInfo.nobleUsers.headwear imageType:ImageTypeUserIcon];
                }
            }
        }
    }
}



- (UIImageView *)positionAvatarImageView {
    if (!_positionAvatarImageView) {
        _positionAvatarImageView = [[UIImageView alloc] init];
        _positionAvatarImageView.userInteractionEnabled = YES;
    }
    return _positionAvatarImageView;
}

- (YYAnimatedImageView *)positionHeadwearImageView {
    if (!_positionHeadwearImageView) {
        _positionHeadwearImageView = [[YYAnimatedImageView alloc] init];
        _positionHeadwearImageView.userInteractionEnabled = YES;
    }
    return _positionHeadwearImageView;
}

- (UIImageView *)positionBeBlockMicroImageView {
    if (!_positionBeBlockMicroImageView) {
        _positionBeBlockMicroImageView = [[UIImageView alloc] init];
        _positionBeBlockMicroImageView.hidden = YES;
        _positionBeBlockMicroImageView.userInteractionEnabled = YES;
    }
    return _positionBeBlockMicroImageView;
}

- (YYLabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[YYLabel alloc] init];
    }
    return _nickNameLabel;
}

- (UIButton *)loveRoomNameButton {
    if (!_loveRoomNameButton) {
        _loveRoomNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loveRoomNameButton.hidden = YES;
        _loveRoomNameButton.userInteractionEnabled = NO;
        _loveRoomNameButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _loveRoomNameButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_loveRoomNameButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
        [_loveRoomNameButton setEnlargeEdgeWithTop:5 right:0 bottom:5 left:0];
        [_loveRoomNameButton addTarget:self action:@selector(loveRoomNameButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loveRoomNameButton;
}

- (SpriteSheetImageManager *)manager {
    if (!_manager) {
        _manager = [[SpriteSheetImageManager alloc] init];
    }
    return _manager;
}

- (UIImageView *)positionStatusLockBg {
    if (!_positionStatusLockBg) {
        _positionStatusLockBg = [[UIImageView alloc] init];
        _positionStatusLockBg.hidden = YES;
        _positionStatusLockBg.userInteractionEnabled = YES;
    }
    return _positionStatusLockBg;
}

- (UIImageView *)positionStatusNormalBg {
    if (!_positionStatusNormalBg) {
        _positionStatusNormalBg = [[UIImageView alloc] init];
        _positionStatusNormalBg.userInteractionEnabled = YES;
    }
    return _positionStatusNormalBg;
}

- (UILabel *)leaveLabel {
    if (!_leaveLabel) {
        _leaveLabel = [[UILabel alloc] init];
        _leaveLabel .text = @"离开";
        _leaveLabel .font = [UIFont systemFontOfSize:16];
        _leaveLabel .textColor = UIColor.whiteColor;
        _leaveLabel.textAlignment = NSTextAlignmentCenter;
        _leaveLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
        _leaveLabel.hidden = YES;
        _leaveLabel.layer.cornerRadius = 65 / 2;
        _leaveLabel.layer.masksToBounds = YES;
        _leaveLabel.userInteractionEnabled = YES;
    }
    return _leaveLabel ;
}

- (TTPositionGiftValueView *)giftValueView {
    if (!_giftValueView) {
        _giftValueView = [[TTPositionGiftValueView alloc] init];
        _giftValueView.hidden = YES;
    }
    return _giftValueView;
}

- (MYPositionGiftValueView *)loveGiftView {
    if (!_loveGiftView) {
        _loveGiftView = [[MYPositionGiftValueView alloc] init];
        _loveGiftView.hidden = YES;
    }
    return _loveGiftView;
}

- (UIView *)longPreGetrueMaskView {
    if (!_longPreGetrueMaskView) {
        _longPreGetrueMaskView = [[UIView alloc] init];
        _longPreGetrueMaskView.hidden = YES;
    }
    return _longPreGetrueMaskView;
}

@end
