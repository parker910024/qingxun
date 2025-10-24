//
//  TTGameViewController.m
//  TuTu
//
//  Created by new on 2019/1/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameViewController.h"
#import "TTHomeRoomSelectView.h" // 创建房间时弹出的选择房间类型View
#import "XCMediator+TTRoomMoudleBridge.h" // 匹配到跳转房间
#import "XCMediator+TTPersonalMoudleBridge.h" // 跳转个人主页
#import "XCMediator+TTGameModuleBridge.h" // 游戏主页桥
#import "XCMediator+TTDiscoverModuleBridge.h" // 发现桥
#import "XCMediator+TTMessageMoudleBridge.h" // 消息桥
#import "XCMediator+TTHomeMoudle.h"
#import "XCHtmlUrl.h"
#import "TTStatisticsService.h"

#import "XCCurrentVCStackManager.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIColor+UIColor_Hex.h" // 颜色设置
#import "XCHUDTool.h"
#import "BaseNavigationController.h"
// Core
#import "AuthCore.h"
#import "RoomCoreV2.h"
#import "ImMessageCore.h"
#import "ImRoomCoreV2.h"
#import "TTGameStaticTypeCore.h"
#import "TTHomeV4DetailData.h"
#import "CheckinCoreClient.h"
#import "CheckinCore.h"
#import "AuthCoreClient.h"
#import "APNSCoreClient.h"
#import "ActivityInfo.h"
#import "P2PInteractiveAttachment.h"
#import "CPGameListModel.h"

#import "UIView+NTES.h"
#import <TYAlertController/TYAlertController.h>
#import "TTPopup.h"

// client
#import "AuthCoreClient.h"
#import "CPGameCoreClient.h"
#import "ImFriendCoreClient.h"
#import "PraiseCoreClient.h"
#import "HomeCoreClient.h"
#import "CPGameCore.h"
#import "UserCoreClient.h"
#import "LinkedMeClient.h"

#import "TTVoiceWkViewController.h"
#import "TTGameMatchingViewController.h"
#import "TTCompleteGameListViewController.h"
#import "TTOppositeSexMatchViewController.h"

// category
#import "TTGameViewController+Request.h"
#import "TTGameViewController+OperationList.h"

// cell
#import "TTGameListTableViewCell.h"
#import "TTGameRankTableViewCell.h"
#import "TTGameFocusTableViewCell.h"
#import "TTGameRecommendRoomTVCell.h"
#import "TTGameRecommendBigRoomTVCell.h"
#import "TTGameOperationViewCell.h"
#import "TTGameFindFriendTableViewCell.h"
#import "TTGameMatchTableViewCell.h"
#import "TTGameSquareTableViewCell.h"

#import "TTGameNavView.h"
#import "TTCheckinAlertView.h"

#import "TTGameRecommendViewProtocol.h"
#import "TTDiscoverCheckInMissionNotiConst.h"
#import "TTGameActivityCycleView.h"

static NSString *const kGameCellID = @"kGameID";
static NSString *const kGameFocusCellID = @"kGameFocusID";
static NSString *const kRoomFunCellID = @"kRoomFunCellID";
static NSString *const kGameFindFriendCellID = @"kGameFindFriendID";
static NSString *const kGameMatchCellID = @"kGameMatchID";
static NSString *const kBigRoomCellID = @"kBigRoomCellID";
static NSString *const kRoomCellID = @"kRoomCellID";

@interface TTGameViewController ()<
AuthCoreClient,
UserCoreClient,
CheckinCoreClient,
CPGameCoreClient,
ImFriendCoreClient,
PraiseCoreClient,
HomeCoreClient,
LinkedMeClient,
TTHomeRoomSelectViewDelegate,
TTGameListTableViewCellDelegate,
SDCycleScrollViewDelegate,
TTGameRankTableViewCellDelegate,
TTGameFocusTableViewCellDelegate,
TTGameNavViewDelegate,
TTGameOperationViewCellDelegate,
TTGameRecommendCellDelegate,
TTGameFindFriendTableViewCellDelegate,
TTGameMatchTableViewCellDelegate,
TTOppositeSexMatchViewControllerDelegate,
TTGameActivityCycleViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
UITabBarControllerDelegate,
CAAnimationDelegate
>

@property (nonatomic, strong) TTHomeRoomSelectView *roomSelectView;
@property (nonatomic, strong) TTGameNavView *customNavView;
@property (nonatomic, strong) NSMutableArray *datasourceArray;

@property (nonatomic, strong) TTCheckinAlertView *checkinView;//签到
@property (nonatomic, strong) TYAlertController *checkinAlertController;//签到弹窗
@property (nonatomic, assign) BOOL controlMatch; // 控制主页的游戏匹配防重复点击
@property (nonatomic, strong) TTOppositeSexMatchViewController *matchVC; // 异性匹配弹窗

@property (nonatomic, strong) TTGameActivityCycleView *gameActivityCycleView; // 首页活动入口

@property (nonatomic, assign) NSInteger sectionNumber;
@end

@implementation TTGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addCore];
    [self initView];
    [self initConstrations];
    
    self.tabBarController.delegate = self;
    
    self.sectionNumber = 0;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    
    self.tableView.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.tableView];
    
    
}

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.controlMatch = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.controlMatch = NO;
}

- (BOOL)isHiddenNavBar {
    return YES;
}

- (void)initCustomNavView {
    self.customNavView = [[TTGameNavView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kNavigationHeight)];
    self.customNavView.delegate = self;
    [self.view addSubview:self.customNavView];
}

- (void)initView {
    
    [self.view addSubview:self.navBackImageView];
    
    [self initCustomNavView];
    
    [self.view insertSubview:self.navBottomImageView belowSubview:self.navBackImageView];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.gameActivityCycleView];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Robot"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"outOfMatchEnterYouRoom"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"outOfMatchEnterMyRoom"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"matchType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)rightCheckInItemClickAction:(UIButton *)btn {
    UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTCheckinViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addCore {
    AddCoreClient(CPGameCoreClient, self);
    AddCoreClient(AuthCoreClient, self);
    AddCoreClient(ImFriendCoreClient, self);
    AddCoreClient(PraiseCoreClient, self);
    AddCoreClient(HomeCoreClient, self);
    AddCoreClient(CheckinCoreClient, self);
    AddCoreClient(APNSCoreClient, self);
    AddCoreClient(UserCoreClient, self);
    AddCoreClient(LinkedMeClient, self);
}

- (void)initConstrations {
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kNavigationHeight);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    [self.navBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.mas_equalTo(kNavigationHeight);
    }];
    
    [self.navBottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kNavigationHeight);
        make.height.mas_equalTo(95);
    }];
}

#pragma mark - CheckinCoreClient
///签到详情接口响应
- (void)responseCheckinSignDetail:(CheckinSignDetail *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    self.checkinView.checkinButton.userInteractionEnabled = YES;
    
    ///确保是当前控制器调用的接口
    if (self.navigationController.viewControllers.count != 1) {
        return;
    }
    
    /// When Network Error
    if (code == nil && msg.length > 0) {
        [XCHUDTool showErrorWithMessage:@"网络出现问题" inView:self.view];
        return;
    }
    
    /// When Servers Send Error
    if (code != nil) {
        [XCHUDTool showErrorWithMessage:msg ?: @"获取数据出现问题" inView:self.view];
        return;
    }
    
    self.checkinView.signDetail = data;
    
    if (data.needSignDialog) {
        [self showCheckinView];
    }
}

///签到接口响应
- (void)responseCheckinSign:(CheckinSign *)data errorCode:(NSNumber *)code msg:(NSString *)msg {
    
    self.checkinView.checkinButton.userInteractionEnabled = YES;
    
    ///确保是当前控制器调用的接口
    if (self.navigationController.viewControllers.count != 1) {
        return;
    }
    
    /// When Network Error
    if (code == nil && msg.length > 0) {
        [XCHUDTool showErrorWithMessage:@"网络出现问题"];
        return;
    }
    
    /// When Servers Send Error
    if (code != nil) {
        [XCHUDTool showErrorWithMessage:msg ?: @"获取数据出现问题"];
        return;
    }
    
    self.checkinView.checkinButton.userInteractionEnabled = NO;
    
    [self requestSignDetail];
    
    ///签到完将金币个数累加上去
    [self.checkinView addCoin:data.signGoldNum];
    
    [TTStatisticsService trackEvent:TTStatisticsServiceEventSignSuccess
                      eventDescribe:@"弹窗签到成功"];
    
    NSString *toast = [NSString stringWithFormat:@"签到成功，奖金池已增加%ld金币", data.signGoldNum];
    [XCHUDTool showSuccessWithMessage:toast];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TTDiscoverCheckInMissonRefreshNoti object:nil];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.operationArray.count > 0) {
        self.sectionNumber = 6 + self.operationArray.count;
        return self.sectionNumber;
    } else {
        return 7;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        if (self.gameListArray.count > 0) {
            return 1;
        } else {
            return 0;
        }
    } else if (section == 2) {
        return 0;
    } else if (section == 3) {
        if (self.welfareArray.count > 0) {
            return 1;
        } else {
            return 0;
        }
    } else if (section == 4) {
        return 1;
    } else if (self.sectionNumber > 7 && section >= 5) {
        for (int i = 0; i <= self.sectionNumber - 7; i++) {
            if (section == 5 + i) {
                TTGameHomeModuleModel *model = [self.operationArray safeObjectAtIndex:i];
                if (model.type == 5) {
                    return 1;
                } else {
                    return [self returnCellNumberRowsIfSection:model];
                }
            }
        }
        if (section == self.sectionNumber - 1) {
            return self.friendFunArray.count;
        }
    } else {
        if (section == 5) {
            if (self.operationArray.count > 0) {
                TTGameHomeModuleModel *model = [self.operationArray safeObjectAtIndex:0];
                if (model.type == 5) {
                    return 1;
                } else {
                    return [self returnCellNumberRowsIfSection:model];
                }
            } else {
                return 0;
            }
        } else if (section == 6) {
            return self.friendFunArray.count;
        } else {
            return 0;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (self.focusArray.count <= 0) {
            TTGameFindFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGameFindFriendCellID];
            if (!cell) {
                cell = [[TTGameFindFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGameFindFriendCellID];
            }
            cell.delegate = self;
            return cell;
        }else{
            TTGameFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGameFocusCellID];
            if (!cell) {
                cell = [[TTGameFocusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGameFocusCellID];
            }
            cell.delegate = self;
            cell.focusArray = self.focusArray.mutableCopy;
            [cell.collectionView reloadData];
            return cell;
        }
    } else if (indexPath.section == 1) {
        TTGameListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGameCellID];
        if (!cell) {
            cell = [[TTGameListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGameCellID];
        }
        cell.delegate = self;
        cell.section = 0;
        cell.dataArray = self.gameListArray.mutableCopy;
        [cell.collectionView reloadData];
        return cell;
    } else if (indexPath.section == 2) {
        TTGameRankModel *model = [self.rankArray safeObjectAtIndex:0];
        TTGameRankTableViewCell *rankCell = [tableView dequeueReusableCellWithIdentifier:@"RankCell"];
        if (!rankCell) {
            rankCell = [[TTGameRankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RankCell"];
        }
        if (self.rankListDataReturn) {
            rankCell.delegate = self;
            [rankCell congifModel:model];
        }
        return rankCell;
    } else if (indexPath.section == 3) {
        TTGameListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGameCellID];
        if (!cell) {
            cell = [[TTGameListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGameCellID];
        }
        cell.delegate = self;
        cell.section = 1;
        cell.welfDataArray = self.welfareArray.mutableCopy;
        [cell.collectionView reloadData];
        return cell;
    } else if (indexPath.section == 4) {
        TTGameMatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGameMatchCellID];
        if (!cell) {
            cell = [[TTGameMatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGameMatchCellID];
        }
        cell.delegate = self;
        return cell;
    } else if (self.sectionNumber > 7  && indexPath.section >= 5) {
        if (indexPath.section < self.sectionNumber - 1) {
            TTGameHomeModuleModel *listModel = [self.operationArray safeObjectAtIndex:indexPath.section - 5];
            if (listModel.type == 5) {
                TTGameSquareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"squareCELL"];
                if (!cell) {
                    cell = [[TTGameSquareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"squareCELL"];
                }
                
                cell.datasourceArray = [listModel.data mutableCopy];
                
                return cell;
                
            } else {
                if (indexPath.row < [self returnBigCellNumberRowsIfSection:listModel]) {
                    TTGameRecommendBigRoomTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kBigRoomCellID];
                    if (!cell) {
                        cell = [[TTGameRecommendBigRoomTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBigRoomCellID];
                    }
                    cell.delegate = self;
                    cell.dataModelArray = [self bigRoomsFromDatas:listModel.data bigRoomCount:indexPath.row WithBigMaxNum:listModel.maxNum WithCellNumber:[self returnBigCellNumberRowsIfSection:listModel]];
                    return cell;
                }
                
                TTGameRecommendRoomTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kRoomCellID];
                if (!cell) {
                    cell = [[TTGameRecommendRoomTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRoomCellID];
                }
                cell.delegate = self;
                //分隔线
                cell.separateLine.hidden = YES;
                //数据源
                TTHomeV4DetailData *model = [listModel.data safeObjectAtIndex:indexPath.row + listModel.maxNum - [self returnBigCellNumberRowsIfSection:listModel]];
                cell.model = model;
                return cell;
            }
        }
        if (indexPath.section == self.sectionNumber - 1) {
            TTGameRecommendRoomTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kRoomFunCellID];
            if (!cell) {
                cell = [[TTGameRecommendRoomTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRoomFunCellID];
            }
            cell.delegate = self;
            //分隔线
            cell.separateLine.hidden = YES;
            //数据源
            TTHomeV4DetailData *model = [self.friendFunArray safeObjectAtIndex:indexPath.row];
            
            cell.model = model;
            
            return cell;
        }
    } else {
        if (indexPath.section == 5) {
            TTGameHomeModuleModel *listModel = [self.operationArray safeObjectAtIndex:indexPath.section - 5];
            if (listModel.type == 5) {
                TTGameSquareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"squareCELL"];
                if (!cell) {
                    cell = [[TTGameSquareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"squareCELL"];
                }
                cell.datasourceArray = [listModel.data mutableCopy];
                return cell;
            } else {
                if (indexPath.row < [self returnBigCellNumberRowsIfSection:listModel]) {
                    TTGameRecommendBigRoomTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kBigRoomCellID];
                    if (!cell) {
                        cell = [[TTGameRecommendBigRoomTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBigRoomCellID];
                    }
                    cell.delegate = self;
                    cell.dataModelArray = [self bigRoomsFromDatas:listModel.data bigRoomCount:indexPath.row WithBigMaxNum:listModel.maxNum WithCellNumber:[self returnBigCellNumberRowsIfSection:listModel]];
                    return cell;
                }
                
                TTGameRecommendRoomTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kRoomCellID];
                if (!cell) {
                    cell = [[TTGameRecommendRoomTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRoomCellID];
                }
                cell.delegate = self;
                //分隔线
                cell.separateLine.hidden = YES;
                //数据源
                TTHomeV4DetailData *model = [listModel.data safeObjectAtIndex:indexPath.row + listModel.maxNum - [self returnBigCellNumberRowsIfSection:listModel]];
                cell.model = model;
                return cell;
            }
        } else if (indexPath.section == 6) {
            TTGameRecommendRoomTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kRoomFunCellID];
            if (!cell) {
                cell = [[TTGameRecommendRoomTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRoomFunCellID];
            }
            cell.delegate = self;
            //分隔线
            cell.separateLine.hidden = YES;
            //数据源
            TTHomeV4DetailData *model = [self.friendFunArray safeObjectAtIndex:indexPath.row];
            
            cell.model = model;
            
            return cell;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emptyCell"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (self.focusArray.count <= 0) {
            if (self.bannerArray.count > 0) {
                return 70;
            } else {
                return 95;
            }
        }else{
            if (self.bannerArray.count > 0) {
                return 110;
            } else {
                return 133;
            }
        }
    } else if (indexPath.section == 1) {
        if (self.gameListArray.count > 0) {
            return 135;
        } else {
            return 0;
        }
    } else if (indexPath.section == 2) {
        return 0;
    } else if (indexPath.section == 3) {
        if (self.welfareArray.count > 0) {
            return 135;
        } else {
            return 0;
        }
    } else if (indexPath.section == 4) {
        return 50;
    } else if (self.sectionNumber > 7) {
        if (indexPath.section < self.sectionNumber - 1) {
            TTGameHomeModuleModel *listModel = [self.operationArray safeObjectAtIndex:indexPath.section - 5];
            if (listModel.type == 5) {
                return ((KScreenWidth - 17 * 3) / 2 + 50) * [self returnCellNumberWithOtherModelIfSection:listModel] + 15 + [self returnCellNumberWithLineHeigtIfSection:listModel];
            } else {
                NSInteger bigNumber = [self returnBigCellNumberRowsIfSection:listModel];
                if (indexPath.row == 0) {
                    return bigNumber * 172;
                } else {
                    return 76;
                }
            }
        }
        if (indexPath.section == self.sectionNumber - 1) {
            return 76;
        }
    } else {
        if (indexPath.section == 5) {
            TTGameHomeModuleModel *listModel = [self.operationArray safeObjectAtIndex:indexPath.section - 5];
            if (listModel.type == 5) {
                return ((KScreenWidth - 17 * 3) / 2 + 50) * [self returnCellNumberWithOtherModelIfSection:listModel] + 15 + [self returnCellNumberWithLineHeigtIfSection:listModel];
            } else {
                NSInteger bigNumber = [self returnBigCellNumberRowsIfSection:listModel];
                if (indexPath.row == 0) {
                    return bigNumber * 172;
                } else {
                    return 76;
                }
            }
        } else if (indexPath.section == 6) {
            return 76;
        }
    }
    
    return 0;
    //    NSNumber *newNumber = [self.dictKeyArray  safeObjectAtIndex:indexPath.section];
    //
    //    if ([newNumber integerValue] == GameDataIndexForArray_Attention){
    //
    //    } else if (([newNumber integerValue] == GameDataIndexForArray_GameList) || ([newNumber integerValue] == GameDataIndexForArray_welfList)) {
    //
    //    } else if ([newNumber integerValue] == GameDataIndexForArray_RankList){
    //
    //    } else if ([newNumber integerValue] == GameDataIndexForArray_FindFriendList){
    
    //    } else if ([newNumber integerValue] == GameDataIndexForArray_OperationList){
    //
    //    } else if ([newNumber integerValue] == GameDataIndexForArray_Match){
    //
    //    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        if (self.gameListArray.count > 0) {
            return 55;
        } else {
            return 0.01;
        }
    } else if (section == 3) {
        if (self.welfareArray.count > 0) {
            return 55;
        } else {
            return 0.01;
        }
    } else if (section == 2) {
        return 0;
    } else if (section == 4) {
        if (self.welfareArray.count <= 0) {
            return 18;
        } else {
            return 13;
        }
    } else if (self.sectionNumber > 7) {
        if (section < self.sectionNumber - 1 && section >= 5) {
            return 40;
        }
        if (section == self.sectionNumber - 1) {
            if (self.friendFunArray.count > 0) {
                return 55;
            } else {
                return 0.01;
            }
        }
    } else {
        if (section == 5) {
            TTGameHomeModuleModel *listModel = [self.operationArray safeObjectAtIndex:section - 5];
            if (listModel.data.count > 0) {
                return 40;
            } else {
                return 0.01;
            }
        } else if (section == 6) {
            if (self.friendFunArray.count > 0) {
                return 55;
            } else {
                return 0.01;
            }
        }
    }
    
    return 0.01;
    
    
    //    NSNumber *newNumber = [self.dictKeyArray  safeObjectAtIndex:section];
    //
    //    if ([newNumber integerValue] == GameDataIndexForArray_GameList || [newNumber integerValue] == GameDataIndexForArray_welfList || [newNumber integerValue] == GameDataIndexForArray_FindFriendList) {
    //        return 55;
    //    }else if ([newNumber integerValue] == GameDataIndexForArray_RankList || [newNumber integerValue] == GameDataIndexForArray_Match){
    //        return 13;
    //    }else{
    //        return 0.01;
    //    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 48)];
    sectionView.backgroundColor = UIColorRGBAlpha(0xffffff, 1);
    
    if (section == 1) {
        if (self.gameListArray.count > 0) {
            sectionView.backgroundColor = UIColorRGBAlpha(0xffffff, 1);
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, KScreenWidth - 30, 20)];
            titleLabel.text = @"大家都爱玩";
            titleLabel.font = [UIFont boldSystemFontOfSize:20];
            titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
            [sectionView addSubview:titleLabel];
            
            if (self.gameListArray.count >= 7) {
                UIButton *gameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [gameBtn setTitle:@"更多游戏 >" forState:UIControlStateNormal];
                [gameBtn setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
                gameBtn.titleLabel.textAlignment = NSTextAlignmentRight;
                gameBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                [gameBtn sizeToFit];
                gameBtn.height = 16;
                gameBtn.bottom = titleLabel.bottom;
                gameBtn.right = KScreenWidth - 9;
                [gameBtn addTarget:self action:@selector(allGameListAction:) forControlEvents:UIControlEventTouchUpInside];
                [sectionView addSubview:gameBtn];
            }
        } else {
            return [[UIView alloc] init];
        }
    } else if (section == 3) {
        if (self.welfareArray.count > 0) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, KScreenWidth - 30, 20)];
            titleLabel.text = @"声控福利房";
            titleLabel.font = [UIFont boldSystemFontOfSize:20];
            titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
            [sectionView addSubview:titleLabel];
        } else {
            return [[UIView alloc] init];
        }
    } else if (self.sectionNumber > 7 && section >= 5) {
        if (section < self.sectionNumber - 1) {
            UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
            sectionView.backgroundColor = UIColorRGBAlpha(0xffffff, 1);
            
            TTGameHomeModuleModel *listModel = [self.operationArray safeObjectAtIndex:section - 5];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, KScreenWidth - 30, 20)];
            titleLabel.text = listModel.title;
            titleLabel.font = [UIFont boldSystemFontOfSize:20];
            titleLabel.textColor = UIColorFromRGB(0x333333);
            [sectionView addSubview:titleLabel];
            
            return sectionView;
        }
        if (section == self.sectionNumber - 1) {
            if (self.friendFunArray.count > 0) {
                UIView *sectionFriendView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 55)];
                sectionFriendView.backgroundColor = UIColorRGBAlpha(0xffffff, 1);
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, KScreenWidth - 30, 20)];
                titleLabel.text = @"玩友欢乐房";
                titleLabel.font = [UIFont boldSystemFontOfSize:20];
                titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
                [sectionFriendView addSubview:titleLabel];
                
                return sectionFriendView;
            } else {
                return [[UIView alloc] init];
            }
        }
    } else {
        if (section == 5) {
            TTGameHomeModuleModel *listModel = [self.operationArray safeObjectAtIndex:section - 5];
            if (listModel.data.count > 0) {
                UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
                sectionView.backgroundColor = UIColorRGBAlpha(0xffffff, 1);
                
                TTGameHomeModuleModel *listModel = [self.operationArray safeObjectAtIndex:section - 5];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, KScreenWidth - 30, 20)];
                titleLabel.text = listModel.title;
                titleLabel.font = [UIFont boldSystemFontOfSize:20];
                titleLabel.textColor = UIColorFromRGB(0x333333);
                [sectionView addSubview:titleLabel];
                
                return sectionView;
            } else {
                return [[UIView alloc] init];
            }
        } else if (section == 6) {
            if (self.friendFunArray.count > 0) {
                UIView *sectionFriendView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 55)];
                sectionFriendView.backgroundColor = UIColorRGBAlpha(0xffffff, 1);
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, KScreenWidth - 30, 20)];
                titleLabel.text = @"玩友欢乐房";
                titleLabel.font = [UIFont boldSystemFontOfSize:20];
                titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
                [sectionFriendView addSubview:titleLabel];
                
                return sectionFriendView;
            } else {
                return [[UIView alloc] init];
            }
        } else {
            return [[UIView alloc] init];
        }
    }
    
    //    if ([newNumber integerValue] == GameDataIndexForArray_GameList) {
    //
    //
    //    }else if ([newNumber integerValue] == GameDataIndexForArray_welfList){
    //
    //    } else if ([newNumber integerValue] == GameDataIndexForArray_FindFriendList){
    //
    //
    //    }
    return sectionView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    if (scrollView == self.tableView)
    {
        if (scrollView.contentOffset.y >= 0) {
            if (self.navBackImageView.isHidden == NO) {
                [self.navBottomImageView layoutIfNeeded];
                [self.navBackImageView layoutIfNeeded];
                self.navBottomImageView.top = self.navBackImageView.height - scrollView.contentOffset.y;
            }
        }else{
            if (self.navBackImageView.isHidden == NO) {
                [self.navBottomImageView layoutIfNeeded];
                [self.navBackImageView layoutIfNeeded];
                self.navBottomImageView.top = self.navBackImageView.bottom;
            }
        }
    }
}

#pragma mark --- 声控福利房和游戏列表 点击代理方法 ---
- (void)itemClickWithIndex:(NSInteger)index WithSection:(NSInteger)section {
    if (section == 0) {
        if (!self.controlMatch) {
            self.controlMatch = YES;
        }else{
            return;
        }
        [[BaiduMobStat defaultStat]logEvent:@"game_homepage_chosegame_click" eventLabel:@"选中游戏点击"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"outOfMatchEnterYouRoom"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"outOfMatchEnterMyRoom"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"matchType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        CPGameListModel *model = self.gameListArray[index];
        UIViewController *gameVC = [[XCMediator sharedInstance] ttGameMoudle_TTGameMatchingViewController:[model model2dictionary] IsHiddenNav:YES];
        
        if (GetCore(RoomCoreV2).isInRoom){
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"firstExitRoomTip"] isEqualToString:@"FirstExitRoomTip"]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"FirstExitRoomTip" forKey:@"firstExitRoomTip"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                @weakify(self)
                [TTPopup alertWithMessage:@"匹配游戏需退出房间" confirmHandler:^{
                    
                    @strongify(self)
                    [GetCore(RoomCoreV2) closeRoomWithBlock:GetCore(AuthCore).getUid.userIDValue Success:^(UserID uid) {
                        
                        [[XCMediator sharedInstance] ttRoomMoudle_closeRoomViewController];
                        [self.navigationController pushViewController:gameVC animated:YES];
                        
                    } failure:^(NSNumber *resCode, NSString *message) {
                        
                    }];
                    
                } cancelHandler:^{
                    
                }];
                
                return;
                
            }else{
                [[XCMediator sharedInstance] ttRoomMoudle_closeRoomViewController];
                [self.navigationController pushViewController:gameVC animated:YES];
            }
        }else{
            [self.navigationController pushViewController:gameVC animated:YES];
        }
    }else{
        
        [[BaiduMobStat defaultStat]logEvent:@"game_homepage_lunkyroom_click" eventLabel:@"声控福利位"];
        CPGameHomeBannerModel *model = self.welfareArray[index];
        
        if (model.skipType == 2) { // 跳转房间
            
            [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:[model.skipUri userIDValue]];
            
        }else if (model.skipType == 3){  // 跳转网页
            TTVoiceWkViewController *voiceVC = [[TTVoiceWkViewController alloc] init];
            voiceVC.webUrlString = model.skipUri;
            [self.navigationController pushViewController:voiceVC animated:YES];
        }
    }
}

- (void)didSelectSmallRoomCell:(TTGameRecommendRoomTVCell *)cell data:(TTHomeV4DetailData *)data {
    if (data == nil) {
        //        assert(0);
        return;
    }
    [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:data.uid];
}

- (void)didSelectBigRoomCell:(TTGameRecommendBigRoomTVCell *)cell data:(TTHomeV4DetailData *)data{
    [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:data.uid];
}

- (void)didSelectSmallAndJumpRoomCell:(TTGameRecommendRoomTVCell *)cell data:(TTHomeV4DetailData *)data{
    if (data == nil) {
        //        assert(0);
        return;
    }
    [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:data.uid];
}

#pragma mark --- 找玩友匹配 ---
- (void)jumpFindFriendPage {
    
    [[BaiduMobStat defaultStat] logEvent:@"game_homepage_player" eventLabel:@"游戏首页-找玩友入口"];
#ifdef DEBUG
    NSLog(@"game_homepage_player");
#else
    
#endif
    
    UIViewController *findFriendVC = [[XCMediator sharedInstance] ttGameMoudle_TTGameFindFriendViewController];
    [self.navigationController pushViewController:findFriendVC animated:YES];
}

#pragma mark --- 异性匹配 ---
- (void)oppositeSexBtnMatchClick {
    [[BaiduMobStat defaultStat] logEvent:@"game_homepage_matchsex" eventLabel:@"游戏首页-异性匹配"];
#ifdef DEBUG
    NSLog(@"game_homepage_matchsex");
#else
    
#endif
    if (GetCore(RoomCoreV2).isInRoom) {
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"firstOppositeSex"] isEqualToString:@"FirstOppositeSex"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"FirstOppositeSex" forKey:@"firstOppositeSex"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            @weakify(self)
            [TTPopup alertWithMessage:@"匹配会退出当前房间并解散用户" confirmHandler:^{
                
                @strongify(self)
                [GetCore(RoomCoreV2) closeRoomWithBlock:GetCore(AuthCore).getUid.userIDValue Success:^(UserID uid) {
                    
                    [[XCMediator sharedInstance] ttRoomMoudle_closeRoomViewController];
                    
                    [GetCore(CPGameCore) userAddOppositeSexMatchPoolWithUid:GetCore(AuthCore).getUid.userIDValue];
                    
                    self.matchVC = [[TTOppositeSexMatchViewController alloc] init];
                    self.matchVC.delegate = self;
                    self.matchVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    [self.tabBarController presentViewController:self.matchVC animated:NO completion:nil];
                    
                } failure:^(NSNumber *resCode, NSString *message) {
                    
                }];
                
            } cancelHandler:^{
                
            }];
            
            return;
        }else{
            [[XCMediator sharedInstance] ttRoomMoudle_closeRoomViewController];
            [GetCore(CPGameCore) userAddOppositeSexMatchPoolWithUid:GetCore(AuthCore).getUid.userIDValue];
            self.matchVC = [[TTOppositeSexMatchViewController alloc] init];
            self.matchVC.delegate = self;
            self.matchVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self.tabBarController presentViewController:self.matchVC animated:NO completion:nil];
        }
    }else{
        [GetCore(CPGameCore) userAddOppositeSexMatchPoolWithUid:GetCore(AuthCore).getUid.userIDValue];
        self.matchVC = [[TTOppositeSexMatchViewController alloc] init];
        self.matchVC.delegate = self;
        self.matchVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.tabBarController presentViewController:self.matchVC animated:NO completion:nil];
    }
}

#pragma mark --- TTOppositeSexMatchViewControllerDelegate 异性匹配超时 ---
- (void)oppositeSexMatchTimeoutWith:(TTOppositeSexMatchViewController *)object {
    
    @weakify(self)
    [object dismissViewControllerAnimated:NO completion:^{
        
        @strongify(self)
        
        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        config.title = @"未匹配到用户";
        config.message = @"试下开个陪伴房等异性来撩";
        config.confirmButtonConfig.title = @"创建房间";
        
        [TTPopup alertWithConfig:config confirmHandler:^{
            
            [[XCMediator sharedInstance] ttRoomMoudle_closeRoomViewController];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self companyButtonActionResponse];
            });
            
        } cancelHandler:^{
            
        }];
    }];
}

#pragma mark --- 嗨聊派对 ---
- (void)hiChatBtnMatchClick {
    [[BaiduMobStat defaultStat] logEvent:@"game_homepage_hiparty" eventLabel:@"游戏首页-嗨聊派对"];
#ifdef DEBUG
    NSLog(@"game_homepage_hiparty");
#else
    
#endif
    [XCHUDTool showGIFLoadingInView:self.view];
    @KWeakify(self);
    [[GetCore(CPGameCore) userMatchGuildRoomWithUid:GetCore(AuthCore).getUid.userIDValue] subscribeNext:^(id x) {
        @KStrongify(self);
        [XCHUDTool hideHUDInView:self.view];
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:[x userIDValue]];
    } error:^(NSError *error) {
        @KStrongify(self);
        [XCHUDTool hideHUDInView:self.view];
    }];
}
#pragma mark --- 关注的人 ---
- (void)focusListClieckWithFindFriend{
    [[BaiduMobStat defaultStat] logEvent:@"game_homepage_player" eventLabel:@"游戏首页-找玩友入口"];
#ifdef DEBUG
    NSLog(@"game_homepage_player");
#else
    
#endif
    UIViewController *findFriendVC = [[XCMediator sharedInstance] ttGameMoudle_TTGameFindFriendViewController];
    [self.navigationController pushViewController:findFriendVC animated:YES];
}

- (void)focusListClieckWithAttentionModel:(Attention *)model{
    [[BaiduMobStat defaultStat]logEvent:@"game_homepage_followroom" eventLabel:@"关注人的房间"];
    
    @KWeakify(self);
    [GetCore(RoomCoreV2) getUserInterRoomInfo:model.uid Success:^(RoomInfo *roomInfo) {
        @KStrongify(self);
        if (roomInfo && roomInfo.uid > 0 && roomInfo.title.length > 0) {
            [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:roomInfo.uid];
        } else {
            [XCHUDTool showErrorWithMessage:@"TA现在没有在房间内哦" inView:self.view];
        }
    } failure:^(NSNumber *resCode, NSString *message) {
        @KStrongify(self);
        [XCHUDTool showErrorWithMessage:message inView:self.view];
    }];
}
// 关注更多
- (void)focusListMoreClickWithAttention{
    UIViewController *focusVC = [[XCMediator sharedInstance] ttMessageMoudle_TTFocusViewController];
    [self.navigationController pushViewController:focusVC animated:YES];
}

#pragma mark --- 排行榜 ---
- (void)clickRankButtonJumpH5{
    
    [[BaiduMobStat defaultStat]logEvent:@"gamepage_homepage" eventLabel:@"游戏榜单"];
    
    NSString *skipurl = HtmlUrlKey(kGameRankURL);
    
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    vc.urlString = skipurl;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 全部游戏 --
- (void)allGameListAction:(UIButton *)sender{
    [[BaiduMobStat defaultStat]logEvent:@"game_homepage_all_game" eventLabel:@"全部游戏入口"];
    
    UIViewController *completeVC = [[XCMediator sharedInstance] ttGameMoudle_TTCompleteGameListViewController];
    [self.navigationController pushViewController:completeVC animated:YES];
}

- (void)moreGameBtnClickActionBackMainPageDeal{
    [[BaiduMobStat defaultStat]logEvent:@"game_homepage_all_game" eventLabel:@"全部游戏入口"];
    UIViewController *completeVC = [[XCMediator sharedInstance] ttGameMoudle_TTCompleteGameListViewController];
    [self.navigationController pushViewController:completeVC animated:YES];
}

#pragma mark --- tabbarControlllerDelegate ---
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    if (tabBarController.selectedIndex == 0) {
//        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
//        // 短时间内 快速切换tabbar 造成数据连续刷新
//        if (timeInterval - self.timeInterval > 10) {
//            self.timeInterval = timeInterval;
////            [self requestData:1];
//        }
//    }
//}

#pragma mark --- 创建房间选择 ---
- (void)ordinaryButtonActionResponse {
    [TTPopup dismiss];
    
    GetCore(TTGameStaticTypeCore).openRoomStatus = OpenRoomType_Normal;
    [[XCMediator sharedInstance] ttRoomMoudle_openMyRoomByType:3];
    [[BaiduMobStat defaultStat]logEvent:@"game_homepage_cr_ord_click" eventLabel:@"创建普通房"];
}
- (void)companyButtonActionResponse {
    [TTPopup dismiss];
    
    GetCore(TTGameStaticTypeCore).openRoomStatus = OpenRoomType_CP;
    [[XCMediator sharedInstance] ttRoomMoudle_openMyRoomByType:5];
    [[BaiduMobStat defaultStat]logEvent:@"game_homepage_cr_cp_click" eventLabel:@"创建陪伴房"];
}

- (void)touchMaskBackground {
    [TTPopup dismiss];
}

#pragma mark --- TTGameNavView Delegate ---
- (void)navViewDidClickCreateRoom:(TTGameNavView *)view {
    
    [self showCreateRoom];
    
    [[BaiduMobStat defaultStat]logEvent:@"game_homepage_cr_click"
                             eventLabel:@"创建房间按钮"];
}

// 搜索
- (void)navViewDidClickSearch:(TTGameNavView *)view{
    @KWeakify(self);
        UIViewController *searchVC = [[XCMediator sharedInstance] ttHomeMoudleBridge_modalSearchRoomControllerWithBlock:^(long long uid){
            @KStrongify(self);
            UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:uid];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:searchVC];
        navVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:navVC animated:YES completion:nil];
}

- (void)jumpInWebViewWithh5Url:(NSString *)h5Url {
    
    TTWKWebViewViewController *webView = [[TTWKWebViewViewController alloc] init];
    
    webView.urlString = h5Url;
    
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark -- 签到 --
- (void)navViewDidClickCheckin:(TTGameNavView *)view {
    
    [TTStatisticsService trackEvent:TTStatisticsServiceEventHomeSign eventDescribe:@"签到-首页"];
    
    UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTCheckinViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- banner 点击 ---
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    [[BaiduMobStat defaultStat]logEvent:@"game_homepage_banner_click" eventLabel:@"游戏首页banner的点击"];
    CPGameHomeBannerModel *model = self.bannerArray[index];
    
    if (model.skipType == 2) { // 跳转房间
        
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:[model.skipUri userIDValue]];
        
    }else if (model.skipType == 3){  // 跳转网页
        TTVoiceWkViewController *voiceVC = [[TTVoiceWkViewController alloc] init];
        voiceVC.webUrlString = model.skipUri;
        [self.navigationController pushViewController:voiceVC animated:YES];
    }
    
}

#pragma mark - Private Methods
/**
 显示创建房间
 */
- (void)showCreateRoom {
    
    if (!self.roomSelectView.roomShowsView.isHidden) {
        self.roomSelectView.roomShowsView.hidden = YES;
    }
    
    [TTPopup popupView:self.roomSelectView
                 style:TTPopupStyleAlert];
}

/**
 显示签到页面
 */
- (void)showCheckinView {
    
    if (![[[XCCurrentVCStackManager shareManager] getCurrentVC] isKindOfClass:self.class]) {
        return;
    }
    
    //防止多次 present
    if ([self.presentedViewController isKindOfClass:TYAlertController.class]) {
        return;
    }
    
    [self presentViewController:self.checkinAlertController animated:YES completion:nil];
}

/**
 显示签到页面
 */
- (void)dismissCheckinView {
    // 缩小返回的动画
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
    anima.toValue = [NSValue valueWithCGPoint:CGPointMake(30, kNavigationHeight - 20)];
    anima.fromValue = [NSValue valueWithCGPoint:self.checkinView.center];
    //动画持续时间
    anima.duration = 0.6;
    
    //动画填充模式
    anima.fillMode = kCAFillModeForwards;
    
    //动画完成不删除
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //xcode8.0之后需要遵守代理协议
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.toValue = @(0.01);
    scale.fromValue = @(1);
    scale.duration = 0.5;
    scale.fillMode = kCAFillModeForwards;
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[anima, scale];
    group.duration = 1;
    group.delegate = self;
    //把动画添加到要作用的Layer上面
    [self.checkinView.layer addAnimation:group forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.checkinAlertController dismissViewControllerAnimated:YES];
    });
}

#pragma mark  --- 首页活动入口 ---
- (void)roomActivityListView:(TTGameActivityCycleView *)activityView jumbByActivityInfo:(ActivityInfo *)activityInfo {
    
    [[BaiduMobStat defaultStat] logEvent:@"game_homepage_activity" eventLabel:@"首页活动入口"];
#ifdef DEBUG
    NSLog(@"game_homepage_activity");
#else
    
#endif
    if (activityInfo.skipType == P2PInteractive_SkipType_Room) {
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:activityInfo.skipUrl.userIDValue];
    } else if (activityInfo.skipType == P2PInteractive_SkipType_H5) {
        [self jumpUrlWithInfo:activityInfo];
    }
}

- (void)jumpUrlWithInfo:(ActivityInfo *)activityInfo {
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
    vc.url = [NSURL URLWithString:activityInfo.skipUrl];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- Getter 懒加载 ---

-(UIView *)roomSelectView{
    if (!_roomSelectView) {
        _roomSelectView = [[TTHomeRoomSelectView alloc] init];
        _roomSelectView.frame = CGRectMake(0, 0, 311, 311);
        _roomSelectView.backgroundColor = [UIColor clearColor];
        _roomSelectView.delegate = self;
    }
    return _roomSelectView;
}


- (UIImageView *)navBackImageView{
    if (!_navBackImageView) {
        _navBackImageView = [[UIImageView alloc] init];
        _navBackImageView.image = [UIImage imageNamed:@"game_home_backImage_Top"];
    }
    return _navBackImageView;
}

- (UIImageView *)navBottomImageView{
    if (!_navBottomImageView) {
        _navBottomImageView = [[UIImageView alloc] init];
        _navBottomImageView.image = [UIImage imageNamed:@"game_home_backImage_Bottom"];
    }
    return _navBottomImageView;
}

- (NSMutableDictionary *)allDataDictionary{
    if (!_allDataDictionary) {
        _allDataDictionary = [NSMutableDictionary dictionary];
    }
    return _allDataDictionary;
}

- (NSMutableArray *)dictKeyArray{
    if (!_dictKeyArray) {
        _dictKeyArray = [NSMutableArray array];
    }
    return _dictKeyArray;
}

- (NSMutableArray *)gameListArray{
    if (!_gameListArray) {
        _gameListArray = [NSMutableArray array];
    }
    return _gameListArray;
}

- (NSMutableArray *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)bannerUrlArray{
    if (!_bannerUrlArray) {
        _bannerUrlArray = [NSMutableArray array];
    }
    return _bannerUrlArray;
}

- (NSMutableArray *)welfareArray{
    if (!_welfareArray) {
        _welfareArray = [NSMutableArray array];
    }
    return _welfareArray;
}

- (NSMutableArray<TTGameRankModel *> *)rankArray{
    if (!_rankArray) {
        _rankArray = [NSMutableArray array];
    }
    return _rankArray;
}

- (NSMutableArray<Attention *> *)focusArray{
    if (!_focusArray) {
        _focusArray = [NSMutableArray array];
    }
    return _focusArray;
}

- (NSMutableArray<TTHomeV4DetailData *> *)friendFunArray{
    if (!_friendFunArray) {
        _friendFunArray = [NSMutableArray array];
    }
    return _friendFunArray;
}

- (NSMutableArray<TTGameHomeModuleModel *> *)operationArray{
    if (!_operationArray) {
        _operationArray = [NSMutableArray array];
    }
    return _operationArray;
}

- (TTCheckinAlertView *)checkinView {
    if (_checkinView == nil) {
        _checkinView = [[TTCheckinAlertView alloc] init];
        @KWeakify(self)
        _checkinView.dismissBlock = ^{
            @KStrongify(self)
            
            if (!self.checkinView.signDetail.isSign) {
                [TTStatisticsService trackEvent:TTStatisticsServiceEventHomePopupSignClosed
                                  eventDescribe:@"签到弹窗关闭按钮(未签到关闭)"];
            }
            
            [self dismissCheckinView];
        };
        _checkinView.checkinBlock = ^{
            @KStrongify(self)
            self.checkinView.checkinButton.userInteractionEnabled = NO;
            
            [TTStatisticsService trackEvent:TTStatisticsServiceEventHomePopupSign eventDescribe:@"签到按钮-签到弹窗"];
            [GetCore(CheckinCore) requestCheckinSign];
        };
        _checkinView.bonusBlock = ^{
            @KStrongify(self)
            [self.checkinAlertController dismissViewControllerAnimated:NO];
            
            UIViewController *vc = [[XCMediator sharedInstance] ttDiscoverMoudle_TTCheckinViewController];
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _checkinView;
}

- (TYAlertController *)checkinAlertController {
    if (_checkinAlertController == nil) {
        _checkinAlertController = [TYAlertController alertControllerWithAlertView:self.checkinView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationFade];
    }
    return _checkinAlertController;
}

- (TTGameActivityCycleView *)gameActivityCycleView {
    if (!_gameActivityCycleView) {
        _gameActivityCycleView = [[TTGameActivityCycleView alloc] init];
        _gameActivityCycleView.size = CGSizeMake(74, 74);
        _gameActivityCycleView.right = KScreenWidth - 15;
        _gameActivityCycleView.bottom = KScreenHeight - 49 - kSafeAreaBottomHeight - 28;
        _gameActivityCycleView.delegate = self;
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_gameActivityCycleView addGestureRecognizer:panGes];
    }
    return _gameActivityCycleView;
}

- (void)panAction:(UIPanGestureRecognizer *)sender {
    CGPoint translationPoint = [sender translationInView:self.view];
    CGPoint center = sender.view.center;
    
    CGPoint newCenter;
    
    if (center.x + translationPoint.x < 65 / 2) {
        newCenter.x = 65 / 2;
    }else if (center.x + translationPoint.x > KScreenWidth - 65 / 2){
        newCenter.x = KScreenWidth - 65 / 2;
    }else{
        newCenter.x = center.x + translationPoint.x;
    }
    
    if (center.y + translationPoint.y < 65 / 2 + kNavigationHeight) {
        newCenter.y = 65 / 2 + kNavigationHeight;
    }else if (center.y + translationPoint.y > KScreenHeight - 65 / 2 - kSafeAreaBottomHeight - 44){
        newCenter.y = KScreenHeight - 65 / 2 - kSafeAreaBottomHeight - 44;
    }else{
        newCenter.y = center.y + translationPoint.y;
    }
    
    sender.view.center = newCenter;
    
    [sender setTranslation:CGPointZero inView:self.view];
}

@end
