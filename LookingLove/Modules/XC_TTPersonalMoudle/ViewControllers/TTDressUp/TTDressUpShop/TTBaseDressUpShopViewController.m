//
//  TTBaseDressShopViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTBaseDressUpShopViewController.h"

#import "XCTheme.h"
#import "CoreManager.h"
#import "XCMacros.h"
#import <Masonry/Masonry.h>
//core
#import "UserCoreClient.h"


@interface TTBaseDressUpShopViewController ()
@end

@implementation TTBaseDressUpShopViewController

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (BOOL)isHiddenNavBar {
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    AddCoreClient(UserCoreClient, self);
    //解决UICollectionView+MJRefreshAutoManager判断问题，默认使用屏幕判断如果collectionview不是全屏的下拉不能加载更多
    self.collectionView.collectionViewHeightOnScreen = 1;
    [self setupRefreshTarget:self.collectionView];
    
    [self pullDownRefresh:1];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    self.collectionView.backgroundColor = UIColorFromRGB(0xffffff);

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
//            make.edges.mas_equalTo(self.view.mas_safeAreaLayoutGuide);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.mas_equalTo(self.view);
        }
    }];

}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}


#pragma mark - UICollectionViewDataSource


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UITabBarController *vc = self.tabBarController;
    CGFloat tabBarHeight = vc.tabBar.frame.size.height;
    CGFloat navHeight = [(UINavigationController *)vc.viewControllers.firstObject navigationBar].frame.size.height;
    return UIEdgeInsetsMake(10, 10, tabBarHeight+statusbarHeight+navHeight+24+52+50+24, 10);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 14;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.currentSelectIndex = indexPath.item;
}


#pragma mark -

- (void)pullDownRefresh:(int)page {
    [self.data removeAllObjects];
    self.currentPage = 1;
}


- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    self.currentPage = page;
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
