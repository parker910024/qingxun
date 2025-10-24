//
//  TTDiscoverViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/1.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "LLDiscoverViewController.h"
#import "XCMediator+TTMessageMoudleBridge.h"

#import "TTPublicChatroomMessageProtocol.h"
//view
#import "TTInvitaFriendCollectionViewCell.h"
#import "TTDiscoverBannerCollectionViewCell.h"
#import "TTDiscoverCollectionReusableView.h"
#import "PDPublicChatSectionHeaderView.h"
#import "PDPublicChatCVCell.h"
#import "TTDiscoverHeadBannerCell.h"
#import "TTHomeRecommendHeadlineCell.h"

//core
#import "AuthCore.h"
#import "XCFamilyModel.h"
#import "DiscoveryCore.h"
#import "DiscoveryCoreClient.h"
#import "FamilyCore.h"
#import "FamilyCoreClient.h"
#import "DiscoveryBannerInfo.h"
#import "DiscoveryBannerInfo.h"

//Tool
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "XCTheme.h"
#import "TTInvitaFriendModel.h"
#import "TTDiscoverCheckInMissionNotiConst.h"
//vc
#import "TTDiscoverRookieViewController.h"
#import "TTFamilySquareViewController.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTRoomMoudleBridge.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "TTWKWebViewViewController.h"
#import "TTMissionContainViewController.h"
#import "TTMasterViewController.h"
#import "TTMissionViewController.h"

#import "TTStatisticsService.h"
#import "TTDiscoverCheckInMissionNotiConst.h"

static NSString *const kPublicChatCellID = @"kPublicChatCellID";
static NSString *const kPublicChatSecitonHeaderID = @"kPublicChatSecitonHeaderID";

static CGFloat const kPublicChatCellHeight = 488.0f + 50;


/**
 发现页分组
 
 - DiscoverSectionHeadBanner: 第一组 头部banner
 - DiscoverSectionToFu: 第二组 豆腐块
 - DiscoverSectionHeadLineNews: 第三组 头条新闻
 - DiscoverSectionFamily: 第四组 收徒
 - DiscoverSectionPublicChat: 第五组 公聊大厅
 */
typedef NS_ENUM(NSUInteger, DiscoverSection) {
    DiscoverSectionHeadBanner = 0,
    DiscoverSectionToFu = 1,
    DiscoverSectionHeadLineNews = 2,
    DiscoverSectionFamily = 3,
    DiscoverSectionPublicChat = 4,
};

@interface LLDiscoverViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DiscoveryCoreClient, FamilyCoreClient, TTPublicChatroomMessageProtocol, PDPublicChatCVCellDelegate, TTHomeRecommendHeadlineCellDelegate, TTDiscoverHeadBannerCellDelegate>
@property (nonatomic, strong) NSArray<DiscoveryBannerInfo *> *headBannerArray;
@property (nonatomic, strong) NSArray<DiscoverTofuInfo *> *tofuArray;
@property (nonatomic, strong) NSArray<XCFamilyModel *> * bannerArray;
@property (nonatomic, strong) DiscoveryMainData *mainData;
// 静态豆腐块数据
@property (nonatomic, strong) NSArray<NSString *> *staticBannerArray;
@property (nonatomic, strong) NSArray * userArray;

@property (nonatomic, strong) NSArray<TTInvitaFriendModel *> *section2Model;

/**
 公聊大厅数据
 */
@property (nonatomic, strong) NSArray<NIMMessageModel *> *publicChatModelArray;

/**
 公聊大厅 @我 的人
 */
@property (nonatomic, strong) NSString *publicChatAtMe;

@end

@implementation LLDiscoverViewController

#pragma mark - life cycle
- (void)dealloc {
    RemoveCoreClientAll(self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
    [self initView];
    [self initContrations];
    
    // 刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullDownRefresh:) name:TTDiscoverCheckInMissonRefreshNoti object:nil];
}

#pragma mark - private method
- (void)initView{
    self.publicChatModelArray = [[XCMediator sharedInstance] ttMessageMoudle_GetPublicChatRoomMessages];
    //头条
    [self.collectionView registerClass:[TTHomeRecommendHeadlineCell class] forCellWithReuseIdentifier:@"TTHomeRecommendHeadlineCell"];
    //banner
    [self.collectionView registerClass:[TTDiscoverHeadBannerCell class] forCellWithReuseIdentifier:@"TTDiscoverHeadBannerCell"];
    // 豆腐块
    [self.collectionView registerClass:[TTDiscoverBannerCollectionViewCell class] forCellWithReuseIdentifier:@"TTDiscoverBannerCollectionViewCell"];
    //邀请好友
    [self.collectionView registerClass:[TTInvitaFriendCollectionViewCell class] forCellWithReuseIdentifier:@"TTInvitaFriendCollectionViewCell"];
    [self.collectionView registerClass:[TTDiscoverCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TTDiscoverCollectionReusableView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
    
    [self.collectionView registerClass:PDPublicChatCVCell.class forCellWithReuseIdentifier:kPublicChatCellID];
    [self.collectionView registerClass:PDPublicChatSectionHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPublicChatSecitonHeaderID];
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self setupRefreshTarget:self.collectionView with:RefreshTypeHeader];
    [self pullDownRefresh:1];
    
    self.view.backgroundColor = [XCTheme getTTSimpleGrayColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)initContrations{
}

- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)addCore{
    AddCoreClient(FamilyCoreClient, self);
    AddCoreClient(DiscoveryCoreClient, self);
    AddCoreClient(TTPublicChatroomMessageProtocol, self);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - http
- (void)pullDownRefresh:(int)page{
    [GetCore(DiscoveryCore) requestDiscoverV2Info];
}

#pragma mark - response
- (void)sectionHeaderViewRecognizer:(UITapGestureRecognizer *)tap{
    TTDiscoverRookieViewController * rookieVC = [[TTDiscoverRookieViewController alloc] init];
    [self.navigationController pushViewController:rookieVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    !self.didScrollCallback ?: self.didScrollCallback(scrollView);
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.didScrollCallback = callback;
}

#pragma mark - DiscoveryCoreClient
// v2 版本接口回调
- (void)getDiscoveryInfoV2:(DiscoveryMainData *)mainData code:(NSInteger)code message:(NSString *)mssage {
    [self successEndRefreshStatus:0 hasMoreData:NO];
    if (!mainData) {
        return;
    }
    self.headBannerArray = mainData.bannerVos;
    self.tofuArray = mainData.banners;
    self.mainData = mainData;
    [self.collectionView reloadData];
}

#pragma mark - FamilyCoreClient
- (void)hhDiscoverNewUserListSuccess:(NSArray<UserInfo *> *)userList status:(int)status isTotal:(BOOL)isTotal{
    if (!isTotal) {
        self.userArray = userList;
        [self successEndRefreshStatus:0 hasMoreData:NO];
        self.section2Model = nil; // 置nil, 让他再次懒加载
        [self.collectionView reloadData];
    }
}

- (void)hhDiscoverNewUserListFail:(NSString *)message status:(int)status isTotal:(BOOL)isTotal{
    if (!isTotal) {
        [self failEndRefreshStatus:0];
    }
}

#pragma mark TTPublicChatroomMessageProtocol
- (void)onCurrentPublicChatroomMessageUpdate:(NSMutableArray *)messages {
    self.publicChatModelArray = [messages copy];
    [self.collectionView reloadSections:[[NSIndexSet alloc] initWithIndex:DiscoverSectionPublicChat]];
}

- (void)onCurrentPublicChatroomSomeBodyAtYou:(NSString *)name {
    self.publicChatAtMe = [name copy];
    [self.collectionView reloadSections:[[NSIndexSet alloc] initWithIndex:DiscoverSectionPublicChat]];
}

#pragma mark - PDPublicChatCVCellDelegate
- (void)didSelectTableViewRowWith:(PDPublicChatCVCell *)cell{
    UIViewController *vc = [[XCMediator sharedInstance] TTMessageMoudle_HeadLineViewContoller:1];
    [self.navigationController pushViewController:vc animated:YES];
    
    ///进入公聊大厅时，清空 @me
    self.publicChatAtMe = nil;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
}



#pragma mark -
#pragma mark TTHomeRecommendHeadlineCellDelegate
- (void)onCellDidSelectLineNewsCellAction {
    // 头条新闻
    UIViewController *vc = [[XCMediator sharedInstance] TTMessageMoudle_HeadLineViewContoller:2];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark TTDiscoverHeadBannerCellDelegate
- (void)onBannerCellClickHandler:(DiscoveryBannerInfo *)info {
    // 头部 banner
    [self headBannerClickWithInfo:info];
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    // 豆腐块数量接口决定
    if (section == DiscoverSectionToFu) {
        return self.tofuArray.count;
    }
    // 家族任务，徒弟什么的。接口决定
    if (section == DiscoverSectionFamily){
        return self.section2Model.count;
    }
    
    if (section == DiscoverSectionHeadBanner) {
        if (!self.headBannerArray.count) {
            return self.headBannerArray.count;
        }
    }
    // banner, 头条新闻，交友大厅都是 1
    
    if (section == DiscoverSectionHeadLineNews) {
        if (self.mainData.topLineVos) {
            return 1;
        }
        return 0;
    }
    
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    // 前三个都不需要显示，往后的全要
    if (section != DiscoverSectionHeadBanner) {
        if (section == DiscoverSectionHeadLineNews) {
            if (self.mainData.topLineVos.count > 0) {
               return CGSizeMake(KScreenWidth, 16);
            }else {
                return CGSizeMake(KScreenWidth, 0);
            }
        }else if (section == DiscoverSectionToFu) {
            if (self.tofuArray.count > 0) {
                return CGSizeMake(KScreenWidth, 9);
            }
            return CGSizeZero;
        }else if (section == DiscoverSectionHeadBanner) {
            if (self.bannerArray.count == 0) {
               return CGSizeMake(KScreenWidth, 16);
            }else {
                 return CGSizeMake(KScreenWidth, 0);
            }
        }
        return CGSizeMake(KScreenWidth, 16);
    }
   return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    view.backgroundColor = [XCTheme getTTSimpleGrayColor];
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case DiscoverSectionHeadBanner: {
            return CGSizeMake(KScreenWidth - 40, 116);
        }
            break;
        case DiscoverSectionToFu: {
            CGFloat width = (KScreenWidth - 40 - 12 * 3) / 4;
            if (projectType() == ProjectType_Planet) {
                return CGSizeMake(width, 87);
            }
            return CGSizeMake(width, 73);
        }
            break;
        case DiscoverSectionHeadLineNews: {
            return CGSizeMake(KScreenWidth - 40 , 84);
        }
            break;
        case DiscoverSectionFamily: {
            return CGSizeMake(KScreenWidth - 40 , 52);
        }
            break;
        case DiscoverSectionPublicChat: {
            return CGSizeMake(KScreenWidth - 40, kPublicChatCellHeight);
            
        }
            break;
        default:
            return CGSizeMake(KScreenWidth, 44); // 没机会用到了
            break;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == DiscoverSectionHeadBanner) {
        return UIEdgeInsetsMake(10, 20, 0, 20);
    }
    if (section == DiscoverSectionToFu) {
        return UIEdgeInsetsMake(0, 20, 0, 20);
    }else if (section == DiscoverSectionHeadLineNews || section == DiscoverSectionFamily || section == DiscoverSectionPublicChat) {
        return UIEdgeInsetsMake(0, 20, 0, 20);
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == DiscoverSectionToFu) {
        return 12;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 头部轮播
    if (indexPath.section == DiscoverSectionHeadBanner) {
        TTDiscoverHeadBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTDiscoverHeadBannerCell" forIndexPath:indexPath];
        cell.headBannerArray = self.headBannerArray;
        cell.delegate = self;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 8;
        cell.contentView.backgroundColor = UIColor.clearColor;
        cell.backgroundColor = UIColor.redColor;
        return cell;
        
    } else if (indexPath.section == DiscoverSectionToFu) { // 豆腐块
        TTDiscoverBannerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTDiscoverBannerCollectionViewCell" forIndexPath:indexPath];
        [cell configTTDiscoverBannerCollectionViewCell:[self.tofuArray safeObjectAtIndex:indexPath.row]];
        cell.contentView.backgroundColor = UIColor.clearColor;
        cell.backgroundColor = UIColor.clearColor;
        return cell;
    } else if(indexPath.section == DiscoverSectionHeadLineNews) {   // 头条新闻
        TTHomeRecommendHeadlineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTHomeRecommendHeadlineCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.lineNews = self.mainData.topLineVos;
        cell.delegate = self;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 8;
        return cell;
    } else if(indexPath.section == DiscoverSectionFamily){  // 收徒
        TTInvitaFriendCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTInvitaFriendCollectionViewCell" forIndexPath:indexPath];
        cell.model = self.section2Model[indexPath.row];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 8;
        return cell;
    }else if(indexPath.section == DiscoverSectionPublicChat){
        //交友大厅  这个是发现页的公屏
        PDPublicChatCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPublicChatCellID forIndexPath:indexPath];
        cell.ATmeName = self.publicChatAtMe;
        cell.dataModelArray = self.publicChatModelArray.mutableCopy;
        cell.delegate = self;
        cell.discoverType = YES;
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 8;
        cell.contentView.backgroundColor = UIColor.whiteColor;
        cell.backgroundColor = UIColor.whiteColor;
        return cell;
    }else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emptyCell" forIndexPath:indexPath];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case DiscoverSectionHeadBanner:
        {
            // cell 不做处理。cell 上的 banner 点击处理
            return;
        }
            break;
        case DiscoverSectionToFu:
        {
            // 豆腐块
            if (self.mainData.banners.count > indexPath.row) {
                DiscoverTofuInfo *info = self.mainData.banners[indexPath.row];
                if (info.type != TofuSkipTypeJumpAppVC) {
                    // 签到，任务业务出现之前的跳转逻辑处理。
                    [self skipVCWith:info.type andSkipUrl:info.param];
                } else {
                    // 跳转签到，任务 VC
                    [self jumpVCWithRouterType:info.routerType];
                }
            }
        }
            break;
        case DiscoverSectionFamily:
        {
            // 家族静态数据构建跳转
            [[BaiduMobStat defaultStat] logEvent:@"find_apprentice_entrance" eventLabel:@"收个徒弟赢金币"];
            TTInvitaFriendModel *model = self.section2Model[indexPath.row];
            UIViewController *vc = [[model.desClass alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case DiscoverSectionHeadLineNews:
        {
            // 跳转头条新闻
            [self onCellDidSelectLineNewsCellAction];
        }
            break;
        case DiscoverSectionPublicChat:
        {
            // 公聊大厅
            // cell 上已经处理
        }
            break;
        default:
            break;
    }
}

#pragma mark - 跳转
- (void)headBannerClickWithInfo:(DiscoveryBannerInfo *)info {
    if (info.skipType == BannerInfoSkipTypeWeb) {
        TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
        NSString *url = info.skipUri;
        if ([info.skipUri containsString:@"?"]) {
            url = [NSString stringWithFormat:@"%@&uid=%@", info.skipUri, [GetCore(AuthCore) getUid]];
        } else {
            url = [NSString stringWithFormat:@"%@?uid=%@", info.skipUri, [GetCore(AuthCore) getUid]];
        }
        vc.url = [NSURL URLWithString:url];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (info.skipType == BannerInfoSkipTypeRoom) {
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:info.skipUri.userIDValue];
    }
}

- (void)jumpVCWithRouterType:(P2PInteractive_SkipType)skipType {
    if (skipType == P2PInteractive_SkipType_Checkin) {
        // 签到
        [TTStatisticsService trackEvent:TTStatisticsServiceEventFindSign eventDescribe:@"签到-发现页 "];
        
        UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTCheckinViewController];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (skipType == P2PInteractive_SkipType_Mission) {
        // 任务
        [TTStatisticsService trackEvent:TTStatisticsServiceEventFindTaskCenter eventDescribe:@"任务中心 "];
        TTMissionContainViewController *vc = [[TTMissionContainViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)skipVCWith:(TofuSkipType)skipType andSkipUrl:(NSString *)skipurl{
    if (skipType == TofuSkipTypeWebH5 || skipType == TofuSkipTypeGame) {
        TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
        NSString *url = nil;
        if ([skipurl containsString:@"?"]) {
            url = [NSString stringWithFormat:@"%@&uid=%@",skipurl,[GetCore(AuthCore)getUid]];
        }else{
            url = [NSString stringWithFormat:@"%@?uid=%@",skipurl,[GetCore(AuthCore)getUid]];
        }
        vc.url = [NSURL URLWithString:url];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (skipType == TofuSkipTypeRoom) {
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:skipurl.userIDValue];
    }else if (skipType == TofuSkipTypeHeadWear){
        UIViewController *  carShoppingVc = [[XCMediator sharedInstance] ttPersonalModule_DressUpShopViewControllerWithUid:0 index:0];
        [self.navigationController pushViewController:carShoppingVc animated:YES];
    }
}


#pragma mark - setters and getters
- (NSArray<TTInvitaFriendModel *> *)section2Model {
    if (!_section2Model) {
        
        // 收徒
        TTInvitaFriendModel *master = [TTInvitaFriendModel new];
        master.title = @"收个徒弟赢金币";
        master.detail = @"收徒赢大礼哦";
        master.desClass = [TTMasterViewController class];
        master.hotImage = [UIImage imageNamed:@"discover_hot_icon"];
        

        _section2Model = @[master];
    }
    return _section2Model;
}

@end
