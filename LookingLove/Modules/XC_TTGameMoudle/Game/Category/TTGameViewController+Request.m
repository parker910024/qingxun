//
//  TTGameViewController+Request.m
//  TTPlay
//
//  Created by new on 2019/3/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameViewController+Request.h"
#import "CPGameCore.h"
#import "AuthCore.h"
#import "XCHUDTool.h"
#import "TTCPGameStaticCore.h"
#import "TTGameRankListModel.h"
#import "TTGameRankModel.h"
#import "TTGameStaticTypeCore.h"
#import "PraiseCore.h"
#import "HomeCore.h"
#import "TTGameHomeModuleModel.h"
#import "CheckinCore.h"
#import "UserCore.h"
#import "ActivityCore.h"
#import "TTGameViewController+OperationList.h"

#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义

static NSUInteger const kPageSize = 10;//分页个数

#define kScale(x) ((x) / 375.0 * KScreenWidth)

@implementation TTGameViewController (Request)

- (void)requestData:(int)page {
    
    if (![GetCore(AuthCore) isLogin]) {
        return;
    }
    
    [self.bannerUrlArray removeAllObjects];
    
    self.rankListDataReturn = NO;
    
    self.currentpage = page;
    
    [GetCore(ActivityCore) getActivityForGamePage:1];
    
    [GetCore(PraiseCore) requestAttentionForGamePageListState:0 page:page PageSize:100];
    
    //    [[GetCore(CPGameCore) requestGameList:GetCore(AuthCore).getUid.userIDValue PageNum:1 PageSize:30] subscribeError:^(NSError *error) {
    //        [self successEndRefreshStatus:0 hasMoreData:YES];
    //    }];
    
    [[GetCore(CPGameCore) requestGameHomeBanner:3] subscribeError:^(NSError *error) {
        [self successEndRefreshStatus:0 hasMoreData:YES];
    }];
    
    [[GetCore(CPGameCore) requestGameHomeBanner:4] subscribeError:^(NSError *error) {
        [self successEndRefreshStatus:0 hasMoreData:YES];
    }];
    
    //    [GetCore(CPGameCore) requestGameHomeRankList:GetCore(AuthCore).getUid];
    
    [GetCore(CPGameCore) requestGameGetModuleRoomsList];
    
    self.friendCurrentPage = page;
    [self requestFriendFunData];
    
    [self.allDataDictionary setObject:@"match" forKey:@(GameDataIndexForArray_Match)];
}

//  玩友欢乐房
- (void)requestFriendFunData{
    [GetCore(HomeCore) requestTTHomeV4RoomCategoryRoomDataWithTitleId:[NSString stringWithFormat:@"%d",16]
                                                              pageNum:self.friendCurrentPage
                                                             pageSize:kPageSize];
}

/**
 请求签到详情接口
 */
- (void)requestSignDetail {
    
    if (![GetCore(AuthCore) isLogin]) {
        return;
    }
    
    UserID uid = [GetCore(AuthCore)getUid].userIDValue;
    
    [GetCore(UserCore) getUserInfo:uid refresh:YES success:^(UserInfo *info) {
        
        //如果没有完善用户信息，不请求签到详情
        if (info == nil || info.nick.length <= 0 || info.avatar.length <= 0) {
            return;
        }
        
        [GetCore(CheckinCore) requestCheckinSignDetail];
        
    } failure:^(NSError *error) {
        
    }];
}

// 下拉刷新
- (void)pullDownRefresh:(int)page{
    [self requestData:1];
}

// 上拉加载
- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    if (isLastPage) {
        return;
    }
    self.friendCurrentPage += 1;
    [self requestFriendFunData];
}

#pragma mark --- CPGameCoreClient ---
//  游戏列表
- (void)onGameList:(NSArray *)listArray{
//    [self.allDataDictionary removeObjectForKey:@(GameDataIndexForArray_GameList)];
//    [self.gameListArray removeAllObjects];
//    [self.gameListArray addObjectsFromArray:listArray];
//    if (self.gameListArray.count > 0) {
//        [self.allDataDictionary setObject:self.gameListArray forKey:@(GameDataIndexForArray_GameList)];
//        [self arraySorting];
//        NSMutableArray *dataArray = [NSMutableArray array];
//        for (int i = 0; i < self.gameListArray.count; i++) {
//            [dataArray addObject:[self.gameListArray[i] model2dictionary]];
//        }
//        GetCore(TTGameStaticTypeCore).privateMessageArray = dataArray;
//
//        [self.tableView reloadData];
//        [self successEndRefreshStatus:0 hasMoreData:YES];
//    }
}

//  轮播图数据
- (void)gameHomeBannerArray:(NSArray *)listArray{
    [self.bannerArray removeAllObjects];
    [self.bannerArray addObjectsFromArray:listArray];
    if (self.bannerArray.count == 0) {
        
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        
        if (iPhoneXSeries) {
            self.navBackImageView.hidden = NO;
            self.navBackImageView.image = [UIImage imageNamed:@"game_home_backImage_IphoneXTop"];
            self.navBottomImageView.image = [UIImage imageNamed:@"game_home_NoBanner_IphoneXBottom"];
            
            [self.navBottomImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(30);
            }];
        }else{
            self.navBackImageView.hidden = YES;
            self.navBottomImageView.image = [UIImage imageNamed:@"game_home_backImage_Bottom"];
            
            [self.navBottomImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
            }];
        }
        
    }else{
        
        self.tableView.tableHeaderView = [self customHeaderView];
        
        self.navBackImageView.hidden = NO;
        if (iPhoneX) {
            self.navBackImageView.image = [UIImage imageNamed:@"game_home_backImage_IphoneXTop"];
            self.navBottomImageView.image = [UIImage imageNamed:@"game_home_backImage_IphoneXBottom"];
        }else{
            self.navBackImageView.image = [UIImage imageNamed:@"game_home_backImage_Top"];
            self.navBottomImageView.image = [UIImage imageNamed:@"game_home_backImage_Bottom"];
        }
        
        [self.navBottomImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(95);
        }];
    }
    [self.tableView reloadData];
    [self successEndRefreshStatus:0 hasMoreData:YES];
}

//  声控福利房
- (void)gameHomeListArray:(NSArray *)listArray{
    [self.welfareArray removeAllObjects];
    [self.allDataDictionary removeObjectForKey:@(GameDataIndexForArray_welfList)];;
    [self.welfareArray addObjectsFromArray:listArray];
    
    if (self.welfareArray.count > 0) {
        //        [self.allDataDictionary setObject:self.welfareArray forKey:@(GameDataIndexForArray_welfList)];
        //        [self arraySorting];
        [self.tableView reloadData];
    }
    [self successEndRefreshStatus:0 hasMoreData:YES];
}

#pragma mark - HomeCoreClient
// 玩友欢乐房
- (void)responseTTHomeV4RoomCategoryRoomData:(RoomCategoryData *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    [self.allDataDictionary removeObjectForKey:@(GameDataIndexForArray_FindFriendList)];
    if (!data) {
        [XCHUDTool showErrorWithMessage:msg inView:self.view];
        [self successEndRefreshStatus:0 hasMoreData:YES];
    }else{
        if (self.friendCurrentPage == 1) {
            [self.friendFunArray removeAllObjects];
            self.friendFunArray = data.rooms.mutableCopy;
            [self successEndRefreshStatus:0 hasMoreData:YES];
        } else {
            [self.friendFunArray addObjectsFromArray:data.rooms];
            if (data.rooms.count > 0) {
                [self.tableView endRefreshStatus:1 hasMoreData:YES];
            }else{
                [self.tableView endRefreshStatus:1 hasMoreData:NO];
            }
        }
        if (self.friendFunArray.count > 0) {
            [self.allDataDictionary setObject:self.friendFunArray forKey:@(GameDataIndexForArray_FindFriendList)];
            [self arraySorting];
            [self.tableView reloadData];
        }
    }
    
}

// 排行榜
- (void)gameHomeRankListArray:(NSDictionary *)listDic{
    
    [self.allDataDictionary removeObjectForKey:@(GameDataIndexForArray_RankList)];
    NSMutableArray *dataArray = [NSMutableArray array];
    if (GetCore(TTCPGameStaticCore).gameRankSwitch){
        NSArray *listArray = listDic[@"list"];
        for (int i = 0 ; i < listArray.count ; i++) {
            TTGameRankListModel *model = [TTGameRankListModel modelDictionary:listArray[i]];
            [dataArray addObject:model];
        }
        TTGameRankModel *rankModel = [[TTGameRankModel alloc] init];
        rankModel.internal = listDic[@"internal"];
        rankModel.listModelArray = [dataArray mutableCopy];
        [self.rankArray addObject:rankModel];
        
        self.rankListDataReturn = YES;
        [self.allDataDictionary setObject:self.rankArray forKey:@(GameDataIndexForArray_RankList)];
        [self arraySorting];
        [self.tableView reloadData];
    }
    [self successEndRefreshStatus:0 hasMoreData:YES];
}
// 运营可配置模块
- (void)gameHomeModuleListArray:(NSArray *)listArray {
    
    [self.allDataDictionary removeObjectForKey:@(GameDataIndexForArray_OperationList)];
    
    [self.operationArray removeAllObjects];
    
    for (int i = 0; i < listArray.count; i++) {
        TTGameHomeModuleModel *listModel = [listArray safeObjectAtIndex:i];
        if (listModel.data.count > 0) {
            [self.operationArray addObject:listModel];
        }
    }
    if (self.operationArray.count > 0) {
        [self.allDataDictionary setObject:self.operationArray forKey:@(GameDataIndexForArray_OperationList)];
        [self arraySorting];
        //        CGFloat height = 0.0;
        //        for (int i = 0; i < self.operationArray.count; i++) {
        //            TTGameHomeModuleModel *model = [self.operationArray safeObjectAtIndex:i];
        //            NSInteger number = [self returnCellNumberRowsIfSection:model];
        //            NSInteger bigNumber = [self returnBigCellNumberRowsIfSection:model];
        //            height = height + bigNumber * 172 + (number - bigNumber) * 76;
        //        }
        //
        //        self.finalyHeight = height + [self returnOperationSectionHeaderHeight:self.operationArray.count];
        [self.tableView reloadData];
    }
    [self successEndRefreshStatus:0 hasMoreData:YES];
}

- (void)gameHomeModuleListArrayError {
    [XCHUDTool hideHUDInView:self.view];
}

// 自定义tableView header
-(UIView *)customHeaderView {
    self.customTabHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kScale(120))];
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(13, 0, KScreenWidth - 26, kScale(120)) delegate:self placeholderImage:[UIImage imageNamed:[XCTheme defaultTheme].placeholder_image_rectangle]];
    
    for (int i = 0 ; i < self.bannerArray.count; i++) {
        CPGameHomeBannerModel *model = self.bannerArray[i];
        [self.bannerUrlArray addObject:model.bannerPic];
    }
    
    self.cycleScrollView.imageURLStringsGroup = self.bannerUrlArray;
    
    self.cycleScrollView.layer.cornerRadius = 21;
    self.cycleScrollView.layer.masksToBounds = YES;
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentLeft;
    self.cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    self.cycleScrollView.pageDotColor = [UIColor colorWithWhite:1 alpha:0.4];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"home_banner_select"];
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"home_banner_normal"];
    
    [self.customTabHeaderView addSubview:self.cycleScrollView];
    
    return self.customTabHeaderView;
}

// 数据排序
- (void)arraySorting{
    self.dictKeyArray = self.allDataDictionary.allKeys.mutableCopy;
    [self.dictKeyArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 intValue] > [obj2 intValue];
    }];
}

@end
