//
//  TTHomeViewController.m
//  TuTu
//
//  Created by lvjunhang on 2018/12/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTHomeViewController.h"
#import "TTHomeCustomNavView.h"

#import "TTSearchRoomViewController.h"
#import "TTHomeRecommendViewController.h"
#import "TTRoomListViewController.h"

#import <Masonry/Masonry.h>
#import <JXCategoryView/JXCategoryView.h>
#import <JXCategoryView/JXCategoryTitleVerticalZoomView.h>

#import "HomeCoreClient.h"
#import "HomeCore.h"
#import "RoomCategory.h"
#import "AuthCore.h"
#import "AuthCoreClient.h"
#import "TTGameStaticTypeCore.h"

#import "XCMediator+TTRoomMoudleBridge.h"
#import "XCMediator+TTPersonalMoudleBridge.h"

#import "XCMacros.h"
#import "CommonFileUtils.h"
#import "UIColor+UIColor_Hex.h"
#import "TTHomeRoomSelectView.h"
#import "BaseNavigationController.h"
#import "TTNewbieGuideView.h"

static NSString * const kRoomCategoryStoreKey = @"Room Category V4";//房间分类存储
// 首页新手引导状态保存
static NSString *const kHomeGuideStatusStoreKey = @"TTHomeViewControllerHomeGuideStatus";

@interface TTHomeViewController ()
<
TTHomeCustomNavViewDelegate,
HomeCoreClient,
TTHomeRoomSelectViewDelegate,
JXCategoryViewDelegate,
JXCategoryListContainerViewDelegate
>

/**
 创建房间选择房间类型
 */
@property (nonatomic, strong) TTHomeRoomSelectView *roomSelectView;

/**
 自定义导航栏
 */
@property (nonatomic, strong) TTHomeCustomNavView *navigationView;

/**
 各个控制器视图容器
 */
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

/**
 推荐控制器
 */
@property (nonatomic, strong) TTHomeRecommendViewController *recommendVC;

@end

@implementation TTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(HomeCoreClient, self);
    AddCoreClient(AuthCoreClient, self);
    
    [GetCore(HomeCore) requestTTHomeV4RoomCategory];
    
    [self initView];
    [self initConstraint];
    
    [self setupListContent];
    
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    BOOL hadGuide = [ud boolForKey:kHomeGuideStatusStoreKey];
//    if (!hadGuide) {
//        [ud setBool:YES forKey:kHomeGuideStatusStoreKey];
//        [ud synchronize];
//        [self initGuiView];
//    }
}

- (void)initGuiView {
    
    TTNewbieGuideView *guideView = [[TTNewbieGuideView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) withArcWithFrame:CGRectMake(-50, statusbarHeight + 8 - 11, KScreenWidth - 73 + 50, 50) withSpace:YES withCorner:25 withPage:TTGuideViewPage_Home];
    
    [self.tabBarController.view addSubview:guideView];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (BOOL)isHiddenNavBar {
    return YES;
}

#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
}

#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    id<JXCategoryListContentViewDelegate> vc = [self.childViewControllers safeObjectAtIndex:index];
    if ([vc conformsToProtocol:@protocol(JXCategoryListContentViewDelegate)]) {
        return vc;
    }
    
    return nil;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.navigationView.categoryView.titles.count;
}

#pragma mark - HomeCoreClient
//兔兔获取首页房间标题列表(房间分类列表)v4
- (void)responseTTHomeV4RoomCategory:(NSArray *)modelArray errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    if (code != nil || msg.length > 0) {
        return;
    }
    
    ///Store
    [CommonFileUtils writeObject:modelArray toUserDefaultWithKey:kRoomCategoryStoreKey];
    
    [self setupListContent];
}

#pragma mark - AuthCoreClient
- (void)onLoginSuccess {
    [GetCore(HomeCore) requestTTHomeV4RoomCategory];
}

#pragma mark - TTHomeCustomNavViewDelegate
- (void)homeCustomNavView:(TTHomeCustomNavView *)view didClickSearchButton:(UIButton *)btn {
    
    TTSearchRoomViewController *searchVC = [[TTSearchRoomViewController alloc] init];
    BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:searchVC];
    @KWeakify(self);
    searchVC.dismissAndDidClickPersonBlcok = ^(long long uid) {
        @KStrongify(self);
        UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:uid];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)homeCustomNavView:(TTHomeCustomNavView *)view didClickMyRoomButton:(UIButton *)btn {
    self.roomSelectView.hidden = NO;
}

#pragma mark - TTHomeRoomSelectViewDelegate
//创建房间选择普通房
- (void)ordinaryButtonActionResponse {
    self.roomSelectView.hidden = YES;
    GetCore(TTGameStaticTypeCore).openRoomStatus = OpenRoomType_Normal;
    [[XCMediator sharedInstance] ttRoomMoudle_openMyRoomByType:3];
}

//创建房间选择CP房
- (void)companyButtonActionResponse {
    self.roomSelectView.hidden = YES;
    GetCore(TTGameStaticTypeCore).openRoomStatus = OpenRoomType_CP;
    [[XCMediator sharedInstance] ttRoomMoudle_openMyRoomByType:5];
}

- (void)touchMaskBackground {
    self.roomSelectView.hidden = YES;
}

#pragma mark - private method
- (void)initView {
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.listContainerView];

    [[UIApplication sharedApplication].keyWindow addSubview:self.roomSelectView];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Robot"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"outOfMatchEnterYouRoom"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"outOfMatchEnterMyRoom"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)initConstraint {
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(kNavigationHeight);
    }];
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navigationView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [self.roomSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, KScreenHeight));
    }];
}

/**
 设置列表内容
 */
- (void)setupListContent {
    
    for (UIViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    
    NSArray<RoomCategory *> *tags = [self fullTags];
    for (RoomCategory *tag in tags) {
        
        if ([tag.titleName isEqualToString:@"推荐"]) {
            //将控制器作为子VC加到容器里，才成响应 push
            [self addChildViewController:self.recommendVC];
            continue;
        }
        
        TTRoomListViewController *vc = [[TTRoomListViewController alloc] init];
        vc.roomTag = tag;
        //将控制器作为子VC加到容器里，才成响应 push
        [self addChildViewController:vc];
    }
    
    self.navigationView.roomCategory = tags;
    [self.listContainerView reloadData];
}

/**
 获取完整 tag 列表（插入KTV、热门、推荐等）
 
 @return 完整 tag 列表
 */
- (nullable NSArray<RoomCategory *> *)fullTags {

    NSArray<RoomCategory *> *storeTags = [self storeTagList];
    
    //如果未登录，不显示其他标签
    if (![GetCore(AuthCore) isLogin]) {
        storeTags = nil;
    }
    
    NSMutableArray *mTagList = [NSMutableArray array];
    if (storeTags && storeTags.count > 0) {
        [mTagList addObjectsFromArray:storeTags];
    }

    RoomCategory *reccommendTag = [[RoomCategory alloc] init];
    reccommendTag.titleName = @"推荐";
    [mTagList insertObject:reccommendTag atIndex:0];
    
    return [mTagList copy];
}

/**
 获取存储 tag 列表
 
 @return 存储 tag 列表
 */
- (nullable NSArray<RoomCategory *> *)storeTagList {
    NSArray<RoomCategory *> *list = [CommonFileUtils readObjectFromUserDefaultWithKey:kRoomCategoryStoreKey];
    if (list == nil || list.count == 0) {
        return nil;
    }
    
    return list;
}

#pragma mark - getter
- (UIView *)roomSelectView {
    if (!_roomSelectView) {
        self.roomSelectView = [[TTHomeRoomSelectView alloc] init];
        _roomSelectView.backgroundColor = [UIColor colorWithHexString:@"50000000"];
        _roomSelectView.hidden = YES;
        _roomSelectView.delegate = self;
    }
    return _roomSelectView;
}

- (TTHomeCustomNavView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[TTHomeCustomNavView alloc] init];
        _navigationView.delegate = self;
        _navigationView.categoryView.delegate = self;
        _navigationView.categoryView.contentScrollView = self.listContainerView.scrollView;
    }
    return _navigationView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _listContainerView.defaultSelectedIndex = 0;
    }
    return _listContainerView;
}

- (TTHomeRecommendViewController *)recommendVC {
    if (!_recommendVC) {
        _recommendVC = [[TTHomeRecommendViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    }
    return _recommendVC;
}

@end
