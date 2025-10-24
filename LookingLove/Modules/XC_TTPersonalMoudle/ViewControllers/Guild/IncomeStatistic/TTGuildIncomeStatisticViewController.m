//
//  TTIncomeStatisticViewController
//  TuTu
//
//  Created by lvjunhang on 2019/1/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildIncomeStatisticViewController.h"
#import "TTGuildIncomeStatisticSubViewController.h"

#import "TTGuildIncomeStatisticSegmentView.h"
#import "TTStatisticsService.h"

#import <Masonry/Masonry.h>
#import "XCMacros.h"

@interface TTGuildIncomeStatisticViewController ()<TTGuildIncomeStatisticSegmentViewDelegate>

@property (nonatomic, strong) TTGuildIncomeStatisticSegmentView *segmentView;

/** 按日子控制器 */
@property (nonatomic, strong) TTGuildIncomeStatisticSubViewController *dayVC;
/** 按周子控制器 */
@property (nonatomic, strong) TTGuildIncomeStatisticSubViewController *weekVC;

@end

@implementation TTGuildIncomeStatisticViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收入统计";
    
    [self initView];
    [self initConstraints];
}

#pragma mark - TTGuildIncomeStatisticSegmentViewDelegate
- (void)guildIncomeStatisticSegmentViewDidSelectIndex:(NSInteger)index {
    if (index == 0) {
        self.dayVC.view.hidden = NO;
        self.weekVC.view.hidden = YES;
    } else {
        self.dayVC.view.hidden = YES;
        self.weekVC.view.hidden = NO;
    }
    
    NSString *event = index==0 ? TTStatisticsServiceEventIncomeDailyClick : TTStatisticsServiceEventIncomeWeeklyClick;
    NSString *describe = index==0 ? @"收入统计 每日" : @"收入统计 每周";
    
    [TTStatisticsService trackEvent:event
                      eventDescribe:describe];
}

#pragma mark - private method
- (void)initView {
    [self.view addSubview:self.segmentView];
    
    [self addChildViewController:self.dayVC];
    [self addChildViewController:self.weekVC];
    
    [self.view addSubview:self.weekVC.view];
    [self.view addSubview:self.dayVC.view];
    
    self.weekVC.view.hidden = YES;
}

- (void)initConstraints {
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationHeight);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(46);
    }];
    
    [self.weekVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.right.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.left.right.bottom.mas_equalTo(self.view);
        }
        make.top.mas_equalTo(self.segmentView.mas_bottom);
    }];
    
    [self.dayVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.right.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.left.right.bottom.mas_equalTo(self.view);
        }
        make.top.mas_equalTo(self.segmentView.mas_bottom);
    }];
}

#pragma mark - getters and setters

- (TTGuildIncomeStatisticSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[TTGuildIncomeStatisticSegmentView alloc] init];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (TTGuildIncomeStatisticSubViewController *)dayVC {
    if (!_dayVC) {
        _dayVC = [[TTGuildIncomeStatisticSubViewController alloc] init];
        _dayVC.type = TTGuildIncomeStatisticTypeDay;
    }
    return _dayVC;
}

- (TTGuildIncomeStatisticSubViewController *)weekVC {
    if (!_weekVC) {
        _weekVC = [[TTGuildIncomeStatisticSubViewController alloc] init];
        _weekVC.type = TTGuildIncomeStatisticTypeWeek;
    }
    return _weekVC;
}

@end
