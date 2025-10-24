//
//  LTOtherUserInfoController.m
//  LTChat
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "LTOtherUserInfoController.h"
//#import "KEMyTagsController.h"
//#import "LTUserDynamicController.h"
#import "BaseNavigationController.h"

//view
#import "HL_ScrollGestureView.h"
#import "HL_PageView.h"
#import "HL_SegmentView.h"
#import "HL_ScrollGestureView.h"
#import "LTOtherUserHeaderView.h"

//tool
#import "UIButton+EnlargeTouchArea.h"

//core
#import "VKCommunityCore.h"
#import "VKCommunityCoreClient.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "UIView+XCToast.h"
#import "AuthCore.h"


@interface LTOtherUserInfoController ()
<
UIScrollViewDelegate,
VKCommunityCoreClient
>

///支持多手势的scrollView
@property (nonatomic, strong) HL_ScrollGestureView *bgScrollView;
///pageView的父View
@property (nonatomic, strong) UIView *bgPageView;
///pageView
@property (nonatomic, strong) HL_PageView *pageView;
///title
@property (nonatomic, strong) HL_SegmentView *segmentView;
///顶部view
@property (nonatomic, strong) LTOtherUserHeaderView *headerView;
///当前scrollView是否可以滚动
@property (nonatomic, assign) BOOL canScroll;
///title数据
@property (nonatomic, strong) NSArray <NSString *> *titles;
///子控制器
@property (nonatomic, strong) NSArray *childVc;
/////左右按钮
//@property (nonatomic, strong) UIButton *leftBtn;
//@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation LTOtherUserInfoController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initConstrations];
    [self addCore];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //Remove Client Here
    RemoveCoreClientAll(self);
}

#pragma mark - public methods

+ (void)jumpToUserControllerWithUserUid:(NSString *)uid uploadFlag:(BOOL)uploadFlag formVc:(UIViewController *)formVc {
    if (!uploadFlag) {
        [UIView showError:@"message_userinfo_notSeeTip"];
        return;
    }
    [UIView showMessage:@""];
    LTOtherUserInfoController *userVc = [[LTOtherUserInfoController alloc]init];
    [userVc addCore];
    userVc.uid = uid;
    userVc.formVc = formVc;
//    [GetCore(VKCommunityCore) requestGetBlackListStatusWithMyUid:GetCore(AuthCore).getUid.userIDValue toUid:uid.userIDValue userVc:userVc];
}

#pragma mark - [系统控件的Protocol]

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.bgScrollView) return;
    CGFloat offsetY = scrollView.contentOffset.y;
//    if (self.bgPageView.top != kScrollTopHeight && offsetY > 0) {
//        _canScroll = NO;
////        [[NSNotificationCenter defaultCenter] postNotificationName:kLeaveTopNotificationName object:nil userInfo:@{@"canScroll":@"1"}];
//
//        [UIView animateWithDuration:0.25 animations:^{
////            self.pageView.superview.top = kScrollTopHeight;
//        }];
////        [self.headerView.videoPlayVc pauseVideo];
//    }
    scrollView.contentOffset = CGPointMake(0, 0);
}

#pragma mark - [自定义控件的Protocol]

#pragma mark - [core相关的Protocol]

//0表示都没拉黑 1表示我拉黑对方，2对方拉黑我，3互相拉黑
- (void)requestGetBlackListStatusSuccess:(NSInteger)likeStatus userVc:(UIViewController *)userVc {
    if (self == userVc) {
        [UIView hideToastView];
        if (likeStatus == 0) {//没有拉黑
            BaseNavigationController *vc = [[BaseNavigationController alloc] initWithRootViewController:self];
            [self.formVc presentViewController:vc animated:YES completion:nil];
        }else if (likeStatus == 2) {//对方拉黑我
            [UIView showError:@"对方已把你拉黑，无法进入主页"];
        }else {//我拉黑对方
            [UIView showError:@"你已拉黑对方，无法进入主页"];
        }
    }
}

- (void)requestGetBlackListStatusFailth:(NSString *)msg {
    [UIView hideToastView];
}


#pragma mark - event response

- (void)leftBtnClickAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBtnClickAction:(UIButton *)button {
//    KEUserInfoSettingController *settingVc = [[KEUserInfoSettingController alloc]init];
//    [self.navigationController pushViewController:settingVc animated:YES];
}

///滑动离开顶部通知
-(void)scrollLeaveTopNotification:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.bgPageView.top = KScreenHeight;
        }];
    }
}

#pragma mark - private method

- (void)initView {
    self.canScroll = YES;
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.headerView];
//    [self addChildViewController:self.headerView.videoPlayVc];
    [self.bgScrollView addSubview:self.bgPageView];
    [self setUpLikeButton];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollLeaveTopNotification:) name:kGoTopNotificationName object:nil];
}

- (void)setUpLikeButton {
//    [self.view addSubview:self.headerView.videoPlayVc.likeButton];
}

- (void)initConstrations {
//    self.leftBtn.left = 20;
//    self.leftBtn.centerY = statusbarHeight + 44/2.f;
//    self.rightBtn.right = KScreenWidth - 20;
//    self.rightBtn.centerY = self.leftBtn.centerY;
}

- (void)addCore {
    AddCoreClient(VKCommunityCoreClient, self);
}

#pragma mark - getters and setters

- (BOOL)isHiddenNavBar {
    return YES;
}

- (NSArray<NSString *> *)titles {
    if (!_titles) {
        _titles = @[@"标签", @"动态"];
    }
    return _titles;
}

- (NSArray *)childVc {
    if (!_childVc) {
        NSMutableArray *tempArr = [NSMutableArray array];
//        NSArray *classNames = @[[KEMyTagsController class],[LTUserDynamicController class]];
//        for (int i = 0; i < self.titles.count; ++i) {
//            UIViewController *vc = [[classNames[i] alloc]init];
//            [vc setValue:self.uid forKeyPath:@"uid"];
//            [vc setValue:@(YES) forKeyPath:@"isHasTabbarHeight"];
//
//            [tempArr addObject:vc];
//        }
        _childVc = tempArr.copy;
    }
    return _childVc;
}

- (HL_ScrollGestureView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[HL_ScrollGestureView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _bgScrollView.backgroundColor = [UIColor clearColor];
        _bgScrollView.delegate = self;
        _bgScrollView.showsVerticalScrollIndicator = YES;
        [_bgScrollView setContentSize:CGSizeMake(KScreenWidth, _bgScrollView.height + 1)];
        if (@available(iOS 11.0, *)) {
            _bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _bgScrollView;
}

- (UIView *)bgPageView {
    if (!_bgPageView) {
//        _bgPageView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight - kScrollTopHeight)];
        _bgPageView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        [_bgPageView addSubview:self.segmentView];
        [_bgPageView addSubview:self.pageView];
    }
    return _bgPageView;
}

- (HL_PageView *)pageView {
    if (!_pageView) {
//        _pageView = [[HL_PageView alloc]initWithFrame:CGRectMake(0, 54, KScreenWidth, KScreenHeight - kScrollTopHeight - 54) segmentView:self.segmentView superController:self childControllers:self.childVc];
        _pageView.delegate = self.segmentView;
    }
    return _pageView;
}

- (HL_SegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView= [[HL_SegmentView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
        _segmentView.titles = self.titles;
        _segmentView.isAvgWith = YES;
        _segmentView.backgroundColor = UIColorFromRGB(0xffffff);
        _segmentView.titleNorColor = UIColorRGBAlpha(0x222222, 0.5);
        _segmentView.titleSelColor = UIColorFromRGB(0x222222);
        _segmentView.titleNorFont = [UIFont systemFontOfSize:14];
        _segmentView.titleSelFont = [UIFont boldSystemFontOfSize:14];
        _segmentView.titleSelColor = UIColorFromRGB(0x222222);
        _segmentView.delegate = self.pageView;
        [_segmentView setUpComplete];

        //圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_segmentView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _segmentView.bounds;
        maskLayer.path = maskPath.CGPath;
        _segmentView.layer.mask = maskLayer;
    }
    return _segmentView;
}


- (LTOtherUserHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[LTOtherUserHeaderView alloc] initWithOtherUid:self.uid];
        _headerView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
//        _headerView.videoPlayVc.formVc = self.formVc;
    }
    return _headerView;
}

//- (UIButton *)leftBtn {
//    if (!_leftBtn) {
//        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_leftBtn setImage:[UIImage imageNamed:@"person_close_icon"] forState:UIControlStateNormal];
//        [_leftBtn sizeToFit];
//        [_leftBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
//        [_leftBtn addTarget:self action:@selector(leftBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _leftBtn;
//}
//
//- (UIButton *)rightBtn {
//    if (!_rightBtn) {
//        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_rightBtn setImage:[UIImage imageNamed:@"person_more_icon"] forState:UIControlStateNormal];
//        [_rightBtn sizeToFit];
//        [_rightBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
//        [_rightBtn addTarget:self action:@selector(rightBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
//        _rightBtn.hidden = [self.uid isEqualToString:GetCore(AuthCore).getUid];
//    }
//    return _rightBtn;
//}
//


@end
