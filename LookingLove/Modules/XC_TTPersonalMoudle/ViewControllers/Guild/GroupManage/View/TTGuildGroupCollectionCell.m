//
//  TTGuildGroupCollectionCell.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/9.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTGuildGroupCollectionCell.h"
#import "TTGuildGroupCollectionContentCell.h"

#import <Masonry/Masonry.h>

#import "XCMacros.h"
#import "XCTheme.h"

CGFloat const TTGuildGroupCollectionCellTopMargin = 0;//顶部边距
CGFloat const TTGuildGroupCollectionCellBottomMargin = 20;//底部边距
CGFloat const TTGuildGroupCollectionCellCVHoriInterval = 28;//cell水平间距
CGFloat const TTGuildGroupCollectionCellCVVertInterval = 20;//cell垂直间距

CGFloat const TTGuildGroupCollectionCellLenth = 42;//cell长度

static NSString * kCellID = @"kCellID";

@interface TTGuildGroupCollectionCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TTGuildGroupCollectionCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        [self updateConstraint];
    }
    return self;
}

- (void)initView {
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.separateLine];
}

- (void)updateConstraint {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView).inset(15);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataModelArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTGuildGroupCollectionContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    cell.model = self.dataModelArray[indexPath.item];
    return cell;
}

#pragma mark - getter setter
- (void)setDataModelArray:(NSArray<NSString *> *)dataModelArray {
    _dataModelArray = dataModelArray;
    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = TTGuildGroupCollectionCellCVHoriInterval;
        layout.minimumLineSpacing = TTGuildGroupCollectionCellCVVertInterval;
        layout.sectionInset = UIEdgeInsetsMake(TTGuildGroupCollectionCellTopMargin,
                                               TTGuildGroupCollectionCellCVVertInterval,
                                               TTGuildGroupCollectionCellBottomMargin,
                                               TTGuildGroupCollectionCellCVVertInterval);
        layout.itemSize = CGSizeMake(TTGuildGroupCollectionCellLenth, TTGuildGroupCollectionCellLenth);
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        view.delegate = self;
        view.dataSource = self;
        view.backgroundColor = [UIColor whiteColor];
        view.scrollEnabled = NO;
        
        [view registerClass:[TTGuildGroupCollectionContentCell class] forCellWithReuseIdentifier:kCellID];
        
        _collectionView = view;
    }
    return _collectionView;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc] init];
        _separateLine.backgroundColor = [XCTheme getLineDefaultGrayColor];
        _separateLine.hidden = YES;
    }
    return _separateLine;
}

@end

