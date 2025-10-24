//
//  TTFamilyShareChildViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/19.
//  Copyright © 2018年 YiZhuan. All rights reserved.
// 分享 好友 粉丝 关注 群

#import "TTFamilyShareChildViewController.h"
//view
#import "TTFamilyMemberTableViewCell.h"
#import "TTFamilyShareGroupTableViewCell.h"
//core
#import "ImFriendCore.h"
#import "PraiseCore.h"
#import "PraiseCoreClient.h"
#import "GroupCore.h"
#import "GroupCoreClient.h"
#import "Attention.h"
#import "UserInfo.h"
#import "ShareModelInfor.h"
#import "ShareCore.h"
#import "AuthCore.h"
#import "RoomCoreV2.h"
#import "RoomQueueCoreV2.h"
#import "TTGameStaticTypeCore.h"
//tool
#import "XCHUDTool.h"
#import "UIView+XCToast.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "NSArray+Safe.h"
#import "TTFamilyBaseAlertController.h"

@interface TTFamilyShareChildViewController ()
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) ShareModelInfor * shareModel;
@property (nonatomic, strong) UIButton *inviteButton; //用于CP房 立即邀请
@property (nonatomic, strong) NSMutableArray *inviteArray; // CP房选中的邀请人
@property (nonatomic, strong) NSMutableArray *buttonSelectArray;  //  存在button选中状态的数组
@property (nonatomic, strong) NSMutableArray *uidArray;  // 存放uid的数组
@end

@implementation TTFamilyShareChildViewController
-(void)dealloc{
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCore];
    [self initView];
    [self initContrations];
}
#pragma mark - private method
- (void)initView{
    self.currentPage = 1;
    self.shareModel = [GetCore(ShareCore) getShareModel];
    
    self.inviteArray = [NSMutableArray array];
    self.buttonSelectArray = [NSMutableArray array];
    self.uidArray = [NSMutableArray array];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[TTFamilyMemberTableViewCell class] forCellReuseIdentifier:@"TTFamilyMemberTableViewCell"];
    [self.tableView registerClass:[TTFamilyShareGroupTableViewCell class] forCellReuseIdentifier:@"TTFamilyShareGroupTableViewCell"];
    
    [self.view addSubview:self.inviteButton];
    if (GetCore(TTGameStaticTypeCore).shareRoomOrInviteType == TTShareRoomOrInviteFriendStatus_Invite) {
        self.inviteButton.hidden = NO;
    }
}

- (void)initContrations{
    
    for (int i = 0; i < self.dataSource.count; i++) {
        [self.buttonSelectArray addObject:@"0"];
    }
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
            if (GetCore(TTGameStaticTypeCore).shareRoomOrInviteType == TTShareRoomOrInviteFriendStatus_Invite) {
                make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-53);
            }else{
                make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            }
        } else {
            make.top.mas_equalTo(self.view.mas_top);
            if (GetCore(TTGameStaticTypeCore).shareRoomOrInviteType == TTShareRoomOrInviteFriendStatus_Invite) {
                make.bottom.mas_equalTo(self.view.mas_bottom).offset(-53);
            }else{
                make.bottom.mas_equalTo(self.view.mas_bottom);
            }
        }
        make.left.right.mas_equalTo(self.view);
    }];
    
    self.inviteButton.frame = CGRectMake(15, self.view.frame.size.height - kNavigationHeight - 38 - kSafeAreaBottomHeight - 15, self.view.frame.size.width - 30, 38);
    
}

- (void)addCore{
    AddCoreClient(PraiseCoreClient, self);
    AddCoreClient(GroupCoreClient, self);
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.childShareType == TTFamilyShare_Type_Group) {
        TTFamilyShareGroupTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TTFamilyShareGroupTableViewCell"];
        if (cell == nil) {
            cell = [[TTFamilyShareGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyShareGroupTableViewCell"];
        }
        [cell configShareGroupCellWith:[self.dataSource safeObjectAtIndex:indexPath.row]];
        return cell;
    }else{
        TTFamilyMemberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTFamilyMemberTableViewCell"];
        if (cell == nil) {
            cell = [[TTFamilyMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyMemberTableViewCell"];
        }
        if (self.childShareType == TTFamilyShare_Type_Fans || self.childShareType == TTFamilyShare_Type_Focus) {
            Attention * attention = [self.dataSource safeObjectAtIndex:indexPath.row];
            UserInfo * infor = [UserInfo yy_modelWithDictionary:[attention model2dictionary]];
            [cell configShareCellWith:infor];
        }else{
            UserInfo * infor = [self.dataSource safeObjectAtIndex:indexPath.row];
            [cell configShareCellWith:infor];
            
            cell.inviteButton.tag = indexPath.row;
            
            cell.inviteButton.selected = [self.buttonSelectArray[indexPath.row] intValue] == 1 ? YES : NO;
            
            if (cell.inviteButton.hidden == NO) {
                
                [cell.inviteButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                
            }
        }
        return cell;
    }
}


-(void)buttonAction:(UIButton *)sender{
    
    UserInfo * infor = [self.dataSource safeObjectAtIndex:sender.tag];
    int sesstionType = 0;
    NSString *uid = [NSString stringWithFormat:@"%lld", infor.uid];
    ShareModelInfor * information = self.shareModel;
    information.sesstionType = sesstionType;
    information.sessionId = uid;
    
    if (self.inviteArray.count >= 20) {
        if (sender.selected == YES) {
            [self.buttonSelectArray replaceObjectAtIndex:sender.tag withObject:@"0"];
            int index = [self.uidArray indexOfObject:uid];
            [self.uidArray removeObjectAtIndex:index];
            [self.inviteArray removeObjectAtIndex:index];
            sender.selected = sender.selected ? NO : YES;
            if (self.customTitleBlock) {
                self.customTitleBlock(self.inviteArray.count);
            }
        }else{
            [XCHUDTool showErrorWithMessage:@"最多只能邀请20个好友哦" inView:self.view];
        }
        return;
    }
    
    sender.selected = sender.selected ? NO : YES;
    
    if (sender.selected == YES) {
        information.shareType = Custom_Noti_Sub_Share_Room;
        
        [self.buttonSelectArray replaceObjectAtIndex:sender.tag withObject:@"1"];
        [self.inviteArray addObject:infor];
        [self.uidArray addObject:uid];
    }else{
        [self.buttonSelectArray replaceObjectAtIndex:sender.tag withObject:@"0"];
        int index = [self.uidArray indexOfObject:uid];
        [self.uidArray removeObjectAtIndex:index];
        [self.inviteArray removeObjectAtIndex:index];
    }
    if (self.customTitleBlock) {
        self.customTitleBlock(self.inviteArray.count);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.shareModel) {
        TTFamilyAlertModel * config = [[TTFamilyAlertModel alloc] init];
        int sesstionType = 0;
        NSString * uid;
        if (self.childShareType == TTFamilyShare_Type_Group) { // 群
            GroupModel * model = [self.dataSource safeObjectAtIndex:indexPath.row];
            config.content = [NSString stringWithFormat:@"确认分享给%@吗？", model.name];
            config.familyMemberIcon = model.icon;
            config.familyMemberName = model.name;
            sesstionType = 1;
            uid = [NSString stringWithFormat:@"%ld", model.tid];
        }else if(self.childShareType == TTFamilyShare_Type_FriendList){ // 好友
            UserInfo * infor = [self.dataSource safeObjectAtIndex:indexPath.row];
            
            config.content = [NSString stringWithFormat:@"确认分享给%@吗？", infor.nick];
            config.familyMemberIcon = infor.avatar;
            config.familyMemberName = infor.nick;
            sesstionType = 0;
            uid = [NSString stringWithFormat:@"%lld", infor.uid];
            
            if (GetCore(TTGameStaticTypeCore).shareRoomOrInviteType == TTShareRoomOrInviteFriendStatus_Invite) {
                ShareModelInfor * information = self.shareModel;
                information.sesstionType = sesstionType;
                information.sessionId = uid;
                
                TTFamilyMemberTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                if (cell.inviteButton.hidden == NO) {
                    if (self.inviteArray.count >= 20) {
                        if (cell.inviteButton.selected == YES) {
                            [self.buttonSelectArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
                            int index = [self.uidArray indexOfObject:uid];
                            [self.uidArray removeObjectAtIndex:index];
                            [self.inviteArray removeObjectAtIndex:index];
                            cell.inviteButton.selected = cell.inviteButton.selected ? NO : YES;
                            if (self.customTitleBlock) {
                                self.customTitleBlock(self.inviteArray.count);
                            }
                        }else{
                            [XCHUDTool showSuccessWithMessage:@"最多只能邀请20个好友哦" inView:self.view];
                        }
                        
                        return;
                    }
                    cell.inviteButton.selected = cell.inviteButton.selected ? NO : YES;
                    if (cell.inviteButton.selected == YES) {
                        
                        [self.buttonSelectArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
                        [self.inviteArray addObject:infor];
                        [self.uidArray addObject:uid];
                    }else{
                        [self.buttonSelectArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
                        int index = [self.uidArray indexOfObject:uid];
                        [self.uidArray removeObjectAtIndex:index];
                        [self.inviteArray removeObjectAtIndex:index];
                    }
                    if (self.customTitleBlock) {
                        self.customTitleBlock(self.inviteArray.count);
                    }
                }
            }
        }else{  // 关注和粉丝
            Attention * attention = [self.dataSource safeObjectAtIndex:indexPath.row];
            config.content = [NSString stringWithFormat:@"确认分享给%@吗？", attention.nick];
            config.familyMemberIcon = attention.avatar;
            config.familyMemberName = attention.nick;
            sesstionType = 0;
            uid =  [NSString stringWithFormat:@"%lld", attention.uid];
        }
        if (GetCore(TTGameStaticTypeCore).shareRoomOrInviteType == TTShareRoomOrInviteFriendStatus_Invite){
            return;
        }
        ShareModelInfor * infor = self.shareModel;
        infor.sesstionType = sesstionType;
        infor.sessionId = uid;
        if (self.shareModel.Type == XCShare_Type_Invite) {//邀请的弹框
            [[TTFamilyBaseAlertController defaultCenter] showShareAlertViewWith:self alertConfig:config sure:^{
                [GetCore(ShareCore) shareAppliactionWith:infor];
            } canle:nil];
        }else{//分享的弹框
            [[TTFamilyBaseAlertController defaultCenter] showAlertViewWith:self alertConfig:config sure:^{
                [GetCore(ShareCore) shareAppliactionWith:infor];
            } canle:nil];
        }
        
    }
}

#pragma mark - GroupCoreClient
//群
- (void)fetchUserTotalGroupsSuccess:(NSArray *)groups status:(int)staus{
    if (_childShareType == TTFamilyShare_Type_Group) {
        self.dataSource = [groups mutableCopy];
        [self.tableView hideToastView];
        if (self.dataSource.count <= 0) {
            [self.tableView  showEmptyContentToastWithTitle:@"您暂时还没有加入任何群聊" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - PraiseCoreClient
//关注 列表
- (void)onRequestAttentionListState:(int)state success:(NSArray *)attentionList {
    if (_childShareType == TTFamilyShare_Type_Focus) {
        if (self.currentPage == 1) {
            [self.dataSource removeAllObjects];
            self.dataSource = [attentionList mutableCopy];
        }else{
            [self.dataSource addObjectsFromArray:[attentionList mutableCopy]];
        }
        if (attentionList.count>0) {
            [self.tableView endRefreshStatus:state hasMoreData:YES];
        }else{
            [self.tableView endRefreshStatus:state hasMoreData:NO];
        }
        
        [self.tableView hideToastView];
        if (self.dataSource.count <= 0) {
            [self.tableView  showEmptyContentToastWithTitle:@"您还没关注任何人" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
        }
        [self.tableView reloadData];
    }
}
//粉丝列表
- (void)onRequestFansListState:(int)state success:(NSArray *)fansList {
    if (_childShareType == TTFamilyShare_Type_Fans) {
        if (self.currentPage == 1) {
            [self.dataSource removeAllObjects];
            self.dataSource = [fansList mutableCopy];
        }else{
            if (fansList.count > 0) {
                [self.dataSource addObjectsFromArray:fansList];
            }
        }
        
        if (fansList.count>0) {
            [self.tableView endRefreshStatus:state hasMoreData:YES];
        }else{
            [self.tableView endRefreshStatus:state hasMoreData:NO];
        }
        [self.tableView hideToastView];
        if (self.dataSource.count <= 0) {
            [self.tableView  showEmptyContentToastWithTitle:@"您还没有任何粉丝" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
        }
        [self.tableView reloadData];
    }
}
- (void) onRequestAttentionListState:(int)state failth:(NSString *)msg {
    [self.tableView endRefreshStatus:state];
}
- (void) onRequestFansListState:(int)state failth:(NSString *)msg {
    [self.tableView endRefreshStatus:state];
}


#pragma mark - http
- (void)refrestDataSourceWithShareType:(TTFamilyShare_Type)shareType page:(int)page status:(int)status{
    if (shareType == TTFamilyShare_Type_FriendList) {
        //好友
        NSArray *array = [GetCore(ImFriendCore)getMyFriends];
        self.dataSource = [array mutableCopy];
        [self.tableView hideToastView];
        if (self.dataSource.count > 0) {
            [self.tableView reloadData];
        }else{
            [self.tableView showEmptyContentToastWithTitle:@"您暂时还没有好友" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
        }
    }else if (shareType == TTFamilyShare_Type_Focus){
        [GetCore(PraiseCore)requestAttentionListState:status page:page PageSize:20];
    }else if (shareType == TTFamilyShare_Type_Fans){
        [GetCore(PraiseCore)requestFansListState:status page:page];
    }else{
        [GetCore(GroupCore) fecthUserTotalGroupWith:status];
    }
    
}

- (void)pullDownRefresh:(int)page{
    self.currentPage = page;
    [self refrestDataSourceWithShareType:self.childShareType page:page status:0];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage{
    if (isLastPage) {
        return;
    }
    self.currentPage = page;
    [self refrestDataSourceWithShareType:self.childShareType page:page status:1];
}


#pragma mark - setters and getters
- (void)setChildShareType:(TTFamilyShare_Type)childShareType{
    _childShareType = childShareType;
    if (_childShareType == TTFamilyShare_Type_Fans || _childShareType == TTFamilyShare_Type_Focus) {
        [self setupRefreshTarget:self.tableView];
    }
    [self refrestDataSourceWithShareType:childShareType page:1 status:0];
}
-(UIButton *)inviteButton{
    if (!_inviteButton) {
        self.inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _inviteButton.backgroundColor = [XCTheme getTTMainColor];
        _inviteButton.layer.cornerRadius = 19;
        [_inviteButton setTitle:@"立即邀请" forState:UIControlStateNormal];
        [_inviteButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_inviteButton addTarget:self action:@selector(inviteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _inviteButton.hidden = YES;
    }
    return _inviteButton;
}

-(void)inviteButtonAction:(UIButton *)sender{
    NIMChatroomMember *mineMember = GetCore(RoomQueueCoreV2).myMember;
    NSMutableArray *uidArray = [NSMutableArray array];
    if (self.inviteArray.count > 0) {
        for (int i = 0; i < self.inviteArray.count; i++) {
            UserInfo * info = self.inviteArray[i];
            [uidArray addObject:[NSString stringWithFormat:@"%lld",info.uid]];
        }
        
        for (int i = 0 ; i < self.inviteArray.count; i++) {
            ShareModelInfor * infor = [[ShareModelInfor alloc] init];
            infor.shareType = Custom_Noti_Sub_Share_Room;
            infor.roomInfor = GetCore(RoomCoreV2).getCurrentRoomInfo;
            infor.sessionId = uidArray[i];
            infor.sesstionType = NIMSessionTypeP2P;
            [GetCore(ShareCore) shareAppliactionWith:infor];
        }
        
        [GetCore(RoomCoreV2) getRoomInviteUid:uidArray roomUid:GetCore(RoomCoreV2).getCurrentRoomInfo.uid success:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
        
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"inviteFriend"] isEqualToString:@"inviteFri"]){
            NSDictionary *params = @{@"title": GetCore(RoomCoreV2).getCurrentRoomInfo.title ?: @"",
                                     @"roomPwd": GetCore(RoomCoreV2).getCurrentRoomInfo.roomPwd ?: @"",
                                     @"tagId": @(GetCore(RoomCoreV2).getCurrentRoomInfo.tagId),
                                     @"limitType":GetCore(RoomCoreV2).getCurrentRoomInfo.roomPwd.length > 0 ? @"lock":@"",
                                     };
            [dataDict setDictionary:params];
        }else{
            NSDictionary *params = @{@"title": GetCore(RoomCoreV2).getCurrentRoomInfo.title ?: @"",
                                     @"roomPwd": @"" ?: @"",
                                     @"tagId": @(GetCore(RoomCoreV2).getCurrentRoomInfo.tagId),
                                     @"limitType":@"isInvite" ?:@"",
                                     };
            [dataDict setDictionary:params];
        }
        
        if (mineMember.type == NIMChatroomMemberTypeManager) {
            [GetCore(RoomCoreV2) updateGameRoomInfo:dataDict
                                               type:UpdateRoomInfoTypeManager
                                 hasAnimationEffect:GetCore(RoomCoreV2).getCurrentRoomInfo.hasAnimationEffect
                                       audioQuality:GetCore(RoomCoreV2).getCurrentRoomInfo.audioQuality
                                          eventType:RoomUpdateEventTypeOther];
        }else if (mineMember.type == NIMChatroomMemberTypeCreator){
            [GetCore(RoomCoreV2) updateGameRoomInfo:dataDict
                                               type:UpdateRoomInfoTypeUser
                                 hasAnimationEffect:GetCore(RoomCoreV2).getCurrentRoomInfo.hasAnimationEffect
                                       audioQuality:GetCore(RoomCoreV2).getCurrentRoomInfo.audioQuality
                                          eventType:RoomUpdateEventTypeOther];
        }
        
        
    }else{
        [XCHUDTool showErrorWithMessage:@"要选择好友才可以邀请哦" inView:self.view];
    }
    
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"inviteFriend"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
