//
//  TTSessionListHeadView.m
//  TuTu
//
//  Created by lee on 2018/12/28.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTSessionListHeadView.h"

#import "TTSessionListHeaderCell.h"

#import "MentoringGrabModel.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

@interface TTSessionListHeadView ()<UICollectionViewDataSource, UICollectionViewDelegate>
/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TTSessionListHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.grabModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTSessionListHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTSessionListHeaderCell class]) forIndexPath:indexPath];
    cell.model = self.grabModels[indexPath.row];
    @KWeakify(self);
    cell.goButtonDidClickAction = ^(long long uid) {
        @KStrongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(sessionListHeadView:didClickGoButtonWithUid:)]) {
            [self.delegate sessionListHeadView:self didClickGoButtonWithUid:uid];
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - private method
- (void)initView {
    self.backgroundColor = RGBCOLOR(246, 247, 249);
    [self addSubview:self.collectionView];
}

- (void)initContrations {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.top.mas_equalTo(10);
    }];
}

#pragma mark - setters and getters
- (void)setGrabModels:(NSMutableArray<MentoringGrabModel *> *)grabModels {
    _grabModels = grabModels;
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        layout.itemSize = CGSizeMake(160, 130);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[TTSessionListHeaderCell class] forCellWithReuseIdentifier:NSStringFromClass([TTSessionListHeaderCell class])];
    }
    return _collectionView;
}

@end
