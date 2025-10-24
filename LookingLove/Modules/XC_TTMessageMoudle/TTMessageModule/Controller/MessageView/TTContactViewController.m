//
//  TTContactViewController.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/25.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTContactViewController.h"

#import "TTFansViewController.h"
#import "TTFocusViewController.h"
#import "TTFriendListViewController.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "TTStatisticsService.h"

#import <Masonry/Masonry.h>

@interface TTContactViewController ()<ZJScrollPageViewDelegate>

/** 滑动条*/
@property (nonatomic,strong) ZJScrollPageView *pageView;

@end

@implementation TTContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系人";
    
    [self initView];
}

- (BOOL)isHiddenNavBar {
    return YES;
}

#pragma mark - private method
- (void)initView {
    [self.view addSubview:self.pageView];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}


#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - ZJScrollPageViewDelegate
- (NSInteger)numberOfChildViewControllers {
    return 3;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        
        if (index == 0) {
            TTFriendListViewController *vc = [[TTFriendListViewController alloc] init];
            vc.type = MessageVCType_Contacts;
            childVc = vc;
            
        } else if (index == 1) {
            TTFansViewController *vc = [[TTFansViewController alloc] init];
            vc.type = MessageVCType_Contacts;
            childVc = vc;
            
        } else if (index == 2) {
            TTFocusViewController *vc = [[TTFocusViewController alloc] init];
            vc.type = MessageVCType_Contacts;
            childVc = vc;
            
            [TTStatisticsService trackEvent:@"news_follow" eventDescribe:@"消息-关注"];
        }
    }
    
    return childVc;
}

#pragma mark - Getter Setter
- (ZJScrollPageView *)pageView {
    if (_pageView == nil) {
        
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
        style.showLine = YES;
        style.titleFont = [UIFont boldSystemFontOfSize:16];
        style.autoAdjustTitlesWidth = YES;// 缩放标题
        style.selectedTitleColor = UIColorFromRGB(0x333333);
        style.normalTitleColor = UIColorFromRGB(0x999999);
        style.scrollLineColor = [XCTheme getTTMainColor];
        style.scrollContentView = YES;
        
        CGFloat height = KScreenHeight - kNavigationHeight - kTabBarHeight;
        CGRect rect = CGRectMake(0, 0, KScreenWidth, height);
        
        _pageView = [[ZJScrollPageView alloc] initWithFrame:rect segmentStyle:style titles:@[@"好友", @"粉丝", @"关注"] parentViewController:self delegate:self];
        _pageView.segmentView.backgroundColor = [UIColor whiteColor];
    }
    return _pageView;
}

@end
