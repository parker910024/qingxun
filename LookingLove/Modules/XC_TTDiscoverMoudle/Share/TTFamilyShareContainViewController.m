//
//  TTFamilyShareContainViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/14.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyShareContainViewController.h"
#import "ZJScrollPageView.h"
//vc
#import "TTFamilySearchViewController.h"
#import "XCAlertControllerCenter.h"
#import "TTFamilyBaseAlertController.h"
#import "TTFamilyShareChildViewController.h"
//core
#import "ShareCore.h"
#import "AuthCore.h"
#import "FamilyCoreClient.h"
#import "ImMessageCoreClient.h"
#import "TTGameStaticTypeCore.h"
#import "XCApplicationSharement.h"
//tool
#import "XCHUDTool.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>



@interface TTFamilyShareContainViewController ()<FamilyCoreClient,
ImMessageCoreClient,
TTFamilySearchViewControllerDelegate, ZJScrollPageViewDelegate>
@property (nonatomic, strong) ZJScrollPageView * scrollPageView;
@property (nonatomic, strong) ZJSegmentStyle * style;
@property (nonatomic, strong) ShareModelInfor * modelInfor;
@property (nonatomic, strong) NSArray<NSString *>* titles;
@property (nonatomic, strong) UILabel *customTitleLabel;
@property (nonatomic, strong) UIView *customTitleView;
@end

@implementation TTFamilyShareContainViewController
- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCore];
    [self initView];
}
- (void)initView {
    
    [self.view addSubview:self.scrollPageView];
    
    if (GetCore(TTGameStaticTypeCore).shareRoomOrInviteType == TTShareRoomOrInviteFriendStatus_Invite) {
        [self cusTomNavigationItemTitleView];
    }else{
        self.title = @"选择一个好友";
        [self addNavigationItemWithImageNames:@[@"home_search"] isLeft:NO target:self action:@selector(searchBarButtonClick:) tags:nil];
    }
    self.modelInfor = [GetCore(ShareCore) getShareModel];
}

-(void)cusTomNavigationItemTitleView{
    self.customTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    
    self.customTitleLabel = [[UILabel alloc] init];
    self.customTitleLabel.text = @"选择好友(0/20)";
    self.customTitleLabel.textColor = UIColorFromRGB(0x333333);
    self.customTitleLabel.font = [UIFont systemFontOfSize:18];
    //    [self.customTitleLabel sizeToFit];
    self.customTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.customTitleLabel.frame = CGRectMake(0, 0, 200, 20);
    
    [self.customTitleView addSubview:self.customTitleLabel];
    self.navigationItem.titleView = self.customTitleView;
}

- (void)addCore{
    AddCoreClient(FamilyCoreClient, self);
    AddCoreClient(ImMessageCoreClient, self);
}

#pragma mark - User Respone
- (void)searchBarButtonClick:(UIButton *)sender {
    TTFamilySearchViewController *vc = [[TTFamilySearchViewController alloc] init];
    vc.currentNav = self.navigationController;
    vc.delegate = self;
    vc.searchType = TTFamilySearchType_Share;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
#pragma mark - TTFamilySearchViewControllerDelegate
- (void)didSelectCellWith:(SearchResultInfo *)infor{
    TTFamilyAlertModel * config = [[TTFamilyAlertModel alloc] init];
    config.familyMemberIcon = infor.avatar;
    config.familyMemberName = infor.nick;
    config.content = [NSString stringWithFormat:@"确认分享给%@吗？", infor.nick];
    ShareModelInfor * sharenInfor = self.modelInfor;
    sharenInfor.sessionId = [NSString stringWithFormat:@"%lld", infor.uid];
    sharenInfor.sesstionType = NIMSessionTypeP2P;
    if (self.modelInfor.Type == XCShare_Type_Invite) {
        @weakify(self);
        [[TTFamilyBaseAlertController defaultCenter] showShareAlertViewWith:self alertConfig:config sure:^{
            @strongify(self);
            [GetCore(ShareCore) shareAppliactionWith:sharenInfor];
        } canle:nil];
    }else{
        @weakify(self);
        [[TTFamilyBaseAlertController defaultCenter] showAlertViewWith:self alertConfig:config sure:^{
            @strongify(self);
            [GetCore(ShareCore) shareAppliactionWith:sharenInfor];
        } canle:nil];
    }
}

- (void)inviteOtherUserToFamilySuccess:(NSDictionary *)stautsDic {
    [XCHUDTool showSuccessWithMessage:@"邀请成功" inView:self.view];
}

#pragma mark - IMMessageCoreClient
- (void)sendCustomMessageShare:(NIMMessage *)msg{
    NIMCustomObject *object = (NIMCustomObject *)msg.messageObject;
    XCApplicationSharement *customObject = (XCApplicationSharement*)object.attachment;
    if (customObject.first == Custom_Noti_Header_InApp_Share ||
        customObject.first == Custom_Noti_Header_Dynamic) {
        [XCHUDTool showSuccessWithMessage:@"分享成功" inView:self.view];
    }
}
#pragma mark - ZJScrollPageViewDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        if (index == 0) {
            TTFamilyShareChildViewController *vc = [[TTFamilyShareChildViewController alloc] init];
            childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)vc;
            vc.childShareType = TTFamilyShare_Type_FriendList;
            
            vc.customTitleBlock = ^(NSInteger index) {
                self.customTitleLabel.text = [NSString stringWithFormat:@"选择好友(%ld/20)",index];
            };
        }else if (index == 1) {
            TTFamilyShareChildViewController *vc = [[TTFamilyShareChildViewController alloc] init];
            childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)vc;
            vc.childShareType = TTFamilyShare_Type_Focus;
        }else if(index ==2){
            TTFamilyShareChildViewController *vc = [[TTFamilyShareChildViewController alloc] init];
            childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)vc;
            vc.childShareType = TTFamilyShare_Type_Fans;
        }else{
            TTFamilyShareChildViewController * controller = [[TTFamilyShareChildViewController alloc] init];
            childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)controller;
            controller.childShareType = TTFamilyShare_Type_Group;
        }
    }
    return childVc;
}



#pragma mark - Getter and setters
- (void)setShareType:(XCShare_Type)shareType{
    _shareType = shareType;
    if (_titles.count > 0) {
        _titles = nil;
    }
    if (_shareType == XCShare_Type_Invite) {
        _titles = @[@"好友", @"关注", @"粉丝"];
    }else{
        _titles = @[@"好友", @"关注", @"粉丝", @"群"];
    }
    [self.scrollPageView reloadWithNewTitles:self.titles];
}

- (ZJSegmentStyle *)style {
    if (!_style) {
        _style = [[ZJSegmentStyle alloc] init];
        _style.showLine = YES;
        _style.titleFont = [UIFont systemFontOfSize:16];
        // 缩放标题
        _style.scaleTitle = YES;
        _style.titleBigScale = 1.1;
        _style.autoAdjustTitlesWidth = YES;
        _style.selectedTitleColor = [XCTheme getTTMainTextColor];
        _style.normalTitleColor = [XCTheme getTTSubTextColor];
        _style.scrollLineColor = [XCTheme getTTMainColor];
        _style.scrollContentView = NO;
    }
    return _style;
}

- (ZJScrollPageView *)scrollPageView {
    if (!_scrollPageView) {
        CGFloat height = self.view.bounds.size.height - kNavigationHeight - kSafeAreaBottomHeight;
        if (GetCore(TTGameStaticTypeCore).shareRoomOrInviteType == TTShareRoomOrInviteFriendStatus_Invite) {
            _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, self.view.bounds.size.width, height) segmentStyle:nil titles:nil parentViewController:self delegate:self];
        }else{
            _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, self.view.bounds.size.width, height) segmentStyle:self.style titles:self.titles parentViewController:self delegate:self];
        }
    }
    return _scrollPageView;
}


- (NSArray<NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"好友",
                    @"关注",
                    @"粉丝",
                    @"群"
                    ];
    }
    return _titles;
}

/*
 - (void)setType:(XCShare_Type)type {
 _type = type;
 
 if (_type == XCShare_Type_Invite) {
 _titles = @[@"好友",
 @"关注",
 @"粉丝",
 ];
 } else {
 _titles = @[@"好友",
 @"关注",
 @"粉丝",
 @"群"
 ];
 }
 
 [self.scrollPageView reloadWithNewTitles:_titles];
 }
 */
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
