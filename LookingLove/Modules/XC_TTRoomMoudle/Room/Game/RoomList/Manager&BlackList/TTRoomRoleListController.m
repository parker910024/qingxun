//
//  TTRoomRoleListController.m
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTRoomRoleListController.h"
#import "TTRoomRoleListCell.h"

#import "ImRoomCoreV2.h"
#import "ImRoomCoreClientV2.h"
#import "UserCore.h"
#import "RoomCoreV2.h"
#import "AuthCore.h"

#import "UIViewController+EmptyDataView.h"
#import "XCMacros.h"
#import "XCHUDTool.h"
#import "NSArray+Safe.h"
#import "NSMutableArray+Safe.h"
#import "NSBundle+Source.h"
#import "NSString+JsonToDic.h"

#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "TTRoomModuleCenter.h"

static NSString *const kCellID = @"kCellID";

@interface TTRoomRoleListController ()<ImRoomCoreClientV2>

@property (strong, nonatomic) NSMutableArray<NIMChatroomMember *> *roomMemberArray;

@end

@implementation TTRoomRoleListController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.role == TTRoomRoleManager ? @"管理员" : @"黑名单";

    [self initView];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.roomMemberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTRoomRoleListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    
    NIMChatroomMember *member = [self.roomMemberArray safeObjectAtIndex:indexPath.row];
    cell.member = member;
    
    @weakify(self)
    [cell setRemoveMemberBlock:^{
        @strongify(self)
       if (self.role == TTRoomRoleManager) {
           [GetCore(ImRoomCoreV2) markManagerList:member.userId.intValue enable:NO];
           
       } else {
           
           XCUserInfoPlatformRole platformRole = [GetCore(UserCore)getUserInfoInDB:GetCore(AuthCore).getUid.userIDValue].platformRole;
           if (platformRole == XCUserInfoPlatformRoleSuperAdmin) {
               
               [GetCore(RoomCoreV2) requsetRoomSettingSuperAdminWithTargetUid:GetCore(AuthCore).getUid.userIDValue opt:1 success:^(BOOL success) {
                    
                   if (success) {
                       [GetCore(ImRoomCoreV2) markBlackList:member.userId.intValue enable:NO];
                       
                   } else {
                       [self.navigationController popToRootViewControllerAnimated:YES];
                   }
               }];
               
           } else if(GetCore(ImRoomCoreV2).myMember.type == NIMChatroomMemberTypeCreator||GetCore(ImRoomCoreV2).myMember.type == NIMChatroomMemberTypeManager) {
               
               [GetCore(ImRoomCoreV2) markBlackList:member.userId.intValue enable:NO];
           }
       }
       
       [self.roomMemberArray removeObjectAtSafeIndex:indexPath.row];
       [tableView reloadData];
    }];
    
    return cell;
}

#pragma mark - ImRoomCoreClientV2
- (void)fetchAllRegularMemberSuccess {
    
    if (self.role == TTRoomRoleManager) {
        
        NSMutableArray *uids = [NSMutableArray array];
        for (NIMChatroomMember *member in [GetCore(ImRoomCoreV2).allManagers copy]) {
            [uids addObject:member.userId];
        }
        
        @weakify(self)
        [GetCore(UserCore) getUserInfos:uids refresh:YES success:^(NSArray *infoArr) {
            
            @strongify(self)
            NSMutableArray *members = [NSMutableArray array];
            
            for (UserInfo *userInfo in infoArr) {
                if (userInfo.platformRole == XCUserInfoPlatformRoleSuperAdmin) {
                    continue;
                }
                
                for (NIMChatroomMember *member in [GetCore(ImRoomCoreV2).allManagers copy]) {
                    if (member.userId.userIDValue == userInfo.uid) {
                        [members addObject:member];
                    }
                }
            }
            
            self.roomMemberArray = members;
            [self reloadData];
        }];
        
    } else {
        self.roomMemberArray = [GetCore(ImRoomCoreV2).backLists mutableCopy];
        [self reloadData];
    }
}

- (void)fetchAllRegularMemberError:(NSError *)error {
    
    if (error) {
        [XCHUDTool showErrorWithMessage:error.localizedDescription];
    }
    
    if (self.role == TTRoomRoleManager) {
        self.roomMemberArray = [GetCore(ImRoomCoreV2).allManagers mutableCopy];
    } else {
        self.roomMemberArray = [GetCore(ImRoomCoreV2).backLists mutableCopy];
    }
    
    if (self.roomMemberArray == nil || self.roomMemberArray.count == 0) {
        NSString *tips = self.role == TTRoomRoleManager ? @"还没有设置管理员哦" : @"还没有黑名单哦";
        [self showEmptyDataViewWithTitle:tips image:[UIImage imageNamed:@"common_noData_empty"]];
    }
    
    [self.tableView reloadData];
}

#pragma mark - private method

- (void)initView {
    AddCoreClient(ImRoomCoreClientV2, self);
    [GetCore(ImRoomCoreV2) queryManagerorBackList];

    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.tableView.rowHeight = 65;
    [self.tableView registerClass:TTRoomRoleListCell.class forCellReuseIdentifier:kCellID];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    @weakify(self)
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.mas_equalTo(self.view);
        }
    }];
}

- (void)reloadData {
    
    if (self.roomMemberArray == nil || self.roomMemberArray.count == 0) {
        NSString *tips = self.role == TTRoomRoleManager ? @"还没有设置管理员哦" : @"还没有黑名单哦";
        [self showEmptyDataViewWithTitle:tips image:[UIImage imageNamed:@"common_noData_empty"]];
    }
    
    [self.tableView reloadData];
}

@end
