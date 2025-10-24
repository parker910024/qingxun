//
//  TTMineBaseDressUpViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMineBaseDressUpViewController.h"
//view
#import "TTMineDressUpCell.h"
//core
//cate
#import "NSArray+Safe.h"
//t
#import "XCTheme.h"
#import "CoreManager.h"
#import "XCMacros.h"
#import <Masonry/Masonry.h>
@interface TTMineBaseDressUpViewController ()

@end

@implementation TTMineBaseDressUpViewController

#pragma mark - life cycle
- (void)dealloc {
    RemoveCoreClient(UserCoreClient, self);
    RemoveCoreClient(TTDressUpUIClient, self);

}

- (void)zj_viewWillAppearForIndex:(NSInteger)index{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AddCoreClient(UserCoreClient, self);
    AddCoreClient(TTDressUpUIClient, self);
    
    self.tableView.rowHeight = 120;
    [self.tableView registerClass:[TTMineDressUpCell class] forCellReuseIdentifier:@"TTMineDressUpCell"];
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64+statusbarHeight+kSafeAreaBottomHeight)];
    self.tableView.tableFooterView = [UIView new];
    AddCoreClient(UserCoreClient, self);
    
    // 底部会被挡住
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.mas_equalTo(self.view);
        }
    }];
    
}

#pragma mark - UITablewViewDelegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTMineDressUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTMineDressUpCell" forIndexPath:indexPath];
    if (!cell) {
        cell  =[[TTMineDressUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTMineDressUpCell"];
    }
    cell.model = [self.data safeObjectAtIndex:indexPath.row];
    return cell;
}

- (void)reloadData {
    
}

@end
