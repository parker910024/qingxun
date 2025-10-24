//
//  TTMessionViewController.m
//  TTPlay
//
//  Created by lee on 2019/3/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMissionViewController.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

// cell
#import "TTMessionCell.h"
// view
#import "TTMessionDoneView.h"
#import "TTCheckinReceiptAlertView.h"
#import "TTMissionGuildView.h"
// core
#import "MissionCore.h"
#import "MissionCoreClient.h"
#import "MissionInfo.h"
#import "UserCore.h"
#import "AuthCore.h"
// vc
#import "TTCheckinViewController.h"
// tool
#import "TTPopup.h"
#import "TTStatisticsService.h"
#import "TTStatisticsServiceEvents.h"
#import "TTDiscoverCheckInMissionNotiConst.h"
#import "XCMediator+TTGameModuleBridge.h"
#import "XCCurrentVCStackManager.h"
// model
#import "UserInfo.h"
// bridge
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "XCMediator+TTMessageMoudleBridge.h"
#import "XCMediator+TTGameModuleBridge.h"

@interface TTMissionViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
MissionCoreClient
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headBgView;  // 头部背景view
@property (nonatomic, strong) TTMessionDoneView *doneView;  // 任务完成view
@property (nonatomic, strong) NSMutableArray<MissionInfo *> *dataArray;
@property (nonatomic, strong) MissionInfo *selectInfo; // 被选中的任务信息
@property (nonatomic, assign) NSIndexPath *selectIndexPath; // 被选中的 index
@end

@implementation TTMissionViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;

    AddCoreClient(MissionCoreClient, self);
    
    [self initViews];
    [self initConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestData];
}

- (BOOL)isHiddenNavBar {
    return YES;
}

/*添加控件*/
- (void)initViews {
    [self.view addSubview:self.tableView];
}

// 布局设置
- (void)initConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

/**
 更新数据
 */
- (void)updateData {
    [self requestData];
}

/**
 请求数据
 */
- (void)requestData {
    if (self.isAchievement) {
        [GetCore(MissionCore) requestMissionAchievementList];
    } else {
        [GetCore(MissionCore) requestMissionList];
    }
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark -
#pragma mark tableView delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMessionCell *cell = [tableView dequeueReusableCellWithIdentifier:kMessionCellConst];
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    
    MissionInfo *info;
    if (self.dataArray.count > indexPath.row) {
        info = self.dataArray[indexPath.row];
    }
    cell.info = info;

    @weakify(self);
    cell.btnClickHandler = ^(P2PInteractive_SkipType skipType, NSString *configId) {
        @strongify(self);
        if (configId) {
            // 如果有 任务 id。 就去领取
            self.selectInfo = info;
            self.selectIndexPath = indexPath; //  选中的 index
            // 1 是每日， 2 是成就任务
            [GetCore(MissionCore) requestMissionReceiveByMissionID:configId type:self.type];
            return;
        }
        
        switch (skipType) {
            case P2PInteractive_SkipType_Checkin:
            {
                // 去签到
                [self goToDoMessionAction];
            }
                break;
            case P2PInteractive_SkipType_GameTab:
            {
                // 跳去游戏页面
                [self goToPlayGame];
            }
                break;
            case P2PInteractive_SkipType_PublicChat: //公聊大厅
            {
                [self gotoPublicChat];
            }
                break;
            case P2PInteractive_SkipType_BindingPhoneNum: // 绑定手机
            {
                [self gotoBingPhone];
            }
                break;
            case P2PInteractive_SkipType_Person:    // 跳转个人页
            {
                [self gotoPersonInfo];
            }
                break;
            case P2PInteractive_SkipType_UpLoad_UserIcon: // 上传头像
            {
                [self gotoUploadUserIcon];
            }
                break;
            case P2PInteractive_SkipType_UpLoad_VoiceMatching: // 声音匹配(声音瓶子)
            {
                [self gotoVoiceMatch];
            }
                break;
            case P2PInteractive_SkipType_LittleWorld: // 跳转小世界
            {
                [self gotoLittleWord];
            }
                break;
            case P2PInteractive_SkipType_LittleWorldPostDynamic: // 发布动态页
            {
                [self gotoPostDynamic];
            }
                break;

            default:
                break;
        }
        // 统计去完成的任务名
        NSString *eventStr = self.isAchievement ? [NSString stringWithFormat:@"成就任务去完成-%@", info.name] : [NSString stringWithFormat:@"每日任务去完成-%@", info.name];
        NSString *trackEvent = self.isAchievement ? TTStatisticsServiceEventTaskToFinish : TTStatisticsServiceEventFindTaskToFinish;
        [TTStatisticsService trackEvent:trackEvent eventDescribe:eventStr];
    };
    
    return cell;
}

#pragma mark -
#pragma mark customView
/** 显示签到成功view */
- (void)showMessionSucceccView:(MissionInfo *)info {
    self.doneView = [[TTMessionDoneView alloc] initWithFrame:CGRectMake(0, 0, 204, 250)];
    self.doneView.effectImageView.hidden = YES;
    self.doneView.info = info;
    
    TTPopupService *service = [[TTPopupService alloc] init];
    service.contentView = self.doneView;
    service.maskBackgroundAlpha = 0.75;
    
    service.didFinishShowingHandler = ^{
        [self.doneView startAnimation];
    };
    
    service.didFinishDismissHandler = ^(BOOL isDismissOnBackgroundTouch) {
        // 领取成功后修改状态为 已经领取
        if (info) {
            info.status = MissionStatusDoneReceive;
            [self.dataArray replaceObjectAtIndex:self.selectIndexPath.row withObject:info];
            [self.tableView reloadRowsAtIndexPaths:@[self.selectIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        // 外部刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:TTDiscoverCheckInMissonRefreshNoti object:nil];
        
        // 任务去领取统计
        NSString *eventString = self.isAchievement ? @"成就任务领取" : @"每日任务领取";
        eventString = [NSString stringWithFormat:@"%@:%@", eventString, info.name];
        
        NSString *trackEvent = self.isAchievement ? TTStatisticsServiceEventTaskAchieveGet : TTStatisticsServiceEventTaskRoutineGet;
        [TTStatisticsService trackEvent:trackEvent eventDescribe:eventString];
    };
    
    [TTPopup popupWithConfig:service];
}

#pragma mark - ViewController
/// 去签到
- (void)goToDoMessionAction {
    TTCheckinViewController *vc = [[TTCheckinViewController alloc] init];
    vc.signSuccessBlock = ^{
        // 刷新数据
        [GetCore(MissionCore) requestMissionList];
        // 回调出去也要刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:TTDiscoverCheckInMissonRefreshNoti object:nil];
    };
    [self missionNeedJumpToVc:vc];
}

/// 去玩游戏
- (void)goToPlayGame {
    // 跳转到游戏列表页
    UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTCompleteGameListViewController];
    [self missionNeedJumpToVc:vc];
}

/** 跳转公聊大厅 */
- (void)gotoPublicChat {
    UIViewController *vc = [[XCMediator sharedInstance] TTMessageMoudle_HeadLineViewContoller:1];
    [self missionNeedJumpToVc:vc];
}
/** 绑定手机 */
- (void)gotoBingPhone {
    /**  - TTBindingPhoneNumTypeUndefined: 未知状态, 没有主动传入类型
     - TTBindingPhoneNumTypeNormal: 普通状态，首次绑定
     - TTBindingPhoneNumTypeEdit: 编辑状态，已绑定过
     - TTBindingPhoneNumTypeConfirm : 验证状态：验证已绑定的手机
     
     TTBindingPhoneNumTypeUndefined = -1,
     TTBindingPhoneNumTypeNormal = 0,
     TTBindingPhoneNumTypeEdit = 1,
     TTBindingPhoneNumTypeConfirm = 2, */

    UserInfo *info = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore) getUid].userIDValue];
    // 此处任务是绑定 所以传入0
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_BindingPhoneController:0 userInfo:[info model2dictionary]];
    [self missionNeedJumpToVc:vc];
}

/** 跳转个人页 */
- (void)gotoPersonInfo {
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:[GetCore(AuthCore).getUid longLongValue]];
    [self missionNeedJumpToVc:vc];
}

/** 去上传头像 */
- (void)gotoUploadUserIcon {
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_TTPersonEditViewController];
    [self missionNeedJumpToVc:vc];
}

/** 跳转声音匹配 */
- (void)gotoVoiceMatch {
    UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTVoiceMatchingViewController];
    [self missionNeedJumpToVc:vc];
}

/** 跳转小世界 */
- (void)gotoLittleWord {
    UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_TTWorldSquareViewController];
    [self missionNeedJumpToVc:vc];
}

/// 发布动态
- (void)gotoPostDynamic {
    UIViewController *vc = [[XCMediator sharedInstance] ttGameMoudle_LLPostDynamicViewControllerWithRefresh:nil];
    [self missionNeedJumpToVc:vc];
}

#pragma mark - private Method
/// 当前任务需要跳转到下个页面
/// @param viewController 下个控制器页面
- (void)missionNeedJumpToVc:(UIViewController *)viewController {
    [[XCCurrentVCStackManager shareManager].currentNavigationController pushViewController:viewController animated:YES];
}


#pragma mark -
#pragma mark missionCore Client
// 任务列表
- (void)getMissionList:(NSArray<MissionInfo *> *)list code:(NSInteger)code message:(NSString *)message {
    if (self.isAchievement) {
        return;
    }
    self.dataArray = [NSMutableArray arrayWithArray:list];
    [self.tableView reloadData];
}

// 成就任务列表
- (void)getMissionAchievementList:(NSArray<MissionInfo *> *)list code:(NSInteger)code message:(NSString *)message {
    if (!self.isAchievement) {
        return;
    }
    self.dataArray = [NSMutableArray arrayWithArray:list];
    [self.tableView reloadData];
}

// 任务领取
- (void)getMissionReceive:(BOOL)isSuccess type:(NSInteger)type code:(NSInteger)code message:(NSString *)message {
    if (isSuccess && type == _type) {
        // 显示成功
        [self showMessionSucceccView:self.selectInfo];
    }
}

#pragma mark -
#pragma mark getter & setter
- (UIImageView *)headBgView {
    if (!_headBgView) {
        _headBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_mession_bg"]];
    }
    return _headBgView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 97;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TTMessionCell class] forCellReuseIdentifier:kMessionCellConst];
    }
    return _tableView;
}

- (NSMutableArray<MissionInfo *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
