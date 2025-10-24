//
//  TTQueueMikeViewController.m
//  TuTu
//
//  Created by lee on 2018/12/12.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTQueueMikeViewController.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "XCCurrentVCStackManager.h"

#import "XCShareView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIViewController+EmptyDataView.h"
#import "XCHUDTool.h"
#import "XCEmptyDataView.h"
#import "UIImage+Utils.h"
#import <YYText/YYText.h>
// cell
#import "TTQueueMikeCell.h"
// core
#import "ShareModelInfor.h"
#import "ShareCore.h"
#import "AuthCore.h"
#import "ArrangeMicCore.h"
#import "ArrangeMicCoreClient.h"
#import "RoomQueueCoreV2.h"
#import "RoomQueueCoreClient.h"
//model
#import "ArrangeMicModel.h"
#import "RoomInfo.h"

// tools
#import <MJRefresh/MJRefresh.h>
#import "UITableView+Refresh.h"
#import "TTStatisticsService.h"

#import "TTPopup.h"

static CGFloat kBottomViewHeight = 64.f;
static CGFloat kTopViewHeight = 44.f;
static CGFloat kJoinBtnHeight = 43.f;
static CGFloat kJoinBtnBottomMargin = 11.f;
static CGFloat kLeftAndRightMargin = 33.f;

@interface TTQueueMikeViewController ()<UITableViewDelegate, UITableViewDataSource, ArrangeMicCoreClient, RoomQueueCoreClient, TTQueueMikeCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *joinBtn;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) XCEmptyDataView *emptyDataView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TTQueueMikeViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(ArrangeMicCoreClient, self);
    AddCoreClient(RoomQueueCoreClient, self);
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self requestListMethodPage:1 status:0];   // 请求排麦列表
    [self initViews];
    [self initConstraints];
    [self configRefreshHandler];
}

#pragma mark -
#pragma mark lifeCycle
- (void)configRefreshHandler {
    @weakify(self);
    [self.tableView setupRefreshFunctionWith:RefreshTypeHeaderAndFooter];
    [self.tableView pullDownRefresh:^(int page) {
        @strongify(self);
        [self requestListMethodPage:page status:0];
    }];
    
    [self.tableView pullUpRefresh:^(int page, BOOL isLastPage) {
        @strongify(self);
        [self requestListMethodPage:page status:1];
    }];
}

- (void)initViews {
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.tableView];
    [self.containerView addSubview:self.joinBtn];
    [self.containerView addSubview:self.tipsLabel];
}

- (void)initConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11, *)) {
//            if (self.isMyRoom) {
//                make.edges.mas_equalTo(self.view.mas_safeAreaLayoutGuide).insets(UIEdgeInsetsMake(210, 0, 0, 0));
//            } else {
//                make.edges.mas_equalTo(self.view.mas_safeAreaLayoutGuide).insets(UIEdgeInsetsMake(210, 0, -kSafeAreaBottomHeight, 0));
//            }
//        } else {
//            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(210, 0, 0, 0));
//        }
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(210 + kNavigationHeight + kSafeAreaTopHeight);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (self.isMyRoom) {
//            make.edges.mas_equalTo(self.containerView).insets(UIEdgeInsetsMake(44, 0, -kSafeAreaBottomHeight, 0));
//        } else {
//            make.edges.mas_equalTo(self.containerView).insets(UIEdgeInsetsMake(44, 0, 0, 0));
//        }
        
        make.left.right.mas_equalTo(self.containerView);
        make.top.mas_equalTo(kTopViewHeight);
        if (self.isMyRoom) {
            make.bottom.mas_equalTo(0);
        } else {
            make.bottom.mas_equalTo(-(kBottomViewHeight + kSafeAreaBottomHeight));
        }
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(15);
    }];
    
    [self.joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.containerView).inset(kJoinBtnBottomMargin + kSafeAreaBottomHeight);
        make.left.right.mas_equalTo(0).inset(kLeftAndRightMargin);
        make.height.mas_equalTo(kJoinBtnHeight);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTQueueMikeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTQueueMikeCell class])];
    cell.countLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    cell.isMyRoom = self.isMyRoom;
    cell.delegate = self;
    if (self.dataArray.count > indexPath.row) {
        cell.userInfo = self.dataArray[indexPath.row];
    }
    return cell;
}

#pragma mark -
#pragma mark private methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableAttributedString *)tipsLabelAttributedString:(NSString *)count text:(NSString *)text{
    NSString *string = [NSString stringWithFormat:@"%@：%@", text, count];
    NSRange range = [string rangeOfString:count];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attStr yy_setColor:[XCTheme getTTMainColor] range:range];
    return attStr;
}

#pragma mark -
#pragma mark public methods
//被邀请上麦
- (void)ttShowInviteAlert{
    
    TTAlertConfig *config = [[TTAlertConfig alloc] init];
    config.title = @"房主或管理员拉你上麦";
    config.message = @"你已被房主或管理员拉上麦，但并未开启麦克风，需要说话，请打开麦克风";
    
    [TTPopup alertWithConfig:config confirmHandler:^{
        
    } cancelHandler:^{
        
    }];
}

#pragma mark -
#pragma mark cell delegate
- (void)onQueueMicBtnClick:(UIButton *)btn userID:(long long)userID gender:(UserGender)gender {
    // 抱他上麦
    if (self.isMyRoom) { // 普通用户不用响应
        [GetCore(RoomQueueCoreV2) inviteUpLockMic:userID gender:gender];
    }
}

#pragma mark -
#pragma mark request method
- (void)requestListMethodPage:(int)page status:(int)status{
    [GetCore(ArrangeMicCore) getArrangeMicList:self.roomInfo.uid status:status page:page pageSize:20];
}

#pragma mark -
#pragma mark button click events
- (void)onJoinBtnClickAction:(UIButton *)btn {
    
    if (self.isMyRoom) {
        // 去分享房间 ？
        [self dismissViewControllerAnimated:NO completion:nil];
        !_btnClickHander ? : _btnClickHander(btn);

        return;
    }
    
    // 如果已经在麦上，就不让再排麦了。管理员 or 房主除外
    if ([GetCore(RoomQueueCoreV2) isOnMicro:[GetCore(AuthCore) getUid].userIDValue]) {
        [XCHUDTool showErrorWithMessage:@"已经在麦上不需要报名啦"];
        return;
    }
    
    if (btn.selected) {
        
        @weakify(self)
        [TTPopup alertWithMessage:@"取消报名后再次报名需要重新排麦哦！确认取消报名吗？" confirmHandler:^{
            if (self.roomInfo.type == RoomType_Love) {
                [TTStatisticsService trackEvent:@"room_blinddate_enlist" eventDescribe:@"相亲房取消报名"];
            } else {
                [TTStatisticsService trackEvent:@"room_blinddate_enlist" eventDescribe:@"非相亲房取消报名"];
            }
            @strongify(self)
            // 取消上麦请求
            [GetCore(ArrangeMicCore) userBegainOrCancleArrangeMicWith:1 operuid:[GetCore(AuthCore) getUid].userIDValue roomUid:self.roomInfo.uid];
            
        } cancelHandler:^{
            
        }];
        
    } else if (!btn.selected) {
        // 加入排麦
        if ([GetCore(RoomQueueCoreV2) isOnMicro:[GetCore(AuthCore).getUid longLongValue]]) {
            [XCHUDTool showErrorWithMessage:@"已经在麦上不需要报名啦"];
            return;
        }
        if (self.roomInfo.type == RoomType_Love) {
            [TTStatisticsService trackEvent:@"room_blinddate_enlist" eventDescribe:@"相亲房点我报名"];
        } else {
            [TTStatisticsService trackEvent:@"room_blinddate_enlist" eventDescribe:@"非相亲房点我报名"];
        }
        //        status 0 开始排麦 1 取消排麦
        [GetCore(ArrangeMicCore) userBegainOrCancleArrangeMicWith:0 operuid:[GetCore(AuthCore) getUid].userIDValue roomUid:self.roomInfo.uid];
    }
}

#pragma mark -
#pragma mark coreClient
// 获取排麦 list
- (void)getArrangeMicListSuccess:(ArrangeMicModel *)arrangeList status:(int)status {
    // 结束刷新
    NSLog(@"!!当前请求的第几页%d",status);
    [self.tableView endRefreshStatus:0];
    
    // 上麦人数
    if (status == 0) { // 下拉刷新
        self.dataArray = [NSMutableArray arrayWithArray:arrangeList.queue];
    } else if (status == 1) { // 上拉加载
        [self.dataArray addObjectsFromArray:arrangeList.queue];
    }
    
    if (self.dataArray.count == 0) {
        // 通用显示 UI
        self.joinBtn.hidden = NO;
        self.emptyDataView.hidden = NO;
//        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tipsLabel.text = @"报名才能排麦喔~";
        
        if (self.isMyRoom) { // 如果是在自己房间
            self.emptyDataView.title = @"冷冷清清的无人排麦哦~\n分享房间邀请好友加入一起嗨";
            [self.joinBtn setTitle:@"立即邀请" forState:UIControlStateNormal];
        } else {
            self.tipsLabel.hidden = NO;
            self.emptyDataView.title = @"立即报名，你就是排麦第一人啦！";
        }
        
        [self.tableView endRefreshStatus:1 hasMoreData:NO];
    } else {
        [self.tableView endRefreshStatus:1 hasMoreData:YES];
        self.emptyDataView.hidden = YES;
        self.joinBtn.hidden = YES;
        self.tipsLabel.hidden = NO;
        if (!self.isMyRoom) {
            self.joinBtn.hidden = NO;
        }
        if (arrangeList.count.integerValue > 0) {
            if (self.isMyRoom) { // 管理员身份或者是群主身份进入的时候，显示样式。
                self.tipsLabel.attributedText = [self tipsLabelAttributedString:arrangeList.count text:@"当前排麦人数"];
            }
        }
    }
    if (arrangeList.myPos.integerValue >= 1) {
        self.joinBtn.selected = YES;
        self.tipsLabel.attributedText = [self tipsLabelAttributedString:arrangeList.myPos text:@"我在队列中排列位置"];
    }
    [self.tableView reloadData];
}

- (void)getArrangeMicListFail:(NSString *)message status:(int)stauts {
}

// 开始排麦 or 取消
- (void)begainOrCancleArrangeMicSuccess:(NSDictionary *)dic status:(int)status {
    if (status == 0) {
        [XCHUDTool showSuccessWithMessage:@"已报名"];
        self.joinBtn.selected = YES;
        
    } else if (status == 1) {
//        [UIView showToastInKeyWindow:@"已取消" duration:2.0 position:YYToastPositionCenter];
        self.joinBtn.selected = NO;
    }
    // 刷新数据
    [self requestListMethodPage:1 status:0];
}

- (void)begainOrCancleArrangeMicFail:(NSString *)message status:(int)stauts {
}

// 从无人排麦到有人
- (void)roomArrangeMicStatusChangeWith:(CustomNotiHeaderArrangeMic)status {
    // 从无人排麦到有人，从有人mm排麦到无人，关闭排麦
    if (status == Custom_Noti_Header_ArrangeMic_Non_Empty ||
        status == Custom_Noti_Header_ArrangeMic_Empty ||
        status == Custom_Noti_Header_ArrangeMic_Mode_Close) {
        [self requestListMethodPage:1 status:0];
    }
}

- (void)embracUserToMicSendMessageSuccess{
    [self requestListMethodPage:1 status:0];
}
//房主邀请上麦
- (void)onMicroBeInvite {
    [self ttShowInviteAlert];
}

#pragma mark -
#pragma mark getter & setter
- (void)setIsMyRoom:(BOOL)isMyRoom {
    _isMyRoom = isMyRoom;
    self.joinBtn.hidden = isMyRoom;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.userInteractionEnabled = YES;
    }
    return _containerView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [XCTheme getTTSimpleGrayColor];
        CGFloat bottomHeight = kSafeAreaBottomHeight;
        if (!self.isMyRoom) {
            bottomHeight += 70;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 65;
        [_tableView registerClass:[TTQueueMikeCell class] forCellReuseIdentifier:NSStringFromClass([TTQueueMikeCell class])];
    }
    return _tableView;
}

- (UIButton *)joinBtn {
    if (!_joinBtn) {
        _joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinBtn setTitle:@"点击报名" forState:UIControlStateNormal];
        [_joinBtn setTitle:@"取消报名" forState:UIControlStateSelected];
        [_joinBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_joinBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateSelected];
        [_joinBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        UIImage *normalImage = [UIImage imageWithColor:[XCTheme getTTMainColor]];
        UIImage *selectedImage = [UIImage imageWithColor:UIColorFromRGB(0xDBDBDB)];
        [_joinBtn setBackgroundImage:selectedImage forState:UIControlStateSelected];
        [_joinBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
        _joinBtn.layer.masksToBounds = YES;
        _joinBtn.layer.cornerRadius = 43 * 0.5;
        _joinBtn.hidden = YES;
        [_joinBtn addTarget:self action:@selector(onJoinBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinBtn;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"报名才能排麦喔~";
        _tipsLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _tipsLabel.font = [UIFont systemFontOfSize:14.f];
        _tipsLabel.adjustsFontSizeToFitWidth = YES;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.hidden = YES;
    }
    return _tipsLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _lineView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (XCEmptyDataView *)emptyDataView {
    if (!_emptyDataView) {
        _emptyDataView = [[XCEmptyDataView alloc] init];
        _emptyDataView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _emptyDataView.messageLabel.textColor = RGBCOLOR(153, 153, 153);
        _emptyDataView.messageLabel.font = [UIFont systemFontOfSize:13];
        _emptyDataView.image = [UIImage imageNamed:@"common_noData_empty"];
        _emptyDataView.imageFrame = CGRectMake((KScreenWidth - 185) / 2, 0, 185, 145);
        _emptyDataView.hidden = YES;
        _emptyDataView.backgroundColor = [UIColor whiteColor];
        _emptyDataView.margin = -45;
        [self.tableView addSubview:_emptyDataView];
    }
    return _emptyDataView;
}
@end
