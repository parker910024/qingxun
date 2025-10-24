//
//  TTFansViewController.m
//  TuTu
//
//  Created by gzlx on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFansViewController.h"
#import "TTFriendTableViewCell.h"
#import "TTMessageEmptyDataView.h"

#import "XCMediator+TTPersonalMoudleBridge.h"
#import "TTSessionViewController.h"
//core
#import "Attention.h"
#import "PraiseCore.h"
#import "PraiseCoreClient.h"
#import "AuthCoreClient.h"
#import "AuthCore.h"
#import "ImFriendCoreClient.h"
//Tool
#import "XCHUDTool.h"
#import "NSArray+Safe.h"
#import "XCTheme.h"
#import "XCCurrentVCStackManager.h"
#import "XCMacros.h"
#import <Masonry/Masonry.h>

@interface TTFansViewController ()<PraiseCoreClient, TTFriendTableViewCellDelegate, AuthCoreClient, ImFriendCoreClient>
@property (nonatomic, assign) int currentpage;
/** 粉丝列表*/
@property (nonatomic, strong) NSMutableArray<Attention *> * fansArray;

@property (nonatomic, strong) TTMessageEmptyDataView *emptyDataView;

@end

@implementation TTFansViewController

- (BOOL)isHiddenNavBar{
    if (self.type == MessageVCType_RoomChat || self.type == MessageVCType_Contacts) {
        return YES;
    }
    return NO;
}

- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
    [self initView];
}

#pragma mark -private  method
- (void)initView{
    
    self.navigationItem.title = @"粉丝";
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(KScreenWidth);
        if (self.type == MessageVCType_Default){
            make.top.mas_equalTo(self.view).offset(statusbarHeight + 44);
            make.bottom.mas_equalTo(self.view);
        }else{
            make.top.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
        }
    }];
    
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        self.tableView.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }else {
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableViewHeightOnScreen = 1;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[TTFriendTableViewCell class] forCellReuseIdentifier:@"TTFriendTableViewCell"];
    [self setupRefreshTarget:self.tableView];
    [self pullDownRefresh:1];
}

- (void)addCore{
    AddCoreClient(PraiseCoreClient, self);
    AddCoreClient(AuthCoreClient, self);
    AddCoreClient(ImFriendCoreClient, self);
}

#pragma mark - UITableViewDelegate and UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.backgroundView = self.fansArray.count == 0 ? self.emptyDataView : nil;
    return self.fansArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTFriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTFriendTableViewCell" forIndexPath:indexPath];
   
    if (self.selectPresentBlock) {
        cell.cellType = TTFriendTableViewCell_Present;
    } else {
        if (self.type == MessageVCType_AtPerson) {
            cell.cellType = TTFriendTableViewCell_IsSelected;
        }else if (self.type == MessageVCType_RoomChat){
            cell.cellType = TTFriendTableViewCell_RoomChat;
        }else{
            cell.cellType = TTFriendTableViewCell_Focus;
        }
    }
    [cell configTTFriendTableViewCellWithAttention:[self.fansArray safeObjectAtIndex:indexPath.row]];

    if (self.type == MessageVCType_Default || self.type == MessageVCType_Contacts) {
        cell.cellType = TTFriendTableViewCell_Focus;
    }else if (self.type == MessageVCType_AtPerson){
        cell.selectDic = self.selectDic;
    }
    
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //赠送礼物时，取消选中行效果
    if (self.selectPresentBlock != nil || self.type == MessageVCType_AtPerson) {
        return;
    }
    
    Attention *model = [self.fansArray safeObjectAtIndex:indexPath.row];
    if (model == nil || ![model isKindOfClass:Attention.class]) {
        return;
    }
    if (self.type == MessageVCType_RoomChat) {
        TTSessionViewController  * sessionVC =[[TTSessionViewController alloc] initWithSession:[NIMSession session:[NSString stringWithFormat:@"%lld", model.uid] type:NIMSessionTypeP2P]];
        sessionVC.isRoomMessage = YES;
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.mainController.view.layer addAnimation:transition forKey:nil];
        [self.mainController addChildViewController:sessionVC];
        [self.mainController.view addSubview:sessionVC.view];
    }else{
        // 跳转个人主页
        UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:model.uid];
        [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - TTFriendTableViewCellDelegate
- (void)focusOrFindFriendWith:(UserInfo *)infor cellType:(TTFriendTableViewCellType)cellType sender:(UIButton *)sender{
    if (sender.selected && cellType == TTFriendTableViewCell_Focus) {
        NSString * mine = [GetCore(AuthCore) getUid];
        [GetCore(PraiseCore) praise:mine.userIDValue bePraisedUid:infor.uid];
    }
}

- (void)choseUserWithInfor:(UserInfo *)infor{
    if (!self.selectDic) {
        self.selectDic = [NSMutableDictionary dictionary];
    }
    if (infor.isSelected) {
        [self.selectDic setValue:infor forKey:[NSString stringWithFormat:@"%lld", infor.uid]];
    }else{
       [self.selectDic removeObjectForKey:[NSString stringWithFormat:@"%lld", infor.uid]];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseFansInforWith:)]) {
        [self.delegate chooseFansInforWith:self.selectDic];
    }
}

- (void)sendPresentDidSelect:(TTSendPresentUserInfo *)user {
    if (self.selectPresentBlock) {
        self.selectPresentBlock(user);
    }
}


#pragma mark - AuthCoreClient
- (void)onLoginSuccess{
    [self pullDownRefresh:1];
}

- (void)onLogout{
    [self.fansArray removeAllObjects];
}

- (void)onFriendChanged{
    [self pullDownRefresh:1];
}

#pragma mark - PraiseCoreClient
- (void)onRequestFansListState:(int)state success:(NSArray *)fansList{
    if (self.currentpage == 1) {
        [self.fansArray removeAllObjects];
    }
    if (fansList.count>0) {
        if (state) { //上拉
            [self.fansArray addObjectsFromArray:[fansList mutableCopy]];
        }else { //下拉
            self.fansArray = [fansList mutableCopy];
        }
        [self.tableView endRefreshStatus:state hasMoreData:YES];
    }else{
        [self.tableView endRefreshStatus:state hasMoreData:NO];
    }
    [self.tableView reloadData];
}

- (void)onRequestFansListState:(int)state failth:(NSString *)msg{
    [self failEndRefreshStatus:state];
}

- (void)onPraiseSuccess:(UserID)uid {
    [XCHUDTool showSuccessWithMessage:@"关注成功，相互关注可成为好友哦" inView:self.view];
}

- (void)onPraiseFailth:(NSString *)msg{
    [XCHUDTool hideHUDInView:self.view];
}

#pragma mark - http
- (void)pullDownRefresh:(int)page{
    self.currentpage = page;
    [GetCore(PraiseCore) requestFansListState:0 page:page];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage{
    if (isLastPage) {
        return;
    }
    self.currentpage = page;
    [GetCore(PraiseCore) requestFansListState:1 page:page];
}

#pragma mark - setters and getters
- (void)setSelectDic:(NSMutableDictionary *)selectDic{
    _selectDic = selectDic;
    [self.tableView reloadData];
}

- (void)setIsReload:(BOOL)isReload{
    _isReload= isReload;
    if (_isReload) {
        [self pullDownRefresh:1];
    }
}

- (TTMessageEmptyDataView *)emptyDataView {
    if (_emptyDataView == nil) {
        _emptyDataView = [[TTMessageEmptyDataView alloc] init];
        _emptyDataView.backgroundColor = UIColor.whiteColor;
        _emptyDataView.text = @"你还没有任何粉丝哦!";
        _emptyDataView.image = @"common_noData_empty";
        _emptyDataView.imageCenterOffsetY = -50;
        _emptyDataView.textToImageBottomOffset = 4;
    }
    return _emptyDataView;
}
@end
