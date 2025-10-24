//
//  TuTuGameRoomListHeaderView.m
//  XChat
//
//  Created by Mac on 2018/1/16.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "TTRoomOnlineNobleHeaderView.h"
#import "TTNobleCollectionViewCell.h"

//view
#import "TTNobleCollectionFooterView.h"

//m
#import "OnLineNobleInfo.h"
//c
#import "AuthCore.h"
#import "UserCore.h"

#import "XCHUDTool.h"

#import <Masonry/Masonry.h>

#define kColCount 4
#define kGameRoomMaxNobleListCount 60

@interface TTRoomOnlineNobleHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray<OnLineNobleInfo *> *nobleLists;

@end

@implementation TTRoomOnlineNobleHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupSubViews{
    
    [self.collectionView registerClass:[TTNobleCollectionViewCell class] forCellWithReuseIdentifier:@"TuTuNobleCollectionViewCell"];
    
    [self.collectionView registerClass:[TTNobleCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"TuTuNobleCollectionFooterView"];
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.nobleLists.count == 0) {
        return kColCount;
    }
    if (self.nobleLists.count % kColCount == 0) {
        return self.nobleLists.count;
    }
    return (self.nobleLists.count/kColCount+1)*kColCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TTNobleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TuTuNobleCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.item >= self.nobleLists.count) {
        [cell configCellWithUserModel:nil];
    }else{
        OnLineNobleInfo *userInfo = [self.nobleLists safeObjectAtIndex:indexPath.row];
        [cell configCellWithUserModel:userInfo];
    }
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (self.nobleLists.count>=kGameRoomMaxNobleListCount) {
        return CGSizeMake(KScreenWidth, 34);
    }else{
        return CGSizeZero;
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter] && self.nobleLists.count>=kGameRoomMaxNobleListCount) {
        TTNobleCollectionFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"TuTuNobleCollectionFooterView" forIndexPath:indexPath];
        return footer;
    }
    return nil;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (KScreenWidth == 320) {
        return UIEdgeInsetsZero;
    }else{
        return UIEdgeInsetsMake(0, 8, 0, 8);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item >= self.nobleLists.count) {
        [GetCore(UserCore) getUserInfo:GetCore(AuthCore).getUid.userIDValue refresh:NO success:^(UserInfo *info) {
            if (info.nobleUsers) {
                //提示已经是贵族
                [XCHUDTool showSuccessWithMessage:@"您已是贵族"];
            }else{
                //提示开通
                [self showOpenNobleTipCard];
            }
        }failure:^(NSError *error) {
            
        }];
       
    }else{
        OnLineNobleInfo *userInfo = [self.nobleLists safeObjectAtIndex:indexPath.item];
        if (userInfo.nobleUsers.enterHide) {
            return;
        }
        if ([self.delegate respondsToSelector:@selector(gameRoomListHeaderViewShowNobleUserCard:)]) {
            [self.delegate gameRoomListHeaderViewShowNobleUserCard:userInfo.uid];
        }
    }
}

#pragma mark - puble method
- (void)configGameRoomListHeaderView:(NSArray *)nubleLists{
    _nobleLists = nubleLists;
    
    int row = 0;
    if (self.nobleLists.count == 0) {
         row = 1;
    } else {
        if (self.nobleLists.count % kColCount == 0) {
            row = self.nobleLists.count / kColCount;
        } else {
            row = self.nobleLists.count / kColCount+1;
        }
    }
    
    CGFloat height = row * (93);
    height = nubleLists.count == kGameRoomMaxNobleListCount ? (height+34) : height+10;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    [self.collectionView reloadData];
}

#pragma mark - private method
- (void)showOpenNobleTipCard {
    if ([self.delegate respondsToSelector:@selector(gameRoomListHeaderViewShowOpenNobleTipCard)]) {
        [self.delegate gameRoomListHeaderViewShowOpenNobleTipCard];
    }
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(80, 93);

        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = (KScreenWidth-kColCount*80)/5;
    }
    return _layout;
}
 
@end
