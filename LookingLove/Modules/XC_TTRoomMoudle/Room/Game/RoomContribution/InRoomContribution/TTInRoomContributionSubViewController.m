//
//  TTWeeklyStarContributionSubViewController.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTInRoomContributionSubViewController.h"
#import "TTRoomContributionCell.h"

//model
#import "RoomBounsListInfo.h"

//core
#import "TTRoomUIClient.h"
#import "RankCore.h"
#import "RankCoreClient.h"
#import "ImRoomCoreV2.h"
#import "ImRoomCoreClientV2.h"


//t
#import "UIViewController+EmptyDataView.h"
#import "XCHUDTool.h"
#import "NSArray+Safe.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"

//view
#import "TTRoomContributionCell.h"

@interface TTInRoomContributionSubViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
RankCoreClient,
TTRoomUIClient
>

@property (strong, nonatomic) NSMutableArray *contribution;

/**
 记录选项卡所选择的类型
 */
@property (nonatomic, assign) RankDataType currentSelectRankDateType;

@end

@implementation TTInRoomContributionSubViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    self.type = TTRoomContributionTypeInRoom;
    [super viewDidLoad];
    
    AddCoreClient(RankCoreClient, self);
    AddCoreClient(TTRoomUIClient, self);
    
    [self initView];
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

#pragma mark - Public
- (void)updateData {
    if (self.currentSelectRankDateType != self.rankDataType) {
        return;
    }
    
    [GetCore(RankCore) getRoomBounsListWithType:self.rankingsType dataType:self.rankDataType];
}

#pragma mark - UITableViewDataSource &  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contribution.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTRoomContributionCell *cell = [TTRoomContributionCell cellWithTableView:tableView];
    cell.rankType = self.rankingsType;
    RoomBounsListInfo *info = [self.contribution safeObjectAtIndex:indexPath.row];
    cell.inRoomData = info;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.contribution.count) return;
    
    RoomBounsListInfo *list = [self.contribution safeObjectAtIndex:indexPath.row];
    if ([list isKindOfClass:RoomBounsListInfo.class]) {
        if (self.giftListSelectUserBlock) {
            self.giftListSelectUserBlock(list.uid);
        }
    }
}

#pragma mark - ZJScrollPageViewChildVcDelegate
- (void)zj_viewWillAppearForIndex:(NSInteger)index {
    [GetCore(RankCore) getRoomBounsListWithType:self.rankingsType dataType:self.rankDataType];
}

#pragma mark - RankCoreClient
//获取房间贡献榜成功
- (void)onGetRoomBounsListWithType:(RankType )rankType dataType:(RankDataType)type success:(NSArray *)bounsListInfo {
    
    if (type != self.rankDataType) {
        return;
    }
    
    [XCHUDTool hideHUD];
    [self removeEmptyDataView];
    
    NSMutableArray *championArray = @[].mutableCopy;
    for (int i = 0; i<3; i++) {
        RoomBounsListInfo *info = [bounsListInfo safeObjectAtIndex:i];
        if (info) {
            RankData *data = [[RankData alloc] init];
            data.nick = info.nick;
            data.avatar = info.avatar;
            data.seqNo = i;
            data.totalNum = info.goldAmount;
            data.uid = info.uid;
            data.erbanNo = [NSString stringWithFormat:@"%lld",info.erbanNo];
            data.gender = info.gender;
            
            [championArray addObject:data];
        }
    }
    self.headView.dataArray = championArray;
    
    self.contribution = bounsListInfo.mutableCopy;
    if (self.contribution.count >= 3) {
        [self.contribution removeObjectAtIndex:0];
        [self.contribution removeObjectAtIndex:0];
        [self.contribution removeObjectAtIndex:0];
    } else {
        self.contribution = nil;
    }
    
    if (self.contribution.count > 0) {
        [self removeEmpty];
    } else {
        [self addEmpty];
    }
    
    [self.tableView reloadData];
}

//获取房间贡献榜失败
- (void)onGetRoomBounsListWihthType:(RankType )rankType dataType:(RankDataType)type failth:(NSString *)message {
    
    if (type !=self.rankDataType) {
        return;
    }
    
    [self removeEmptyDataView];
    [XCHUDTool showErrorWithMessage:message];
}

#pragma mark - RoomUIClient
//房间榜变更
- (void)roomRankingsTypeUpdate:(RankType)rankingType dataType:(RankDataType)dataType {
    
    self.rankingsType = rankingType;
    self.currentSelectRankDateType = dataType;
    
    if (dataType != self.rankDataType) {
        return;
    }
    
    [GetCore(RankCore) getRoomBounsListWithType:self.rankingsType dataType:self.rankDataType];
}

#pragma mark - private method
- (void)reloadDataWhenLoadFail {
    [GetCore(RankCore) getRoomBounsListWithType:self.rankingsType dataType:self.rankDataType];
}

- (void)initView {
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
    }];
}

#pragma mark - Getter & Setter



@end
