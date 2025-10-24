//
//  TTGameListTableViewCell.m
//  TuTu
//
//  Created by new on 2019/1/17.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameListTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+UIColor_Hex.h" // 颜色设置
#import "XCMacros.h"
#import "CPGameListModel.h"
#import "CPGameHomeBannerModel.h"
#import "XCTheme.h" // 颜色设置的宏定义
#import "TTGameListCollectionViewCell.h"

static NSString *const kGameItemCellID = @"kGameItemID";

@interface TTGameListTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,TTGameListCollectionViewCellDelegate>

@end

@implementation TTGameListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorRGBAlpha(0xffffff, 1);
        
        [self initView];
        
    }
    return self;
}

- (void)initView{
    [self.contentView addSubview:self.collectionView];
}

-(void)layoutSubviews{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(105, 125);
        layout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:[TTGameListCollectionViewCell class] forCellWithReuseIdentifier:kGameItemCellID];
    }
    return _collectionView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)welfDataArray{
    if (!_welfDataArray) {
        self.welfDataArray = [NSMutableArray array];
    }
    return _welfDataArray;
}

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.section == 0) {
        return self.dataArray.count < 7 ? self.dataArray.count : 7;
    }else{
        return self.welfDataArray.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TTGameListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGameItemCellID forIndexPath:indexPath];

    if (self.section == 0) {
        [cell configData:self.dataArray WithIndexPath:indexPath.row];
        cell.delegate = self;
    }else{
        CPGameHomeBannerModel *model = self.welfDataArray[indexPath.row];
        [cell configWelfDataModel:model];
    }
    

    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemClickWithIndex:WithSection:)]) {
        [self.delegate itemClickWithIndex:indexPath.row WithSection:self.section];
    }
}

- (void)moreGameBtnClickAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreGameBtnClickActionBackMainPageDeal)]) {
        [self.delegate moreGameBtnClickActionBackMainPageDeal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
