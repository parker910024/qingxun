//
//  TTSendGiftAvatarView.m
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSendGiftAvatarView.h"

#import "TTSendGiftAvatarCell.h"

#import "GiftSendAllMicroAvatarInfo.h"
#import "AuthCore.h"
#import "RoomQueueCoreV2.h"
#import "UserCore.h"
#import "ImRoomCoreClientV2.h"
#import "RoomCoreV2.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "NSArray+Safe.h"
#import "UIImageView+QiNiu.h"

@interface TTSendGiftAvatarView ()<UICollectionViewDataSource, UICollectionViewDelegate, ImRoomCoreClientV2>
/** 麦序collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *targetAvatar;//送礼物用户头像（私聊界面）
@property (nonatomic, strong) UILabel *nickLabel;//nick
@property (nonatomic, strong) UIButton *userInfoButton;//用户资料
@property (nonatomic, strong) UIButton *reportButton;//举报

/** 麦上用户 */
@property (nonatomic, strong) NSMutableArray<GiftSendAllMicroAvatarInfo *> *microArray;
/** 全麦模型 */
@property (nonatomic, strong) GiftSendAllMicroAvatarInfo *allMicInfo;
/** 是否是 全麦送 */
@property (nonatomic, assign) BOOL isAllMicroSend;
/** 选中送礼物的人 */
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedUids;
/** 是否赠送给麦上的人 */
@property (nonatomic, assign) BOOL isSendOnMic;
@end

@implementation TTSendGiftAvatarView

#pragma mark - life cycle

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
//初始化后数据
- (void)initDisplayModel {
    //是否赠送给麦上的人
    if (!self.isSendOnMic) {
        return;
    }
    NSMutableArray *temp = [GetCore(RoomQueueCoreV2) findSendGiftMember];//麦上的人
    NSMutableArray *tempArr = [NSMutableArray array];//需要显示的人(如果自己在麦上去除自己)
    NSMutableArray *selectedUis = [NSMutableArray array];//选中送礼物的人
    
    // 如果是离开模式
    RoomInfo *roomInfo = GetCore(RoomCoreV2).getCurrentRoomInfo;
    if (roomInfo.leaveMode) {
        // userinfo
        NIMChatroomMember *charRoomMember = [[NIMChatroomMember alloc] init];
        charRoomMember.userId = [NSString stringWithFormat:@"%lld", roomInfo.uid];
        charRoomMember.roomAvatar = roomInfo.avatar;
        
        MicroState *state = [[MicroState alloc] init];
        state.position = -1; // 固定为房主位
        
        UserInfo *info = [GetCore(UserCore) getUserInfoInDB:roomInfo.uid];
        
        ChatRoomMicSequence *sequence = [[ChatRoomMicSequence alloc] init];
        sequence.userInfo = info;
        sequence.microState = state;
        sequence.chatRoomMember = charRoomMember;
        
        [temp insertObject:sequence atIndex:0];
    }
    
    for (ChatRoomMicSequence *item in temp) {
        GiftSendAllMicroAvatarInfo *info = [[GiftSendAllMicroAvatarInfo alloc]init];
        info.position = [NSString stringWithFormat:@"%d",item.microState.position];
        info.member = item.chatRoomMember;
        //有传入selectedUids,需要默认选中
        if ([self.selectedUids containsObject:item.chatRoomMember.userId]) {
            info.isSelected = YES;
        } else {
            info.isSelected = NO;
        }
        for (NSString *uid in self.selectedUids) { //有传入selectedUids
            if ([uid isEqualToString:item.chatRoomMember.userId]) {
                [selectedUis addObject:uid];
            }
        }
        //过滤掉自己在麦上的情况
        if (item.chatRoomMember.userId.userIDValue != [GetCore(AuthCore) getUid].userIDValue) {
            [tempArr addObject:info];
        }
    }
    if (selectedUis.count == 0 && tempArr.count > 0) {//没有传入selectedUids。默认选中第一个
        
//        GiftSendAllMicroAvatarInfo *info = tempArr[0];
//        [selectedUis addObject:info.member.userId];
//        info.isSelected = YES;
    }
    if ((selectedUis.count == tempArr.count) && tempArr.count > 1) {
        self.isAllMicroSend = YES;
    } else {
        self.isAllMicroSend = NO;
    }
    if (tempArr.count == 0) { //没有人在麦上
        self.isAllMicroSend = NO;
    }
    self.selectedUids = selectedUis;
    self.microArray = tempArr;
    
    [self.collectionView reloadData];
}

- (void)setTargetInfo:(UserInfo *)targetInfo {
    _targetInfo = targetInfo;
    if (_targetInfo.avatar || _targetInfo.uid == 0) { // _targetInfo.uid == 0点击工具类的礼物项目
        [self.targetAvatar qn_setImageImageWithUrl:self.targetInfo.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserIcon];
        [self updateUI];
    } else {
        @weakify(self)
        [GetCore(UserCore) getUserInfo:targetInfo.uid refresh:NO success:^(UserInfo *info) {
            @strongify(self)
            self.targetInfo = info;
            [self.targetAvatar qn_setImageImageWithUrl:self.targetInfo.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserIcon];
            [self updateUI];
        } failure:^(NSError * error) {
            [self updateUI];
        }];
    }
}

- (void)setUsingPlace:(XCSendGiftViewUsingPlace)usingPlace {
    _usingPlace = usingPlace;
    
    [self updateUI];
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.microArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTSendGiftAvatarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTSendGiftAvatarCell class]) forIndexPath:indexPath];
    
    GiftSendAllMicroAvatarInfo *displayInfo;
    if (indexPath.item == 0) {
        displayInfo = self.allMicInfo;
    } else {
        displayInfo = [self.microArray safeObjectAtIndex:indexPath.row - 1];
    }
    [cell configModle:displayInfo isAllMicSend:self.isAllMicroSend];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.isAllMicroSend = !self.isAllMicroSend;
        if (self.isAllMicroSend) {
            NSMutableArray *uids = [NSMutableArray array];
            for (GiftSendAllMicroAvatarInfo *item in self.microArray) {
                [uids addObject:item.member.userId];
            }
            self.selectedUids = uids;
        } else {
            [self.selectedUids removeAllObjects];
            if (self.microArray.count > 0) {
                [self.selectedUids addObject:self.microArray[0].member.userId];
            }
        }
    } else {
        GiftSendAllMicroAvatarInfo *item = self.microArray[indexPath.row - 1];
        item.isSelected = !item.isSelected;
        if (item.isSelected) {
            [self.selectedUids addObject:item.member.userId];
        } else {
            [self.selectedUids removeObject:item.member.userId];
        }
        
        self.isAllMicroSend = NO;
    }
    [self initDisplayModel];
}

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - ImRoomCoreClientV2
// 麦序更新
- (void)onGetRoomQueueSuccessV2:(NSMutableDictionary *)info {
    [self initDisplayModel];
}

#pragma mark - event response
- (void)userInfoButtonDidClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftAvatarView:didClickUserInfoButton:)]) {
        [self.delegate sendGiftAvatarView:self didClickUserInfoButton:button];
    }
}

- (void)reportButtonDidClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftAvatarView:didClickReportButton:)]) {
        [self.delegate sendGiftAvatarView:self didClickReportButton:button];
    }
}

#pragma mark - private method

- (void)updateUI {
    if (self.usingPlace == XCSendGiftViewUsingPlace_Message) {
        self.collectionView.hidden = YES;
        self.targetAvatar.hidden = NO;
        self.nickLabel.hidden = YES;
        self.userInfoButton.hidden = YES;
        self.reportButton.hidden = YES;
    } else if (self.usingPlace == XCSendGiftViewUsingPlace_Room) {
        NSString *position = [GetCore(RoomQueueCoreV2) findThePositionByUid:self.targetInfo.uid];
        
        self.nickLabel.hidden = YES;
        self.reportButton.hidden = YES;
        self.userInfoButton.hidden = YES;
        if (self.targetInfo.uid && !position) {//打赏麦下用户
            
            self.targetAvatar.hidden = NO;
            self.collectionView.hidden = YES;
            
            self.selectedUids = @[[NSString stringWithFormat:@"%lld", self.targetInfo.uid]].mutableCopy;
            
        } else {
            if (self.targetInfo.uid) {
                self.selectedUids = @[[NSString stringWithFormat:@"%lld", self.targetInfo.uid]].mutableCopy;
            }
            self.isSendOnMic = YES;
            self.targetAvatar.hidden = YES;
            self.collectionView.hidden = NO;
            [self initDisplayModel];
        }
    } else if (self.usingPlace == XCSendGiftViewUsingPlace_PublcChat || self.usingPlace == XCSendGiftViewUsingPlace_Team) {
        self.collectionView.hidden = YES;
        self.targetAvatar.hidden = NO;
        self.nickLabel.hidden = NO;
        self.userInfoButton.hidden = NO;
        self.reportButton.hidden = NO;
        
        self.nickLabel.text = self.targetInfo.nick;
    }
}

- (void)initView {
    [self addSubview:self.collectionView];
    
    [self addSubview:self.targetAvatar];
    [self addSubview:self.nickLabel];
    [self addSubview:self.reportButton];
    [self addSubview:self.userInfoButton];
    
    AddCoreClient(ImRoomCoreClientV2, self); // 监听麦序更新
    self.backgroundColor = RGBACOLOR(255, 255, 255, 0.01);
}

- (void)initConstrations {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.right.mas_equalTo(-7);
        make.top.bottom.mas_equalTo(self);
    }];
    
    [self.targetAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.centerY.mas_equalTo(self);
        make.height.width.mas_equalTo(30);
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.targetAvatar.mas_right).offset(6);
    }];
    
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.equalTo(self.userInfoButton.mas_left).offset(-8);
        make.width.height.equalTo(self.userInfoButton);
    }];
    
    [self.userInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
}

#pragma mark - getters and setters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(52, 55);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[TTSendGiftAvatarCell class] forCellWithReuseIdentifier:NSStringFromClass([TTSendGiftAvatarCell class])];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (GiftSendAllMicroAvatarInfo *)allMicInfo {
    if (!_allMicInfo) {
        _allMicInfo = [[GiftSendAllMicroAvatarInfo alloc] init];
        _allMicInfo.isAllMic = YES;
    }
    return _allMicInfo;
}

- (UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.font = [UIFont systemFontOfSize:14];
        _nickLabel.textColor = [UIColor whiteColor];
    }
    return _nickLabel;
}

- (UIImageView *)targetAvatar {
    if (!_targetAvatar) {
        _targetAvatar = [[UIImageView alloc] init];
        _targetAvatar.layer.masksToBounds = YES;
        _targetAvatar.layer.cornerRadius = 15;
        _targetAvatar.hidden = YES;
    }
    return _targetAvatar;
}

- (UIButton *)userInfoButton {
    if (!_userInfoButton) {
        _userInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userInfoButton setTitle:@"资料" forState:UIControlStateNormal];
        _userInfoButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_userInfoButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _userInfoButton.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        
        _userInfoButton.layer.borderWidth = 0.5;
        _userInfoButton.layer.cornerRadius = 4;
        [_userInfoButton addTarget:self action:@selector(userInfoButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userInfoButton;
}

- (UIButton *)reportButton{
    if (!_reportButton) {
        _reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
        _reportButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_reportButton setTitleColor:UIColorRGBAlpha(0xffffff, 0.4) forState:UIControlStateNormal];
        [_reportButton addTarget:self action:@selector(reportButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportButton;
}

@end
