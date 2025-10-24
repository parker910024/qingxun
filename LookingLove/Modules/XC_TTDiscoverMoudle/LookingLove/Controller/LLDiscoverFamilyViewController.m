//
//  LLDiscoverFamilyViewController.m
//  XC_TTDiscoverMoudle
//
//  Created by fengshuo on 2019/7/26.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "LLDiscoverFamilyViewController.h"
//cell
#import "LLDiscoverSquareTableViewCell.h"
#import "LLDiscoverCharmTableViewCell.h"
#import "LLDiscoverBannerTableViewCell.h"
#import "LLDiscoverServiceTableViewCell.h"
#import "LLDiscoverSectionView.h"
#import "LLDiscoverHeaderView.h"
//vc
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCMediator+TTMessageMoudleBridge.h"
#import "TTWKWebViewViewController.h"
//tool
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "AuthCore.h"
#import "FamilyCore.h"
#import "FamilyCoreClient.h"
#import "AuthCoreClient.h"
#import "XCHtmlUrl.h"
#import "HostUrlManager.h"

#import "TTStatisticsService.h"

@interface LLDiscoverFamilyViewController ()<FamilyCoreClient,AuthCoreClient>
/** banner*/
@property (nonatomic, strong) NSArray * bannderArray;
/** 我的家族*/
@property (nonatomic, strong) XCFamily * familyModel;
/** 魅力榜*/
@property (nonatomic, strong) NSArray * charmArray;
/** 家族客服 家族指南*/
@property (nonatomic, strong) NSMutableArray * serviceArray;
/**创建家族/家族广场 */
@property (nonatomic, strong) NSArray * familyArray;
/** 保存家族客服和电话*/
@property (nonatomic, strong) NSDictionary * serviceDic;

@end

@implementation LLDiscoverFamilyViewController
#pragma mark - life cycle
- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
    [self initView];
    [self initConstrations];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;//banner 家族广场 家族星推荐 我的家族 家族客服
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == LLDiscoverFamilyCellType_Banners) {
        return self.bannderArray.count > 0 ? 1 : 0;
    }else if (section == LLDiscoverFamilyCellType_Square) {
        return self.familyModel ? 1 : 2;
    }else if (section == LLDiscoverFamilyCellType_MyFamily){
         return self.familyModel ? 1: 0;
    }else if (section == LLDiscoverFamilyCellType_Charm){
        return self.charmArray.count > 0 ? self.charmArray.count :0;
    }else if(section == LLDiscoverFamilyCellType_Service){
        return 2;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == LLDiscoverFamilyCellType_Banners) {
        return 116;
    }else if (section == LLDiscoverFamilyCellType_Square) {
        return 75;
    }else if (section == LLDiscoverFamilyCellType_MyFamily){
        return 77;
    }else if (section == LLDiscoverFamilyCellType_Charm){
        return 77;
    }else if(section == LLDiscoverFamilyCellType_Service){
        return 44;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == LLDiscoverFamilyCellType_Banners) {
        return self.bannderArray.count > 0 ? 10 : 0;
    }else if (section == LLDiscoverFamilyCellType_Square) {
        return 18;
    }else if (section == LLDiscoverFamilyCellType_MyFamily){
        return self.familyModel ? 60 : 0;
    }else if (section == LLDiscoverFamilyCellType_Charm){
        return self.charmArray.count > 0 ? 60 : 0;
    }else if(section == LLDiscoverFamilyCellType_Service){
        return 10;
    }else {
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == LLDiscoverFamilyCellType_Charm || section == LLDiscoverFamilyCellType_MyFamily) {
        LLDiscoverSectionView * sectionView = [[LLDiscoverSectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
        sectionView.section = section;
        if (section == LLDiscoverFamilyCellType_Charm) {
            if (self.charmArray.count >0) {
                return sectionView;
            }
        }else if (section == LLDiscoverFamilyCellType_MyFamily) {
            if (self.familyModel) {
                return sectionView;
            }
        }
    }else if (section == LLDiscoverFamilyCellType_Square) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 18)];
        view.backgroundColor = [XCTheme getTTSimpleGrayColor];
        return view;
    }else if (section == LLDiscoverFamilyCellType_Service) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
        view.backgroundColor = [XCTheme getTTSimpleGrayColor];
        return view;
    }else if (section == LLDiscoverFamilyCellType_Banners) {
        if (self.bannderArray.count > 0) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
            view.backgroundColor = [XCTheme getTTSimpleGrayColor];
            return view;
        }
    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == LLDiscoverFamilyCellType_Banners) {
        return [self configLLDiscoverBannerTableViewCell:tableView indexPath:indexPath];
    }else if (indexPath.section == LLDiscoverFamilyCellType_Square) {
        return [self configTTDiscoverSquareTableViewCell:tableView indexPath:indexPath];
    }else if (indexPath.section == LLDiscoverFamilyCellType_MyFamily || indexPath.section == LLDiscoverFamilyCellType_Charm) {
        return [self configTTDiscoverCharmTableViewCell:tableView indexPath:indexPath];
    }else if (indexPath.section == LLDiscoverFamilyCellType_Service) {
        return [self configLLDiscoverServiceTableViewCell:tableView indexPath:indexPath];
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == LLDiscoverFamilyCellType_Square) {
        if (indexPath.row == 0) {
            [TTStatisticsService trackEvent:TTStatisticsServiceEventFamilySquareClick
                              eventDescribe:@"家族广场"];
            UIViewController * conterllVC = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilySquareViewController];
            [self.navigationController pushViewController:conterllVC animated:YES];
        }else{
            TTWKWebViewViewController * webView =  [[TTWKWebViewViewController alloc] init];
            webView.urlString = HtmlUrlKey(kFamilyCreate);
            [self.navigationController pushViewController:webView animated:YES];
        }
    }else if (indexPath.section == LLDiscoverFamilyCellType_MyFamily) {
        if (self.familyModel) {
            
            [TTStatisticsService trackEvent:TTStatisticsServiceEventMyFamilyClick
                              eventDescribe:@"家族 我的家族"];
            
            UIViewController * controlerVC = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyPersonViewController:[self.familyModel.familyId integerValue]];
            [self.navigationController pushViewController:controlerVC animated:YES];
        }
    }else if (indexPath.section == LLDiscoverFamilyCellType_Charm) {
        if (self.charmArray.count > 0) {
            XCFamilyModel * familyModel = [self.charmArray safeObjectAtIndex:indexPath.row];
            if (familyModel.id) {
                UIViewController * controller= [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyPersonViewController:[familyModel.id integerValue]];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }else if (indexPath.section == LLDiscoverFamilyCellType_Service) {
        if (indexPath.row == 0) {
            if (self.serviceDic) {
                XCFamilyModel * onlinemodel = self.serviceDic[@"online"];
                UIViewController * controller = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:[onlinemodel.uid integerValue] sessectionType:NIMSessionTypeP2P];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else if (indexPath.row == 1) {
            TTWKWebViewViewController * webView =  [[TTWKWebViewViewController alloc] init];
            webView.urlString = HtmlUrlKey(kFamilyGuide);
            [self.navigationController pushViewController:webView animated:YES];
        }
    }
}


//区头跟随移动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.didScrollCallback = callback;
}

#pragma mark - AuthCoreClient
- (void)onLoginSuccess {
    [self pullDownRefresh:1];
}

#pragma mark - FamilyCoreClient
- (void)getTTDiscoverBannerSuccess:(NSDictionary *)familyInfor {
    self.familyModel = familyInfor[@"family"];
    NSDictionary * squredic = @{@"imageName":@"discover_family_square_PD", @"title":@"家族广场", @"content":@"来这里找到自己的组织"};
    if (self.familyModel) {
        self.familyArray = @[squredic];
    }else{
        NSDictionary * createdic = @{@"imageName":@"discover_family_create_PD", @"title":@"创建家族", @"content":@"创建自己的家族俱乐部 召唤小伙伴一起玩耍~"};
        self.familyArray = @[squredic , createdic];
    }
    [self successEndRefreshStatus:0 hasMoreData:NO];
    [self.tableView reloadData];
}

- (void)getTTDiscoverBannerFail:(NSString *)familyInfor {
    [self failEndRefreshStatus:0];
}

/** 请求家族客服和电话*/
- (void)getServiceAndPhoneSuccess:(NSDictionary *)dic {
    self.serviceDic = dic;
}
/** 请求发现页接口*/
- (void)getFinderFamilyMessageSuccess:(NSDictionary *)finderDic {
    [self successEndRefreshStatus:0 hasMoreData:NO];
    if (finderDic != nil && [finderDic allKeys].count > 0) {
        self.bannderArray = finderDic[@"banners"];
        self.charmArray = [(XCFamily *)finderDic[@"charm"] familys];
    }
    [self.tableView reloadData];
}

- (void)getFinderFamilyMessageFail:(NSString *)message {
    [self failEndRefreshStatus:0];
}

//修改家族信息成功
- (void)modifyFamilyInforMessageSuccess:(NSDictionary *)familyDic {
    [GetCore(FamilyCore) getTTDiscoverBannerInfor:[GetCore(AuthCore) getUid]];
}

//解散家族 创建家族成功  被踢出家族
- (void)reciveFamilyCustomMessageWith:(MessageParams *)messageDic {
    [GetCore(FamilyCore) getTTDiscoverBannerInfor:[GetCore(AuthCore) getUid]];
}


#pragma mark - event response
#pragma mark - private method
- (void)initView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView registerClass:[LLDiscoverCharmTableViewCell class] forCellReuseIdentifier:@"LLDiscoverCharmTableViewCell"];
    [self.tableView registerClass:[LLDiscoverBannerTableViewCell class] forCellReuseIdentifier:@"LLDiscoverBannerTableViewCell"];
    [self.tableView registerClass:[LLDiscoverServiceTableViewCell class] forCellReuseIdentifier:@"LLDiscoverServiceTableViewCell"];
    [self.tableView registerClass:[LLDiscoverSquareTableViewCell class] forCellReuseIdentifier:@"LLDiscoverSquareTableViewCell"];
    
    [self setupRefreshTarget:self.tableView With:RefreshTypeHeader];
    NSDictionary * serviceDic = @{@"imageName":@"discover_family_guide", @"title":@"家族客服", @"content":@"合作洽谈 活动答疑"};
    NSDictionary * guideDic = @{@"imageName":@"discover_family_service", @"title":@"家族指南", @"content":@"快速上手教程"};
    self.serviceArray= [@[serviceDic, guideDic] mutableCopy];
    if (GetCore(FamilyCore).serviceDic == nil) {
        [GetCore(FamilyCore) requestService];
    }else{
        self.serviceDic = GetCore(FamilyCore).serviceDic;
    }
    [self pullDownRefresh:1];
}
- (void)initConstrations {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self.view);
    }];
}

- (void)addCore {
    AddCoreClient(FamilyCoreClient, self);
    AddCoreClient(AuthCoreClient, self);
}

- (void)pullDownRefresh:(int)page {
    [GetCore(FamilyCore) familyFinderMessage:[GetCore(AuthCore) getUid]];
    [GetCore(FamilyCore) getTTDiscoverBannerInfor:[GetCore(AuthCore) getUid]];
}

//家族星推荐和我的家族
- (LLDiscoverCharmTableViewCell *)configTTDiscoverCharmTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    LLDiscoverCharmTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LLDiscoverCharmTableViewCell"];
    if (cell == nil) {
        cell = [[LLDiscoverCharmTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLDiscoverCharmTableViewCell"];
    }
    if (indexPath.section == LLDiscoverFamilyCellType_MyFamily) {
        [cell configTTDiscoverSquareTableViewCell:self.familyModel];
    }else {
        XCFamilyModel * familyModel = [self.charmArray safeObjectAtIndex:indexPath.row];
        [cell configDiscoverCharmWith:familyModel];
    }
    return cell;
}

//家族广场
- (LLDiscoverSquareTableViewCell *)configTTDiscoverSquareTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    LLDiscoverSquareTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LLDiscoverSquareTableViewCell"];
    if (cell == nil) {
        cell = [[LLDiscoverSquareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLDiscoverSquareTableViewCell"];
    }
    NSDictionary * dic = [self.familyArray safeObjectAtIndex:indexPath.row];
    [cell configDicoverSquareOrFamilyGuide:dic];
    [cell updateCellContainerViewLayerWithTotal:self.familyArray.count row:indexPath.row];
    return cell;
}
//家族客服/家族指南
- (LLDiscoverServiceTableViewCell *)configLLDiscoverServiceTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    LLDiscoverServiceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LLDiscoverServiceTableViewCell"];
    if (cell == nil) {
        cell = [[LLDiscoverServiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLDiscoverServiceTableViewCell"];
    }
   NSDictionary * dic = [self.serviceArray safeObjectAtIndex:indexPath.row];
    [cell configDicoverSquareOrFamilyGuide:dic];
    return cell;
}

//轮播图
- (LLDiscoverBannerTableViewCell *)configLLDiscoverBannerTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    LLDiscoverBannerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LLDiscoverBannerTableViewCell"];
    if (cell == nil) {
        cell = [[LLDiscoverBannerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLDiscoverBannerTableViewCell"];
    }
    cell.currentVC = self;
    [cell configTTDiscoverHeaderView:self.bannderArray];
   
    return cell;
}
#pragma mark - getters and setters


@end
