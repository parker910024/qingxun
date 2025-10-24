//
//  TTGameViewController.h
//  TuTu
//
//  Created by new on 2019/1/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"
#import "BaseTableViewController.h"

#import "SDCycleScrollView.h"
#import "CPGameHomeBannerModel.h"
#import "RoomCategoryData.h"
#import "Attention.h"
#import "TTGameRankModel.h"
#import "TTGameHomeModuleModel.h"


typedef enum : NSUInteger {
    GameDataIndexForArray_Banner = 1,  // 轮播图
    GameDataIndexForArray_Attention = 2,  // 关注
    GameDataIndexForArray_GameList = 3,  // 大家都爱玩,
    GameDataIndexForArray_RankList = 4, // 排行榜
    GameDataIndexForArray_welfList = 5, // 声控福利房
    GameDataIndexForArray_Match = 6, // 匹配
    GameDataIndexForArray_OperationList = 7, // 运营可配置
    GameDataIndexForArray_FindFriendList = 8, //  玩友欢乐房
} GameDataIndexForArray;

NS_ASSUME_NONNULL_BEGIN

@interface TTGameViewController : BaseTableViewController

@property (nonatomic, strong) NSMutableArray<Attention *> *focusArray; // 关注列表
@property (nonatomic, strong) NSMutableArray *gameListArray; // 游戏列表
@property (nonatomic, strong) NSMutableArray *bannerArray; // 轮播图列表
@property (nonatomic, strong) NSMutableArray *bannerUrlArray; // 轮播图url列表
@property (nonatomic, strong) NSMutableArray *welfareArray; // 声控福利房列表
@property (nonatomic, strong) NSMutableArray<TTGameRankModel *> *rankArray; // 排行榜

@property (nonatomic, strong) NSMutableArray<TTGameHomeModuleModel *> *operationArray; //  运营可配置模块
@property (nonatomic, strong) NSMutableArray<TTHomeV4DetailData *> *friendFunArray; // 玩友欢乐房
@property (nonatomic, strong) NSMutableDictionary *allDataDictionary;  // 所有数据汇总成为一个字典
@property (nonatomic, strong) NSMutableArray *dictKeyArray;

@property (nonatomic, assign) BOOL rankListDataReturn; // 排行榜数据是否返回
@property (nonatomic, strong) UIView *customTabHeaderView; // 自定义tableView header
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView; // 轮播图

@property (nonatomic, strong) UIImageView *navBackImageView;
@property (nonatomic, strong) UIImageView *navBottomImageView;
@property (nonatomic, strong) UIImageView *maskGuildView; // afterLogin 分类里面的属性
@property (nonatomic, assign) int currentpage;

@property (nonatomic, assign) int friendCurrentPage;
@end

NS_ASSUME_NONNULL_END
