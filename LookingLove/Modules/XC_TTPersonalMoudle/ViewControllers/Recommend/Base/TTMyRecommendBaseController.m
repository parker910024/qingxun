//
//  TTMyRecommendBaseController.m
//  TTPlay
//
//  Created by lee on 2019/2/12.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMyRecommendBaseController.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
// view
#import "TTRecommendBaseCell.h"
#import "UIViewController+EmptyDataView.h"
#import "TTWKWebViewViewController.h"
// tools
#import "XCHtmlUrl.h"

@interface TTMyRecommendBaseController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TTMyRecommendBaseController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddCoreClient(RecommendClient, self);
    
    [self initConstraints];
    [self setupTableView];
    
}

- (void)setupTableView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 141;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[TTRecommendBaseCell class] forCellReuseIdentifier:kTTRecommendBaseCellConst];
    self.tableView.tableViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.tableView];
    [self pullDownRefresh:1];
}
- (TTRecommendCellStyle)style {
    return TTRecommendCellStyleUndefined;
}

- (void)pullDownRefresh:(int)page {
    
    [GetCore(RecommendCore) getMyRecommendCarState:(RecommendState)[self style] page:1 state:0];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    if (isLastPage) {
        NSLog(@"已经最后一页了");
        return;
    }
    [GetCore(RecommendCore) getMyRecommendCarState:(RecommendState)[self style] page:page state:1];
}

- (void)onRecommendMyRecommendState:(RecommendState)status page:(int)page state:(int)state list:(NSArray<RecommendModel *> *)list {

    // 结束刷新
    [self.tableView endRefreshStatus:0];
    [self.tableView endRefreshStatus:1];
    // 如果类型不一致，就直接返回，不然导致数据错乱
    if ((TTRecommendCellStyle)status != [self style]) {
        return;
    }
    if (page == 1) {
        [self.dataArray removeAllObjects];
        if (!list.count) {
            [self.tableView reloadData];
            [self showEmptyDataViewWithTitle:@"暂无数据" image:[UIImage imageNamed:@"common_noData_empty"]];
            [self showEmptyDataViewWithTitle:@"暂无数据"];
            [self successEndRefreshStatus:state hasMoreData:NO];
            return;
        }
        self.dataArray = list.mutableCopy;
        
    }else {
        [self.dataArray addObjectsFromArray:list];
    }
    if (list.count >= 10) {
        [self successEndRefreshStatus:0 hasMoreData:YES];
    }else {
        [self successEndRefreshStatus:0 hasMoreData:NO];
    }
    [self removeEmptyDataView];
    [self.tableView reloadData];
}

- (void)onRecommendMyRecommendFailthState:(RecommendState)state page:(int)page{
    if ((TTRecommendCellStyle)state != [self style]) {
        return;
    }
    if (page == 1) {
        [self  showEmptyDataViewWithTitle:@"暂无数据" image:[UIImage imageNamed:@"common_noData_empty"]];
    }
}


#pragma mark -
#pragma mark tableView delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
//    return 10 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTRecommendBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:kTTRecommendBaseCellConst];
    if (self.dataArray.count > indexPath.row) {
        RecommendModel *model = self.dataArray[indexPath.row];
        cell.cellStyle = (TTRecommendCellStyle)model.status;
        cell.model = model;
    }
    cell.recommendCellBtnClickHandler = ^(RecommendModel * _Nonnull model) {
        if (model.status != RecommendState_Unuse) {
            return ;
        }
        
        // 判断如何进入当前页面的。
        __block BOOL isFromRecommedVc = NO;
        
        [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[TTWKWebViewViewController class]]) {
                isFromRecommedVc = YES;
                *stop = YES;
            }
        }];
        
        // 如果是从上级页面过来的
        if (isFromRecommedVc) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc] init];
            vc.urlString = HtmlUrlKey(kRecommendCardURL);
            @weakify(self);
            vc.notifyRefreshHandler = ^(WebViewNotifyAppActionStatusType statusType) {
                @strongify(self);
                [self pullDownRefresh:1];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark lifeCycle

- (void)initConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter
- (NSMutableArray<RecommendModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

@end
