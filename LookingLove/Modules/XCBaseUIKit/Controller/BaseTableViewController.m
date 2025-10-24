//
//  BaseTableViewController.m
//  XChat
//
//  Created by KevinWang on 2017/11/28.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "BaseTableViewController.h"
#import "XCTheme.h"
#import "XCMacros.h"
@interface BaseTableViewController ()
@property (nonatomic, weak)UITableView * targetTableView;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;//TableView 视图样式
@end

@implementation BaseTableViewController

#pragma mark - Life Cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style {
    self = [super init];
    if (self) {
        _tableViewStyle = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark -- fresh
- (void)setupRefreshTarget:(UITableView *)tableView {
    //设置tableView默认 对象为lybaseviewcontroller的tableview
    if (tableView==nil) tableView = self.tableView;
    
    self.targetTableView = tableView;
    CGFloat targetTabViewOrigin = CGRectGetMinY(self.tableView.frame);
    self.tableView.screenOrigin = targetTabViewOrigin;
    self.tableView.tableViewHeightOnScreen = tableView.tableViewHeightOnScreen;
    
    [tableView setupRefreshFunctionWith:RefreshTypeHeaderAndFooter];
    
    @KWeakify(self);
    [tableView pullUpRefresh:^(int page, BOOL isLastPage) {
        @KStrongify(self);
        [self pullUpRefresh:page lastPage:isLastPage];
    }];
    
    [tableView pullDownRefresh:^(int page) {
         @KStrongify(self);
         [self pullDownRefresh:page];
     }];
}

- (void)setupRefreshTarget:(UITableView *)tableView With:(RefreshType)type {
    //设置tableView默认 对象为lybaseviewcontroller的tableview
    if (tableView==nil) tableView = self.tableView;
    
    self.targetTableView = tableView;
    
    [tableView setupRefreshFunctionWith:type];
    
    @KWeakify(self);
    
    if (type == RefreshTypeHeader) {
        [tableView pullDownRefresh:^(int page) {
            @KStrongify(self);
            [self pullDownRefresh:page];
         }];
    } else if (type==RefreshTypeFooter) {
        [tableView pullUpRefresh:^(int page, BOOL isLastPage) {
            @KStrongify(self);
            [self pullUpRefresh:page lastPage:isLastPage];
        }];
    } else {
        [self setupRefreshTarget:tableView];
    }
}

- (void)pullDownRefresh:(int)page {
    
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    
}

//请求成功结束刷新状态
- (void)successEndRefreshStatus:(int)status totalPage:(int)totalPage {
    [self.targetTableView endRefreshStatus:status totalPage:totalPage];
}
//请求成功结束刷新状态
- (void)successEndRefreshStatus:(int)status hasMoreData:(BOOL)hasMore {
    [self.targetTableView endRefreshStatus:status hasMoreData:hasMore];
}

//请求失败结束刷新状态
- (void)failEndRefreshStatus:(int)status {
    [self.targetTableView endRefreshStatus:status];
}

#pragma mark - Setter Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) style:_tableViewStyle];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = UIColorFromRGB(0xebebeb);
        _tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    
    return _tableView;
}

@end
