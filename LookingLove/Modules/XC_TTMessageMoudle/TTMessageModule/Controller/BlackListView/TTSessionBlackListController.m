//
//  XCSessionBlackListController.m
//  XChat
//
//  Created by 卫明何 on 2018/1/27.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "TTSessionBlackListController.h"
#import "TTSessionPersonInfoCell.h"
#import "TTSessionLabelCell.h"
#import "TTBlackListTwiceEnsureView.h"

#import "XCMediator+TTPersonalMoudleBridge.h"
#import "TTWKWebViewViewController.h"
#import "XCHtmlUrl.h"
#import "TTPopup.h"

#import "UserCore.h"
#import "ImFriendCore.h"
#import "ImFriendCoreClient.h"
#import "XCHUDTool.h"
#import "XCTheme.h"
#import "XCMacros.h"
#import <Masonry.h>

@interface TTSessionBlackListController ()<ImFriendCoreClient>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UserInfo *userInfo;

@end

@implementation TTSessionBlackListController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    AddCoreClient(ImFriendCoreClient, self);
    [self initView];
}

- (void)dealloc {
    RemoveCoreClient(ImFriendCoreClient, self);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 20;
    } else {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60.0;
    } else {
        return 44;
    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:self.userInfo.uid];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc] init];
        NSString *urlstr = [NSString stringWithFormat:@"%@?reportUid=%lld&source=CHAT",HtmlUrlKey(kReportURL),self.userInfo.uid];
        vc.urlString = urlstr;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    [self showBlackListAlert:self.userInfo.uid];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc]init];
    if (section == 1) {
        header.frame = CGRectMake(0, 0, self.view.frame.size.width, 20);
        header.backgroundColor = UIColorFromRGB(0xebebeb);
    } else if (section == 0) {
        return nil;
    }
    return [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        TTSessionPersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XCSessionPersonInfoCell" forIndexPath:indexPath];
        [cell setUserInfo:self.userInfo];
        return cell;
    } else {
        TTSessionLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XCLabelCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            [cell setTitle:@"举报"];
        } else {
            BOOL isInBlack = [GetCore(ImFriendCore)isUserInBlackList:[NSString stringWithFormat:@"%lld",self.userInfo.uid]];
            if (!isInBlack) {
                [cell setTitle:@"加入黑名单"];
            } else {
                [cell setTitle:@"移除黑名单"];
            }
        }
        
        return cell;
    }
    return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
}

#pragma mark - ImFriendCoreClient
- (void)onAddToBlackListSuccess {
    @weakify(self);
    dispatch_main_sync_safe(^{
        @strongify(self);
        [self.tableView reloadData];
    });
    [XCHUDTool showSuccessWithMessage:@"操作成功" inView:self.view];
}

- (void)onAddToBlackListFailth {
    [XCHUDTool showErrorWithMessage:@"状态异常" inView:self.view];
}

- (void)onRemoveFromBlackListSuccess {
    @weakify(self);
    dispatch_main_sync_safe(^{
        @strongify(self);
        [self.tableView reloadData];
    });
    [XCHUDTool showSuccessWithMessage:@"操作成功" inView:self.view];
}

- (void)onRemoveFromBlackListFailth {
    [XCHUDTool showErrorWithMessage:@"状态异常" inView:self.view];
}

#pragma mark - Public
- (void)setUid:(UserID)uid {
    _uid = uid;
    UserInfo * info = [GetCore(UserCore)getUserInfoInDB:uid];
    self.userInfo = info;
    [self.tableView reloadData];
}

#pragma mark - private method

- (void)initView {
    self.title = @"聊天信息";
    self.view.backgroundColor =UIColorFromRGB(0xebebeb);
    
    [self.tableView registerClass:[TTSessionPersonInfoCell class] forCellReuseIdentifier:@"XCSessionPersonInfoCell"];
    [self.tableView registerClass:[TTSessionLabelCell class] forCellReuseIdentifier:@"XCLabelCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
    self.headerView.backgroundColor = UIColorFromRGB(0xebebeb);
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusbarHeight + 44);
        make.bottom.leading.trailing.mas_equalTo(self.view);
    }];
}


- (void)showBlackListAlert:(UserID)uid {
    NSString *title = nil;
    NSString *message = nil;
    if (![GetCore(ImFriendCore)isUserInBlackList:[NSString stringWithFormat:@"%lld",self.userInfo.uid]]) {
        title = @"加入黑名单";
        message = @"加入黑名单，你将不再收到对方的消息";
    } else {
        title = @"移除黑名单";
        message = @"移除黑名单，你将正常收到对方的消息";
    }
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = title;
    config.message = message;
    
    @weakify(self)
    [TTPopup alertWithConfig:config confirmHandler:^{
        @strongify(self);
        if (![GetCore(ImFriendCore)isUserInBlackList:[NSString stringWithFormat:@"%lld",self.userInfo.uid]]) {
            [GetCore(ImFriendCore)addToBlackList:[NSString stringWithFormat:@"%lld",uid]];
        } else {
            [GetCore(ImFriendCore)removeFromBlackList:[NSString stringWithFormat:@"%lld",uid]];
        }
    } cancelHandler:^{
        
    }];
}

@end
