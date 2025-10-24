//
//  TTSearchRoomViewController.m
//  TuTu
//
//  Created by Macx on 2018/11/5.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTSearchRoomViewController.h"

#import "TTSearchRoomTableViewCell.h"
#import "TTSearchRecordCell.h"
#import "TTSearchVisitRoomCell.h"
#import "TTSearchCustomNavView.h"

#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTRoomMoudleBridge.h"

#import "SearchCore.h"
#import "SearchCoreClient.h"
#import "SearchResultInfo.h"
#import "GuildCore.h"
#import "GuildCoreClient.h"
#import "UserCore.h"
#import "AuthCore.h"
#import "RoomCoreClient.h"
#import "RoomCoreV2.h"

#import "XCMacros.h"
#import "XCConst.h"
#import "XCHUDTool.h"
#import "TTPopup.h"
#import "XCKeyWordTool.h"
#import "TTStatisticsService.h"
#import "XCTheme.h"
#import "XCEmptyDataView.h"

#import <Masonry/Masonry.h>

@interface TTSearchRoomViewController ()
<
UITextFieldDelegate,
SearchCoreClient,
GuildCoreClient,
RoomCoreClient
>

@property (nonatomic, strong) TTSearchCustomNavView *customNavView;
@property (nonatomic, strong) XCEmptyDataView *emptyDataView;

@property (nonatomic, copy) NSArray<SearchResultInfo *> *resultList;
@property (nonatomic, strong) NSMutableArray<RoomVisitRecord *> *visitRoomList;//进房记录

/// 当前是否需要显示历史记录，需要showHistoryRecord为真时有效
@property (nonatomic, assign) BOOL shouldShowHistoryRecord;

@end

@implementation TTSearchRoomViewController

#pragma mark - life cycle
- (void)dealloc {
    self.resultList = nil;
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(SearchCoreClient, self);
    AddCoreClient(GuildCoreClient, self);
    AddCoreClient(RoomCoreClient, self);
    
    [self initView];
    [self initConstrations];
    [self initEvent];
    [self.customNavView.searchTextField becomeFirstResponder];
    
    if (self.showHistoryRecord) {
        self.shouldShowHistoryRecord = YES;
        
        //请求进房记录
        [GetCore(RoomCoreV2) requestRoomVisitRecord];
    }
}

#pragma mark - UITableViewViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.showHistoryRecord && self.shouldShowHistoryRecord) {
        NSInteger count = 0;
        if ([self searchRecordList].count > 0) {
            count ++;
        }
        if (self.visitRoomList.count > 0) {
            count ++;
        }
        return count;
    }
    
    return self.resultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.showHistoryRecord && self.shouldShowHistoryRecord) {
        
        //搜索记录
        if ([self searchRecordList].count > 0 && indexPath.row == 0) {
            TTSearchRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TTSearchRecordCell.class) forIndexPath:indexPath];
            cell.dataArray = [self searchRecordList];
            @weakify(self)
            cell.selectedRecordHandler = ^(NSString * _Nonnull record) {
                @strongify(self)
                self.customNavView.searchTextField.text = record;
                [self search:record];
                
                [TTStatisticsService trackEvent:@"search_recent_search" eventDescribe:@"最近搜索记录"];
            };
            cell.cleanRecordHandler = ^{
                @strongify(self)
                [self.view endEditing:YES];
                
                TTAlertConfig *config = [[TTAlertConfig alloc] init];
                config.message = @"确定清空搜索记录吗？";
                config.cancelButtonConfig.title = @"手滑了";
                config.confirmButtonConfig.title = @"清空";
                
                [TTPopup alertWithConfig:config confirmHandler:^{
                    [self cleanSearchRecord];
                    [self.tableView reloadData];
                } cancelHandler:^{
                }];
            };
            return cell;
        }
        
        //进房记录
        TTSearchVisitRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TTSearchVisitRoomCell.class) forIndexPath:indexPath];
        cell.dataArray = self.visitRoomList;
        @weakify(self)
        cell.selectedRoomHandler = ^(RoomVisitRecord * _Nonnull room) {
            
            [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:room.roomUid.longLongValue];
            
            [TTStatisticsService trackEvent:@"search_recent_enter_room" eventDescribe:@"最近进房记录"];
            
            @strongify(self)
            [self.visitRoomList removeObject:room];
            [self.visitRoomList insertObject:room atIndex:0];
            [self.tableView reloadData];
        };
        cell.cleanRecordHandler = ^{
            @strongify(self)
            [self.view endEditing:YES];
            
            TTAlertConfig *config = [[TTAlertConfig alloc] init];
            config.message = @"确定清空进房记录吗？";
            config.cancelButtonConfig.title = @"手滑了";
            config.confirmButtonConfig.title = @"清空";
            
            [TTPopup alertWithConfig:config confirmHandler:^{
                [GetCore(RoomCoreV2) requestRoomVisitRecordClean];
            } cancelHandler:^{
            }];
        };
        return cell;
    }
    
    TTSearchRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTSearchRoomTableViewCell class]) forIndexPath:indexPath];
    
    SearchResultInfo *info = [self.resultList safeObjectAtIndex:indexPath.row];
    cell.info = info;
    
    if (!self.isPresent || info.uid == GetCore(AuthCore).getUid.longLongValue) {
        cell.presentButton.hidden = YES;
    } else {
        cell.presentButton.hidden = NO;
    }
    cell.inviteButton.hidden = !self.isInvite;
    
    //非赠送、非邀请、有房主UID，显示进入房间按钮
    cell.enterRoomButton.hidden = !self.enterRoomHandler || self.isPresent || self.isInvite || !info.userInRoomUid;
    
    @weakify(self)
    cell.presentBtnClickBlcok = ^(UIButton *button) {
        @strongify(self)
        
        if (button.tag == 1001) {
            // 发起邀请
            NSString *msg = [NSString stringWithFormat:@"确认邀请%@加入吗？", info.nick];
            
            TTAlertMessageAttributedConfig *nameAttrConfig = [[TTAlertMessageAttributedConfig alloc] init];
            nameAttrConfig.text = info.nick;
            nameAttrConfig.color = [XCTheme getTTMainColor];
            
            TTAlertConfig *config = [[TTAlertConfig alloc] init];
            config.message = msg;
            config.messageAttributedConfig = @[nameAttrConfig];
            
            [TTPopup alertWithConfig:config confirmHandler:^{
                
                [GetCore(GuildCore) requestGuildHallInviteWithTargetUid:[NSString stringWithFormat:@"%lld", info.uid]];
                
            } cancelHandler:^{
                
            }];
            
            return ;
        }
        
        UserInfo *uinfo = [UserInfo new];
        uinfo.uid = info.uid;
        uinfo.nick = info.nick;
        if (self.isPresent && self.searchPresentDidClickBlock) {
            // 执行block
            self.searchPresentDidClickBlock(info.uid, info.nick);
        }
    };
    
    cell.enterRoomHandler = ^{
        @strongify(self)
        !self.enterRoomHandler ?: self.enterRoomHandler(info.userInRoomUid.userIDValue);
        [TTStatisticsService trackEvent:@"search_enter_room" eventDescribe:@"搜索结果_进入房间"];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.showHistoryRecord && self.shouldShowHistoryRecord) {
        if ([self searchRecordList].count > 0 && indexPath.row == 0) {
            return 100;
        }
        return 160;
    }
    
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.showHistoryRecord && self.shouldShowHistoryRecord) {
        return;
    }
    
    if (self.isPresent || self.isInvite) {
        return;
    }
    
    SearchResultInfo *info = self.resultList[indexPath.row];
    
    if (self.isHallSearch) {
        UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:info.uid];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        @weakify(self);
        [self dismissViewControllerAnimated:YES completion:^{
            @strongify(self);
            if (self.dismissAndDidClickPersonBlcok) {
                self.dismissAndDidClickPersonBlcok(info.uid);
            }
        }];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self search:textField.text];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //清除最后一个字符，展示搜索记录
    if (NSEqualRanges(range, NSMakeRange(0, 1)) && [string isEqualToString:@""]) {
        if (self.showHistoryRecord) {
            self.shouldShowHistoryRecord = YES;
            self.emptyDataView.hidden = YES;
            [self.tableView reloadData];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    //清空字符，展示搜索记录
    if (self.showHistoryRecord) {
        self.shouldShowHistoryRecord = YES;
        self.emptyDataView.hidden = YES;
        [self.tableView reloadData];
    }
    
    return YES;
}

#pragma mark - Search
- (void)search:(NSString *)key {
    [self.view endEditing:YES];
    [XCHUDTool showGIFLoadingInView:self.view];
    
    //保存搜索记录
    [self storeSearchRecord:key];
    
    if (self.showHistoryRecord) {
        self.shouldShowHistoryRecord = NO;
    }
    
    if (self.isHallSearch) {
        
        UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore).getUid longLongValue]];
        [GetCore(GuildCore) requestGuildSearchMembersWithHallId:@(info.hallId).stringValue key:key];
    } else {
        [GetCore(SearchCore) searchWithKey:key];
    }
}

#pragma mark - SearchCoreClient
- (void)onSearchSuccess:(NSArray *)data {
    [XCHUDTool hideHUDInView:self.view];
    
    self.emptyDataView.hidden = data.count > 0;
    self.resultList = data;
    [self.tableView reloadData];
}

- (void)onSearchFailth:(NSString *)message {
    [XCHUDTool showErrorWithMessage:message inView:self.view];
}

#pragma mark - GuildCoreClient
- (void)responseGuildHallInvite:(BOOL)isSuccess errorCode:(NSNumber *)code msg:(NSString *)msg {
    if (isSuccess) {
        [XCHUDTool showSuccessWithMessage:@"已成功发送邀请" inView:self.view];
    }
}

/** 根据搜索结果 */
- (void)responseGuildHallSearchMembers:(NSArray<UserInfo *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    [XCHUDTool hideHUDInView:self.view];
    
    self.emptyDataView.hidden = data.count > 0;
    self.resultList = data.copy;
    [self.tableView reloadData];
}

#pragma mark - RoomCoreClient
/// 进房记录
- (void)responseRoomVisitRecord:(NSArray<RoomVisitRecord *> *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    self.visitRoomList = data.mutableCopy;
    [self.tableView reloadData];
}

/// 进房记录清除
- (void)responseRoomVisitRecordClean:(BOOL)success errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    self.visitRoomList = nil;
    [self.tableView reloadData];
}

#pragma mark - event response
- (void)didClickedCancleButton:(UIButton *)button {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method
- (void)initView {
    [self.view addSubview:self.customNavView];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[TTSearchRoomTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TTSearchRoomTableViewCell class])];
    [self.tableView registerClass:[TTSearchRecordCell class] forCellReuseIdentifier:NSStringFromClass([TTSearchRecordCell class])];
    [self.tableView registerClass:[TTSearchVisitRoomCell class] forCellReuseIdentifier:NSStringFromClass([TTSearchVisitRoomCell class])];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)initConstrations {
    [self.customNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(statusbarHeight + 44);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.customNavView.mas_bottom);
    }];
}

- (void)initEvent {
    [self.customNavView.cancleButton addTarget:self action:@selector(didClickedCancleButton:) forControlEvents:UIControlEventTouchUpInside];
}

/// 获取搜索记录
- (NSArray *)searchRecordList {
    NSString *key = [NSString stringWithFormat:@"%@_%@", XCConstSearchRecordStoreKey, [GetCore(AuthCore) getUid]];
    NSArray *list = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return list;
}

/// 保存搜索记录
- (void)storeSearchRecord:(NSString *)record {
    if (record == nil || record.length <= 0) {
        return;
    }
    
    NSString *key = [NSString stringWithFormat:@"%@_%@", XCConstSearchRecordStoreKey, [GetCore(AuthCore) getUid]];
    NSMutableArray *list = [[[NSUserDefaults standardUserDefaults] objectForKey:key] mutableCopy];
    if (list == nil) {
        list = [[NSMutableArray alloc] init];
    }
    
    [list removeObject:record];//去重
    [list insertObject:record atIndex:0];//插入
    
    if (list.count > 20) {//最多保存20条记录
        [list removeLastObject];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:list forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 清空搜索记录
- (void)cleanSearchRecord {
    NSString *key = [NSString stringWithFormat:@"%@_%@", XCConstSearchRecordStoreKey, [GetCore(AuthCore) getUid]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - getters and setters
- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)setIsHallSearch:(BOOL)isHallSearch {
    _isHallSearch = isHallSearch;
    
    NSString *placeholder = [NSString stringWithFormat:@"搜索昵称/%@ID", [XCKeyWordTool sharedInstance].myAppName];
    self.customNavView.searchTextField.placeholder = placeholder;
}

- (void)setIsInvite:(BOOL)isInvite {
    _isInvite = isInvite;
    
    NSString *placeholder = [NSString stringWithFormat:@"搜索昵称/%@ID", [XCKeyWordTool sharedInstance].myAppName];
    self.customNavView.searchTextField.placeholder = placeholder;
}

- (TTSearchCustomNavView *)customNavView {
    if (!_customNavView) {
        _customNavView = [[TTSearchCustomNavView alloc] init];
        _customNavView.searchTextField.delegate = self;
    }
    return _customNavView;
}

- (XCEmptyDataView *)emptyDataView {
    if (!_emptyDataView) {
        _emptyDataView = [[XCEmptyDataView alloc] init];
        _emptyDataView.frame = CGRectMake(0, statusbarHeight + 64, KScreenWidth, KScreenHeight);
        _emptyDataView.title = @"没有搜到相关消息";
        _emptyDataView.messageLabel.textColor = RGBCOLOR(153, 153, 153);
        _emptyDataView.messageLabel.font = [UIFont systemFontOfSize:13];
        _emptyDataView.image = [UIImage imageNamed:@"common_noData_empty"];
        _emptyDataView.imageFrame = CGRectMake((KScreenWidth - 185) / 2, (KScreenHeight - 145) / 2 - 60, 185, 145);
        _emptyDataView.hidden = YES;
        _emptyDataView.backgroundColor = [UIColor whiteColor];
        _emptyDataView.margin = -45;
        [self.view addSubview:_emptyDataView];
    }
    return _emptyDataView;
}

@end
