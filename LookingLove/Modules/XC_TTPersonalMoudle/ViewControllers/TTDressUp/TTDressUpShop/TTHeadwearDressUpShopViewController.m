//
//  TTHeadwearDressUpViewController.m
//  TuTu
//
//  Created by Macx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTHeadwearDressUpShopViewController.h"

#import "TTHeadwearDressUpCell.h"

//core
#import "HeadWearCore.h"
#import "UserCoreClient.h"
#import "TTDressUpUIClient.h"
//cate
#import "NSArray+Safe.h"
#import "UIView+XCToast.h"
//t
#import "XCMacros.h"
#import "CoreManager.h"
#import "XCTheme.h"

#define kItemWidth (KScreenWidth - 58) / 3
#define kItemHeight (kItemWidth - 8 * 2) + 51 //

@interface TTHeadwearDressUpShopViewController()
@property (nonatomic, strong) UserHeadWear *currentSelectHeadwear;//当前选择的头饰
@end

@implementation TTHeadwearDressUpShopViewController



- (void)zj_viewDidAppearForIndex:(NSInteger)index {
    if(self.currentSelectHeadwear) {
        NotifyCoreClient(TTDressUpUIClient, @selector(shopSelectHeadwear:), shopSelectHeadwear:self.currentSelectHeadwear);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[TTHeadwearDressUpCell class] forCellWithReuseIdentifier:@"TTHeadwearDressUpCell"];
}


#pragma mark - SystemDelegate

#pragma mark - CollectionView Delegate && DataSource

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTHeadwearDressUpCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTHeadwearDressUpCell" forIndexPath:indexPath];
    cell.headwear = [self.data safeObjectAtIndex:indexPath.item];
    if (self.currentSelectIndex == indexPath.item) {
        cell.isSelect = YES;
    }else {
        cell.isSelect = NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    UserHeadWear *headwear = [self.data safeObjectAtIndex:indexPath.item];
    if (self.currentSelectHeadwear == headwear) {
        return;
    }
    self.currentSelectHeadwear = headwear;
    NotifyCoreClient(TTDressUpUIClient, @selector(shopSelectHeadwear:), shopSelectHeadwear:self.currentSelectHeadwear);

    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(floorf(kItemWidth), kItemHeight);
}

#pragma mark - Core Client

//获取头饰商城成功
- (void)onGetHeadWearListSuccess:(NSArray *)list state:(int)state {
    
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
//获取头饰商城列表失败
- (void)onGetHeadwearListFailth:(NSString *)message {
    
}

#pragma mark - Event
- (void)pullDownRefresh:(int)page {
    [super pullDownRefresh:page];
    [GetCore(HeadWearCore) requestHeadwearListByPage:@"1" pageSize:@"20" state:0 uid:self.userID];
}

- (void)pullUpRefresh:(int)page lastPage:(BOOL)isLastPage {
    [super pullUpRefresh:page lastPage:isLastPage];
    [GetCore(HeadWearCore) requestHeadwearListByPage:[NSString stringWithFormat:@"%d",page] pageSize:@"20" state:1 uid:self.userID];
}


@end
