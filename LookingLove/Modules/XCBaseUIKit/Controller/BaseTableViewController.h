//
//  BaseTableViewController.h
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "BaseUIViewController.h"
#import "UITableView+Refresh.h"

@interface BaseTableViewController : BaseUIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/**
 初始化 TableView 视图样式
 
 @discussion 使用 [init] 方法初始化时，默认为 UITableViewStylePlain 样式
 @param style 视图样式
 @return 控制器实例
 */
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style;

/***集成头部刷新和底部刷新
 @param tableView 要集成刷新的对象 tableview
 ***/
- (void)setupRefreshTarget:(UITableView*)tableView;

/**
 根据集成类型集成刷新
 @param type 集成的类型
 @param tableView 要集成刷新的对象 tableview
 HHRefreshTypeHeader 只有头
 HHRefreshTypeFooter 只有底部
 HHRefreshTypeHeaderAndFooter 有头也有底部
 */
- (void)setupRefreshTarget:(UITableView*)tableView With:(RefreshType)type;
/**
 下拉刷新的回调 子类需要重写
 @param page 当前请求的页数
 */
- (void)pullDownRefresh:(int)page;

/**
 上拉刷新的回掉  子类需要重写
 @param page   当前请求的页数
 @param isLastPage yes:已经到了最后一页 NO：还没到
 */
- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage;

//刷新成功的回调方法中调用这个方法 status:0结束头部刷新,1 结束底部刷新;  totalPage: 总页数
- (void)successEndRefreshStatus:(int)status totalPage:(int)totalPage;
- (void)successEndRefreshStatus:(int)status hasMoreData:(BOOL)hasMore;
//刷新失败的回调方法中调用这个方法 status:0结束头部刷新 1 结束底部刷新
- (void)failEndRefreshStatus:(int)status;
@end
