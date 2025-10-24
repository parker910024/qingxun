//
//  TTRoomMessageViewController.m
//  TTPlay
//
//  Created by Jenkins on 2019/3/7.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTRoomMessageViewController.h"
#import "ZJScrollPageView.h"
//core

//view
#import "ZJScrollPageView.h"
//vc
#import "TTFansViewController.h"
#import "TTFriendListViewController.h"
#import "TTFocusViewController.h"
#import "TTSessionListViewController.h"
//tool
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"

@interface TTRoomMessageViewController ()<ZJScrollPageViewDelegate>
@property (nonatomic, strong) UIButton * button;

@property (nonatomic, strong) ZJSegmentStyle * style;
@property (nonatomic, strong) ZJScrollPageView * pageView;
@property (nonatomic, strong) UIView * lineView;
@end

@implementation TTRoomMessageViewController

- (BOOL)isHiddenNavBar{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CAShapeLayer * layer = [[CAShapeLayer alloc] init];
    layer.path = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)].CGPath;
    self.view.layer.mask = layer;
    [self initView];
    [self initContrations];
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pageView];
    [self.view addSubview:self.lineView];
}

- (void)initContrations{
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.view).offset(49);
    }];
}


- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index{
    UIViewController<ZJScrollPageViewChildVcDelegate> * childVC = reuseViewController;
    if (childVC == nil) {
        if (index == 0) {
            TTSessionListViewController<ZJScrollPageViewChildVcDelegate> *sessionlitVC =  [[TTSessionListViewController alloc] init];
            sessionlitVC.isRoomMessage = YES;
            sessionlitVC.mainController = self;
            childVC = sessionlitVC;
        }else if (index == 1){
            TTFriendListViewController<ZJScrollPageViewChildVcDelegate> *friendlitVC =  [[TTFriendListViewController alloc] init];
            friendlitVC.type = MessageVCType_RoomChat;
            friendlitVC.mainController = self;
            childVC = friendlitVC;
        }else if (index == 2){
            TTFansViewController * fansVC = [[TTFansViewController alloc] init];
            fansVC.type = MessageVCType_RoomChat;
            fansVC.mainController = self;
            childVC = fansVC;
        }else if (index == 3){
            TTFocusViewController<ZJScrollPageViewChildVcDelegate> *praiseVC =  [[TTFocusViewController alloc] init];
            praiseVC.type = MessageVCType_RoomChat;
            praiseVC.mainController = self;
            childVC = praiseVC;
        }
    }
    return childVC;
}

- (NSInteger)numberOfChildViewControllers{
    return 4;
}



- (ZJSegmentStyle *)style{
    if (!_style) {
        _style = [[ZJSegmentStyle alloc] init];
        _style.titleFont = [UIFont boldSystemFontOfSize:16];
        _style.segmentHeight = 49;
        _style.normalTitleColor = [XCTheme getTTDeepGrayTextColor];
        _style.selectedTitleColor = [XCTheme getTTMainTextColor];
        _style.showLine = YES;
        _style.scrollLineColor = [XCTheme getTTMainColor];
        _style.autoAdjustTitlesWidth = YES;
        _style.scrollTitle = NO;
    }
    return _style;
}

- (ZJScrollPageView *)pageView{
    if (!_pageView) {
        CGFloat height = 400;
        if (KScreenWidth > 320) {
            height = 530;
        }
        _pageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, height) segmentStyle:self.style titles:@[@"消息", @"好友", @"粉丝", @"关注"] parentViewController:self delegate:self];
    }
    return _pageView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [XCTheme getMSSimpleGrayColor];
    }
    return _lineView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
