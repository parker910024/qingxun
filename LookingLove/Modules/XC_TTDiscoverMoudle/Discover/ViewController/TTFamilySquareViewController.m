//
//  TTFamilySquareViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/1.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilySquareViewController.h"
//View
#import "TTSquareTableViewCell.h"
#import "TTFamilySquareHeaderView.h"
#import "TTFamilyEmptyTableViewCell.h"
//VC
#import "TTFamilyListViewController.h"
#import "TTFamilyPersonViewController.h"
#import "TTFamilySearchViewController.h"
//core
#import "FamilyCore.h"
#import "FamilyCoreClient.h"
//tool
#import <Masonry/Masonry.h>
#import "NSArray+Safe.h"
#import "XCTheme.h"
#import "XCMacros.h"

@interface TTFamilySquareViewController ()<
UITableViewDelegate,
UITableViewDataSource,
FamilyCoreClient,
TTSquareTableViewCellDelegate>

@property (nonatomic, strong) NSArray * familyArray;
@property (nonatomic, assign) NSInteger totalFamilyNumber;
/** 头部的view*/
@property (nonatomic, strong) TTFamilySquareHeaderView * headerView;


@end

@implementation TTFamilySquareViewController
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

#pragma mark - response
- (void)searchFamilyAcion:(UIButton*)sender{
    TTFamilySearchViewController * seachVC = [[TTFamilySearchViewController alloc] init];
    seachVC.searchType = TTFamilySearchType_Family;
    seachVC.currentNav = self.navigationController;
    seachVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:seachVC animated:YES completion:nil];
}

#pragma mark - private method
- (void)initView{
     [self addNavigationItemWithImageNames:@[@"family_search"] isLeft:NO target:self action:@selector(searchFamilyAcion:) tags:nil];
    self.title = @"家族广场";
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[TTSquareTableViewCell class] forCellReuseIdentifier:@"TTSquareTableViewCell"];
    [self.tableView registerClass:[TTFamilyEmptyTableViewCell class] forCellReuseIdentifier:@"TTFamilyEmptyTableViewCell"];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefreshTarget:self.tableView With:RefreshTypeHeader];
    [self pullDownRefresh:1];
}

- (void)initContrations{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(statusbarHeight + 44);
    }];
}

- (void)addCore{
    AddCoreClient(FamilyCoreClient, self);
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.familyArray.count > 0) {
        if (self.familyArray.count > 6) {
            return 6;
        }
        return self.familyArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.familyArray.count > 0) {
        if (self.totalFamilyNumber > 6) {
            if (indexPath.row == 5) {
                return 75+54;
            }
            return 75;
        }else{
            return 75;
        }
    }else{
        return KScreenHeight - 258 - kSafeAreaTopHeight - kSafeAreaBottomHeight - 64;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.familyArray.count > 0) {
        TTSquareTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTSquareTableViewCell"];
        if (cell == nil) {
            cell = [[TTSquareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTSquareTableViewCell"];
        }
        cell.totalFamily = self.totalFamilyNumber;
        cell.indexPath = indexPath;
        cell.delegate = self;
        XCFamilyModel * preFamilyModel;
        XCFamilyModel * nowFamilyModel;
        nowFamilyModel = [self.familyArray safeObjectAtIndex:indexPath.row];
        if (indexPath.row > 0) {
            preFamilyModel = [self.familyArray safeObjectAtIndex:indexPath.row -1];
            nowFamilyModel.gapNumber = preFamilyModel.familyCharm - nowFamilyModel.familyCharm;
        }
        [cell configTTSquareTableViewCellWith:[self.familyArray safeObjectAtIndex:indexPath.row]];
        return cell;
    }else{
        TTFamilyEmptyTableViewCell * emptyCell = [tableView dequeueReusableCellWithIdentifier:@"TTFamilyEmptyTableViewCell"];
        if (emptyCell == nil) {
            emptyCell = [[TTFamilyEmptyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyEmptyTableViewCell"];
        }
        emptyCell.iconImageView.image = [UIImage imageNamed:[[XCTheme defaultTheme] default_empty]];
        emptyCell.titleLabel.text = @"暂时还没有家族";
        return emptyCell;
    }
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


#pragma mark - TTSquareTableViewCellDelegate
- (void)squareCellMoreButtonAction:(UIButton *)sender{
    TTFamilyListViewController * familylistVC = [[TTFamilyListViewController alloc] init];
    [self.navigationController pushViewController:familylistVC animated:YES];
}

#pragma mark - FamilyCoreClient
- (void)getTolalCharmFamilyListSuccess:(int)status family:(XCFamily *)family{
        self.familyArray = family.familys;
    self.totalFamilyNumber = [family.count integerValue];
    [self successEndRefreshStatus:0 hasMoreData:NO];
    [self.tableView reloadData];
}

- (void)getTolalCharmFamilyListFail:(int)staus andMessage:(NSString *)message{
    [self failEndRefreshStatus:0];
}

#pragma mark - http
- (void)pullDownRefresh:(int)page{
    [GetCore(FamilyCore) getCharmFamilyList:2 page:1 pageSize:10 status:0];
}

#pragma mark- setters and getters
- (TTFamilySquareHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TTFamilySquareHeaderView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 258)];
    }
    return _headerView;
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
