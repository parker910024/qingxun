//
//  TTHomeFamilyViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTHomeFamilyViewController.h"
//cell
#import "TTDiscoverSquareTableViewCell.h"
#import "TTDiscoverCharmTableViewCell.h"
#import "TTDiscoverSectionView.h"
#import "TTDiscoverHeaderView.h"
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

@interface TTHomeFamilyViewController ()<FamilyCoreClient,AuthCoreClient>
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
/** 显示banner的View*/
@property (nonatomic, strong) TTDiscoverHeaderView * headerView;
@end

@implementation TTHomeFamilyViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addCore];
    [self initView];
    [self initConstrations];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;//家族广场 家族星推荐 我的家族 家族客服
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.familyModel ? 1 : 2;
    }else if (section == 1){
        return self.charmArray.count > 0 ? 1 :0;
    }else if (section == 2){
        return self.familyModel ? 1: 0;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }else if (indexPath.section == 1){
        return self.charmArray.count > 0 ? 125 :0;
    }else if (indexPath.section == 2){
        return self.familyModel ? 80: 0;
    }else if(indexPath.section ==3){
        return 60;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        if (self.charmArray.count > 0) {
            return 44;
        }
    }else if (section == 2){
        if (self.familyModel) {
            return 44;
        }
    }else if (section == 3){
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        TTDiscoverSectionView * sectionView = [[TTDiscoverSectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
        sectionView.section = section;
        if (section == 1) {
            if (self.charmArray.count >0) {
                return sectionView;
            }
        }else if (section == 2){
            if (self.familyModel) {
                return sectionView;
            }
        }
    }else if (section ==3){
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
        view.backgroundColor = [XCTheme getTTSimpleGrayColor];
        return view;
    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 2 || indexPath.section == 3) {
        return [self configTTDiscoverSquareTableViewCell:tableView indexPath:indexPath];
    }else if (indexPath.section == 1){
        return [self configTTDiscoverCharmTableViewCell:tableView indexPath:indexPath];
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
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
    }else if (indexPath.section == 2){
        if (self.familyModel) {
            
            [TTStatisticsService trackEvent:TTStatisticsServiceEventMyFamilyClick
                              eventDescribe:@"家族 我的家族"];
            
            UIViewController * controlerVC = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyPersonViewController:[self.familyModel.familyId integerValue]];
            [self.navigationController pushViewController:controlerVC animated:YES];
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            if (self.serviceDic) {
                XCFamilyModel * onlinemodel = self.serviceDic[@"online"];
                UIViewController * controller = [[XCMediator sharedInstance] ttMessageMoudle_TTSessionViewController:[onlinemodel.uid integerValue] sessectionType:NIMSessionTypeP2P];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else if (indexPath.row == 1){
            TTWKWebViewViewController * webView =  [[TTWKWebViewViewController alloc] init];
            webView.urlString = HtmlUrlKey(kFamilyGuide);
            [self.navigationController pushViewController:webView animated:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.didScrollCallback ?: self.didScrollCallback(scrollView);
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

#pragma mark - AuthCoreClient
- (void)onLoginSuccess{
    [self pullDownRefresh:1];
}

#pragma mark - FamilyCoreClient
- (void)getTTDiscoverBannerSuccess:(NSDictionary *)familyInfor{
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

- (void)getTTDiscoverBannerFail:(NSString *)familyInfor{
    [self failEndRefreshStatus:0];
}

/** 请求家族客服和电话*/
- (void)getServiceAndPhoneSuccess:(NSDictionary *)dic{
    self.serviceDic = dic;
    [self configService];
}
/** 请求发现页接口*/
- (void)getFinderFamilyMessageSuccess:(NSDictionary *)finderDic{
    [self successEndRefreshStatus:0 hasMoreData:NO];
    if (finderDic != nil && [finderDic allKeys].count > 0) {
        self.bannderArray = finderDic[@"banners"];
        self.charmArray = [(XCFamily *)finderDic[@"charm"] familys];
    }
    if (self.bannderArray.count > 0) {
        self.headerView.hidden = NO;
        self.headerView.frame = CGRectMake(0, 0, KScreenWidth, 130);
        [self.headerView configTTDiscoverHeaderView:self.bannderArray];
    }else{
        self.headerView.hidden = YES;
        self.headerView.frame= CGRectMake(0, 0, KScreenWidth, 0);
    }
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView reloadData];
}

- (void)getFinderFamilyMessageFail:(NSString *)message{
    self.headerView.hidden = YES;
    self.headerView.frame= CGRectMake(0, 0, KScreenWidth, 0);
    self.tableView.tableHeaderView = self.headerView;
    [self failEndRefreshStatus:0];
}

//修改家族信息成功
- (void)modifyFamilyInforMessageSuccess:(NSDictionary *)familyDic{
   [GetCore(FamilyCore) getTTDiscoverBannerInfor:[GetCore(AuthCore) getUid]];
}

//解散家族 创建家族成功  被踢出家族
- (void)reciveFamilyCustomMessageWith:(MessageParams *)messageDic{
  [GetCore(FamilyCore) getTTDiscoverBannerInfor:[GetCore(AuthCore) getUid]];
}


#pragma mark - event response
#pragma mark - private method
- (void)initView {
    self.tableView.separatorColor = UIColorFromRGB(0xF0F0F0);
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView registerClass:[TTDiscoverCharmTableViewCell class] forCellReuseIdentifier:@"TTDiscoverCharmTableViewCell"];
    [self.tableView registerClass:[TTDiscoverSquareTableViewCell class] forCellReuseIdentifier:@"TTDiscoverSquareTableViewCell"];
    [self setupRefreshTarget:self.tableView With:RefreshTypeHeader];
    NSDictionary * serviceDic = @{@"imageName":@"discover_family_guide", @"title":@"家族客服", @"content":@"ID:------ 合作洽谈 活动答疑"};
    NSDictionary * guideDic = @{@"imageName":@"discover_family_service", @"title":@"家族指南", @"content":@"快速上手教程"};
    self.serviceArray= [@[serviceDic, guideDic] mutableCopy];
    if (GetCore(FamilyCore).serviceDic == nil) {
        [GetCore(FamilyCore) requestService];
    }else{
        self.serviceDic = GetCore(FamilyCore).serviceDic;
        [self configService];
    }
    [self pullDownRefresh:1];
}
- (void)initConstrations {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self.view);
    }];
}

- (void)configService{
    XCFamilyModel * onlinemodel = self.serviceDic[@"online"];
    NSMutableDictionary * dic = [[self.serviceArray firstObject] mutableCopy];
    NSString * content = [NSString stringWithFormat:@"ID：%@  合作洽谈 活动答疑", onlinemodel.content];
    [dic setValue:content forKey:@"content"];
    [self.serviceArray replaceObjectAtIndex:0 withObject:dic];
    [self.tableView reloadData];
}

- (void)addCore{
    AddCoreClient(FamilyCoreClient, self);
    AddCoreClient(AuthCoreClient, self);
}

- (void)pullDownRefresh:(int)page{
    [GetCore(FamilyCore) familyFinderMessage:[GetCore(AuthCore) getUid]];
    [GetCore(FamilyCore) getTTDiscoverBannerInfor:[GetCore(AuthCore) getUid]];
}

- (TTDiscoverCharmTableViewCell *)configTTDiscoverCharmTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    TTDiscoverCharmTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTDiscoverCharmTableViewCell"];
    if (cell == nil) {
        cell = [[TTDiscoverCharmTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTDiscoverCharmTableViewCell"];
    }
    cell.currentVC = self;
    [cell configDiscoverCharmTableViewCell:self.charmArray];
    return cell;
}

- (TTDiscoverSquareTableViewCell *)configTTDiscoverSquareTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    TTDiscoverSquareTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTDiscoverSquareTableViewCell"];
    if (cell == nil) {
        cell = [[TTDiscoverSquareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTDiscoverSquareTableViewCell"];
    }
    if (indexPath.section == 0) {
        NSDictionary * dic = [self.familyArray safeObjectAtIndex:indexPath.row];
        [cell configDicoverSquareOrFamilyGuide:dic];
    }else if (indexPath.section == 2){
        [cell configTTDiscoverSquareTableViewCell:self.familyModel];
    }else if (indexPath.section == 3){
        NSDictionary * dic = [self.serviceArray safeObjectAtIndex:indexPath.row];
        [cell configDicoverSquareOrFamilyGuide:dic];
    }
    return cell;
}
#pragma mark - getters and setters
- (TTDiscoverHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TTDiscoverHeaderView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 130)];
        _headerView.currentVC = self;
    }
    return _headerView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - getters and setters
- (BOOL)isHiddenNavBar {
    return YES;
}

@end
