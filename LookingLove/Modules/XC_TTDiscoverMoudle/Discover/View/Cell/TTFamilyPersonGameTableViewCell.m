//
//  XCFamilyPersonGameTableViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyPersonGameTableViewCell.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "NSArray+Safe.h"
#import "XCMacros.h"
#import "TTPersonGameCollectionViewCell.h"
#import "TTWKWebViewViewController.h"

@interface TTFamilyPersonGameTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView * collectionView;
/** 列表数据源*/
@property (nonatomic, strong) NSArray * gameArray;
@end


@implementation TTFamilyPersonGameTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - public method
- (void)configTTFamilyPersonGameTableViewCellGameArray:(NSArray<XCFamilyModel *> *)gameArray{
    self.gameArray = gameArray;
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
    return self.gameArray.count > 0? 1:0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.gameArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70, 90);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(13, 15, 15, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return (KScreenWidth - 30 - 70 * 5) / 4;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TTPersonGameCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTPersonGameCollectionViewCell" forIndexPath:indexPath];
    [cell configpPersonGanmeCellWithFamilyModel:[self.gameArray safeObjectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.gameArray.count > 0) {
        XCFamilyModel * familyModel = [self.gameArray safeObjectAtIndex:indexPath.row];
        TTWKWebViewViewController* webviewVC = [[TTWKWebViewViewController alloc] init];
        webviewVC.urlString = familyModel.link;
        [self.currentVC.navigationController pushViewController:webviewVC animated:YES];
    }
}

#pragma mark - setters and getters
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowlayout  = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        [_collectionView registerClass:[TTPersonGameCollectionViewCell class] forCellWithReuseIdentifier:@"TTPersonGameCollectionViewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
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
