//
//  TTMagicCell.m
//  TuTu
//
//  Created by lee on 2018/11/1.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMineInfoMagicCell.h"
#import "TTMineInfoGiftCell.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "NSArray+Safe.h"

@interface TTMineInfoMagicCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView  *collectionView;//
@property (nonatomic, strong) UILabel  *noMagicTip;//
@property (nonatomic, strong) UIView  *titleLineView;//标题线
@property (nonatomic, strong) UILabel  *giftCountLabel;//数量
@property (nonatomic, strong) UILabel  *titleLabel;//标题

@end

@implementation TTMineInfoMagicCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    [self addSubview:self.collectionView];
    [self addSubview:self.noMagicTip];
    [self addSubview:self.titleLineView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
    [self.noMagicTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.titleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.right.left.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
}

#pragma mark - CollectionViewDelegate && DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isCarrot) {
        return self.carrotGiftList.count;
    }
    return self.userMagicList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTMineInfoGiftCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTMineInfoGiftCell class]) forIndexPath:indexPath];
    if (self.carrotGiftList.count > indexPath.item && self.isCarrot) {
        cell.isCarrot = YES;
        [cell configCellModel:self.carrotGiftList[indexPath.item]];
    } else if (self.userMagicList.count > indexPath.item) {
        [cell configCellModel:self.userMagicList[indexPath.item]];
    }
    return cell;
}

#pragma mark - Getter && Setter
- (void)setUserMagicList:(NSArray *)userMagicList {
    _userMagicList = userMagicList;
    self.noMagicTip.hidden = _userMagicList.count;
    
    [self.collectionView reloadData];
}

- (void)setCarrotGiftList:(NSArray *)carrotGiftList {
    _carrotGiftList = carrotGiftList;
    self.noMagicTip.hidden = carrotGiftList.count;
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 10.f;
        flowLayout.itemSize = CGSizeMake(75.f, 120.f);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[TTMineInfoGiftCell class] forCellWithReuseIdentifier:NSStringFromClass([TTMineInfoGiftCell class])];
    }
    return _collectionView;
}

- (UILabel *)noMagicTip {
    if (!_noMagicTip) {
        _noMagicTip = [[UILabel alloc] init];
        _noMagicTip.text = @"还没有被施展魔法哦！";
        _noMagicTip.font = [UIFont systemFontOfSize:14];
        _noMagicTip.textAlignment = NSTextAlignmentCenter;
        _noMagicTip.textColor = UIColorFromRGB(0x999999);
    }
    return _noMagicTip;
}

- (UIView *)titleLineView {
    if (!_titleLineView) {
        _titleLineView = [[UILabel alloc] init];
        _titleLineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    }
    return _titleLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"被施展魔法";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = UIColorFromRGB(0x999999);
    }
    return  _titleLabel;
}

- (UILabel *)giftCountLabel {
    if (!_giftCountLabel) {
        _giftCountLabel = [[UILabel alloc] init];
        _giftCountLabel.text = @"(0)";
        _giftCountLabel.textColor = UIColorFromRGB(0x999999);
        _giftCountLabel.font = [UIFont systemFontOfSize:14];
    }
    return _giftCountLabel;
}


@end
