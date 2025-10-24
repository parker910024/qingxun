//
//  TTDiscoverRookieViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/1.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDiscoverRookieViewController.h"
#import "TTNewUserCollectionViewCell.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import "XCHUDTool.h"
//Core
#import "DiscoveryCore.h"
#import "DiscoveryCoreClient.h"
//bridge
#import "XCMediator+TTPersonalMoudleBridge.h"

@interface TTDiscoverRookieViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DiscoveryCoreClient>
@property (nonatomic, strong) NSMutableArray<UserInfo *> * rookieArray;
@property (nonatomic, assign) int currentpage;
@end

@implementation TTDiscoverRookieViewController

#pragma Mark- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCore];
    [self initView];
    [self initContrations];
}
#pragma mark - private method
- (void)initView{
    self.title = @"新人驾到";
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewHeightOnScreen = 1;
    [self.collectionView registerClass:[TTNewUserCollectionViewCell class] forCellWithReuseIdentifier:@"TTNewUserCollectionViewCell"];
    [self setupRefreshTarget:self.collectionView];
    [self pullDownRefresh:1];
}

- (void)initContrations{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(statusbarHeight + 44);
    }];
}

- (void)addCore{
    AddCoreClient(DiscoveryCoreClient, self);
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.rookieArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth - 45) / 3, (KScreenWidth - 68 -40) / 3 + 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 20, 34,20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 25;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TTNewUserCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTNewUserCollectionViewCell" forIndexPath:indexPath];
    cell.isShowID = YES;
    [cell configTTNewUserCollectionViewCell:[self.rookieArray safeObjectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UserInfo * infor = [self.rookieArray safeObjectAtIndex:indexPath.row];
    UIViewController * controller = [[XCMediator sharedInstance] ttPersonalModule_personalViewController:infor.uid];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - DiscoveryCoreClient
- (void)hhDiscoverNewUserListSuccess:(NSArray<UserInfo *> *)userList status:(int)status isTotal:(BOOL)isTotal{
    if (isTotal) {
        if (self.currentpage == 1) {
            [self.rookieArray removeAllObjects];
        }
        if (userList.count > 0) {
            if (status) {
                [self.rookieArray addObjectsFromArray:userList];
            }else{
                self.rookieArray = [userList mutableCopy];
            }
            [self successEndRefreshStatus:status hasMoreData:YES];
        }else{
            [self successEndRefreshStatus:status hasMoreData:NO];
        }
        [XCHUDTool hideHUDInView:self.view];
        if (self.rookieArray.count ==0) {
//            [self.collectionView showEmptyContentToastWithTitle:@"还没有新秀玩友" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
        }
        [self.collectionView reloadData];
    }
}

- (void)hhDiscoverNewUserListFail:(NSString *)message status:(int)status isTotal:(BOOL)isTotal{
    if (isTotal) {
        [self failEndRefreshStatus:status];
    }
}

#pragma mark - http
- (void)pullDownRefresh:(int)page{
    self.currentpage = page;
    [GetCore(DiscoveryCore) getNewUserListWith:page pageSize:20 status:0 isTotal:YES];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage{
    if (isLastPage) {
        return;
    }
    self.currentpage = page;
    [GetCore(DiscoveryCore) getNewUserListWith:page pageSize:20 status:1 isTotal:YES];
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
