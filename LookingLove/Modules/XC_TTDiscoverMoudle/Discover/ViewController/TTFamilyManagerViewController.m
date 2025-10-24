//
//  TTFamilyManagerViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyManagerViewController.h"
#import "TTFamilyInforViewController.h"
#import "TTFamilyMonViewController.h"
#import "TTFamilyMemberViewController.h"
#import <Masonry/Masonry.h>
#import "TTFamilyManagerTableViewCell.h"
#import "NSArray+Safe.h"
#import "XCTheme.h"
#import "XCMacros.h"

@interface TTFamilyManagerViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TTFamilyManagerViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initContrations];
}
#pragma mark - lif
- (void)initView{
    self.title = @"家族管理";
    self.tableView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    [self.tableView registerClass:[TTFamilyManagerTableViewCell class] forCellReuseIdentifier:@"TTFamilyManagerTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initContrations{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusbarHeight + 44);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.familyInfor.openMoney) {
        return  3;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTFamilyManagerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTFamilyManagerTableViewCell"];
    if (cell == nil) {
        cell = [[TTFamilyManagerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TTFamilyManagerTableViewCell"];
    }
    NSArray * imageArray;
    NSArray * titleArray;
    if (self.familyInfor.openMoney) {
        imageArray = @[@"family_manager_money", @"family_manager_member", @"family_manager_infor"];
        titleArray = @[@"家族币管理", @"成员管理", @"家族信息"];
    }else{
        imageArray = @[@"family_manager_member", @"family_manager_infor"];
        titleArray = @[@"成员管理", @"家族信息"];
    }
    cell.imageNameString = [imageArray safeObjectAtIndex:indexPath.row];
    cell.titleString = [titleArray safeObjectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TTFamilyManagerTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.familyInfor.openMoney) {
        if (indexPath.row == 0) {
            TTFamilyMonViewController * familyMonVc = [[TTFamilyMonViewController alloc] init];
            familyMonVc.ownerType = FamilyMoneyOwnerManager;
            [self.navigationController pushViewController:familyMonVc animated:YES];
        }else if (indexPath.row == 1){
            TTFamilyMemberViewController * memberVC = [[TTFamilyMemberViewController alloc] init];
            memberVC.listType = FamilyMemberListFamilyRemove;
            [self.navigationController pushViewController:memberVC animated:YES];
        }else{
            TTFamilyInforViewController * infor = [[TTFamilyInforViewController alloc] init];
            [self.navigationController pushViewController:infor animated:YES];
        }
    }else{
        if (indexPath.row == 0){
            TTFamilyMemberViewController * memberVC = [[TTFamilyMemberViewController alloc] init];
            memberVC.listType = FamilyMemberListFamilyRemove;
            [self.navigationController pushViewController:memberVC animated:YES];
        }else{
            TTFamilyInforViewController * infor = [[TTFamilyInforViewController alloc] init];
            [self.navigationController pushViewController:infor animated:YES];
        }
    }
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
