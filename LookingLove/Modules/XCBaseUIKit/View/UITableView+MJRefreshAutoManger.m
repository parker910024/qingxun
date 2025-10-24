//
//  UITableView+MJRefreshAutoManger.m
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "UITableView+MJRefreshAutoManger.h"
#import <MJRefresh.h>
#import <ReactiveObjC/ReactiveObjC.h>
@implementation UITableView (MJRefreshAutoManger)
static char stateKey;
static void * KscreenOrigins = (void *)@"KscreenOrigins";
static void * KtableViewHeightOnScreens = (void *)@"KtableViewHeightOnScreens";

- (void)setScreenOrigins:(CGFloat)screenOrigins
{
    objc_setAssociatedObject(self, &KscreenOrigins, @(screenOrigins), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)screenOrigins
{
    NSNumber *number =  (NSNumber *)objc_getAssociatedObject(self, &KscreenOrigins);
    return   number.floatValue;
}
- (void)setTableViewHeightOnScreens:(CGFloat)tableViewHeightOnScreens
{
    objc_setAssociatedObject(self, &KtableViewHeightOnScreens, @(tableViewHeightOnScreens), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)tableViewHeightOnScreens
{
    NSNumber *number =  (NSNumber *)objc_getAssociatedObject(self, &KtableViewHeightOnScreens);
    return   number.floatValue;
}
- (void)setFootRefreshState:(MJFooterRefreshState)footRefreshState {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (self.tableViewHeightOnScreens == 0) {
        self.tableViewHeightOnScreens = window.frame.size.height;
    }
    [RACObserve(self.mj_footer, frame)subscribeNext:^(id x) {
        CGPoint point = [self convertPoint:self.mj_footer.frame.origin toView:window];

        if (point.y < self.tableViewHeightOnScreens - self.screenOrigins) {
            [(MJRefreshAutoNormalFooter *)self.mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
            [self.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
    [self handleFooterRefresh:footRefreshState];
    NSString *value = [NSString stringWithFormat:@"%ld", (long)footRefreshState];
    objc_setAssociatedObject(self, &stateKey, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}





- (MJFooterRefreshState)footRefreshState {
    NSString *refreshState =objc_getAssociatedObject(self, &stateKey);
    if ([refreshState isEqualToString:@"MJFooterRefreshStateLoadMore"]) {
        return MJFooterRefreshStateNoMore;
    }
    else {
        return MJFooterRefreshStateLoadMore;
    }
}

- (void) handleFooterRefresh: (MJFooterRefreshState)footRefreshState {
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter*)self.mj_footer;
    switch (footRefreshState) {
        case MJFooterRefreshStateNormal: {
            [footer setTitle:@"" forState:MJRefreshStateIdle];
            break;
        }
        case MJFooterRefreshStateLoadMore: {
            [self.mj_footer endRefreshing];
            break;
        }
        case MJFooterRefreshStateNoMore: {
            [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
            [self.mj_footer endRefreshingWithNoMoreData];
            break;
        }
        default:
            break;
    }
}

@end
