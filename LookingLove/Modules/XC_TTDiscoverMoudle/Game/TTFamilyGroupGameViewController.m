//
//  TTFamilyGroupGameViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/20.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyGroupGameViewController.h"
//core
#import "FamilyCore.h"
#import "FamilyCoreClient.h"
#import "XCFamilyModel.h"
//tool
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIView+XCToast.h"
#import "XCMacros.h"
//view
#import "TTNewUserCollectionViewCell.h"
#import "TTWKWebViewViewController.h"


@interface TTFamilyGroupGameViewController ()<UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray<XCFamilyModel *> * gameArray;
@end

@implementation TTFamilyGroupGameViewController
- (void)dealloc{
    RemoveCoreClientAll(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
#pragma mark - life cycle
- (void)initView{
    self.title = @"家族游戏";
    [self.collectionView registerClass:[TTNewUserCollectionViewCell class] forCellWithReuseIdentifier:@"TTNewUserCollectionViewCell"];
    AddCoreClient(FamilyCoreClient, self);
    [GetCore(FamilyCore) requestGameListByFamilyId:self.familyId];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusbarHeight + 44);
        make.right.left.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - FamilyCoreClient
- (void)getFamilyGameListSuccess:(NSArray<XCFamilyModel *> *)familyGames familyId:(NSInteger)familyId {
    if (familyId == self.familyId) {
        self.gameArray = [familyGames mutableCopy];
    }
    if (self.gameArray.count == 0) {
        [self.collectionView showEmptyContentToastWithTitle:@"暂无游戏" andImage:[UIImage imageNamed:[[XCTheme defaultTheme] default_empty]]];
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.gameArray.count > 0) {
        XCFamilyModel *model = self.gameArray[indexPath.row];
        TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
        vc.url = [NSURL URLWithString:model.link];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTNewUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTNewUserCollectionViewCell" forIndexPath:indexPath];
    XCFamilyModel *model = self.gameArray[indexPath.row];
    [cell configTTFamilyGameCellWith:model];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gameArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(70, 90);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return (KScreenWidth - 30 - 70 * 4)/ 3;
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
