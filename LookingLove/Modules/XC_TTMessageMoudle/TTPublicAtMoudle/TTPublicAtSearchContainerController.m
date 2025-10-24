//
//  TTPublicAtSearchController.m
//  TuTu
//
//  Created by 卫明 on 2018/11/7.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicAtSearchContainerController.h"

//view
#import "TTPublicAtSearchBar.h"
#import "ZJScrollSegmentView.h"
#import "ZJContentView.h"
#import "ZJScrollPageView.h"

//core
#import "PublicChatroomCore.h"

//client
#import "PublicChatroomCoreClient.h"

//image
#import "UIImage+Utils.h"

//theme
#import "XCTheme.h"

//vc
#import "TTFriendListViewController.h"
#import "TTFocusViewController.h"
#import "TTFansViewController.h"
#import "TTPublicSearchController.h"

//const
#import "XCMacros.h"

//tool
#import <Masonry/Masonry.h>
#import "NIMKit.h"
#import "XCCurrentVCStackManager.h"
#import "UIView+NIM.h"

//at cache
#import "NIMInputAtCache.h"


@interface TTPublicAtSearchContainerController ()
<
    TTPublicAtSearchBarDelegate,
    ZJScrollPageViewDelegate,
    TTFriendListViewControllerDelegate,
    TTFocusViewControllerDelegate,
    TTFansViewControllerDelegate,
    TTPublicSearchControllerDelegate
>

/**
 结果数组
 */
@property (strong, nonatomic) NSArray *results;

/**
 搜索框
 */
@property (strong, nonatomic) TTPublicAtSearchBar *searhBar;

/**
 确定按钮
 */
@property (strong, nonatomic) UIButton *confirmButton;

/**
 滑动view
 */
@property (strong, nonatomic) ZJScrollPageView *pageView;

/**
 标题数组
 */
@property (strong, nonatomic) NSArray *titles;

@property (strong, nonatomic) TTFriendListViewController *friendVC;

@property (strong, nonatomic) TTFocusViewController *focusVC;

@property (strong, nonatomic) TTFansViewController *fansVC;


@end

@implementation TTPublicAtSearchContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initConstrations];
}

- (void)initView {
    self.title = @"选择你要@的人";
    [self.view addSubview:self.searhBar];
    [self.view addSubview:self.pageView];
    [self.view addSubview:self.confirmButton];
    
    [self addNavigationItemWithTitles:@[@"取消"] titleColor:[XCTheme getTTMainColor] isLeft:NO target:self action:@selector(onCancelButtonClick:) tags:nil];
}

- (void)initConstrations {
    [self.searhBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.height.mas_equalTo(50);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading).offset(15);
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-15);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(345);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).offset(-8);
    }];
}

#pragma mark - TTFriendListViewControllerDelegate,TTFocusViewControllerDelegate,TTFansViewControllerDelegate

- (void)chooseFansInforWith:(NSDictionary *)userInforDic {
    self.selectedUser = [userInforDic mutableCopy];
}

#pragma mark - TTPublicAtSearchBarDelegate

- (void)onSearchBarClick:(TTPublicAtSearchBar *)searchBarDidClick {
    TTPublicSearchController *vc = [[TTPublicSearchController alloc]init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - TTPublicSearchControllerDelegate

- (void)onSearchVC:(TTPublicSearchController *)vc didSelectedUserInfo:(UserInfo *)info {
    info.isSelected = YES;
    [self.selectedUser setObject:info forKey:[NSString stringWithFormat:@"%lld",info.uid]];
    self.selectedUser = self.selectedUser;
    self.fansVC.selectDic = self.selectedUser;
    self.friendVC.selectDic = self.selectedUser;
    self.focusVC.selectDic = self.selectedUser;
    
}

#pragma mark - ZJScrollPageViewDelegate

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        if (index == 0) {
            TTFriendListViewController *vc = [[TTFriendListViewController alloc]init];
            childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)vc;
            vc.type = MessageVCType_AtPerson;
            vc.selectDic = self.selectedUser;
            vc.delegate = self;
            self.friendVC = vc;
        }else if (index == 1) {
            TTFocusViewController *vc = [[TTFocusViewController alloc]init];
            childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)vc;
            vc.type = MessageVCType_AtPerson;
            vc.selectDic = self.selectedUser;
            vc.delegate = self;
            self.focusVC = vc;
        }else if (index == 2){
            TTFansViewController *vc = [[TTFansViewController alloc]init];
            childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)vc;
            vc.type = MessageVCType_AtPerson;
            vc.selectDic = self.selectedUser;
            vc.delegate = self;
            self.fansVC = vc;
        }
    }else{
        if (index == 0) {
            TTFriendListViewController *vc = (TTFriendListViewController *)childVc;
            vc.selectDic = self.selectedUser;
        }else if (index == 1) {
            TTFocusViewController *vc = (TTFocusViewController *)childVc;
            vc.selectDic = self.selectedUser;
        }else if (index == 2){
            TTFansViewController *vc = (TTFansViewController *)childVc;
            vc.selectDic = self.selectedUser;
        }
    }
    return childVc;
}

#pragma mark - public method

- (void)show {
    [[[XCCurrentVCStackManager shareManager]getCurrentVC] presentViewController:self animated:YES completion:nil];
}

#pragma mark - private method

- (void)onCancelButtonClick:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onConfirmButtonClick:(UIButton *)sender {
    PublicChatAtMemberAttachment *at = [[PublicChatAtMemberAttachment alloc]init];
    at.atUids = self.selectedUser.allKeys;
    NSMutableArray *atNames = [NSMutableArray array];
    NSMutableArray *atOriginNames = [NSMutableArray array];
    for (NSString *uid in self.selectedUser.allKeys) {
        NSMutableString *nick = [[self.selectedUser objectForKey:uid].nick mutableCopy];
        [atOriginNames addObject:[nick copy]];
        [nick insertString:NIMInputAtStartChar atIndex:0];
//        [nick appendString:NIMInputAtEndChar];
        [atNames addObject:nick];
        
    }
    at.atNames = atNames;
    at.originAtNames = atOriginNames;
    
    if ([self.delegate respondsToSelector:@selector(onAtUsersSelected:selectedDic:)]) {
        [self.delegate onAtUsersSelected:at selectedDic:self.selectedUser];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter & setter

- (ZJScrollPageView *)pageView {
    if (!_pageView) {
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc]init];
        style.showLine = YES;
        style.titleFont = [UIFont systemFontOfSize:16];
        // 缩放标题
        style.scaleTitle = YES;
        style.titleBigScale = 1.1;
        style.autoAdjustTitlesWidth = YES;
        style.selectedTitleColor = UIColorFromRGB(0x333333);
        style.normalTitleColor = UIColorFromRGB(0x999999);
        style.scrollLineColor = [XCTheme getTTMainColor];
        style.scrollContentView = NO;
        _pageView = [[ZJScrollPageView alloc]initWithFrame:CGRectMake(0, statusbarHeight + 44 + 50, KScreenWidth, KScreenHeight - 88 - statusbarHeight - 44 - 8) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    }
    return _pageView;
}

- (void)setSelectedUser:(NSMutableDictionary *)selectedUser {
    _selectedUser = selectedUser;
    self.title = [NSString stringWithFormat:@"选择你要@的人(%ld)",selectedUser.count];
}

- (TTPublicAtSearchBar *)searhBar {
    if (!_searhBar) {
        _searhBar = [[TTPublicAtSearchBar alloc]init];
        _searhBar.delegate = self;
    }
    return _searhBar;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]init];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        _confirmButton.titleLabel.textColor = UIColorFromRGB(0xffffff);
        [_confirmButton setBackgroundColor:[XCTheme getTTMainColor]];
        [_confirmButton addTarget:self action:@selector(onConfirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.cornerRadius = 19.f;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"好友",@"关注",@"粉丝"];
    }
    return _titles;
}

@end
