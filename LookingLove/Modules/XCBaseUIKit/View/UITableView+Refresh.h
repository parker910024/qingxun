//
//  UITableView+Refresh.h
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionView+Refresh.h"

typedef void(^headerRefreshBlock)(int page);
typedef void(^footerRefreshBlock)(int page,BOOL isLastPage);

@interface UITableView (Refresh)

//当前是第几页
@property (nonatomic, assign)int currentPage;
//总共有多少页
@property (nonatomic, assign)int totalPage;
//是否还有更多数据
@property (nonatomic, assign)BOOL hasMore;

@property (nonatomic, copy)headerRefreshBlock headerRefreshHandle;
@property (nonatomic, copy)footerRefreshBlock footerRefreshHandle;

//是否正在刷新
@property (nonatomic, assign)BOOL isLoading;
//是不是从屏幕原点开始的  = 0的话 就是从原点开始的
@property (nonatomic, assign) CGFloat screenOrigin;
//tableView的高度
@property (nonatomic, assign) CGFloat tableViewHeightOnScreen;
//集成下拉刷新上拉加载功能
- (void)setupRefreshFunctionWith:(RefreshType)type;

//集成下拉刷新上拉加载功能 并设置颜色
- (void)setupRefreshFunctionWith:(RefreshType)type andColor:(UIColor *)color;

//下拉刷新
- (void)pullDownRefresh:(headerRefreshBlock)block;

//上拉加载
- (void)pullUpRefresh:(footerRefreshBlock)block;

//数据请求回来后结束刷新的回调  totalPage 总页数
- (void)endRefreshStatus:(int)status totalPage:(int)totalPage;
- (void)endRefreshStatus:(int)status hasMoreData:(BOOL)hasMore;

- (void)endRefreshStatus:(int)status;

@end
