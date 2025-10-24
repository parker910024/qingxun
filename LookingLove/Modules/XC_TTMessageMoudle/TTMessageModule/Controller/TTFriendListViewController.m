//
//  TTFriendListViewController.m
//  TuTu
//
//  Created by gzlx on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFriendListViewController.h"
#import "TTMessageEmptyDataView.h"

#import "XCMediator+TTPersonalMoudleBridge.h"
#import "TTSessionViewController.h"
//core
#import "ImFriendCore.h"
#import "ImFriendCoreClient.h"
#import "UserInfo.h"
#import "AuthCoreClient.h"
//tool
#import "XCHUDTool.h"
#import "XCTheme.h"
#import "NSArray+Safe.h"
#import "XCCurrentVCStackManager.h"
#import "XCMacros.h"
#import <Masonry/Masonry.h>
//view
#import "TTFriendTableViewCell.h"

@interface TTFriendListViewController ()<UITableViewDelegate, UITableViewDataSource, ImFriendCoreClient, TTFriendTableViewCellDelegate, AuthCoreClient>
/**好友列表 */
@property (nonatomic, strong) NSMutableArray<UserInfo *> * friendArray;

@property (nonatomic, strong) TTMessageEmptyDataView *emptyDataView;

@end

@implementation TTFriendListViewController

- (BOOL)isHiddenNavBar{
    if (self.type == MessageVCType_RoomChat || self.type == MessageVCType_Contacts) {
        return YES;
    }
    return NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

#pragma mark -private  method
- (void)initView{
    self.navigationItem.title = @"好友";
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(KScreenWidth);
        if (self.type == MessageVCType_Default){
            make.top.mas_equalTo(self.view).offset(statusbarHeight + 44);
            make.bottom.mas_equalTo(self.view);
        }else if (self.type == MessageVCType_SendHeaderWear){
            make.top.mas_equalTo(self.view);
            make.height.mas_equalTo(KScreenHeight);
        }else{
            make.top.mas_equalTo(self.view);
            make.height.mas_equalTo(self.view);
        }
    }];
    if (self.type == MessageVCType_SendHeaderWear) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44 + 37 + statusbarHeight, 0);
    }
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        self.tableView.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }else {
      self.tableView.backgroundColor = [UIColor whiteColor];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerClass:[TTFriendTableViewCell class] forCellReuseIdentifier:@"TTFriendTableViewCell"];
    self.friendArray = [[GetCore(ImFriendCore) getMyFriends] mutableCopy];
}

#pragma mark - UITableViewDelegate and UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.backgroundView = self.friendArray.count == 0 ? self.emptyDataView : nil;
    return self.friendArray.count;
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
        }else if(self.type == MessageVCType_RoomChat){
            cell.cellType = TTFriendTableViewCell_RoomChat;
        }else{
            cell.cellType = TTFriendTableViewCell_Hidden;
        }
    }
    [cell configTTFriendTableViewCell:[self.friendArray safeObjectAtIndex:indexPath.row]];
    if (self.type == MessageVCType_AtPerson) {
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
    
    UserInfo *model = [self.friendArray safeObjectAtIndex:indexPath.row];
    if (model == nil || ![model isKindOfClass:UserInfo.class]) {
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

#pragma mark - TTFriendListViewControllerDelegate
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

#pragma mark - setters and getters
- (void)setIsReload:(BOOL)isReload{
    _isReload= isReload;
    if (_isReload) {
       self.friendArray = [[GetCore(ImFriendCore) getMyFriends] mutableCopy];
        [self.tableView reloadData];;
    }
}

- (void)setSelectDic:(NSMutableDictionary *)selectDic{
    _selectDic = selectDic;
    [self.tableView reloadData];
}

- (TTMessageEmptyDataView *)emptyDataView {
    if (_emptyDataView == nil) {
        _emptyDataView = [[TTMessageEmptyDataView alloc] init];
        _emptyDataView.backgroundColor = UIColor.whiteColor;
        _emptyDataView.text = @"你还没有添加任何好友哦！\n快去添加好友吧！";
        _emptyDataView.image = @"common_noData_empty";
        _emptyDataView.imageCenterOffsetY = -50;
        _emptyDataView.textToImageBottomOffset = 4;
    }
    return _emptyDataView;
}

@end
