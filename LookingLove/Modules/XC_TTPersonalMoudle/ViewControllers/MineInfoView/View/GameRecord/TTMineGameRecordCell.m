//
//  TTMineGameRecordCell.m
//  TTPlay
//
//  Created by new on 2019/3/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMineGameRecordCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"


#import "CPGameListModel.h"
#import "TTMineGameListModel.h"

#import "NSArray+Safe.h"
#import "TTGameRecordCollectionViewCell.h"


static NSString *const kMineGameCellID = @"kMineGameID";

@interface TTMineGameRecordCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TTMineGameRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
        [self initConstraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initViews{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.collectionView];
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(30);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
        make.width.mas_equalTo(KScreenWidth);
        make.bottom.mas_equalTo(0);
    }];
}

- (NSMutableArray *)recordArray {
    if (!_recordArray) {
        _recordArray = [NSMutableArray array];
    }
    return _recordArray;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"本周战绩";
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(90, 90 + 24);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 11;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:TTGameRecordCollectionViewCell.class forCellWithReuseIdentifier:kMineGameCellID];
        
    }
    return _collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.recordArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TTGameRecordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMineGameCellID forIndexPath:indexPath];
    
    TTMineGameListModel *model = [self.recordArray safeObjectAtIndex:indexPath.row];
    
    [cell configModel:model];
    
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
