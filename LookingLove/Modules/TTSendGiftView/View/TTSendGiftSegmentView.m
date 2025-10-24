//
//  TTSendGiftSegmentView.m
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSendGiftSegmentView.h"

#import "TTSendGiftSegmentCell.h"

#import "TTSendGiftSegmentItem.h"

#import "UserCore.h"
#import "AuthCore.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "NSArray+Safe.h"

@interface TTSendGiftSegmentView ()<UICollectionViewDataSource, UICollectionViewDelegate>
/** 菜单collectionView */
@property (strong, nonatomic) UICollectionView *collectionView;
/** 开通贵族 */
@property (nonatomic, strong) UIButton *becomeNobelButton;
/// 首次充值按钮
@property (nonatomic, strong) UIButton *firstRechargeButton;

/** 操作选项 */
@property (nonatomic, strong) NSArray<TTSendGiftSegmentItem *> *segmentArray;
/** 记录选中的segment */
@property (nonatomic, strong) TTSendGiftSegmentItem *selectedSegmentItem;
/** 当前选择的礼物类型 */
@property (nonatomic, assign) SelectGiftType currentType;
/** 我的用户信息 */
@property (nonatomic, strong) UserInfo *myUserInfo;
@end

@implementation TTSendGiftSegmentView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods
- (void)setUsingPlace:(XCSendGiftViewUsingPlace)usingPlace {
    _usingPlace = usingPlace;
    
    [self refreshButtonUsingPlace:usingPlace];
    
    self.segmentArray = [self createSegmentDataArray];
    // 默认选中第一个
    self.selectedSegmentItem = self.segmentArray.firstObject;
    self.selectedSegmentItem.isSelected = YES;
    [self.collectionView reloadData];
}

/// 首次充值按钮更新
- (void)updateFirstRechargeButtonLayout:(BOOL)isFirst {
    // 用户已经充值过了不做处理
    if (!isFirst) {
        
        if (!self.firstRechargeButton.hidden) {
            self.firstRechargeButton.hidden = YES;
        }
        
        [self refreshButtonUsingPlace:self.usingPlace];
        
        return;
    }
    
    // 用户注册后还未充值过
    self.firstRechargeButton.hidden = !isFirst;
    
    if (!self.becomeNobelButton.hidden) {
        self.becomeNobelButton.hidden = YES;
    }
}

- (void)refreshButtonUsingPlace:(XCSendGiftViewUsingPlace)usingPlace {
    if (usingPlace == XCSendGiftViewUsingPlace_Message) {
        self.becomeNobelButton.hidden = YES;
    } else if (usingPlace == XCSendGiftViewUsingPlace_Room) {
        self.becomeNobelButton.hidden = self.myUserInfo.nobleUsers.level > 0 ? YES : NO;
    } else if (usingPlace == XCSendGiftViewUsingPlace_PublcChat || usingPlace == XCSendGiftViewUsingPlace_Team) {
        self.becomeNobelButton.hidden = YES;
    }
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.segmentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTSendGiftSegmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTSendGiftSegmentCell class]) forIndexPath:indexPath];
    
    TTSendGiftSegmentItem *item = [self.segmentArray safeObjectAtIndex:indexPath.item];
    cell.segmentItem = item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedSegmentItem.isSelected = NO;
    TTSendGiftSegmentItem *item = [self.segmentArray safeObjectAtIndex:indexPath.item];
    item.isSelected = YES;
    self.selectedSegmentItem = item;
    
    switch (indexPath.item) {
        case 0:
            self.currentType = SelectGiftType_gift;
            break;
        case 1:
            self.currentType = SelectGiftType_nobleGift;
            break;
        case 2:
            self.currentType = (self.usingPlace == XCSendGiftViewUsingPlace_Room) ? SelectGiftType_magic : SelectGiftType_giftPackage;
            break;
        case 3:
            self.currentType = SelectGiftType_giftPackage;
            break;
        default:
            self.currentType = SelectGiftType_gift;
            break;
    }
    
    [self.collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(sendGiftSegmentView:didClickSegmentItem:SelectGiftType:)]) {
        [self.delegate sendGiftSegmentView:self didClickSegmentItem:item SelectGiftType:self.currentType];
    }
}

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)becomeNobeButtonDidClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftSegmentView:didClickBecomeNobeButton:)]) {
        [self.delegate sendGiftSegmentView:self didClickBecomeNobeButton:btn];
    }
}

- (void)onClickFirstRechargeButtonClickAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftSegmentView:didClickFirstRechargeButton:)]) {
        [self.delegate sendGiftSegmentView:self didClickFirstRechargeButton:button];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.collectionView];
    [self addSubview:self.becomeNobelButton];
    [self addSubview:self.firstRechargeButton];
    
    UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
    self.myUserInfo = [GetCore(UserCore) getUserInfoInDB:myUid];
    
    self.currentType = SelectGiftType_gift;
}

- (void)initConstrations {
    [self.becomeNobelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.mas_equalTo(self);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(30);
    }];
    
    // height 36
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self);
        make.right.mas_equalTo(-88);
    }];
    
    [self.firstRechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.mas_equalTo(self);
    }];
}

- (NSArray<TTSendGiftSegmentItem *> *)createSegmentDataArray {
    NSArray *segmentArray = nil;
    if (self.usingPlace == XCSendGiftViewUsingPlace_Room) {
        segmentArray = @[[TTSendGiftSegmentItem itemWithTitle:@"礼物"],
                         [TTSendGiftSegmentItem itemWithTitle:@"贵族"],
                         [TTSendGiftSegmentItem itemWithTitle:@"魔法"],
                         [TTSendGiftSegmentItem itemWithTitle:@"背包"]];
        
    } else {
        segmentArray = @[[TTSendGiftSegmentItem itemWithTitle:@"礼物"],
                         [TTSendGiftSegmentItem itemWithTitle:@"贵族"],
                         [TTSendGiftSegmentItem itemWithTitle:@"背包"]];
    }
    return segmentArray;
}

#pragma mark - getters and setters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(30, 30);
        layout.minimumLineSpacing = 20;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[TTSendGiftSegmentCell class] forCellWithReuseIdentifier:NSStringFromClass([TTSendGiftSegmentCell class])];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (UIButton *)becomeNobelButton{
    if (!_becomeNobelButton) {
        _becomeNobelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_becomeNobelButton setImage:[UIImage imageNamed:@"room_gift_become_noble"] forState:UIControlStateNormal];
        [_becomeNobelButton addTarget:self action:@selector(becomeNobeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _becomeNobelButton;
}

- (UIButton *)firstRechargeButton{
    if (!_firstRechargeButton) {
        _firstRechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _firstRechargeButton.hidden = YES;
        [_firstRechargeButton setImage:[UIImage imageNamed:@"gift_firstRecharge_icon"] forState:UIControlStateNormal];
        [_firstRechargeButton addTarget:self action:@selector(onClickFirstRechargeButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstRechargeButton;
}

@end
