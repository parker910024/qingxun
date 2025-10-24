//
//  TTSendGiftMiddleView.m
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSendGiftMiddleView.h"

#import "TTSendGiftViewConfig.h"
#import "TTSendGiftContainCell.h"
#import "TTEmptyPackGiftView.h"

//core
#import "AuthCore.h"
#import "UserCore.h"
#import "GiftCore.h"
#import "GiftCoreClient.h"
#import "RoomMagicCore.h"
#import "RoomMagicCoreClient.h"

#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "XCTheme.h"
#import "NSArray+Safe.h"
#import "XCHUDTool.h"

// 礼物喊话最长内容
#define MAX_MESSAGE_LENGTH 15

@interface TTSendGiftMiddleView ()<UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, RoomMagicCoreClient, GiftCoreClient, TTSendGiftContainCellDelegate>
/** 礼物面板，魔法，礼物背包公用collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 分页控件 */
@property (nonatomic, strong) UIPageControl *pageController;
/** 礼物喊话 */
@property (nonatomic, strong) UITextField *msgTextField;
/** 没有背包礼物view */
@property (nonatomic, strong) TTEmptyPackGiftView *emptyPackGiftView;

@property (strong, nonatomic) NSMutableArray<GiftInfo *> *giftPackOriginInfos;//礼物背包数据源 用于处理背包礼物赠送成功的数据源计算
@property (nonatomic, strong) NSMutableArray *giftInfos;//礼物 数据源
@property (nonatomic, strong) NSMutableArray *magicInfos;//魔法 数据源
@property (nonatomic, strong) NSMutableArray *giftPackInfos;//礼物背包 数据源
@property (nonatomic, strong) NSMutableArray *giftNobleInfos;//贵族礼物 数据源
@property (nonatomic, strong) GiftInfo *lastSelectGiftInfo;//上次选择的礼物
@property (nonatomic, strong) RoomMagicInfo *lastSelectMagicInfo;//上次选择的魔法
@property (nonatomic, strong) GiftInfo *lastSelectNobleInfo;//上次选择的贵族礼物
@property (nonatomic, strong) GiftInfo *lastSelectPackInfo;//上次选择的礼物背包
@property (nonatomic, assign) BOOL isFrist;//是否第一页
@property (nonatomic, strong) UserInfo *myUserInfo;
/** 房间礼物面板时, 房间uid */
@property (nonatomic, assign) NSInteger roomUid;

/// 是否初始化布局完成
@property (nonatomic, assign) BOOL didInitialLayout;

@end

@implementation TTSendGiftMiddleView

#pragma mark - life cycle

- (void)dealloc {
    RemoveCoreClientAll(self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //解决第一个礼物有喊麦功能时导致高度不足
    if (!CGRectEqualToRect(CGRectZero, self.frame)) {
        if (!self.didInitialLayout) {
            self.didInitialLayout = YES;
            [self selectedGift:self.lastSelectGiftInfo];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

#pragma mark - public methods
- (instancetype)initWithRoomUid:(NSInteger)roomUid {
    if (self = [self initWithFrame:CGRectZero]) {
        
        self.roomUid = roomUid;
        
        [self initView];
        [self initConstrations];
        [self addCore];
    }
    return self;
}

- (void)setCurrentType:(SelectGiftType)currentType {
    _currentType = currentType;
    
    [self.collectionView setContentOffset:CGPointMake(0, 0)];
    [self.collectionView reloadData];
    
    if (currentType == SelectGiftType_gift) {
        self.pageController.hidden = self.giftInfos.count > 0 ? NO : YES;
        if ([self.giftInfos.firstObject isKindOfClass:[NSArray class]]) {
            [self.pageController setNumberOfPages:self.giftInfos.count];
        }
        if (self.lastSelectGiftInfo && self.lastSelectGiftInfo.isSendMsg) {
            [self showTextField];
        } else {
            [self hideTextField];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftMiddleView:didSelectGift:)]) {
            [self.delegate sendGiftMiddleView:self didSelectGift:self.lastSelectGiftInfo];
        }
    } else if (currentType == SelectGiftType_magic) {
        self.pageController.hidden = self.magicInfos.count > 0 ? NO : YES;
        if ([self.magicInfos.firstObject isKindOfClass:[NSArray class]]) {
            [self.pageController setNumberOfPages:self.magicInfos.count];
        }
        [self hideTextField];
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftMiddleView:didSelectGift:)]) {
            [self.delegate sendGiftMiddleView:self didSelectGift:self.lastSelectMagicInfo];
        }
    } else if (currentType == SelectGiftType_giftPackage) {
        if (self.lastSelectPackInfo.isSendMsg) {
            [self showTextField];
        } else {
            [self hideTextField];
        }
        self.pageController.hidden = self.giftPackInfos.count > 1 ? NO : YES;
        if ([self.giftPackInfos.firstObject isKindOfClass:[NSArray class]]) {
            [self.pageController setNumberOfPages:self.giftPackInfos.count];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftMiddleView:didSelectGift:)]) {
            [self.delegate sendGiftMiddleView:self didSelectGift:self.lastSelectPackInfo];
        }
    } else if (currentType == SelectGiftType_nobleGift) {
        self.pageController.hidden = self.giftNobleInfos.count > 0 ? NO : YES;
        if ([self.giftNobleInfos.firstObject isKindOfClass:[NSArray class]]) {
            [self.pageController setNumberOfPages:self.giftNobleInfos.count];
        }
        if (self.lastSelectNobleInfo.isSendMsg) {
            [self showTextField];
        } else {
            [self hideTextField];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftMiddleView:didSelectGift:)]) {
            [self.delegate sendGiftMiddleView:self didSelectGift:self.lastSelectNobleInfo];
        }
    }
}

- (void)setUsingPlace:(XCSendGiftViewUsingPlace)usingPlace {
    _usingPlace = usingPlace;
    
    [self initDatas];
}

#pragma mark - scrollviewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.collectionView) {
        return;
    }
    
    if (!self.isFrist) {
        self.isFrist = YES;
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    CGFloat offX =  scrollView.contentOffset.x;
    CGFloat width = CGRectGetWidth(scrollView.frame);
    self.pageController.currentPage = ceilf(offX/width);
}

#pragma mark - UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.currentType == SelectGiftType_gift) {
        self.emptyPackGiftView.hidden = YES;
        return self.giftInfos.count;
    } else if (self.currentType == SelectGiftType_magic) {
        self.emptyPackGiftView.hidden = YES;
        return self.magicInfos.count;
    } else if(self.currentType == SelectGiftType_giftPackage) {
        self.emptyPackGiftView.hidden = self.giftPackInfos.count;
        return self.giftPackInfos.count;
    } else if(self.currentType == SelectGiftType_nobleGift) {
        self.emptyPackGiftView.hidden = self.giftNobleInfos.count;
        return self.giftNobleInfos.count;
    } else {
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTSendGiftContainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTSendGiftContainCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.section = indexPath.section;
    cell.type = self.currentType;
    if (self.currentType == SelectGiftType_gift) {
        cell.giftInfos = [self.giftInfos safeObjectAtIndex:indexPath.section];
    } else if (self.currentType == SelectGiftType_magic) {
        cell.maigcInfos = [self.magicInfos safeObjectAtIndex:indexPath.section];
    } else if (self.currentType == SelectGiftType_giftPackage) {
        cell.giftPackInfos = [self.giftPackInfos safeObjectAtIndex:indexPath.section];
    } else if (self.currentType == SelectGiftType_nobleGift) {
        cell.nobleGiftInfos = [self.giftNobleInfos safeObjectAtIndex:indexPath.section];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.collectionView){
        [self reset];
        TTSendGiftContainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTSendGiftContainCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.section = indexPath.section;
        cell.type = self.currentType;
        if (self.currentType == SelectGiftType_gift) {
            self.lastSelectGiftInfo.isSelected = YES;
            cell.giftInfos = [self.giftInfos safeObjectAtIndex:indexPath.section];
        } else if (self.currentType == SelectGiftType_magic) {
            self.lastSelectMagicInfo.isSelected = YES;
            cell.maigcInfos = [self.magicInfos safeObjectAtIndex:indexPath.section];
        } else if (self.currentType == SelectGiftType_giftPackage) {
            self.lastSelectPackInfo.isSelected = YES;
            cell.giftPackInfos = [self.giftPackInfos safeObjectAtIndex:indexPath.section];
        } else if (self.currentType == SelectGiftType_nobleGift) {
            self.lastSelectNobleInfo.isSelected = YES;
            cell.giftInfos = [self.giftNobleInfos safeObjectAtIndex:indexPath.section];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TTSendGiftContainCellDelegate
- (void)sendGiftContainCell:(TTSendGiftContainCell *)giftContainCell didSelectedGift:(GiftInfo *)giftInfo {
    [self reset];
    [self selectedGift:giftInfo];
}

- (void)sendGiftContainCell:(TTSendGiftContainCell *)giftContainCell didSelectedPackageGift:(GiftInfo *)giftPackInfo {
    if (self.lastSelectPackInfo && self.lastSelectPackInfo.isSelected) {
        self.lastSelectPackInfo.isSelected = NO;
    }
    giftPackInfo.isSelected = YES;
    self.lastSelectPackInfo = giftPackInfo;
    if (giftPackInfo.isSendMsg) {
        [self showTextField];
    } else {
        [self hideTextField];
    }
    [self.collectionView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftMiddleView:didSelectGift:)]) {
        [self.delegate sendGiftMiddleView:self didSelectGift:giftPackInfo];
    }
}

- (void)sendGiftContainCell:(TTSendGiftContainCell *)giftContainCell didSelectedMagic:(RoomMagicInfo *)magicInfo {
    if (self.lastSelectMagicInfo && self.lastSelectMagicInfo.isSelected) {
        self.lastSelectMagicInfo.isSelected = NO;
    }
    magicInfo.isSelected = YES;
    self.lastSelectMagicInfo = magicInfo;
    [self.collectionView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftMiddleView:didSelectGift:)]) {
        [self.delegate sendGiftMiddleView:self didSelectGift:magicInfo];
    }
}

- (void)sendGiftContainCell:(TTSendGiftContainCell *)giftContainCell didSelectedNobleGift:(GiftInfo *)nobleGiftInfo {
    if (self.myUserInfo.nobleUsers.level < nobleGiftInfo.nobleId) {
        if ([self.delegate respondsToSelector:@selector(sendGiftMiddleView:currentNobleLevel:needNobelLevel:)]) {
            [self.delegate sendGiftMiddleView:self currentNobleLevel:self.myUserInfo.nobleUsers.level needNobelLevel:self.myUserInfo.nobleUsers.level];
        }
        return;
    }
    
    if (self.lastSelectNobleInfo && self.lastSelectNobleInfo.isSelected) {
        self.lastSelectNobleInfo.isSelected = NO;
    }
    nobleGiftInfo.isSelected = YES;
    self.lastSelectNobleInfo = nobleGiftInfo;
    [self.collectionView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftMiddleView:didSelectGift:)]) {
        [self.delegate sendGiftMiddleView:self didSelectGift:nobleGiftInfo];
    }
}

#pragma mark - RoomMagicCoreClient
// 魔法数据源更新
- (void)onRoomMagicListNeedRefresh {
    self.magicInfos = [GetCore(RoomMagicCore) getRoomMagicType:RoomMagicTypeNormal];
    [self dealMagicArray];
    [self.collectionView reloadData];
}

#pragma mark - GiftCoreClient
// 礼物数据源更新
- (void)onGiftIsRefresh {
    self.giftInfos = [GetCore(GiftCore) getGameRoomGiftType:GameRoomGiftType_Normal roomUid:self.roomUid];
    self.giftNobleInfos = [GetCore(GiftCore) getGameRoomGiftType:GameRoomGiftType_Noble roomUid:self.roomUid];
    [self dealGiftDataArray];
    [self dealNobleDataArray];
    [self.collectionView reloadData];
}

/** 请求房间普通礼物 + 专属礼物 失败的回调 */
- (void)onRequestGiftListFailth:(NSString *)message roomUid:(NSInteger)roomUid {
    
    // 请求失败, 则使用 基础的礼物列表数据
    self.giftInfos = [GetCore(GiftCore) getGameRoomGiftType:GameRoomGiftType_Normal roomUid:0];
    self.giftNobleInfos = [GetCore(GiftCore) getGameRoomGiftType:GameRoomGiftType_Noble roomUid:0];
    [self dealGiftDataArray];
    [self dealNobleDataArray];
    [self.collectionView reloadData];
}

// 礼物下线
- (void)onGiftIsOffLine:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message];
}

// 获取背包数据成功
- (void)onBackPackGiftSuccess:(NSArray<GiftInfo *> *)infos {
    self.giftPackInfos = infos.mutableCopy;
    [self dealPackArray];
}

// 获取背包数据失败
- (void)onBackPackGiftFailed:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message];
}

// 背包礼物赠送成功 处理背包数据
- (void)onUpdatePackGiftWithGiftId:(NSInteger)giftId giftNum:(NSInteger)count microCount:(NSInteger)microCount {
    
    @KWeakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @KStrongify(self);
        NSMutableArray *dealArray = self.giftPackOriginInfos.mutableCopy;
        if (self.lastSelectPackInfo.giftId == giftId) {
            NSInteger number = self.lastSelectPackInfo.count - count*microCount;
            if (number <= 0) {
                [dealArray removeObject:self.lastSelectPackInfo];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.giftPackInfos = dealArray;
                    [self dealPackArray];
                    return;
                });
            } else {
                self.lastSelectPackInfo.count = number;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            return ;
        }
        __block GiftInfo *tagGiftInfo;
        [dealArray enumerateObjectsUsingBlock:^(GiftInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.giftId == giftId) {
                tagGiftInfo = obj;
                *stop = YES;
            }
        }];
        if (tagGiftInfo) {
            NSInteger number = tagGiftInfo.count - count*microCount;
            tagGiftInfo.count = number;
            if (number <= 0) {
                [dealArray removeObject:tagGiftInfo];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.giftPackInfos = dealArray;
                    [self dealPackArray];
                });
                return ;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    });
}

// 萝卜不足
- (void)onGiftNotCarrotToPay:(NSString *)message {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftMiddleView:notEnoughtCarrot:)]) {
        [self.delegate sendGiftMiddleView:self notEnoughtCarrot:message];
    }
}

#pragma mark - event response
- (void)msgTextFieldEditChanged:(NSNotification *)obj {
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {// 简体中文输入
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > MAX_MESSAGE_LENGTH) {
                [XCHUDTool showErrorWithMessage:@"输入文字不能大于15字"];
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_MESSAGE_LENGTH];
                if (rangeIndex.length == 1) {
                    textField.text = [toBeString substringToIndex:MAX_MESSAGE_LENGTH];
                } else {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_MESSAGE_LENGTH)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
    } else { // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > MAX_MESSAGE_LENGTH) {
            [XCHUDTool showErrorWithMessage:@"输入文字不能大于15字"];
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_MESSAGE_LENGTH];
            if (rangeIndex.length == 1) {
                textField.text = [toBeString substringToIndex:MAX_MESSAGE_LENGTH];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_MESSAGE_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

#pragma mark - private method
// 显示喊话输入框
- (void)showTextField {
    [self.msgTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
    }];
    self.msgTextField.hidden = NO;
    [self.superview.superview layoutIfNeeded];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftMiddleView:layoutMsgTextField:)]) {
        [self.delegate sendGiftMiddleView:self layoutMsgTextField:YES];
    }
}

// 隐藏喊话输入框
- (void)hideTextField {
    [self.msgTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    self.msgTextField.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftMiddleView:layoutMsgTextField:)]) {
        [self.delegate sendGiftMiddleView:self layoutMsgTextField:NO];
    }
}

//重置
- (void)reset {
    for (NSArray *infos in self.giftInfos) {
        if([infos isKindOfClass:[NSArray class]]){
            for (GiftInfo *info in infos) {
                info.isSelected = NO;
            }
        }
    }
    for (NSArray *infos in self.magicInfos) {
        if([infos isKindOfClass:[NSArray class]]){
            for (RoomMagicInfo *info in infos) {
                info.isSelected = NO;
            }
        }
    }
    for (NSArray *infos in self.giftPackInfos) {
        if([infos isKindOfClass:[NSArray class]]){
            for (GiftInfo *info in infos) {
                info.isSelected = NO;
            }
        }
    }
    for (NSArray *infos in self.giftNobleInfos) {
        if([infos isKindOfClass:[NSArray class]]){
            for (GiftInfo *info in infos) {
                info.isSelected = NO;
            }
        }
    }
}

- (void)dealGiftDataArray {
    
    [self removeBoxGift];
    GiftInfo *firstGift = self.giftInfos.firstObject;
    self.giftInfos = [self dealArray:self.giftInfos];
    
    if (!firstGift) {
        return;
    }
    
    [self selectedGift:firstGift];
}

- (void)dealMagicArray {
    if (!self.magicInfos.count) {
        return ;
    }
    RoomMagicInfo *fristInfo = self.magicInfos.firstObject;
    fristInfo.isSelected = YES;
    self.lastSelectMagicInfo = fristInfo;
    self.magicInfos = [self dealArray:self.magicInfos];
    [self.collectionView reloadData];
}

- (void)dealNobleDataArray{
    if (!self.giftNobleInfos.count) {
        return ;
    }
    GiftInfo *fristInfo = self.giftNobleInfos.firstObject;
    fristInfo.isSelected = YES;
    self.lastSelectNobleInfo = fristInfo;
    self.giftNobleInfos = [self dealArray:self.giftNobleInfos];
    [self.collectionView reloadData];
}

- (void)dealPackArray {
    if (!self.giftPackInfos.count) {
        return ;
    }
    GiftInfo *fristInfo = self.giftPackInfos.firstObject;
    fristInfo.isSelected = YES;
    self.lastSelectPackInfo = fristInfo;
    self.giftPackOriginInfos = self.giftPackInfos;
    self.giftPackInfos = [self dealArray:self.giftPackInfos];
    [self.collectionView reloadData];
}

/// 构造 8xN 二维数组
/// @param sourceArray 一维数组数据源
- (NSMutableArray *)dealArray:(NSMutableArray *)sourceArray {
    NSMutableArray *sectionArray = @[].mutableCopy;
    NSInteger row = sourceArray.count / 8;
    for (int i = 0; i< row; i++) {
        NSMutableArray *itemArray = @[].mutableCopy;
        for (int j = 0; j < 8; j++) {
            id info = [sourceArray safeObjectAtIndex:i*8+j];
            [itemArray addObject:info];
        }
        [sectionArray addObject:itemArray];
    }
    
    //余数
    NSInteger remainder = sourceArray.count % 8;
    if (remainder > 0) {
        NSMutableArray  *remainderArray = @[].mutableCopy;
        for (int i = 0; i < remainder; i++) {
            [remainderArray addObject:[sourceArray safeObjectAtIndex:row*8+i]];
        }
        [sectionArray addObject:remainderArray];
    }
    return sectionArray;
}

/// 房间以外的其他地方，不显示盲盒礼物，故移除
- (void)removeBoxGift {
    if (self.usingPlace == XCSendGiftViewUsingPlace_Room) {
        return;
    }
    
    NSMutableArray *gifts = [NSMutableArray arrayWithCapacity:self.giftInfos.count];
    for (GiftInfo *gift in self.giftInfos) {
        if (gift.consumeType != GiftConsumeTypeBox) {
            [gifts addObject:gift];
        }
    }
    
    self.giftInfos = gifts;
}

/// 选中礼物处理
- (void)selectedGift:(GiftInfo *)gift {
    
    gift.isSelected = YES;
    self.lastSelectGiftInfo = gift;
    
    if (gift.isSendMsg) {
        [self showTextField];
    } else {
        [self hideTextField];
    }
    
    [self.collectionView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftMiddleView:didSelectGift:)]) {
        [self.delegate sendGiftMiddleView:self didSelectGift:gift];
    }
}

- (void)initView {
    [self addSubview:self.collectionView];
    [self addSubview:self.pageController];
    [self addSubview:self.msgTextField];
    [self addSubview:self.emptyPackGiftView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgTextFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.msgTextField];
}

- (void)addCore {
    AddCoreClient(GiftCoreClient, self); // 监听礼物/赠送的网络请求
    AddCoreClient(RoomMagicCoreClient, self); // 监听魔法数据更新
    [GetCore(RoomMagicCore) requestRoomMagicList]; // 魔法
    [GetCore(GiftCore) getPackGift]; // 背包礼物
}

- (void)initConstrations {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(210);
    }];
    
    [self.pageController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.msgTextField.mas_bottom).mas_equalTo(2);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(6);
        make.bottom.mas_equalTo(self);
    }];
    
    [self.msgTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(0);
    }];
    
    [self.emptyPackGiftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self);
    }];
}

- (void)initDatas {
    self.magicInfos = [GetCore(RoomMagicCore) getRoomMagicType:RoomMagicTypeNormal];
    self.giftInfos = [GetCore(GiftCore) getGameRoomGiftType:GameRoomGiftType_Normal roomUid:self.roomUid];
    self.giftNobleInfos = [GetCore(GiftCore) getGameRoomGiftType:GameRoomGiftType_Noble roomUid:self.roomUid];
    
    [self dealGiftDataArray];
    [self dealMagicArray];
    [self dealNobleDataArray];
    [self.pageController setNumberOfPages:self.giftInfos.count];
    
    UserID myUid = [GetCore(AuthCore) getUid].userIDValue;
    self.myUserInfo = [GetCore(UserCore) getUserInfoInDB:myUid];
}

#pragma mark - getters and setters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(KScreenWidth, 210);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[TTSendGiftContainCell class] forCellWithReuseIdentifier:NSStringFromClass([TTSendGiftContainCell class])];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIPageControl *)pageController {
    if (!_pageController) {
        _pageController = [[UIPageControl alloc] init];
        _pageController.currentPageIndicatorTintColor = RGBCOLOR(207, 207, 207);
    }
    return _pageController;
}

- (UITextField *)msgTextField {
    if (!_msgTextField) {
        _msgTextField = [[UITextField alloc] init];
        
        NSMutableAttributedString *attMStr = [[NSMutableAttributedString alloc] init];
        NSAttributedString *att1 = [[NSAttributedString alloc] initWithString:@"请喊话..." attributes:@{NSForegroundColorAttributeName : RGBACOLOR(255, 255, 255, 0.5), NSFontAttributeName : [UIFont systemFontOfSize:14]}];
        NSAttributedString *att2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"（如：%@）", [TTSendGiftViewConfig globalConfig].room_gift_sendMsg_default] attributes:@{NSForegroundColorAttributeName : RGBACOLOR(255, 255, 255, 0.1), NSFontAttributeName : [UIFont systemFontOfSize:14]}];
        [attMStr appendAttributedString:att1];
        [attMStr appendAttributedString:att2];

        _msgTextField.attributedPlaceholder = attMStr;
        
        _msgTextField.font = [UIFont systemFontOfSize:14];
        _msgTextField.textColor = UIColorRGBAlpha(0xffffff, 0.5);
        _msgTextField.backgroundColor = UIColorRGBAlpha(0xF5F5F5, 0.05);
        _msgTextField.hidden = YES;
        _msgTextField.delegate = self;
        _msgTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        _msgTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _msgTextField;
}

- (TTEmptyPackGiftView *)emptyPackGiftView {
    if (!_emptyPackGiftView) {
        _emptyPackGiftView = [[TTEmptyPackGiftView alloc] init];
    }
    return _emptyPackGiftView;
}

@end
