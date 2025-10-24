//
//  TTFamilyListViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/1.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyListViewController.h"
//view
#import "TTSquareTableViewCell.h"
//core
#import "FamilyCore.h"
#import "FamilyCoreClient.h"
//tool
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "NSArray+Safe.h"
#import "UIView+XCToast.h"
#import "XCMacros.h"
//vc
#import "TTFamilySearchViewController.h"
#import "TTFamilyPersonViewController.h"

@interface TTFamilyListViewController ()<UITableViewDelegate, UITableViewDataSource, FamilyCoreClient>
@property (nonatomic, strong) NSArray * familyArray;
@end

@implementation TTFamilyListViewController
#pragma mark - life cycle
- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
    [self initView];
    [self initContrations];
}

- (void)initView{
    [self addNavigationItemWithImageNames:@[@"family_search"] isLeft:NO target:self action:@selector(searchFamilyAcion:) tags:nil];
    self.title = @"家族列表";
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[TTSquareTableViewCell class] forCellReuseIdentifier:@"TTSquareTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefreshTarget:self.tableView With:RefreshTypeHeader];
    [self pullDownRefresh:1];
}

- (void)initContrations{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusbarHeight + 44);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

- (void)addCore{
    AddCoreClient(FamilyCoreClient, self);
}

#pragma mark - response
- (void)searchFamilyAcion:(UIButton *)sender{
    TTFamilySearchViewController * seachVC = [[TTFamilySearchViewController alloc] init];
    seachVC.searchType = TTFamilySearchType_Family;
    seachVC.currentNav = self.navigationController;
    [self.navigationController presentViewController:seachVC animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate  and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.familyArray.count > 0) {
        return self.familyArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTSquareTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTSquareTableViewCell"];
    if (cell == nil) {
        cell = [[TTSquareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTSquareTableViewCell"];
    }
    cell.isFamilyList = YES;
    cell.indexPath = indexPath;
    XCFamilyModel * preFamilyModel;
    XCFamilyModel * nowFamilyModel;
    nowFamilyModel = [self.familyArray safeObjectAtIndex:indexPath.row];
    if (indexPath.row > 0) {
        preFamilyModel = [self.familyArray safeObjectAtIndex:indexPath.row -1];
        nowFamilyModel.gapNumber = preFamilyModel.familyCharm - nowFamilyModel.familyCharm;
    }
    [cell configTTSquareTableViewCellWith:[self.familyArray safeObjectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.familyArray.count > 0) {
        TTFamilyPersonViewController * familyPersnVC = [[TTFamilyPersonViewController alloc] init];
        XCFamilyModel * family = [self.familyArray safeObjectAtIndex:indexPath.row];
        familyPersnVC.familyId =family.id;
        [self.navigationController pushViewController:familyPersnVC animated:YES];
    }
}


#pragma mark - FamilyCoreClinet
- (void)getTolalCharmFamilyListSuccess:(int)status family:(XCFamily *)family{
    self.familyArray = family.familys;
    if (self.familyArray.count <= 0) {
        [self.tableView showEmptyContentToastWithTitle:@"暂时还没有家族" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
    }
    [self successEndRefreshStatus:0 hasMoreData:NO];
    [self.tableView reloadData];
}
- (void)getTolalCharmFamilyListFail:(int)staus andMessage:(NSString *)message{
    [self failEndRefreshStatus:0];
}

#pragma mark - http
- (void)pullDownRefresh:(int)page{
    [GetCore(FamilyCore) getCharmFamilyList:2 page:1 pageSize:40 status:0];
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
