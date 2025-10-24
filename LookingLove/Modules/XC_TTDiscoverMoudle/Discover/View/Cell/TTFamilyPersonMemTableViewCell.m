//
//  TTFamilyPersonMemTableViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyPersonMemTableViewCell.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "NSArray+Safe.h"
#import "TTPersonGameCollectionViewCell.h"
#import "XCMacros.h"

@interface TTFamilyPersonMemTableViewCell()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>
/** 家族成员*/
@property (nonatomic, strong) NSArray * memberArray;
@property (nonatomic, strong) UICollectionView * collectionView;
@end

@implementation TTFamilyPersonMemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - public method
- (void)configTTFamilyPersonMemTableViewCellWith:(NSArray<XCFamilyModel *> *)memberarray{
    self.memberArray = memberarray;
    [self.collectionView reloadData];
}

#pragma mark - private method
- (void)initView{
    [self.contentView addSubview:self.collectionView];
}

- (void)initContrations{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.memberArray.count > 0? 1:0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.memberArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(50, 70);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(13, 15, 25, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
     return (KScreenWidth - 30 - 50 * 5) / 4;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TTPersonGameCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTPersonGameCollectionViewCell" forIndexPath:indexPath];
    [cell configpPersonMemberCellWithFamilyModel:[self.memberArray safeObjectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.memberArray.count > 0) {
        if (self.delegate &&  [self.delegate respondsToSelector:@selector(didSelectFamilyMemberWith:)]) {
            XCFamilyModel * mode = [self.memberArray safeObjectAtIndex:indexPath.row];
            [self.delegate didSelectFamilyMemberWith:mode];
        }
    }
}

#pragma mark - setters and getters
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowlayout  = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        [_collectionView registerClass:[TTPersonGameCollectionViewCell class] forCellWithReuseIdentifier:@"TTPersonGameCollectionViewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
