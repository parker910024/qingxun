//
//  XCHeartCommentViewController.m
//  UKiss
//
//  Created by apple on 2018/12/6.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import "LTDynamicCommentListVC.h"
#import "LTOtherUserInfoController.h"
#import "BaseNavigationController.h"
//core
#import "UserCore.h"
#import "UserCoreClient.h"
#import "ImLoginCoreClient.h"
#import "VKCommunityCore.h"
#import "VKCommunityCoreClient.h"
#import "AuthCore.h"
#import "ImFriendCoreClient.h"

//view
#import "LTCommentListViewCell.h"
//tool
#import "UIView+XCToast.h"
#import "XCAlertControllerCenter.h"
//#import "LTRefreshHeader.h"
//#import "UIView+loading.h"

//sdk
#import <MJRefresh/MJRefresh.h>
#import "UITableView+Refresh.h"
#import "HeartCommentInfo.h"

//birdge
#import "LTCommentFooterView.h"
//#import <LYEmptyView/LYEmptyViewHeader.h>

#import "UIView+XCToast.h"
#import "UIView+NTES.h"
#import "XCMacros.h"
#import "XCTheme.h"
//vc
#import "LTDynamicDetailVC.h"
#import "CTCommentReplyModel.h"
//#import "AppDelegate.h"

@interface LTDynamicCommentListVC ()<VKCommunityCoreClient,ImLoginCoreClient,ImFriendCoreClient,LTCommentFooterViewDelegate,LTCommentListViewCellDelegate>
@property (nonatomic, strong) NSMutableArray<HeartCommentInfo *> *dataSource;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) LTCommentFooterView * footerView;
@property (strong, nonatomic) UIButton *clearBtn;
@property (assign, nonatomic) BOOL isNoMoreData;;
///空列表数据
@property (nonatomic, strong) UIView *emptyTipView;

@end

@implementation LTDynamicCommentListVC

- (BOOL)isHiddenNavBar{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray array];
    [self initUI];
    [self addcore];
    
//    self.navigationController.navigationBar.barTintColor = UIColorRGBAlpha(0x322B50, 1);
   
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)initUI {
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.textColor = UIColorFromRGB(0x222222);
    titleLab.font = [UIFont boldSystemFontOfSize:17];
    titleLab.text = @"动态消息";
    titleLab.frame = CGRectMake(0, statusbarHeight, KScreenWidth, 44);
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    //    self.navigationItem.titleView = titleLab;
    
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"nav_bar_back_white"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.width = 44;
    closeBtn.height = 44;
    closeBtn.left = 0;
    closeBtn.centerY = titleLab.centerY;

    [self.view addSubview:closeBtn];
    self.type = 1;
    self.currentPage = 0;

    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.frame = CGRectMake(0, closeBtn.bottom, KScreenWidth, KScreenHeight-statusbarHeight-44);
    self.tableView.tableViewHeightOnScreen = 1;
    //    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49*2, 0);
//    [self setupRefreshTarget:self.tableView];
    [self.tableView registerClass:[LTCommentListViewCell class] forCellReuseIdentifier:@"LTCommentListViewCell"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;//高度设置为自适应
//    self.tableView.tableFooterView = self.footerView;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.sectionFooterHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.separatorColor = UIColorFromRGB(0x2B2541);
//    UILabel *emptyLab = [[UILabel alloc]init];
//    emptyLab.text = [@"暂无数据" localString];
//    emptyLab.textColor = UIColorFromRGB(0x666666);
//    [emptyLab sizeToFit];
//    emptyLab.font = [UIFont systemFontOfSize:15];
//    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithCustomView:emptyLab];
    
//    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithCustomView:self.emptyTipView];
//    [LYEmptyView emptyViewWithImageStr:@"empty_dynamic_message_icon"
//                                                        titleStr:[@"暂无数据" localString]
//                                                       detailStr:@""];
//    self.tableView.ly_emptyView.contentViewY = KScreenHeight/2;
//    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:self.clearBtn];
    [self initMJRefresh];
//    [self.view showLoading];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [GetCore(VKCommunityCore) requestUnReadCount];

}

- (void)dealloc {
    
    RemoveCoreClient(UserCoreClient, self);
    RemoveCoreClient(VKCommunityCoreClient, self);
}
#pragma mark - LTCommentListViewCellDelegate
- (void)onTapDynamic:(LTCommentListViewCell *)cell{
    LTDynamicDetailVC * vc = [[LTDynamicDetailVC alloc] init];
    vc.dynamicId = cell.info.dynamicId;
    if (cell.info.dynamicStatus == 3) {
        [UIView showError:@"该动态已被删除"];
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTapAvart:(LTCommentListViewCell *)cell{
    [LTOtherUserInfoController jumpToUserControllerWithUserUid:cell.info.commentUid uploadFlag:cell.info.uploadFlag formVc:self];
}
#pragma mark - LTCommentFooterViewDelegate
/**
 历史记录
 */
- (void)historyButtonClick{
    if (self.isNoMoreData) {
        [UIView showError:@"没有更多"];
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        return;
    }
    
    self.currentPage += 1;
    [GetCore(VKCommunityCore) requestHistoryListTpye:self.type page:self.currentPage minDate:0];
}

/**
 清除
 */
- (void)onclearBtnClicked:(UIButton *)btn{
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:@"确定清除全部通知？" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xC1BEE3),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
//    [XCNewAlertDailogView showAlertWithTitle:@"提示" withContent:att withSureTitle: @"确定" sure:^{
//        [GetCore(VKCommunityCore) requestUnReadClearListTpye:self.type];
//    } cancle:^{
//
//    }];
//
}
#pragma mark - XCFriendListTableViewCellDelegate
//- (void)friendListCellFindOrFocusWith:(XCFriendListTableViewCell *)cell cellType:(FriendiListCellType)cellType focusButton:(UIButton *)sender
//{
//    if (cellType == FriendiListCellType_FindUser && cell.userId) {
//        //        [[XCMediator sharedInstance] hhRoomMoudle_presentRoomViewControllerWithRoomUid:cell.userId];
//    }
//}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTCommentListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LTCommentListViewCell" forIndexPath:indexPath];
//    cell.type = self.type;
    cell.info = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [UIView new];
//    view.backgroundColor = UIColorFromRGB(0xf5f5f5);
//    return view;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 5;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

//    LTCommentListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LTCommentListViewCell"];
    return [LTCommentListViewCell cellHeight:self.dataSource[indexPath.row]];
//    if (self.type == HeadMessageType_Comment) {
//    }else{
//        return 92;
//    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.dataSource.count > 0) {
        HeartCommentInfo * info = [self.dataSource safeObjectAtIndex:indexPath.row];
        if (info.dynamicStatus == 3) {
            [UIView showError:@"该动态已被删除"];
            return;
        }
        if (info.type == 0) {//评论
            LTDynamicDetailVC * vc = [[LTDynamicDetailVC alloc] init];
                if (info.isDelete) {
                    [UIView showError:@"该评论已被删除"];
                    return;
                }
//                vc.selCommentID = info.commentId;
            vc.dynamicId = info.dynamicId;
            [self.navigationController presentViewController:[[BaseNavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
        }else{//回复
            if (info.isDelete) {
                [UIView showError:@"该回复已被删除"];
                return;
            }
            LTDynamicDetailVC *detailVc = [[LTDynamicDetailVC alloc]init];
            detailVc.dynamicId = info.dynamicId;
            [self.navigationController pushViewController:detailVc animated:YES];
        }
    }
}

#pragma mark - VKCommunityCoreClient
- (void)onRequestUnReadListFailth:(NSString *)msg{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
//    [self.view hiddenLoading];
}

- (void)onRequestUnReadListSuccess:(NSArray *)lists{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
//    [self.view hiddenLoading];
    [self.dataSource removeAllObjects];
    //置空数据
//    AppDelegate * delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    delegate.unreadModel = nil;
    
    if (lists.count<=0) {//没有评论消息 加载历史评论
        self.currentPage = 1;
        [GetCore(VKCommunityCore) requestHistoryListTpye:self.type page:self.currentPage minDate:0];
        self.clearBtn.hidden = self.dataSource.count<=0;
        [self.tableView reloadData];
        return;
    }
    [self.dataSource addObjectsFromArray:[lists mutableCopy]];
    [self rightAndHistoryUI];
    [self.tableView reloadData];
}

- (void)onRequestHistoryListSuccess:(NSArray *)lists{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (lists.count < 20) {
        self.isNoMoreData = YES;
    }
    if (lists.count<=0) {
        self.currentPage -= 1;
        [UIView showError:@"没有更多"];
        return;
    }
    if (self.currentPage == 1) {
        [self.dataSource removeAllObjects];
    }
    [self.dataSource addObjectsFromArray:[lists mutableCopy]];
    [self rightAndHistoryUI];
    
    [self.tableView reloadData];
}

- (void)onRequestHistoryListFailth:(NSString *)msg{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

//清空评论点赞列表
- (void) requestUnReadClearListSuccess{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.dataSource removeAllObjects];
    [self rightAndHistoryUI];
    [self.tableView reloadData];
}

- (void) requestUnReadClearListFailth:(NSString *)msg{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - ImLoginCoreClient
- (void)onImLogoutSuccess {
    [self.dataSource removeAllObjects];
}

- (void)onImSyncSuccess {
    self.currentPage = 1;
    [self pullDownRefresh:1];
}

- (void)onFriendChanged
{
    self.currentPage = 1;
    [self pullDownRefresh:1];
    
}

#pragma mark - private method

- (void)rightAndHistoryUI{
    
    if (self.dataSource.count>0) {
        self.tableView.tableFooterView = self.footerView;
    }else{
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    self.clearBtn.hidden = self.dataSource.count<=0;
}

- (void)presenterActionWithUserInfo:(UserInfo *)userinfo{
    !self.praisePresenterBlock ? : self.praisePresenterBlock(userinfo);
}

- (void)initMJRefresh {
    @weakify(self);
//    LTRefreshHeader *header = [LTRefreshHeader headerWithRefreshingBlock:^{
//        @strongify(self);
//        self.currentPage = 1;
//        [GetCore(VKCommunityCore) requestUnReadListType:self.type];
//
//    }];
//    //    header.stateLabel.textColor = [UIColor whiteColor];
//    //    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
//    self.tableView.mj_header = header;
    
    self.currentPage = 1;
    [GetCore(VKCommunityCore) requestUnReadListType:self.type];
}


//- (void)setupRefreshTarget:(UITableView *)tableView {

//    [tableView setupRefreshFunctionWith:RefreshTypeHeaderAndFooter];
//
//    [tableView pullUpRefresh:^(int page, BOOL isLastPage) {
//
//        [self pullUpRefresh:page lastPage:isLastPage];
//    }];
//
//    [tableView pullDownRefresh:^(int page)
//     {
//         [self pullDownRefresh:page];
//     }];
//}

- (void)addcore{
    AddCoreClient(VKCommunityCoreClient, self);
    AddCoreClient(UserCoreClient, self);
//    AddCoreClient(RoomCoreClient, self);
//    AddCoreClient(ImLoginCoreClient, self);
//    AddCoreClient(ImFriendCoreClient, self);

    [GetCore(VKCommunityCore) requestUnReadListType:self.type];

}

#pragma mark - Getter
- (NSMutableArray<HeartCommentInfo *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (LTCommentFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[LTCommentFooterView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
        _footerView.delegate = self;
    }
    return _footerView;
}

- (UIButton *)clearBtn{
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _clearBtn.layer.masksToBounds = YES;
        _clearBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_clearBtn setTitleColor:UIColorFromRGB(0xA49EFE) forState:UIControlStateNormal];
        [_clearBtn setTitle:@"清除" forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(onclearBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

- (UIView *)emptyTipView {
    if (!_emptyTipView) {
        _emptyTipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height)];
        UIImageView *emptyImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_dynamic_message_icon"]];;
        emptyImg.frame = CGRectMake(0, 0, _emptyTipView.width, _emptyTipView.height);
        emptyImg.contentMode = UIViewContentModeScaleAspectFill;
        UILabel *emptyLab = [[UILabel alloc]init];
        emptyLab.numberOfLines = 0;
        emptyLab.text = @"等\n赞\n /\n评\n论\n ~";
        emptyLab.textColor = UIColorFromRGB(0x222222);
        emptyLab.font = [UIFont boldSystemFontOfSize:14];
        emptyLab.textAlignment = NSTextAlignmentCenter;
        [emptyLab sizeToFit];
        emptyLab.top = 200;
        emptyLab.centerX = _emptyTipView.width/2.f;
//        emptyLab.textAlignment = NSTextAlignmentCenter;
//        emptyLab.frame = CGRectMake(0, CGRectGetMaxY(emptyImg.frame) + 20, emptyImg.width, 44);
//        _emptyTipView.frame = CGRectMake(0, 0, emptyImg.width, emptyImg.height + 44);
        
        [_emptyTipView addSubview:emptyImg];
        [_emptyTipView addSubview:emptyLab];
    }
    return _emptyTipView;
}
@end
