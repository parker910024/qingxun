//
//  TTMainMessageViewController.m
//  TuTu
//
//  Created by gzlx on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMainMessageViewController.h"

//vc
#import "TTSessionListViewController.h"
#import "TTMessageContentViewController.h"

//view
#import "TTMessageSegmentView.h"
#import "TTMessageScrollView.h"

//Tool
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"

//core
#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"
#import "MentoringShipCoreClient.h"
#import "TTServiceCoreClient.h"
#import "TTServiceCore.h"

#import "TTNewbieGuideView.h"
// 消息页新手引导状态保存
static NSString *const kMessageGuideStatusStoreKey = @"TTMessageViewControllerMessageGuideStatus";

@interface TTMainMessageViewController ()<ImMessageCoreClient, TTServiceCoreClient, UIScrollViewDelegate, TTMessageSegmentViewDelegate, MentoringShipCoreClient>
/** segmentView */
@property (nonatomic, strong) TTMessageSegmentView *segmentView;
/** scrollView */
@property (nonatomic, strong) TTMessageScrollView *scrollView;
/** scrollContentView */
@property (nonatomic, strong) UIView *scrollContentView;
/** 消息 */
@property (nonatomic, strong) TTSessionListViewController *messageViewController;
/** 联系人 */
@property (nonatomic, strong) TTMessageContentViewController *contactsViewController;
@end

@implementation TTMainMessageViewController

#pragma mark - life cycle
- (BOOL)isHiddenNavBar{
    return YES;
}

- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initConstrations];
    
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL hadGuide = [ud boolForKey:kMessageGuideStatusStoreKey];
    if (!hadGuide) {
        [ud setBool:YES forKey:kMessageGuideStatusStoreKey];
        [ud synchronize];
        [self initGuiView];
    }
}

- (void)initGuiView {
    TTNewbieGuideView *guideView = [[TTNewbieGuideView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) withArcWithFrame:CGRectMake(-50, statusbarHeight + 8 - 11, KScreenWidth - 73 + 50, 50) withSpace:NO withCorner:25 withPage:TTGuideViewPage_Message];
    
    guideView.currentType = ^(NSInteger index) {
        
    };
    
    [self.tabBarController.view addSubview:guideView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addBadge];
}

#pragma mark - TTServiceCoreClietn
- (void)onQYUnreadCountChanged:(NSInteger)count{
    [self addBadge];
}

#pragma mark - ImMessageCoreClient
- (void)onRecvAnMsg:(NIMMessage *)msg {
    [self addBadge];
}

- (void)onImUnReadCountHandleComplete {
    [self addBadge];
}

#pragma mark - MentoringShipCoreClient
- (void)updateMessageMainViewControllerSelectIndex:(NSInteger)index {
    [self.segmentView updateButtonWithIndex:index];
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.frame.size.width, 0) animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.scrollView) {
        scrollView.scrollEnabled = NO;
    }
    if (!decelerate) {
        // 计算最后的索引
        NSInteger toIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self.segmentView updateButtonWithIndex:toIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        scrollView.scrollEnabled = NO;
    }
    // 计算最后的索引
    NSInteger toIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.segmentView updateButtonWithIndex:toIndex];
}

#pragma mark - TTMessageSegmentViewDelegate
/** 点击了index标题 */
- (void)messageSegmentView:(TTMessageSegmentView *)navView didSelectWithIndex:(NSInteger)index {
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.frame.size.width, 0) animated:NO];
}

#pragma mark - private method
- (void)initView {
    AddCoreClient(ImMessageCoreClient, self);
    AddCoreClient(TTServiceCoreClient, self);
    AddCoreClient(MentoringShipCoreClient, self);
    
    [self.view addSubview:self.segmentView];
    
    [self.segmentView updateButtonWithIndex:0];
    [self.view addSubview:self.scrollView];
    
    [self addChildViewController:self.messageViewController];
    [self addChildViewController:self.contactsViewController];
    [self.scrollView addSubview:self.scrollContentView];
    [self.scrollContentView addSubview:self.messageViewController.view];
    [self.scrollContentView addSubview:self.contactsViewController.view];
    
    [self.messageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(KScreenWidth);
    }];
    
    [self.contactsViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KScreenWidth * 1);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(KScreenWidth);
    }];
}

- (void)initConstrations {
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(statusbarHeight + 44);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(KScreenWidth * 2);
        make.height.mas_equalTo(self.scrollView);
    }];
}

- (void)addBadge {
    [self.navigationController.tabBarItem setBadgeValue:nil];
    if ([GetCore(ImMessageCore)getUnreadCount] > 0) {
        NSInteger  allUnread = [GetCore(ImMessageCore) getUnreadCount];
        [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",allUnread]];
    }else {
        [self.navigationController.tabBarItem setBadgeValue:nil];
    }
}

#pragma mark - setters and getters

- (TTMessageSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[TTMessageSegmentView alloc] init];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (TTMessageScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[TTMessageScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.scrollEnabled = NO;
        _scrollView.scrollsToTop = NO;
    }
    return _scrollView;
}

- (UIView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIView alloc] init];
        _scrollContentView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollContentView;
}

- (TTSessionListViewController *)messageViewController {
    if (!_messageViewController) {
        _messageViewController = [[TTSessionListViewController alloc] init];
    }
    return _messageViewController;
}

- (TTMessageContentViewController *)contactsViewController {
    if (!_contactsViewController) {
        _contactsViewController = [[TTMessageContentViewController alloc] init];
        _contactsViewController.isContacts = YES;
    }
    return _contactsViewController;
}

@end
