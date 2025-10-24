//
//  TTCarDressUpShopViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTCarDressUpShopViewController.h"
#import "TTCarDressUpCell.h"
//model
#import "UserCar.h"
//core
#import "CarCore.h"
#import "UserCoreClient.h"
#import "TTDressUpUIClient.h"
//cate
#import "NSArray+Safe.h"
#import "UIView+XCToast.h"
//t
#import "XCMacros.h"
#import "CoreManager.h"
#import "XCTheme.h"

#define kItemWidth floorf((KScreenWidth - 45)) / 2
#define kItemHeight ((kItemWidth - 8 * 2) / 3) * 2 + 51 //

@interface TTCarDressUpShopViewController()
@property (nonatomic, strong) UserCar  *currentSelectCar;//
@end

@implementation TTCarDressUpShopViewController



- (void)zj_viewDidAppearForIndex:(NSInteger)index {
    if(self.currentSelectCar) {
        NotifyCoreClient(TTDressUpUIClient, @selector(shopSelectCar:), shopSelectCar:self.currentSelectCar);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[TTCarDressUpCell class] forCellWithReuseIdentifier:@"TTCarDressUpCell"];
}

#pragma mark - System Delegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 0, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    UserCar *car = [self.data safeObjectAtIndex:indexPath.item];
    if (self.currentSelectCar == car) {
        return;
    }
    self.currentSelectCar = car;
    NotifyCoreClient(TTDressUpUIClient, @selector(shopSelectCar:), shopSelectCar:self.currentSelectCar);
    [self.collectionView reloadData];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kItemWidth, kItemHeight);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TTCarDressUpCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTCarDressUpCell" forIndexPath:indexPath];
    [cell setCar:[self.data safeObjectAtIndex:indexPath.item]];
    if (self.currentSelectIndex == indexPath.item) {
        cell.isSelected = YES;
    }else {
        cell.isSelected = NO;
    }
    return cell;
}


#pragma mark - Custom Delegate

#pragma mark - Core Client

//获取商城座驾列表成功
- (void)onGetCarListSuccess:(NSArray *)list state:(int)state {
    
    BOOL isNeedSelectFirst = NO;
    if (list.count == 0) {
        if (state == 0) {
            [self.collectionView showEmptyContentToastWithTitle:@"没有数据" andImage:[UIImage imageNamed:[XCTheme defaultTheme].default_empty]];
        }
        [self successEndRefreshStatus:state hasMoreData:NO];
    }else {
        [self.collectionView hideToastView];
        if (state == 0) {
            self.data = [list mutableCopy];
            //默认选择第一个
            isNeedSelectFirst = YES;
        }else {
            [self.data addObjectsFromArray:list];
        }
        [self successEndRefreshStatus:state hasMoreData:YES];
    }
    [self.collectionView reloadData];
    if (isNeedSelectFirst) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexpath];
    }
}
//获取商城座驾列表失败
- (void)onGetCarListFailth:(NSString *)message {
    
}

#pragma mark - Event
- (void)pullDownRefresh:(int)page {
    [super pullDownRefresh:page];
    [GetCore(CarCore)requestCarListByPage:@"1" pageSize:@"20" state:0];
}
- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    [super pullUpRefresh:page lastPage:isLastPage];
    [GetCore(CarCore)requestCarListByPage:[NSString stringWithFormat:@"%d",page] pageSize:@"20" state:1];
    
}


@end
