//
//  TTHalfhourContributionViewController.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTHalfhourContributionViewController.h"

//view
#import "TTHalfhourContributionHeadView.h"
#import "TTRoomContributionCell.h"

//core
#import "RankCore.h"
#import "RankCoreClient.h"
#import "RoomCoreV2.h"
//t
#import "XCMacros.h"
#import <Masonry.h>
#import "XCTheme.h"

//cate
#import "UITableView+Refresh.h"
#import "NSArray+Safe.h"
#import "UIViewController+EmptyDataView.h"

@interface TTHalfhourContributionViewController ()
@property (nonatomic, strong) TTHalfhourContributionHeadView *topHeadView;
@end

@implementation TTHalfhourContributionViewController

- (void)viewDidLoad {
    self.type = TTRoomContributionTypeHalfhour;
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    AddCoreClient(RankCoreClient, self);

    [self.view addSubview:self.topHeadView];
    [self.topHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(128);
    }];
        
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topHeadView.mas_bottom);
        make.bottom.left.right.mas_equalTo(0);
    }];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)pullDownRefresh:(int)page {
    [GetCore(RankCore) getHalfHourRankByRoomUid:[NSString stringWithFormat:@"%lld",GetCore(RoomCoreV2).getCurrentRoomInfo.uid]];
}

#pragma mark - Public
- (void)updateData {
    [self pullDownRefresh:1];
}

#pragma mark - RankCoreClient
- (void)onGetHalfHourRankWithRoomUid:(NSString *)roomUid success:(NSArray<RankData *> *)rankVoList meRankData:(RankData *)meRankData {
    
    if (![roomUid isEqualToString:@(GetCore(RoomCoreV2).getCurrentRoomInfo.uid).stringValue]) {
        return;
    }
        
    [self.tableView endRefreshStatus:0 hasMoreData:NO];
    
    self.dataArray = rankVoList.mutableCopy;
    self.headView.dataArray = rankVoList.copy;
    self.topHeadView.myRankData = meRankData;
    
    if (self.dataArray.count >= 3) {
        [self.dataArray removeObjectAtIndex:0];
        [self.dataArray removeObjectAtIndex:0];
        [self.dataArray removeObjectAtIndex:0];
    } else {
        self.dataArray = @[].mutableCopy;
    }
    
    if (self.headView.dataArray.count > 0) {
        [self removeEmpty];
    } else {
        [self addEmpty];
    }
    [self.tableView reloadData];
}

- (void)onGetHalfHourRankWithRoomUid:(NSString *)roomUid fauile:(NSString *)message {
    
}

#pragma mark - UITabelViewDelgate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTRoomContributionCell *cell = [TTRoomContributionCell cellWithTableView:tableView];
    RankData *data = [self.dataArray safeObjectAtIndex:indexPath.row];
    cell.halfhourData = data;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        return CGFLOAT_MIN;
    }else {
         return self.headView.dataArray.count == 0 ? CGFLOAT_MIN : 86.0f;
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (projectType() == ProjectType_LookingLove) {
        return [UIView new];
    }
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = UIColor.whiteColor;
    footer.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"每整点半小时内，房间礼物流水排名前十将有机会登上房间首页的官方推荐哦~";
    label.textColor = [XCTheme getTTDeepGrayTextColor];
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    [footer addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.right.mas_equalTo(footer).inset(15);
        make.bottom.mas_lessThanOrEqualTo(0);
    }];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [XCTheme getTTSimpleGrayColor];
    [footer addSubview:topLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    return footer;
}

#pragma mark - ZJScrollPageViewChildVcDelegate
- (void)zj_viewWillAppearForIndex:(NSInteger)index {
    [self pullDownRefresh:1];
}

#pragma mark - private
#pragma mark - Getter && Setter

- (TTHalfhourContributionHeadView *)topHeadView {
    if (!_topHeadView) {
        _topHeadView = [[TTHalfhourContributionHeadView alloc] init];
        @weakify(self)
        _topHeadView.tapInfoViewBlock = ^(UserID uid) {
            @strongify(self)
            self.selectUserBlock(uid);
        };
    }
    return _topHeadView;
}

@end
