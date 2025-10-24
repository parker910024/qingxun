//
//  TTUserCardInfoFunctionContentView.m
//  TuTu
//
//  Created by 卫明 on 2018/11/16.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTUserCardInfoFunctionContentView.h"

//cell
#import "TTUserCardFunctionView.h"

//tool
#import "NSMutableArray+Safe.h"
#import "NSArray+Safe.h"

//const
#import "XCMacros.h"

//mas-
#import <Masonry/Masonry.h>

@interface TTUserCardInfoFunctionContentView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic,assign) UserID uid;
@end

@implementation TTUserCardInfoFunctionContentView

- (instancetype)initWithFrame:(CGRect)frame actionUid:(UserID)uid {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
        self.uid = uid;
    }
    return self;
}

- (void)initView {
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[TTUserCardFunctionView class] forCellWithReuseIdentifier:@"TTUserCardFunctionView"];
    
}

- (void)initConstrations {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.functionItem.count > 0) {
        TTUserCardFunctionItem *item = [self.functionItem safeObjectAtIndex:indexPath.row];
        if (item.actionBolock) {
            item.actionBolock(self.uid, indexPath, item);
        }
        
        if (item.actionUserBlock) {
            item.actionUserBlock(self.currentUserInfo, indexPath, item);
        }
        
        if ([self.delegate respondsToSelector:@selector(onUserFunctionCard:didselected:function:)]) {
            [self.delegate onUserFunctionCard:self didselected:indexPath function:[self.functionItem safeObjectAtIndex:indexPath.row]];
        }
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.frame.size.width / 4, 80);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.functionItem.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTUserCardFunctionView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTUserCardFunctionView" forIndexPath:indexPath];
    [cell setItem:[self.functionItem safeObjectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark - private method

#pragma mark - setter & getter

- (void)setFunctionItem:(NSMutableArray *)functionItem {
    _functionItem = functionItem;
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

@end
