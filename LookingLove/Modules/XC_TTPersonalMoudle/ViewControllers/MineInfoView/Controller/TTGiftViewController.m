//
//  TTGiftViewController.m
//  TuTu
//
//  Created by lee on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTGiftViewController.h"

#import "TTMineInfoEnumConst.h"

#import "TTMineInfoGiftCell.h"
#import "TTMineInfoMagicCell.h"
#import "TTMineInfoGiftEmptyCell.h"
#import "TTMineGiftAchievementCell.h"
#import "TTMineGiftSwitchView.h"
#import "TTMineInfoGiftReusableHeaderView.h"

#import "RoomMagicCore.h"
#import "RoomMagicCoreClient.h"
#import "RoomMagicInfo.h"
#import "RoomMagicWallInfo.h"
#import "UserCore.h"
#import "UserCoreClient.h"
#import "UserInfo.h"
#import "UserGift.h"
#import "UserGiftAchievementList.h"
#import "AuthCore.h"

#import "NSArray+Safe.h"
#import "NSString+Utils.h"
#import "UIImageView+QiNiu.h"
#import "UIViewController+EmptyDataView.h"
#import "XCMacros.h"
#import "XCTheme.h"
#import "XCHUDTool.h"
#import "ZJScrollPageViewDelegate.h"
#import "TTStatisticsService.h"

#import <Masonry/Masonry.h>

@interface TTGiftViewController ()
<
ZJScrollPageViewChildVcDelegate,
RoomMagicCoreClient,
UserCoreClient
>

@property (nonatomic, strong) TTMineGiftSwitchView *switchView;//礼物展示切换
@property (nonatomic, assign) TTGiftExhibitType exhibitType;//礼物展示类型

@property (nonatomic, strong) NSArray<UserGift *> *userGiftList;//礼物
@property (nonatomic, strong) NSArray<RoomMagicWallInfo *> *userMagicList;//魔法礼物
@property (nonatomic, strong) NSArray<UserGift *> *userCarrotGiftList;//萝卜礼物
@property (nonatomic, strong) NSArray<UserGiftAchievementList *> *achievementGiftList;//礼物成就

///GCD Group Handler Helper
@property (nonatomic, copy) void (^giftRequestHandler)(void);
@property (nonatomic, copy) void (^magicGiftRequestHandler)(void);
@property (nonatomic, copy) void (^carrotGiftRequestHandler)(void);
@property (nonatomic, copy) void (^achievementGiftRequestHandler)(void);

@end

@implementation TTGiftViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(RoomMagicCoreClient, self);
    AddCoreClient(UserCoreClient, self);
    
    [self subviewsInitAndLayout];
    
    [self groupNotifyRequestAllAPI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *des = self.mineInfoStyle == TTMineInfoViewStyleDefault ? @"个人主页主态页" : @"个人主页客态页";
    [TTStatisticsService trackEvent:@"homepage_gift" eventDescribe:des];
}

- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
}

/**
 提示加载失败, 点击重试时会调用此方法, 控制器中请重写此方法, 重新请求数据
 */
- (void)reloadDataWhenLoadFail {
    if (self.exhibitType == TTGiftExhibitTypeAchievement) {
        [self requestAchievementGiftWithCompletion:nil];
    }
}

#pragma mark - collectionView delegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.exhibitType == TTGiftExhibitTypeAchievement) {
        return self.achievementGiftList.count;
    }
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.exhibitType == TTGiftExhibitTypeAchievement) {
        UserGiftAchievementList *list = [self.achievementGiftList safeObjectAtIndex:section];
        return list.giftList.count;
    }
    
    if (section == 2) {
        if (self.userGiftList.count) {
            return self.userGiftList.count;
        }
        return 1;
    }
    
    if (section == 1) {
        if (self.userCarrotGiftList.count) {
            return 1;
        }
        return 0;
    }
    
    if (self.userMagicList.count) {
        return 1; // 魔法墙，就只显示一行
    } // 如果没数据，就不显示
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.exhibitType == TTGiftExhibitTypeAchievement) {
        //礼物成就
        TTMineGiftAchievementCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(TTMineGiftAchievementCell.class) forIndexPath:indexPath];
        
        UserGiftAchievementList *list = [self.achievementGiftList safeObjectAtIndex:indexPath.section];
        UserGiftAchievementItem *data = [list.giftList safeObjectAtIndex:indexPath.item];
        cell.data = data;
        [cell configBgImageWithCategoryName:list.typeName];
        
        return cell;
    }
    
    if (indexPath.section == 2) {
        if (self.userGiftList.count) {
            // 礼物
            TTMineInfoGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTMineInfoGiftCell class]) forIndexPath:indexPath];
            if (self.userGiftList.count > indexPath.item) {
                [cell configCellModel:self.userGiftList[indexPath.item]];
            }
            return cell;
        }
        
        // 空白占位
        TTMineInfoGiftEmptyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTMineInfoGiftEmptyCell class]) forIndexPath:indexPath];
        return cell;
    }
    
    if (indexPath.section == 1) {
        // 萝卜
        TTMineInfoMagicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"carrotCell" forIndexPath:indexPath];
        cell.isCarrot = YES;
        cell.carrotGiftList = self.userCarrotGiftList;
        return cell;
    }
    
    // 魔法
    TTMineInfoMagicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTMineInfoMagicCell class]) forIndexPath:indexPath];
    cell.userMagicList = self.userMagicList;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TTMineInfoGiftReusableHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([TTMineInfoGiftReusableHeaderView class]) forIndexPath:indexPath];
        
        if (self.exhibitType == TTGiftExhibitTypeAchievement) {
            headerView.achievementGiftList = [self.achievementGiftList safeObjectAtIndex:indexPath.section];
            //客态页隐藏计数
            headerView.hiddenGiftCount = self.userID != [GetCore(AuthCore) getUid].userIDValue;
        } else {
            if (indexPath.section == 0) {
                headerView.userMagicList = self.userMagicList;
            } else if (indexPath.section == 2) {
                headerView.userGiftList = self.userGiftList;
            } else if (indexPath.section == 1) {
                headerView.carrotGiftList = self.userCarrotGiftList;
            }
        }
        
        reusableView = headerView;
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.exhibitType == TTGiftExhibitTypeAchievement) {
        //点击成就礼物时toast提示
        UserGiftAchievementList *list = [self.achievementGiftList safeObjectAtIndex:indexPath.section];
        UserGiftAchievementItem *data = [list.giftList safeObjectAtIndex:indexPath.item];
        if (data.tip.length > 0) {
            [XCHUDTool showSuccessWithMessage:data.tip];
        }
        
        NSString *event = data.tip.length > 0 ? @"homepage_gift_tip" : @"homepage_gift_no_tip";
        [TTStatisticsService trackEvent:event eventDescribe:data.giftName];
        return;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.exhibitType == TTGiftExhibitTypeAchievement) {
        NSInteger column = 4;
        CGFloat width = (KScreenWidth - 16*2 - 4*(column-1))/column;
        return CGSizeMake(width, 130.f);
    }
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        return CGSizeMake(KScreenWidth, 130.f);
    }
    
    if (self.userGiftList.count) {
        CGFloat itemW = (KScreenWidth - 16 * 2 - 9 * 3) / 4;
        CGFloat itemH = itemW + 45.f;
        return CGSizeMake(itemW, itemH);
    }
    return CGSizeMake(KScreenWidth, 201.f); // 占位图
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize itemSize = CGSizeMake(KScreenWidth, 36.f);
    
    if (self.exhibitType == TTGiftExhibitTypeAchievement) {
        return itemSize;
    }
    
    if (section == 0) {
        if (self.userMagicList.count) { // 如果有魔法墙数据 就显示
            return itemSize;
        }
        return CGSizeZero;// 如果没有 就隐藏
    }
    
    if (section == 1) {
        if (self.userCarrotGiftList.count) {
            return itemSize;
        }
        return CGSizeZero;// 如果没有 就隐藏
    }
    return itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    CGFloat bottom = 10;
    if (section == collectionView.numberOfSections - 1) {
        bottom = 84 + 15 + kSafeAreaBottomHeight;
    }
    
    if (self.exhibitType == TTGiftExhibitTypeReceive) {
        if (section == 0) {
            if (self.userMagicList.count == 0) {
                bottom = 0;
            }
        } else if (section == 1) {
            if (self.userCarrotGiftList.count == 0) {
                bottom = 0;
            }
        }
    }
    
    return UIEdgeInsetsMake(0, 16, bottom, 16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if (self.exhibitType == TTGiftExhibitTypeAchievement) {
        return 4;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    if (self.exhibitType == TTGiftExhibitTypeAchievement) {
        return 4;
    }
    return CGFLOAT_MIN;
}

#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}

#pragma mark - RoomMagicCoreClient
// 魔法墙
- (void)onRequestPersonMagicListSuccessWithUid:(UserID)uid andList:(NSArray *)list {
    
    if (uid == self.userID) {
        self.userMagicList = list;
        !self.magicGiftRequestHandler ?: self.magicGiftRequestHandler();
    }
}

- (void)onRequestPersonMagicListFailth:(NSString *)message {
    [XCHUDTool showErrorWithMessage:@"请求魔法墙失败" inView:self.view];
    !self.magicGiftRequestHandler ?: self.magicGiftRequestHandler();
}

#pragma mark - UserCoreClient
// 礼物
- (void)onGetReceiveGiftSuccess:(NSArray *)userGiftList uid:(UserID)uid {
    if (uid == self.userID) {
        self.userGiftList = userGiftList;
        !self.giftRequestHandler ?: self.giftRequestHandler();
    }
}

- (void)onGetReceiveGiftFailth:(NSString *)message {
    [XCHUDTool showErrorWithMessage:@"请求礼物墙失败" inView:self.view];
    !self.giftRequestHandler ?: self.giftRequestHandler();
}

// 获取礼物墙成就列表
- (void)onGetAchievementGiftSuccess:(NSArray *)achievementGiftList uid:(UserID)uid {
    if (uid == self.userID) {
        
        if (achievementGiftList == nil || achievementGiftList.count == 0) {
            self.exhibitType = TTGiftExhibitTypeReceive;
            [self.switchView forbidExhibitAchievementGift];
        }
        
        [self removeEmptyDataView];
        
        self.achievementGiftList = achievementGiftList;
        
        if (self.achievementGiftRequestHandler) {
            self.achievementGiftRequestHandler();
        } else {
            [self.collectionView reloadData];
        }
    }
}

- (void)onGetAchievementGiftFailth:(NSString *)message {
    
    [XCHUDTool showErrorWithMessage:@"请求礼物墙失败" inView:self.view];
    
    [self showLoadFailViewWithTitle:@"请求礼物墙失败" image:[UIImage imageNamed:@"common_no_network"] view:self.collectionView complete:nil];

    !self.achievementGiftRequestHandler ?: self.achievementGiftRequestHandler();
}

// 萝卜礼物墙数据
- (void)onGetReceiveCarrotGiftSuccess:(NSArray *)userGiftList uid:(UserID)uid code:(NSNumber *)code msg:(NSString *)msg {
    
    if (uid == self.userID) {
        self.userCarrotGiftList = userGiftList;
        !self.carrotGiftRequestHandler ?: self.carrotGiftRequestHandler();
    }
}

#pragma mark - Private Methods
#pragma mark Layout
- (void)subviewsInitAndLayout {
    
    [self.collectionView registerClass:[TTMineInfoGiftCell class] forCellWithReuseIdentifier:NSStringFromClass([TTMineInfoGiftCell class])];
    [self.collectionView registerClass:[TTMineInfoMagicCell class] forCellWithReuseIdentifier:NSStringFromClass([TTMineInfoMagicCell class])];
    [self.collectionView registerClass:[TTMineInfoMagicCell class] forCellWithReuseIdentifier:@"carrotCell"];
    [self.collectionView registerClass:[TTMineInfoGiftReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([TTMineInfoGiftReusableHeaderView class])];
    [self.collectionView registerClass:[TTMineInfoGiftEmptyCell class] forCellWithReuseIdentifier:NSStringFromClass([TTMineInfoGiftEmptyCell class])];
    [self.collectionView registerClass:[TTMineGiftAchievementCell class] forCellWithReuseIdentifier:NSStringFromClass([TTMineGiftAchievementCell class])];
    
    ///Layout
    
    [self.view addSubview:self.collectionView];
    
    @weakify(self)
    self.switchView = [[TTMineGiftSwitchView alloc] init];
    self.switchView.hidden = YES;
    [self.switchView setSwitchTypeHandler:^(TTGiftExhibitType type) {
        @strongify(self)
        self.exhibitType = type;
        [self.collectionView reloadData];
        
        NSString *des = type == TTGiftExhibitTypeAchievement ? @"礼物成就" : @"收到的礼物";
        [TTStatisticsService trackEvent:@"homepage_gift_change_tab" eventDescribe:des];
    }];
    [self.view addSubview:self.switchView];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40.0f);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.switchView.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
}

#pragma mark Network Request
/// 请求并监听所有接口
- (void)groupNotifyRequestAllAPI {
    
    ///各请求完成情况标志位，解决控制器未能成功消除时多次网络回调导致dispatch_group_leave被多次调用导致奔溃
    ///主要原因是，网络请求回调是监听式的，而非一一对应
    ///记录可能崩溃原因 https://satanwoo.github.io/2017/01/07/DispatchGroupCrash/
    __block BOOL giftFlag = NO;
    __block BOOL magicGiftFlag = NO;
    __block BOOL carrotGiftFlag = NO;
    __block BOOL achievementGiftFlag = NO;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self requestGiftWithCompletion:^{
        if (giftFlag) {
            return;
        }
        giftFlag = YES;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self requestMagicGiftWithCompletion:^{
        if (magicGiftFlag) {
            return;
        }
        magicGiftFlag = YES;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self requestCarrotGiftWithCompletion:^{
        if (carrotGiftFlag) {
            return;
        }
        carrotGiftFlag = YES;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self requestAchievementGiftWithCompletion:^{
        if (achievementGiftFlag) {
            return;
        }
        achievementGiftFlag = YES;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.switchView.hidden = NO;
        [self.collectionView reloadData];
    });
}

/// 请求礼物数据
/// @param completion 请求完成回调
- (void)requestGiftWithCompletion:(void (^)(void))completion {
    self.giftRequestHandler = completion;
    [GetCore(UserCore) getReceiveGift:self.userID orderType:2];
}

/// 请求魔法礼物数据
/// @param completion 请求完成回调
- (void)requestMagicGiftWithCompletion:(void (^)(void))completion {
    self.magicGiftRequestHandler = completion;
    [GetCore(RoomMagicCore) requestPersonMagicListByUid:self.userID];
}

/// 请求萝卜礼物数据
/// @param completion 请求完成回调
- (void)requestCarrotGiftWithCompletion:(void (^)(void))completion {
    self.carrotGiftRequestHandler = completion;
    [GetCore(UserCore) getReceiveCarrotGift:self.userID];
}

/// 获取礼物墙成就列表
/// @param completion 请求完成回调
- (void)requestAchievementGiftWithCompletion:(void (^)(void))completion {
    self.achievementGiftRequestHandler = completion;
    [GetCore(UserCore) getAchieveGiftForUid:self.userID];
}

@end
