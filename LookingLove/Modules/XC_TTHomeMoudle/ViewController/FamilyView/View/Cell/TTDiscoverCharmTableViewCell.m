//
//  TTDiscoverCharmTableViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDiscoverCharmTableViewCell.h"
#import "TTDiscoverCharmCollectionViewCell.h"
#import "NSArray+Safe.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMediator+TTDiscoverModuleBridge.h"

@interface TTDiscoverCharmTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** view*/
@property (nonatomic, strong) UICollectionView * collectionView;
/** 箭头*/
@property (nonatomic, strong) NSArray<XCFamilyModel *> * charmList;
@end

@implementation TTDiscoverCharmTableViewCell

#pragma mark - life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}
#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.charmList.count > 0 ? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.charmList.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 23, 15);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TTDiscoverCharmCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTDiscoverCharmCollectionViewCell" forIndexPath:indexPath];
    if (self.charmList.count > 0) {
        XCFamilyModel * familyModel = [self.charmList safeObjectAtIndex:indexPath.row];
        [cell configDiscoverCharmWith:familyModel];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.charmList.count > 0) {
            XCFamilyModel * familyModel = [self.charmList safeObjectAtIndex:indexPath.row];
        UIViewController * controller= [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyPersonViewController:[familyModel.id integerValue]];
        [self.currentVC.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - public method
- (void)configDiscoverCharmTableViewCell:(NSArray *)charms{
    if (charms.count > 0) {
        self.charmList = charms;
        [self.collectionView reloadData];
    }
}

#pragma mark - private method
- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.collectionView];
}
- (void)initConstrations {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}
#pragma mark - getters and setters
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        flowLayout.itemSize = CGSizeMake(70, 88);
        flowLayout.minimumInteritemSpacing = 15;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator= NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[TTDiscoverCharmCollectionViewCell class] forCellWithReuseIdentifier:@"TTDiscoverCharmCollectionViewCell"];
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
