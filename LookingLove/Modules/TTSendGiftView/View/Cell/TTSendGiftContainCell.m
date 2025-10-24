//
//  TTSendGiftContainCell.m
//  TTSendGiftView
//
//  Created by Macx on 2019/4/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSendGiftContainCell.h"

//m
#import "GiftInfo.h"
#import "RoomMagicInfo.h"
//t
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "XCTheme.h"
#import "NSArray+Safe.h"
#import "UIImageView+QiNiu.h"

//layout
#import "TTSendGiftItemLayout.h"

@interface TTSendGiftContainCell()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation TTSendGiftContainCell

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.type == SelectGiftType_gift) {
        return self.giftInfos.count;
    } else if (self.type == SelectGiftType_magic) {
        return self.maigcInfos.count;
    } else if (self.type == SelectGiftType_nobleGift) {
        return self.nobleGiftInfos.count;
    } else {
        return self.giftPackInfos.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TTSendGiftItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTSendGiftItemCell class]) forIndexPath:indexPath];
    
    if (self.type == SelectGiftType_gift) { // 普通礼物
        GiftInfo *info = [self.giftInfos safeObjectAtIndex:indexPath.item];
        [cell configCellBySelectedType:SelectGiftType_gift data:info];
    } else if (self.type == SelectGiftType_magic) { // 魔法礼物
        RoomMagicInfo *info = [self.maigcInfos safeObjectAtIndex:indexPath.item];
        [cell configCellBySelectedType:SelectGiftType_magic data:info];
    } else if(self.type == SelectGiftType_giftPackage) { // 背包礼物
        GiftInfo *info = [self.giftPackInfos safeObjectAtIndex:indexPath.item];
        [cell configCellBySelectedType:SelectGiftType_giftPackage data:info];
    } else if(self.type == SelectGiftType_nobleGift) { // 贵族礼物
        GiftInfo *info = [self.nobleGiftInfos safeObjectAtIndex:indexPath.item];
        [cell configCellBySelectedType:SelectGiftType_nobleGift data:info];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.type == SelectGiftType_gift) {//礼物
        if ([self.delegate respondsToSelector:@selector(sendGiftContainCell:didSelectedGift:)]) {
            GiftInfo *info = [self.giftInfos safeObjectAtIndex:indexPath.item];
            [self.delegate sendGiftContainCell:self didSelectedGift:info];
        }
    } else if (self.type == SelectGiftType_magic) {//魔法
        if ([self.delegate respondsToSelector:@selector(sendGiftContainCell:didSelectedMagic:)]) {
            RoomMagicInfo *info = [self.maigcInfos safeObjectAtIndex:indexPath.item];
            [self.delegate sendGiftContainCell:self didSelectedMagic:info];
        }
    } else if(self.type == SelectGiftType_giftPackage) {//背包
        if ([self.delegate respondsToSelector:@selector(sendGiftContainCell:didSelectedPackageGift:)]) {
            GiftInfo *info = [self.giftPackInfos safeObjectAtIndex:indexPath.item];
            [self.delegate sendGiftContainCell:self didSelectedPackageGift:info];
        }
    } else if(self.type == SelectGiftType_nobleGift) {//贵族
        if ([self.delegate respondsToSelector:@selector(sendGiftContainCell:didSelectedNobleGift:)]) {
            GiftInfo *info = [self.nobleGiftInfos safeObjectAtIndex:indexPath.item];
            [self.delegate sendGiftContainCell:self didSelectedNobleGift:info];
        }
    }
}

#pragma mark - private method
- (void)initSubViews {
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

#pragma mark - Getter && Setter
- (void)setGiftInfos:(NSArray<GiftInfo *> *)giftInfos {
    if ([giftInfos isKindOfClass:[NSArray class]]) {
        _giftInfos = giftInfos;
        [self.collectionView reloadData];
    }
}

- (void)setMaigcInfos:(NSArray<RoomMagicInfo *> *)maigcInfos {
    _maigcInfos = maigcInfos;
    [self.collectionView reloadData];
}

- (void)setGiftPackInfos:(NSArray<GiftInfo *> *)giftPackInfos {
    _giftPackInfos = giftPackInfos;
    [self.collectionView reloadData];
}

- (void)setNobleGiftInfos:(NSArray<GiftInfo *> *)nobleGiftInfos{
    _nobleGiftInfos = nobleGiftInfos;
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        TTSendGiftItemLayout *layout = [[TTSendGiftItemLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        CGFloat cellWidth = KScreenWidth / 4.0;
        layout.itemSize = CGSizeMake(cellWidth, 105);
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[TTSendGiftItemCell class] forCellWithReuseIdentifier:NSStringFromClass([TTSendGiftItemCell class])];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}
@end
