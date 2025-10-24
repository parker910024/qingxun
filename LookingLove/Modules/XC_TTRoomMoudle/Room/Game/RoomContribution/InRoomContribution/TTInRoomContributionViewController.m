//
//  TTWeeklyStarContributionViewController.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTInRoomContributionViewController.h"
//VC
#import "TTInRoomContributionSubViewController.h"
//View
#import "TTInRoomContributionHeadView.h"

//tool
#import "ZJScrollPageView.h"
#import "XCMacros.h"
#import <Masonry.h>

//client
#import "TTRoomUIClient.h"
//core
#import "RankCore.h"


@interface TTInRoomContributionViewController ()<ZJScrollPageViewDelegate,TTRoomUIClient>

@property (nonatomic, strong) TTInRoomContributionHeadView *headView;
@property (nonatomic, strong) NSArray  *titles;
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
@property (nonatomic, assign) RankType rankingsType;

@end

@implementation TTInRoomContributionViewController
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    AddCoreClient(TTRoomUIClient, self);

    self.titles = @[@"日榜",@"周榜"];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.scrollPageView];
    [self addConstraint];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
    [GetCore(RankCore) clearCache];
}

#pragma mark - ZJScrollPageViewDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        @weakify(self)
        TTInRoomContributionSubViewController *contributionVc =  [[TTInRoomContributionSubViewController alloc] init];
        contributionVc.rankDataType = index;
        contributionVc.rankingsType = self.rankingsType;
        contributionVc.giftListSelectUserBlock = ^(UserID uid) {
            @strongify(self)
            [self showUserCord:uid];
        };
        contributionVc.selectUserBlock = ^(UserID uid) {
            @strongify(self)
            [self showUserCord:uid];
        };
        childVc = (UIViewController<ZJScrollPageViewChildVcDelegate> *)contributionVc;
    }
    
    return childVc;
}

#pragma mark - private method
- (void)showUserCord:(UserID)uid {
    !self.roomContributionSelectBlock ?: self.roomContributionSelectBlock(uid);
}

- (void)addConstraint {
    [self.scrollPageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headView.mas_bottom);
    }];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(128);
    }];
}

#pragma mark - Getter && Setter

- (TTInRoomContributionHeadView *)headView {
    if (!_headView) {
        _headView = [[TTInRoomContributionHeadView alloc] init];
        @weakify(self)
        _headView.headViewSelectDataBlock = ^(RankType rankType, RankDataType type) {
            @strongify(self)
            [self.scrollPageView setSelectedIndex:type animated:YES];
        };
        _headView.headViewSelectedRankTypeBlock = ^(RankType rankType, RankDataType type) {
            @strongify(self)
            self.rankingsType = rankType;
            NotifyCoreClient(TTRoomUIClient, @selector(roomRankingsTypeUpdate:dataType:), roomRankingsTypeUpdate:rankType dataType:type);
        };
    }
    return _headView;
}

- (ZJScrollPageView *)scrollPageView {
    if (!_scrollPageView) {
        _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 128, KScreenWidth, 480-128) segmentStyle:nil titles:self.titles parentViewController:self delegate:self];
    }
    return _scrollPageView;
}

@end
