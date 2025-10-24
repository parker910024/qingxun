//
//  TTCarrotViewController.m
//  TTPlay
//
//  Created by lee on 2019/3/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCarrotViewController.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "XCHUDTool.h"
#import "XCHtmlUrl.h"
// view
#import "TTCarrotHeadView.h"
#import "TTSelectDateView.h"
#import "TTDatePickView.h"
#import "TTCustomBaseNavView.h"
// tools
#import <ReactiveObjC/ReactiveObjC.h>
#import "UIView+ZJFrame.h"
#import "PLTimeUtil.h"
#import "TTPopup.h"
// vc
#import "TTBillListViewController.h"
#import "TTWKWebViewViewController.h"
#import "TTBaseCarrotBillViewController.h"
// core
#import "PurseCore.h"
#import "PurseCoreClient.h"

@interface TTCarrotViewController ()<UIScrollViewDelegate, PurseCoreClient, TTDatePickViewDelegate, TTCustomBaseNavViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TTCarrotHeadView *headView;
@property (nonatomic, strong) TTSelectDateView *selectDateView;
@property (nonatomic, strong) TTDatePickView *datePickView;
@property (nonatomic, strong) UIScrollView *contentView;
// vc
@property (nonatomic, strong) TTBaseCarrotBillViewController *billOutVc;
@property (nonatomic, strong) TTBaseCarrotBillViewController *billInVc;
@property(nonatomic, assign) NSInteger selectIndex;
/** 返回顶部按钮 */
@property (nonatomic, strong) UIButton *scrollTopBtn;
@property (nonatomic, strong) TTCustomBaseNavView *navView;

@end

@implementation TTCarrotViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (BOOL)isHiddenNavBar {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(PurseCoreClient, self);
    //类型,1:萝卜币
    [GetCore(PurseCore) requestCarrotWalletWithType:1];
    
    [self setupChildViewControllers];
    [self initViews];
    [self initConstraints];
    [self selectDateViewHandler];
    
    // 解决底部无法滑动返回的问题
    [self.contentView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self.view addSubview:self.headView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.selectDateView];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.scrollTopBtn];
    [self scrollViewDidEndScrollingAnimation:self.contentView];
}

- (void)initConstraints {
    [self.selectDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headView.mas_bottom);
        make.height.mas_equalTo(55);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.selectDateView.mas_bottom);
    }];
    
    [self.scrollTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0).inset(15);
        make.bottom.mas_equalTo(-55);
    }];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(kNavigationHeight);
    }];
}

- (void)setupChildViewControllers {
    // 支出
    TTBaseCarrotBillViewController *billOut = [[TTBaseCarrotBillViewController alloc] init];
    billOut.listType = CarrotBillListTypeGiftOut;
    // 收入
    TTBaseCarrotBillViewController *billIn = [[TTBaseCarrotBillViewController alloc] init];
    billIn.listType = CarrotBillListTypeGiftIn;

    [self addChildViewController:billIn];
    [self addChildViewController:billOut];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    scrollView.contentSize = CGSizeMake(scrollView.zj_width * self.childViewControllers.count, 0);
    // 当前索引
    NSInteger index = scrollView.contentOffset.x / scrollView.zj_width;
    self.selectIndex = index;
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    TTBaseCarrotBillViewController *base = (TTBaseCarrotBillViewController *)vc;
    vc.view.zj_x = scrollView.contentOffset.x;
    vc.view.zj_y = 0;
    vc.view.zj_height = scrollView.zj_height;
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.zj_width;
}

#pragma mark -
#pragma mark coreClient
- (void)getCarrotNum:(CarrotWallet *)carrotWallet code:(NSNumber *)code message:(NSString *)message {
    if (!carrotWallet) {
        // 默认有 toast 提示
        return;
    }
    
    self.headView.carrotWalletInfo = carrotWallet;
}

#pragma mark - TTMissionNavViewDelegate
- (void)didClickBackButtonInMissionNavView:(TTCustomBaseNavView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickRightBtn:(TTCustomBaseNavView *)nav {
    TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc] init];
    vc.urlString = HtmlUrlKey(kRadishRuleURL);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods
/** 选择日期view */
- (void)selectDateViewHandler {
    @weakify(self);
    _selectDateView.selecteDayHandler = ^(selectDateType dateType) {
        @strongify(self);
        switch (dateType) {
            case selectDateTypeToady:
            {
                // 选择当天
                [self reloadDataByDate:[NSDate date]];
            }
                break;
            case selectDateTypeChooseDay:
            {
                // 选择一个日期
                [self showDateView];
            }
                break;
                
            default:
                break;
        }
    };
}

// 显示dateView
- (void)showDateView {
    
    [TTPopup popupView:self.datePickView style:TTPopupStyleActionSheet];
}

/** 根据时间刷新数据 */
- (void)reloadDataByDate:(NSDate *)date {
    TTBaseCarrotBillViewController *baseVc = (TTBaseCarrotBillViewController *)self.childViewControllers[self.selectIndex];
    [baseVc reloadDateByDate:date];
}

#pragma mark -
#pragma mark datePicker delegate
- (void)ttDatePickCancelAction {
    [TTPopup dismiss];
}

- (void)ttDatePickLimitAction {
    [XCHUDTool showErrorWithMessage:@"出错了" inView:self.view];
}

- (void)ttDatePickEnsureAction:(NSString *)YMd date:(NSDate *)date {
    self.selectDateView.todayText = YMd;
    [self reloadDataByDate:date];
}


#pragma mark -
#pragma mark button click events
- (void)scrollTopBtnClickAction:(UIButton *)scrollTopBtn {
    TTBaseCarrotBillViewController *baseVc = (TTBaseCarrotBillViewController *)self.childViewControllers[self.selectIndex];
    [baseVc scrollToTop];
}

#pragma mark -
#pragma mark getter & setter
- (TTCarrotHeadView *)headView {
    if (!_headView) {
        _headView = [[TTCarrotHeadView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 205 + statusbarHeight)];
        _headView.backgroundColor = UIColor.whiteColor;
        @weakify(self);
        _headView.selectHandler = ^(NSInteger index) {
            @strongify(self);
            self.selectIndex = index;
            CGPoint offset = self.contentView.contentOffset;
            offset.x = index * KScreenWidth;
            [self.contentView setContentOffset:offset animated:YES];
            // 切换就改时间默认为当天
            self.selectDateView.todayText = [PLTimeUtil getYYMMDDWithDate:[NSDate date]];
        };
    }
    return _headView;
}

- (TTSelectDateView *)selectDateView {
    if (!_selectDateView) {
        _selectDateView = [[TTSelectDateView alloc] init];
    }
    return _selectDateView;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxX(self.selectDateView.frame), KScreenWidth, KScreenHeight - CGRectGetMaxX(self.selectDateView.frame))];
        _contentView.contentSize = CGSizeMake(KScreenWidth * 2, 0);
        _contentView.pagingEnabled = YES;
        _contentView.delegate = self;
        _contentView.bounces = NO;
        _contentView.scrollEnabled = NO;
    }
    return _contentView;
}

- (TTDatePickView *)datePickView {
    if (!_datePickView) {
        _datePickView = [[TTDatePickView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 240 + kSafeAreaBottomHeight)];
        _datePickView.delegate = self;
        _datePickView.maximumDate = [NSDate date];
        _datePickView.time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
        _datePickView.dateFormat = @"YYYY年MM月dd日";
    }
    return _datePickView;
}

- (UIButton *)scrollTopBtn {
    if (!_scrollTopBtn) {
        _scrollTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scrollTopBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_scrollTopBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_scrollTopBtn setImage:[UIImage imageNamed:@"Bill_scrollTop"] forState:UIControlStateNormal];
        _scrollTopBtn.layer.masksToBounds = YES;
        _scrollTopBtn.layer.cornerRadius = 25;
        [_scrollTopBtn addTarget:self action:@selector(scrollTopBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scrollTopBtn;
}

- (TTBaseCarrotBillViewController *)billInVc {
    if (!_billInVc) {
        _billInVc = [[TTBaseCarrotBillViewController alloc] init];
        _billInVc.listType = CarrotBillListTypeGiftIn;
    }
    return _billInVc;
}

- (TTBaseCarrotBillViewController *)billOutVc {
    if (!_billOutVc) {
        _billOutVc = [[TTBaseCarrotBillViewController alloc] init];
        _billOutVc.listType = CarrotBillListTypeGiftOut;
    }
    return _billOutVc;
}

- (TTCustomBaseNavView *)navView {
    if (!_navView) {
        _navView = [[TTCustomBaseNavView alloc] init];
        _navView.delegate = self;
    }
    return _navView;
}


@end

