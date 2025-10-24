//
//  LTDynamicDetailVC.m
//  LTChat
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019 wujie. All rights reserved.
//
//vc
#import "LTDynamicDetailVC.h"
#import "LTDynamicPlayVideoVC.h"
#import "BaseNavigationController.h"
#import "TTStatisticsService.h"
#import "LTOtherUserInfoController.h"
//model
#import "CTCommentReplyModel.h"
#import "CTDynamicModel.h"

//core
#import "DynamicCommentCore.h"
#import "DynamicCommentCoreClient.h"

#import "VKCommunityCore.h"
#import "VKCommunityCoreClient.h"
//view
//#import "XCDetailsCommentCell.h"
#import "LTDynamicCell.h"
#import "XCDetailsCommentEmptyCell.h"
//#import "KEAlertDailogView.h"
#import "CTInputView.h"
#import "CTSessionLayoutImpl.h"
#import "NIMKitKeyboardInfo.h"
#import "CTInputToolBar.h"
#import "CTGrowingTextView.h"
#import "CTGrowingInternalTextView.h"
#import "LTDetailCommentView.h"
#import "LTReplyCell.h"
//tool
//#import "MorningEveningMusicInfo.h"
//#import "MorningEveningMusicCache.h"
#import "KEMenuItemTool.h"
#import "VKPlayerManager.h"
#import "IQKeyboardManager.h"
//#import "LTRefreshHeader.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "UIView+XCToast.h"
#import "AuthCore.h"
#import "LittleWorldCore.h"
#import "LittleWorldCoreClient.h"
#import "TTPopup.h"
#import "TTWKWebViewViewController.h"
#import "XCHtmlUrl.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
#import "UserCore.h"
#import <YYText/YYText.h>
#import "XCHUDTool.h"
#import <MJRefresh/MJRefresh.h>
#import "HostUrlManager.h"
#import "XCHtmlUrl.h"
#import "XCShareView.h"
#import "ShareCore.h"
#import "XCMediator+TTAuthModule.h"
#import "XCMediator+TTDiscoverModuleBridge.h"
#import "UIView+NTES.h"

@interface LTDynamicDetailVC ()
<
LTDynamicCellDelegate,
CTInputDelegate,
NIMInputActionDelegate,
//XCDetailsCommentCellDelegate,
DynamicCommentCoreClient,
VKCommunityCoreClient,
UITableViewDelegate,
UITableViewDataSource,
LTDetailCommentViewDelegate,
LTReplyCellDelegate,
LittleWorldCoreClient,
CAAnimationDelegate,
XCShareViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
///评论数据
@property (nonatomic, strong) NSMutableArray <CTCommentReplyModel *>*dataArray;
///动态模型
@property (nonatomic, strong) CTDynamicModel *dynamicModel;
//评论总数量
@property (nonatomic, assign) int totalCount;
//输入框
@property (nonatomic, strong) CTInputView *sessionInputView;
///底部工具条
@property (nonatomic, strong) UIView *detailToolView;
///点赞button
@property (nonatomic, weak) UIButton *laudBtn;
/// 点赞按钮动画辅助，因为动画大小变化，不适合直接在按钮上直接做动画
@property (nonatomic, strong) UIImageView *likeAnimationImageView;
///正在播放的cell
@property (nonatomic, weak) LTDynamicCell *playingCell;
@property (nonatomic, assign) NSInteger currentPage;
// 当点击删除时的当前cell
@property (nonatomic, strong) LTReplyCell *deleteCell;

@property (nonatomic, assign) long nextTimeStamp; // 最后一个评论的时间戳
@property (nonatomic, assign) long nextCommentTimeStamp; // 最后一个评论时间戳


/// 用于区分是用来回复评论，还是在回复评论中的评论
@property (nonatomic, assign) BOOL isReplyComment;
@property (nonatomic, strong) NSIndexPath *replyIndexPath;
@property (nonatomic, strong) UILabel *tipsLabel; // 提示view
@property (nonatomic, strong) UILabel *countLabel; // 总评论数量
@end

@implementation LTDynamicDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initSessionInput];
    [self addCore];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self hiddenKeyBoard];
//    [self.sessionInputView.toolBar.inputTextView.textView resignFirstResponder];
}

#pragma mark - LittleWorldCoreClient
- (void)requestDynamicDetailsSuccess:(CTDynamicModel *)dynamicModel {
    if (!self.view.window) return;
    [UIView hideToastView];

    self.dynamicModel = dynamicModel;
    [self loadButtomView];
    
    if (self.dynamicModel.likeCount>0) {
        
        [self.laudBtn setTitle:self.dynamicModel.likeCount forState:UIControlStateNormal];
        if ([self.dynamicModel.likeCount integerValue] >= 100000) {
            [self.laudBtn setTitle:@"99999+" forState:UIControlStateNormal];
        }
    }
    self.laudBtn.selected = dynamicModel.isLike;
    [self.tableView reloadData];
}

- (void)requestDynamicDetailsFailth:(NSNumber *)resCode errorMessage:(NSString *)errorMessage {
    if (resCode.integerValue == 500) { //如果动态已经被删除就退出
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    [self.tableView reloadData];
}

#pragma mark - DynamicCommentCoreClient
// 评论列表
- (void)requestCommentListSuccess:(NSArray<CTCommentReplyModel *> *)modelList timeStamp:(long)timeStamp {
    if (!self.view.window) return;
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    self.nextCommentTimeStamp = timeStamp;
    
    if (self.currentPage == 1) {
        self.dataArray = [NSMutableArray arrayWithArray:modelList];
    } else {
        [self.dataArray addObjectsFromArray:modelList];
    }
    
    // 获取的数据不到10个，说明没有更多的数据了。所以显示没有更多tips
    if (modelList.count < 10) {
        self.tableView.tableFooterView = self.tipsLabel;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        self.tableView.tableFooterView = [UIView new];
    }
    
    //键盘弹出
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isShowKeyboard) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.sessionInputView.hidden = NO;
                [self.sessionInputView refreshStatus:CTInputStatusText];
                [self.sessionInputView.toolBar.inputTextView.textView becomeFirstResponder];
                self.isShowKeyboard = NO;
            });
        }
    });
    
    [UIView performWithoutAnimation:^{
        [self.tableView reloadData];
    }];
}

// 添加评论
- (void)requestAddCommentSuccess:(CTCommentReplyModel *)commentModel {
    if (commentModel == nil) {
        return;
    }
    [UIView showError:@"评论成功"];
    [self.dataArray insertObject:commentModel atIndex:0];
    
    // 总评论数量加一
    self.dynamicModel.commentCount = [NSString stringWithFormat:@"%d", [self.dynamicModel.commentCount integerValue] + 1];
    [self commentCountAttString];
    
    [UIView performWithoutAnimation:^{
        [self.tableView reloadData];
    }];
}

// 删除评论
- (void)requestDeleteCommentSuccessWithCommentId:(NSString *)commentId type:(NSInteger)type {
    [XCHUDTool hideHUD];

    if (type == 1) {
        // 删除评论回复
        
        NSIndexPath *indexPath = self.deleteCell.indexPath;
        
        CTCommentReplyModel *commentModel = self.dataArray[indexPath.section -1];
        
        NSInteger row = [commentModel.replyInfo.replyList indexOfObject:self.deleteCell.replyModel];
        NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
        
        [commentModel.replyInfo.replyList removeObject:self.deleteCell.replyModel];
        [self.tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        // 总评论数量减一
        self.dynamicModel.commentCount = [NSString stringWithFormat:@"%d", [self.dynamicModel.commentCount integerValue] - 1];
        
    } else {
        // 总评论数量减一
        self.dynamicModel.commentCount = [NSString stringWithFormat:@"%u", [self.dynamicModel.commentCount integerValue] - 1 - self.commentModel.replyInfo.replyList.count - self.commentModel.replyInfo.leftCount];
        
        [self.dataArray removeObject:self.commentModel];
        [self.tableView reloadData];
    }

    
    self.countLabel.attributedText = [self commentCountAttString];

    !_dynamicChangeCallBack ? : _dynamicChangeCallBack(self.dynamicModel);
    
}
- (void)requestDeleteCommentFailth:(NSString *)message type:(NSInteger)type {
    [XCHUDTool hideHUD];
}

// 回复评论
- (void)requestReplyCommentSuccess:(CTReplyModel *)commentModel{
    if (!commentModel) {
        return;
    }
    [UIView showError:@"回复成功"];
    NSInteger currentIndex = self.changeSection - 1;
    CTCommentReplyModel * model = self.dataArray[currentIndex];
    [model.replyInfo.replyList addObject:commentModel];
    [self.dataArray replaceObjectAtIndex:currentIndex withObject:model];
    
    // 总评论数量加一
    self.dynamicModel.commentCount = [NSString stringWithFormat:@"%d", [self.dynamicModel.commentCount integerValue] + 1];
    [self commentCountAttString];
    
    [UIView performWithoutAnimation:^{
        [self.tableView reloadData];
    }];
    self.commentModel = nil;
}

// 评论列表数据
- (void)requestCommentReplyListSuccess:(NSArray <CTCommentReplyModel *>*)commentList totalCount:(int)totalCount {
    // 动态的当前评论数据
    CTCommentReplyModel *model = self.dataArray[self.changeSection - 1];
    // 评论中的回复列表
    NSMutableArray *replyArr = model.replyInfo.replyList.mutableCopy;
    // 增加更多数据源
    [replyArr addObjectsFromArray:commentList];
    model.replyInfo.replyList = replyArr.copy;
    
    [UIView performWithoutAnimation:^{
        [self.tableView reloadData];
    }];
}

// 获取更多评论
- (void)requestCommentReplyListSuccess:(CTReplyInfoModel *)replyInfo {
    
    CTCommentReplyModel *commentReplyModel = self.dataArray[self.changeSection -1];
    [commentReplyModel.replyInfo.replyList addObjectsFromArray:replyInfo.replyList];
    commentReplyModel.replyInfo.leftCount = replyInfo.leftCount;
    commentReplyModel.replyInfo.nextTimestamp = replyInfo.nextTimestamp;
    
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.changeSection] withRowAnimation:UITableViewRowAnimationNone];

    [self.tableView reloadData];
//    [UIView performWithoutAnimation:^{
////        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.changeSection] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView reloadData];
//    }];
}

- (void)requestCommentListFailth:(NSString *)message {
    self.tableView.tableFooterView = [UIView new];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)requestDynamicDeleteSuccess {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [XCHUDTool hideHUD];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)requestDynamicDeleteFailth:(NSString *)message {
    [XCHUDTool hideHUD];
}

#pragma mark - NIMInputActionDelegate
//发送按钮事件
- (void)onSendText:(NSString *)text atUsers:(NSArray *)atUsers {
    
    if ([self isEmpty:text]) {
        [UIView showError:@"不能回复空内容哦~"];
        return;
    }
    
    if (text.length > 500) {
        self.sessionInputView.toolBar.inputTextView.text = [text substringToIndex:500];
        [UIView showError:@"评论最多500字"];
        return;
    }
    
    if (self.commentModel) {
        // 回复评论
        NSInteger commentID = [self.commentModel.commentId integerValue];
        if (self.isReplyComment) {
            CTReplyModel *replyModel = self.commentModel.replyInfo.replyList[self.replyIndexPath.row];
            commentID = [replyModel.replyId integerValue];
        }
        [GetCore(LittleWorldCore) requestReplyCommentWithDynamicId:self.dynamicId content:text commentId:commentID];
        [self hiddenKeyBoard];
        return;
    }
    // 发布动态评论
    [GetCore(LittleWorldCore) requestAddCommentWithDynamicId:self.dynamicId content:text];
    [self hiddenKeyBoard];
}

#pragma mark - 数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionCount = self.dataArray.count > 0 ? self.dataArray.count + 1 : 2;
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1 && self.dataArray.count == 0) {//空cell
        return 1;
    }
    CTReplyInfoModel *replyInfo = self.dataArray[section -1].replyInfo;
    
    NSInteger count = replyInfo.replyList.count;
    return replyInfo.leftCount > 0 ? count+1 : count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LTDynamicCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LTDynamicCell" forIndexPath:indexPath];
        if (self.dynamicModel) {
            cell.delegate = self;
            cell.dynamicModel = self.dynamicModel;
        }
        return cell;
    }else{
        if (!self.dataArray || self.dataArray.count<=0) {//空cell
            XCDetailsCommentEmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"XCDetailsCommentEmptyCell" forIndexPath:indexPath];
            emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return emptyCell;
        }
        if (indexPath.row == self.dataArray[indexPath.section-1].replyInfo.replyList.count) {//末
            return [self getMoreReplyCellWithIndexPath:indexPath];
        }
        LTReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:LTReplyCellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.replyModel = self.dataArray[indexPath.section-1].replyInfo.replyList[indexPath.row];
        cell.indexPath = indexPath;
        cell.littleWorldOwerUid = self.dynamicModel.uid;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }
    if (indexPath.section == 1) {
        if (!self.dataArray || self.dataArray.count<=0) {
            return MAX(self.tableView.height - [self.tableView rectForSection:0].size.height,200);
        }
    }
    if ((self.dataArray[indexPath.section-1].replyInfo.replyList.count == indexPath.row)){
        NSInteger count = self.dataArray[indexPath.section-1].replyInfo.leftCount;
        return count > 0 ? 40 : 0;
    }
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0 && self.dataArray.count > 0) {
        LTDetailCommentView *commentHeaderView = [[LTDetailCommentView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 120)];
        commentHeaderView.commentReplyModel = self.dataArray[section - 1];
        commentHeaderView.delegate = self;
        commentHeaderView.tag = section;
        commentHeaderView.littleWorldOwerUid = self.dynamicModel.uid;
        return commentHeaderView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
        bgView.backgroundColor = [UIColor whiteColor];
        UILabel *totalCommentLab = ({
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, KScreenWidth - 16*2, 30)];
            lab.attributedText = [self commentCountAttString];
            lab;
        });
        
        self.countLabel = totalCommentLab;
        
        UIView *lineView = ({
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 43, KScreenWidth - 15*2, 0.5)];
            line.backgroundColor = UIColorFromRGB(0xF4F4F4);
            line;
        });
        
        [bgView addSubview:totalCommentLab];
        [bgView addSubview:lineView];
        return bgView;
    }
    return nil;
}

/// 当前评论数量
- (NSAttributedString *)commentCountAttString {
    if (!self.dynamicModel) {
        return [[NSAttributedString alloc] initWithString:@"所有评论(0)"];
    }
    NSString *countStr = self.dynamicModel.commentCount;
    if ([self.dynamicModel.commentCount integerValue] >= 100000) {
        countStr = @"99999+";
    }
    NSString *text = [NSString stringWithFormat:@"所有评论(%@)", countStr];

    NSMutableAttributedString *countAtt = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [XCTheme getTTDeepGrayTextColor]}];
    
    NSRange range = [text rangeOfString:countStr];
   
    [countAtt yy_setColor:[XCTheme getTTMainTextColor] range:range];
    
    return countAtt;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0 && self.dataArray.count > 0) {
//        CTCommentReplyModel *model = self.dataArray[section - 1];
//        return [model getCommentHeight];
        return UITableViewAutomaticDimension;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 44;
    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.inputView resignFirstResponder];
    [self hiddenKeyBoard];
    if (indexPath.section == 0 || !self.dataArray.count || self.dataArray[indexPath.section -1].replyInfo.replyList.count <= indexPath.row) {
        self.commentModel = nil;
        self.sessionInputView.inputPlaceholder = @"输入发送消息…";
        return;
    }

    if (!self.dataArray.count) {
        return;
    }
    
    CTCommentReplyModel *commentModel = self.dataArray[indexPath.section -1];
    CTReplyModel *replyModel = commentModel.replyInfo.replyList[indexPath.row];

    if ([replyModel.uid isEqualToString:GetCore(AuthCore).getUid]) {
        return;
    }
    
    self.sessionInputView.hidden = NO;
    [self.sessionInputView refreshStatus:CTInputStatusText];
    self.changeSection = indexPath.section;
    self.isReplyComment = YES; // 是回复评论中的评论
    self.replyIndexPath = indexPath; // 回复评论的index
    self.sessionInputView.inputPlaceholder =  [NSString stringWithFormat:@"%@：%@" ,@"回复",  replyModel.landLordFlag ? @"楼主" : replyModel.nick];
    [self.sessionInputView.toolBar.inputTextView.textView becomeFirstResponder];
    self.commentModel = commentModel;
    
    [TTStatisticsService trackEvent:@"world_reply_comment" eventDescribe:@"回复评论"];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        self.sessionInputView.hidden = YES;
        [self hiddenKeyBoard];
        UIMenuController *controller = [UIMenuController sharedMenuController];
        controller.menuItems = nil;
    }
}
#pragma mark - LTDetailCommentViewDelegate
///点击名称跳转到个人详情
- (void)jumpUserDetailsWithDetailCommentView:(LTDetailCommentView *)commentView {
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:[commentView.commentReplyModel.uid userIDValue]];
    [self.navigationController pushViewController:vc animated:YES];
}

///点击删除评论回调
- (void)deleteCommentWithDetailCommentView:(LTDetailCommentView *)commentView {
    [XCHUDTool showGIFLoading];
    self.commentModel = commentView.commentReplyModel;
    self.changeSection = commentView.tag;
    [GetCore(LittleWorldCore) requestDynamicDeleteCommentWithCommentID:commentView.commentReplyModel.commentId deleteType:0];
}

- (void)replyCommentActionWithDetailCommentView:(LTDetailCommentView *)commentView {
    if (![self userPhoneBindStatus]) {
        return; // 未绑定手机xx
    }
    
    self.isReplyComment = NO; // 只是回复评论，不是在评论的评论中回复
    self.sessionInputView.inputPlaceholder = [NSString stringWithFormat:@"%@：%@" , @"回复",commentView.commentReplyModel.landLordFlag ? @"楼主" : commentView.commentReplyModel.nick];
    [self.sessionInputView.toolBar.inputTextView.textView becomeFirstResponder];
    self.commentModel = commentView.commentReplyModel;
    self.changeSection = commentView.tag;
}

// 举报
- (void)reportCommentWithDetailCommentView:(LTDetailCommentView *)commentView {
    [self reportH5ActionWithUid:commentView.commentReplyModel.uid source:@"DYNAMICCOMMENT"];
}

#pragma mark - LTReplyCellDelegate
///点击名称跳转到个人详情
- (void)jumpReplyUserDetailsWithCell:(LTReplyCell *)cell userUid:(NSString *)uid {
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:[uid userIDValue]];
    [self.navigationController pushViewController:vc animated:YES];
}
///删除回复
- (void)deleteReplyWithReplyCell:(LTReplyCell *)cell {
    [XCHUDTool showGIFLoading];
    [GetCore(LittleWorldCore) requestDynamicDeleteCommentWithCommentID:cell.replyModel.replyId deleteType:1];
    self.deleteCell = cell;
}

- (void)reportReplyWithReplyCell:(LTReplyCell *)cell {
    [self reportH5ActionWithUid:cell.replyModel.uid source:@"DYNAMICCOMMENT"];
}


#pragma mark - LTDynamicCellDelegate
- (void)refreshMyVestDynamicCell:(LTDynamicCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        [UIView performWithoutAnimation:^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }else{
        [UIView performWithoutAnimation:^{
            [self.tableView reloadData];
        }];
    }
}

/// 点击头像，跳转个人页
- (void)didClickUserActionWithUserUid:(NSString *)uid communityCell:(LTDynamicCell *)cell{
    UIViewController *vc = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:[uid userIDValue]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)myVestDynamicCell:(LTDynamicCell *)cell clickLaudButtonCallBackWith:(BOOL)isLaud {
    [GetCore(LittleWorldCore) requestDynamicLikeWitDynamicId:cell.dynamicModel.dynamicId worldId:self.worldId isLike:isLaud dynamicUid:cell.dynamicModel.uid completion:^(BOOL success, NSString * _Nonnull errorMsg) {
        if (success) {
            cell.dynamicModel.isLike = !cell.dynamicModel.isLike;
            
            NSInteger likeCount = [cell.dynamicModel.likeCount integerValue];
            likeCount += (cell.dynamicModel.isLike ? 1 : -1);
            likeCount = MAX(likeCount, 0);
            cell.dynamicModel.likeCount = [NSString stringWithFormat:@"%ld", (long)likeCount];
            
            [cell updateLikeButtonStatus];
            
            if (cell.dynamicModel.isLike) {
                [TTStatisticsService trackEvent:@"world_like_moments" eventDescribe:@"点赞动态:动态列表"];
                [TTStatisticsService trackEvent:@"world_like_moments_b" eventDescribe:self.dynamicModel.nick];
                [TTStatisticsService trackEvent:@"world_like_moments_c" eventDescribe:@"点赞动态:点赞"];
            } else {
                [TTStatisticsService trackEvent:@"点赞动态" eventDescribe:@"点赞动态:取消赞"];
            }
        }
    }];
}

- (void)didMoreDynamicCellCallBack:(LTDynamicCell *)cell{
    @weakify(self);

    [self.sessionInputView.toolBar.inputTextView.textView resignFirstResponder];
    
    NSMutableArray *items = [NSMutableArray array];
    TTActionSheetConfig *report = [TTActionSheetConfig actionWithTitle:@"举报" color:UIColorFromRGB(0xFF3B30) handler:^{
        @strongify(self);
        // 举报
        [TTStatisticsService trackEvent:@"world_report_moments" eventDescribe:@"动态详情：举报动态"];
        [self reportH5ActionWithUid:cell.dynamicModel.uid source:@"WORLDDYNAMIC"];
    }];
    
    TTActionSheetConfig *delete = [TTActionSheetConfig actionWithTitle:@"删除" color:UIColorFromRGB(0xFF3B30) handler:^{
        @strongify(self);
        [TTPopup alertWithMessage:@"删除后不可恢复\n确定删除该动态吗？" confirmHandler:^{
            [XCHUDTool showGIFLoading];
            [TTStatisticsService trackEvent:@"world_delete_moments" eventDescribe:@"动态详情：删除动态"];
            [GetCore(LittleWorldCore) requestDynamicDeleteWitDynamicId:cell.dynamicModel.dynamicId worldId:self.worldId];
        } cancelHandler:^{
            
        }];
        // 删除
    }];
    
    NSString *currentUid = GetCore(AuthCore).getUid;
     if (![cell.dynamicModel.uid isEqualToString:currentUid]) {
         [items addObject:report];
     }
     
    // 删除功能
    if ([cell.dynamicModel.uid isEqualToString:currentUid] ||
        [self.worldItem.ownerUid isEqualToString:currentUid]) {
        [items addObject:delete];
    }
    [TTPopup actionSheetWithItems:items.copy showCancelItem:YES];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.sessionInputView.bottom = self.view.bottom - kSafeAreaBottomHeight;
}

- (void)initView {
    self.currentPage = 1;
    
    self.title = @"详情";
        
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.detailToolView];
//    [self.view addSubview:self.keyBoardCloseView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:NIMKitKeyboardWillChangeFrameNotification object:nil];
    [self.tableView registerClass:[LTReplyCell class] forCellReuseIdentifier:LTReplyCellIdentifier];
    [self.tableView registerClass:[LTDynamicCell class] forCellReuseIdentifier:@"LTDynamicCell"];
    [self.tableView registerClass:[XCDetailsCommentEmptyCell class] forCellReuseIdentifier:@"XCDetailsCommentEmptyCell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, kSafeAreaBottomHeight + 49, 0));
        } else {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(kNavigationHeight, 0, kSafeAreaBottomHeight + 49, 0));
        }
    }];
    
    [self.detailToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(49+kSafeAreaBottomHeight);
    }];
    
    [self initMJRefresh];
}

- (void)initMJRefresh {
    
    @weakify(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.currentPage = 1;
        [self loadData];
    }];
    
    header.stateLabel.font = [UIFont systemFontOfSize:10];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:10.0];
    header.arrowView.image = [UIImage imageNamed:@"refreshImage"];
    
    self.tableView.mj_header = header;

    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.currentPage += 1;
        [GetCore(LittleWorldCore) requestCommentListWithWorldID:self.worldId dynamicId:[NSString stringWithFormat:@"%ld", (long)self.dynamicId] pageNum:self.currentPage timestamp:self.nextCommentTimeStamp];
    }];
    
    [self loadData];
}

- (void)goBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData {
    [TTStatisticsService trackEvent:@"world_moments_details" eventDescribe:@"动态详情"];
    
    [GetCore(LittleWorldCore) requestDynamicDetailsWitDynamicId:[NSString stringWithFormat:@"%ld", (long)self.dynamicId] worldID:self.worldId];
    [GetCore(LittleWorldCore) requestCommentListWithWorldID:self.worldId dynamicId:[NSString stringWithFormat:@"%ld", (long)self.dynamicId] pageNum:self.currentPage timestamp:nil];
}

- (void)initSessionInput {
    self.sessionInputView = [[CTInputView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame)+5, KScreenWidth, 44)];
    self.sessionInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    //    [self.sessionInputView setSession:self.session];
    [self.sessionInputView setInputDelegate:self];
    [self.sessionInputView setInputActionDelegate:self];
    [self.sessionInputView refreshStatus:CTInputStatusText];
    self.sessionInputView.hidden = YES;
    self.sessionInputView.backgroundColor =  UIColorFromRGB(0xF5F5F5);
    self.sessionInputView.maxTextLength = 500;
    self.sessionInputView.inputPlaceholder = self.commentModel ? [NSString stringWithFormat:@"%@：%@" ,@"回复",self.commentModel.nick] : @"输入发送消息…" ;//@"回复：楼主";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.sessionInputView.toolBar.inputTextView.textColor = UIColorFromRGB(0x222222);
    });
    [self.view addSubview:_sessionInputView];
}

- (void)addCore {
    AddCoreClient(LittleWorldCoreClient, self);
}
#pragma mark -
- (void)didChangeInputHeight:(CGFloat)inputHeight {
      UIView *superView = self.sessionInputView.superview;
      UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
      if (@available(iOS 11.0, *))
      {
          safeAreaInsets = superView.safeAreaInsets;
      }
      self.sessionInputView.bottom = superView.height - safeAreaInsets.bottom;
}

#pragma mark - event response
- (void)updateLikeButtonStatus {
    // 点赞动画
    if (!self.dynamicModel.isLike) {
        self.likeAnimationImageView.hidden = YES;
        [self updateLikeButton];
        return;
    }
    
    //为防止动画过程重影，将当前按钮图片替换为等大空白图片，达到暂时隐藏作用
    [self.laudBtn setImage:[UIImage imageNamed:@"community_post_like_placeholder"] forState:UIControlStateNormal];
    self.likeAnimationImageView.hidden = NO;

    //存放图片的数组
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<=13; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dynamic_like_%d", i]];
        [array addObject:(id)image.CGImage];
    }

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.delegate = self;
    animation.duration = 0.52;
    animation.values = array;
    [self.likeAnimationImageView.layer addAnimation:animation forKey:@""];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.laudBtn setImage:[UIImage imageNamed:@"community_post_like"] forState:UIControlStateNormal];
    self.likeAnimationImageView.hidden = YES;

    if (flag) {
        [self updateLikeButton];
    }
}

- (void)updateLikeButton {
    self.laudBtn.selected = self.dynamicModel.isLike;
    
    NSString *like = self.dynamicModel.likeCount;
    if ([self.dynamicModel.likeCount integerValue] > 99999) {
        like = @"99999+";
    }
    [self.laudBtn setTitle:like forState:UIControlStateNormal];
}

- (void)toolBarButtonActions:(UIButton *)button {
    NSInteger index = button.tag - 100;
    if (index == 0) { // 点赞
        @weakify(self);
        [GetCore(LittleWorldCore) requestDynamicLikeWitDynamicId:self.dynamicId
                                                         worldId:self.worldId
                                                          isLike:!button.selected
                                                      dynamicUid:self.dynamicModel.uid
                                                      completion:^(BOOL success, NSString * _Nonnull errorMsg) {
            @strongify(self);
            if (success) {
                self.dynamicModel.isLike = !self.dynamicModel.isLike;
                
                NSInteger likeCount = [self.dynamicModel.likeCount integerValue];
                likeCount += (self.dynamicModel.isLike ? 1 : -1);
                likeCount = MAX(likeCount, 0);
                self.dynamicModel.likeCount = [NSString stringWithFormat:@"%ld", (long)likeCount];
                
                [self updateLikeButtonStatus];
                
                if (self.dynamicModel.isLike) {
                    [TTStatisticsService trackEvent:@"world_like_moments" eventDescribe:@"点赞动态:动态列表"];
                    [TTStatisticsService trackEvent:@"world_like_moments_b" eventDescribe:self.dynamicModel.nick];
                    [TTStatisticsService trackEvent:@"world_like_moments_c" eventDescribe:@"点赞动态:点赞"];
                } else {
                    [TTStatisticsService trackEvent:@"点赞动态" eventDescribe:@"点赞动态:取消赞"];
                }
                
                !self.dynamicChangeCallBack ? : self.dynamicChangeCallBack(self.dynamicModel);
            }
        }];
        
    } else if (index == 1) { // 评论
        
        if (![self userPhoneBindStatus]) {
            return; // 未绑定手机
        }
        
        if (self.dynamicModel.status == 0) {
            return; // 未通过审核的动态
        }
        
        self.sessionInputView.hidden = NO;
        [self.sessionInputView refreshStatus:CTInputStatusText];
        [self.sessionInputView.toolBar.inputTextView.textView becomeFirstResponder];
        self.commentModel = nil;
        [TTStatisticsService trackEvent:@"world_comment_dynamic" eventDescribe:self.dynamicModel.nick];
    } else { // 分享
        //TODO
        [TTStatisticsService trackEvent:@"world_share_moments" eventDescribe:@"动态详情：动态分享"];
        
        if (self.dynamicModel.status == 0) {
            return; // 未通过的动态，不给分享
        }
        
        CGSize itemSize = CGSizeMake((KScreenWidth-2*22)/4, 76);
        
        XCShareView *shareView = [[XCShareView alloc] initWithShareViewStyle:XCShareViewStyleCenterAndBottom items:[self getShareItems] itemSize:itemSize edgeInsets:UIEdgeInsetsMake(12, 22, 12, 22)];
        
        shareView.delegate = self;
        
        [TTPopup popupView:shareView style:TTPopupStyleActionSheet];
    }
}


- (NSArray<XCShareItem *>*)getShareItems {

    BOOL installWeChat = [GetCore(ShareCore) isInstallWechat];
    BOOL installQQ = [GetCore(ShareCore) isInstallQQ];

    XCShareItem *tutuItem = [XCShareItem itemWitTag:XCShareItemTagAppFriends title:@"好友" imageName:@"share_friend" disableImageName:@"share_friend" disable:NO];

    XCShareItem *momentItem = [XCShareItem itemWitTag:XCShareItemTagMoments title:@"朋友圈" imageName:@"share_wxcircle" disableImageName:@"share_wxcircle_disable" disable:!installWeChat];
    XCShareItem *weChatItem = [XCShareItem itemWitTag:XCShareItemTagWeChat title:@"微信好友" imageName:@"share_wx" disableImageName:@"share_wx_disable" disable:!installWeChat];
    XCShareItem *qqZoneItem = [XCShareItem itemWitTag:XCShareItemTagQQZone title:@"QQ空间" imageName:@"share_qqzone" disableImageName:@"share_qqzone_disable" disable:!installQQ];
    XCShareItem *qqItem = [XCShareItem itemWitTag:XCShareItemTagQQ title:@"QQ好友" imageName:@"share_qq" disableImageName:@"share_qq_disable" disable:!installQQ];

    return @[tutuItem,momentItem,weChatItem,qqZoneItem,qqItem];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame   = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [self.sessionInputView sizeToFit];
//     [self.sessionInputView endEditing:YES];
    CGFloat containerHeight = 0;
    switch (self.sessionInputView.status)
    {
        case CTInputStatusEmoticon:
            
            break;
        case CTInputStatusText:
            self.sessionInputView.hidden = endFrame.origin.y == KScreenHeight;
//            self.keyBoardCloseView.hidden = self.sessionInputView.hidden;
            break;
        default:
            break;
    }
}

- (void)loadMoreReplyAction:(UIButton *)button {
    self.changeSection = button.tag;
    CTCommentReplyModel *model = self.dataArray[button.tag - 1];
    
    [GetCore(LittleWorldCore) requestDynamicCommentReplyListWithDynamicID:self.dynamicModel.dynamicId commentID:model.commentId timestamp:model.replyInfo.nextTimestamp];
}

- (void)hiddenKeyBoard {
    self.commentModel = nil;
    [self.sessionInputView endEditing:YES];
    self.sessionInputView.hidden = YES;
    self.sessionInputView.inputPlaceholder = @"输入发送消息…";
}

#pragma mark - XCShareViewDelegate
- (void)shareView:(XCShareView *)shareView didSelected:(XCShareItemTag)itemTag {
    SharePlatFormType sharePlatFormType;
    
    [TTPopup dismiss];
    
    switch (itemTag) {
        case XCShareItemTagAppFriends:
            sharePlatFormType = Share_Platfrom_Type_Within_Application;
            break;
        case XCShareItemTagMoments:
            sharePlatFormType = Share_Platform_Type_Wechat_Circle;
            break;
        case XCShareItemTagWeChat:
            sharePlatFormType = Share_Platform_Type_Wechat;
            break;
        case XCShareItemTagQQZone:
            sharePlatFormType = Share_Platform_Type_QQ_Zone;
            break;
        case XCShareItemTagQQ:
            sharePlatFormType = Share_Platform_Type_QQ;
            break;
        default:
            sharePlatFormType = Share_Platform_Type_Wechat_Circle;
            break;
    }
    
    [self handShare:sharePlatFormType];
}

- (void)shareViewDidClickCancle:(XCShareView *)shareView {
    [TTPopup dismiss];
}

- (void)handShare:(SharePlatFormType)shareType {
    
    CTDynamicModel *dynamicModel = self.dynamicModel;
    
    ShareDynamicInfo *dynamicInfo = [[ShareDynamicInfo alloc] init];
    dynamicInfo.nick = dynamicModel.nick;
    dynamicInfo.dynamicID = [NSString stringWithFormat:@"%ld", (long)dynamicModel.dynamicId];
    dynamicInfo.worldID = dynamicModel.worldId;
    dynamicInfo.content = dynamicModel.content;
    dynamicInfo.shareUid = dynamicModel.uid;
    if (dynamicInfo.content.length == 0) {
        dynamicInfo.content = @"点击查看动态详情";
    }
    dynamicInfo.iconUrl = dynamicModel.avatar;
    
    if (dynamicModel.dynamicResList.count > 0) {
        // 如果动态中有发布图片，就改为动态中的第一张图
        LLDynamicImageModel *imageModel = [dynamicModel.dynamicResList firstObject];
        dynamicInfo.iconUrl = imageModel.resUrl;
    }
    
    ShareModelInfor *model = [[ShareModelInfor alloc] init];
    model.currentVC = self;
    model.shareType = Custom_Noti_Sub_Dynamic_ShareDynamic;
    model.dynamicInfo = dynamicInfo;
    [GetCore(ShareCore) reloadShareModel:model];
    
    if (shareType == Share_Platfrom_Type_Within_Application) {
        UIViewController * controller = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyShareContainViewController];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        
        NSString *iconUrl = dynamicModel.avatar; // 默认图片是用户的头像
        if (dynamicModel.dynamicResList.count > 0) {
            // 如果动态中有发布图片，就改为动态中的第一张图
            LLDynamicImageModel *imageModel = [dynamicModel.dynamicResList firstObject];
            iconUrl = imageModel.resUrl;
        }
        NSString *urlStr = [NSString stringWithFormat:@"%@%@?uid=%@&dynamicId=%ld&worldId=%@",[HostUrlManager shareInstance].hostUrl, HtmlUrlKey(kLittleWorldDynamicShareURL), GetCore(AuthCore).getUid, (long)dynamicModel.dynamicId, dynamicModel.worldId];
        [GetCore(ShareCore) shareDynamicH5WithNick:dynamicModel.nick dynamicText:dynamicModel.content dynamicIcon:iconUrl shareUrl:urlStr platform:shareType];
    }
}

#pragma mark - 私有方法

- (UITableViewCell *)getMoreReplyCellWithIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"moreCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger count = self.dataArray[indexPath.section-1].replyInfo.leftCount;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(100, 0, KScreenWidth - 75, count > 0 ? 40 : 20)];
    bgView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    if (count > 0) {
        NSString *text = self.dataArray[indexPath.section-1].isShowMoreReply ? @"展开更多回复…" : [NSString stringWithFormat:@"展开%zd条回复", count];
        UIButton *openBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:UIColorFromRGB(0x34A7FF) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [btn setTitle:text forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.tag = indexPath.section;
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [btn addTarget:self action:@selector(loadMoreReplyAction:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        openBtn.frame = bgView.bounds;
        [bgView addSubview:openBtn];
    }
    [cell.contentView addSubview:bgView];
    return cell;
}

/// 用户资料的手机绑定状态
- (BOOL)userPhoneBindStatus {
    UserInfo *userInfo = [GetCore(UserCore) getUserInfoInDB:[GetCore(AuthCore).getUid longLongValue]];
    if (!userInfo.isBindPhone) {
        
        TTAlertMessageAttributedConfig *msgConfig = [[TTAlertMessageAttributedConfig alloc] init];
        msgConfig.text = @"绑定手机号";
        msgConfig.font = [UIFont boldSystemFontOfSize:15];
        
        TTAlertConfig *config = [[TTAlertConfig alloc] init];
        config.message = @"为了营造更安全的网络环境发布评论需先 绑定手机号";
        config.messageAttributedConfig = @[msgConfig];
        config.confirmButtonConfig.title = @"前往";
        
        @weakify(self);
        [TTPopup alertWithConfig:config confirmHandler:^{
            @strongify(self);
            UIViewController *vc = [[XCMediator sharedInstance] ttAuthMoudle_bindPhoneAlertViewController:^{
                [GetCore(AuthCore) logout];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        } cancelHandler:^{
        }];
    }
    
    return userInfo.isBindPhone;
}

// 判断文本内容是否全是空格组成
- (BOOL)isEmpty:(NSString *)str {
    if (!str) {
        return YES;
    }
    
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
    
    if ([trimedString length] == 0) {
        return YES;
    }  else {
        return NO;
    }
}

/// 举报 h5 页面
/// @param uid 被举报 uid
/// @param source 举报来源 小世界动态：WORLDDYNAMIC 小世界动态评论：DYNAMICCOMMENT
- (void)reportH5ActionWithUid:(NSString *)uid source:(NSString *)source {
    // 举报
      TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
      NSString *urlstr = [NSString stringWithFormat:@"%@?reportUid=%@&source=%@",HtmlUrlKey(kReportURL), uid, source];
      vc.urlString = urlstr;
      [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getters and setters

- (void)setTotalCount:(int)totalCount {
    _totalCount = totalCount;
}

- (void)loadButtomView{
    [self.detailToolView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSArray *datas = @[
                       @{@"title" : @"点赞" ,@"imageName" : @"community_post_like"},
                       @{@"title" : @"评论",@"imageName" : @"community_post_comment"},
                       @{@"title" : @"" ,@"imageName" : @"community_post_share"},
                       ];
    
    CGFloat avgWidth = KScreenWidth / datas.count;
    for (int i = 0; i < datas.count; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        btn.frame = CGRectMake(i*avgWidth, 0, avgWidth, 49);
        [btn setImage:[UIImage imageNamed:datas[i][@"imageName"]]  forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xAFAFB3) forState:UIControlStateNormal];
        [btn setTitle:datas[i][@"title"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        if (i == 0) {
            self.laudBtn = btn;
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_sel",datas[i][@"imageName"]]] forState:UIControlStateSelected];
            if ([self.dynamicModel.likeCount integerValue] > 0) {
                [self.laudBtn setTitle:[NSString stringWithFormat:@"%@",self.dynamicModel.likeCount] forState:UIControlStateNormal];
            }
        }
        
        [btn addTarget:self action:@selector(toolBarButtonActions:) forControlEvents:UIControlEventTouchUpInside];
        [_detailToolView addSubview:btn];
    }
    
    [self.detailToolView addSubview:self.likeAnimationImageView];
    [self.likeAnimationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.center.mas_equalTo(self.laudBtn.imageView);
       make.width.height.mas_equalTo(50);
    }];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = self.tipsLabel;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        if (@available(iOS 11, *)) {
            
        } else {
            _tableView.estimatedRowHeight = KScreenHeight;
            _tableView.estimatedSectionHeaderHeight = 100;
        }
    }
    return _tableView;
}

- (UIView *)detailToolView {
    if (!_detailToolView) {
        _detailToolView = [[UIView alloc] init];
        _detailToolView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _detailToolView;
}

- (NSMutableArray<CTCommentReplyModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        _tipsLabel.text = @"不要扒拉我，我是底线";
        _tipsLabel.textColor = UIColorFromRGB(0xC8C8CC);
        _tipsLabel.font = [UIFont systemFontOfSize:13];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

- (UIImageView *)likeAnimationImageView {
    if (_likeAnimationImageView == nil) {
        _likeAnimationImageView = [[UIImageView alloc] init];
        _likeAnimationImageView.image = [UIImage imageNamed:@"dynamic_like_0"];
        _likeAnimationImageView.hidden = YES;
    }
    return _likeAnimationImageView;
}

@end
