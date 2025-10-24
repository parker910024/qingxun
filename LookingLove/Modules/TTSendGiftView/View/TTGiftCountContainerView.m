//
//  TTGiftCountContainerView.m
//  TTSendGiftView
//
//  Created by Macx on 2019/5/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGiftCountContainerView.h"

#import "TTSendGiftCountCell.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "NSArray+Safe.h"

@interface TTGiftCountContainerView ()<UICollectionViewDelegate, UICollectionViewDataSource>
/** collection */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 礼物数量数据源 */
@property (nonatomic, strong) NSArray<TTSendGiftCountItem *> *giftCountArray;
@end

@implementation TTGiftCountContainerView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.giftCountArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTSendGiftCountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTSendGiftCountCell class]) forIndexPath:indexPath];
    TTSendGiftCountItem *countItem = [self.giftCountArray safeObjectAtIndex:indexPath.item];
    cell.countItem = countItem;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TTSendGiftCountItem *countItem = [self.giftCountArray safeObjectAtIndex:indexPath.item];
    if (countItem.isCustomCount) {
        countItem.giftCount = @"";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(giftCountContainerView:didSelectItem:)]) {
        [self.delegate giftCountContainerView:self didSelectItem:countItem];
    }
}

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response

#pragma mark - private method

- (void)initView {
    // 设置毛玻璃效果
    self.layer.cornerRadius = 12;
    self.layer.masksToBounds = YES;
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = CGRectMake(0, 0, 135, 230);
    [self addSubview:effectView];
    
    [self addSubview:self.collectionView];
    self.giftCountArray = [self createCountDataArray];
}

- (void)initConstrations {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - getters and setters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(135, 28);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[TTSendGiftCountCell class] forCellWithReuseIdentifier:NSStringFromClass([TTSendGiftCountCell class])];
        _collectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (NSArray<TTSendGiftCountItem *> *)createCountDataArray {
    
    TTSendGiftCountItem *_1Dic = [TTSendGiftCountItem itemWithGiftNormalTitle:@"一心一意" giftCount:@"1"];
    TTSendGiftCountItem *_10Dic = [TTSendGiftCountItem itemWithGiftNormalTitle:@"十全十美" giftCount:@"10"];
    TTSendGiftCountItem *_66Dic = [TTSendGiftCountItem itemWithGiftNormalTitle:@"一切顺利" giftCount:@"66"];
    TTSendGiftCountItem *_99Dic = [TTSendGiftCountItem itemWithGiftNormalTitle:@"长长久久" giftCount:@"99"];
    TTSendGiftCountItem *_188Dic = [TTSendGiftCountItem itemWithGiftNormalTitle:@"要抱抱" giftCount:@"188"];
    TTSendGiftCountItem *_520Dic = [TTSendGiftCountItem itemWithGiftNormalTitle:@"我爱你" giftCount:@"520"];
    TTSendGiftCountItem *_1314Dic = [TTSendGiftCountItem itemWithGiftNormalTitle:@"一生一世" giftCount:@"1314"];
    
    // 其他数额
    TTSendGiftCountItem *_otherDic = [TTSendGiftCountItem itemWithGiftNormalTitle:@"其他数额" giftCount:@""];
    _otherDic.isCustomCount = YES;
    
    NSArray *dataArray = @[_1Dic,_10Dic,_66Dic,_99Dic,_188Dic,_520Dic,_1314Dic,_otherDic];
    return dataArray;
}

@end
