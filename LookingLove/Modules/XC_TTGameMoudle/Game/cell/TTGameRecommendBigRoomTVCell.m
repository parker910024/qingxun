//
//  TTGameRecommendBigRoomTVCell.m
//  TTPlay
//
//  Created by lvjunhang on 2019/2/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameRecommendBigRoomTVCell.h"
#import "TTGameRecommendBigRoomCVCell.h"

#import "TTGameRecommendViewProtocol.h"

#import <Masonry/Masonry.h>

#import "XCMacros.h"
#import "TTHomeV4DetailData.h"

CGFloat const TTGameRecommendBigRoomTVCellTopMargin = 16;//顶部边距
CGFloat const TTGameRecommendBigRoomTVCellBottomMargin = 16;//底部边距

CGFloat const TTGameRecommendBigRoomCVCellTopMargin = 0;//cell顶部边距
CGFloat const TTGameRecommendBigRoomCVCellBottomMargin = 0;//cell底部边距
CGFloat const TTGameRecommendBigRoomCVCellHoriInterval = 12;//cell水平间距
CGFloat const TTGameRecommendBigRoomCVCellVertInterval = 10;//cell垂直间距
CGFloat const TTGameRecommendBigRoomCVCellLabelHeight = 37;//标题+间隔 29+8

static NSString * kCellID = @"kCellID";

@interface TTGameRecommendBigRoomTVCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TTGameRecommendBigRoomTVCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self initView];
        [self updateConstraint];
    }
    return self;
}

- (void)initView {
    self.clipsToBounds = YES;
    self.selectionStyle = NO;
    [self.contentView addSubview:self.collectionView];
}

- (void)updateConstraint {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    /// 如果个数不是3的倍数，则向上补足至3的倍数，显示虚位以待
    NSInteger times = self.dataModelArray.count / 3;
    NSInteger remainder = self.dataModelArray.count % 3;
    if (remainder != 0) {
        times += 1;
    }
    
    return times * 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTGameRecommendBigRoomCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    if (self.dataModelArray.count > indexPath.item) {
        cell.showRankMark = self.isSupperDataType && indexPath.item == 2;
        cell.model = self.dataModelArray[indexPath.item];
    } else {
        cell.model = nil;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBigRoomCell:data:)]) {
        
        TTHomeV4DetailData *data = nil;
        if (self.dataModelArray.count > indexPath.item) {
            data = self.dataModelArray[indexPath.item];
        }
        [self.delegate didSelectBigRoomCell:self data:data];
    }
}

#pragma mark - getter setter
- (void)setDataModelArray:(NSArray<TTHomeV4DetailData *> *)dataModelArray {
    _dataModelArray = dataModelArray;
    
    _isSupperDataType = NO;
}

- (void)setIsSupperDataType:(BOOL)isSupperDataType {
    _isSupperDataType = isSupperDataType;
    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = TTGameRecommendBigRoomCVCellHoriInterval;
        layout.minimumLineSpacing = TTGameRecommendBigRoomCVCellVertInterval;
        layout.sectionInset = UIEdgeInsetsMake(TTGameRecommendBigRoomTVCellTopMargin, 15, TTGameRecommendBigRoomTVCellBottomMargin, 15);
        
        CGFloat width = (KScreenWidth - 15*2 - TTGameRecommendBigRoomCVCellHoriInterval*2) / 3;
        CGFloat height = width + TTGameRecommendBigRoomCVCellLabelHeight;
        
        layout.itemSize = CGSizeMake(width, height);
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        view.delegate = self;
        view.dataSource = self;
        view.backgroundColor = [UIColor whiteColor];
        view.scrollEnabled = NO;
        
        [view registerClass:TTGameRecommendBigRoomCVCell.class forCellWithReuseIdentifier:kCellID];
        
        _collectionView = view;
    }
    return _collectionView;
}

@end
