//
//  TTRoomContributionController.m
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTRoomContributionController.h"
#import "TTRoomContributionNavView.h"

#import "TTHalfhourContributionViewController.h"
#import "TTInRoomContributionViewController.h"

#import "ZJScrollPageViewDelegate.h"
#import "ZJScrollPageView.h"

#import "XCTheme.h"
#import "RankCore.h"

#import <Masonry/Masonry.h>
#import "XCMacros.h"

@interface TTRoomContributionController ()<ZJScrollPageViewDelegate, TTRoomContributionNavViewDelegate>

@property (nonatomic, strong) TTRoomContributionNavView *navView;

@property (nonatomic, strong) UIView *bottmBGView;//作用是切圆角填补回来
@property (nonatomic, strong) ZJScrollPageView *scorllPageView;

@end

@implementation TTRoomContributionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self initSubView];
}

- (void)initSubView {
    [self.view addSubview:self.bottmBGView];
    [self.view addSubview:self.scorllPageView];
    [self.view addSubview:self.navView];
    
    [self.bottmBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(52);
    }];
}

#pragma mark - TTRoomContributionNavViewDelegate
- (void)didClickHalfhourRankInNavView:(TTRoomContributionNavView *)view {
    [self.scorllPageView setSelectedIndex:0 animated:YES];
}

- (void)didClickRoomRankInNavView:(TTRoomContributionNavView *)view {
    [self.scorllPageView setSelectedIndex:1 animated:YES];
}

#pragma mark - ZJScrollPageViewDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.navView.titleArray.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    if (reuseViewController) {
        return reuseViewController;
    }
    
    @weakify(self)
    switch (index) {
            case 0:
        {
            TTHalfhourContributionViewController *vc = [[TTHalfhourContributionViewController alloc] init];
            vc.selectUserBlock = ^(UserID uid) {
                @strongify(self)
                if ([self.delegate respondsToSelector:@selector(halfhourContributionDidSelectUser:)]) {
                    [self.delegate halfhourContributionDidSelectUser:uid];
                }
            };
            reuseViewController = vc;
        }
            break;
            case 1:
        {
            TTInRoomContributionViewController *vc = [[TTInRoomContributionViewController alloc] init];
            vc.roomContributionSelectBlock = ^(UserID uid) {
                @strongify(self)
                if ([self.delegate respondsToSelector:@selector(inRoomContributionDidSelectUser:)]) {
                    [self.delegate inRoomContributionDidSelectUser:uid];
                }
            };
            reuseViewController = vc;
        }
            break;
        default:
            break;
    }
    return reuseViewController;
}

#pragma mark - Getter && Setter
- (UIView *)bottmBGView {
    if (!_bottmBGView) {
        _bottmBGView = [[UIView alloc] init];
        _bottmBGView.backgroundColor = [UIColor whiteColor];
    }
    return _bottmBGView;
}

- (ZJScrollPageView *)scorllPageView {
    if (!_scorllPageView) {
        _scorllPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 480) segmentStyle:nil titles:@[@"",@""] parentViewController:self delegate:self];
        _scorllPageView.layer.cornerRadius = 20;
        _scorllPageView.layer.masksToBounds = YES;
    }
    return _scorllPageView;
}

- (TTRoomContributionNavView *)navView {
    if (_navView == nil) {
        _navView = [[TTRoomContributionNavView alloc] init];
        _navView.delegate = self;
    }
    return _navView;
}

@end

