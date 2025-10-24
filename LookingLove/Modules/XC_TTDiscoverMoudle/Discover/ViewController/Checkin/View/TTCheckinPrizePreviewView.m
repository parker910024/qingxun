//
//  TTCheckinPrizePreviewView.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCheckinPrizePreviewView.h"
#import "TTCheckinPrizePreviewViewCell.h"

#import "TTCheckinConst.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "CheckinRewardTodayNotice.h"
#import "NSArray+Safe.h"

#import <Masonry/Masonry.h>

@interface TTCheckinPrizePreviewView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UIImageView *bgImageView;//背景

@property (nonatomic, strong) UILabel *titleLabel;//累计签到 领取相应奖励
@property (nonatomic, strong) UIImageView *titleLeftImageView;//累计签到，左图标
@property (nonatomic, strong) UIImageView *titleRightImageView;//累计签到，右图标

@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString *const kCellID = @"kCellID";

@implementation TTCheckinPrizePreviewView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Public Methods
/**
 更新数据源后刷新
 */
/**
 签到获取当天礼物刷新（因服务器接口延迟，这里手动处理
 
 @param todaySignDay 当天签到是28天中的第几天
 */
- (void)refreshViewAfterReceivePrizeForDay:(NSInteger)todaySignDay {
    
    if (self.dataModelArray.count <= 0) {
        return;
    }
    
    if (todaySignDay <= 0) {
        todaySignDay = 1;
    }
    
    if (todaySignDay > 28) {
        return;
    }
    
    for (CheckinRewardTodayNotice *reward in self.dataModelArray) {
        if (reward.signDays == todaySignDay) {
            reward.isReceive = YES;
            break;
        }
    }
    
    [self.collectionView reloadData];
}

#pragma mark - System Protocols
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTCheckinPrizePreviewViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    cell.canReplenishSign = self.canReplenishSign;
    cell.model = [self.dataModelArray safeObjectAtIndex:indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CheckinRewardTodayNotice *model = [self.dataModelArray safeObjectAtIndex:indexPath.item];
    if (model && !model.isReceive && model.canReplenishSign) {
        !self.selectPreviewPrizeBlock ?: self.selectPreviewPrizeBlock(model);
    }
}

#pragma mark - Custom Protocols
#pragma mark - Core Protocols
#pragma mark - Event Responses
#pragma mark - Private Methods
- (void)initViews {
    [self addSubview:self.bgImageView];
    
    [self.bgImageView addSubview:self.titleLabel];
    [self.bgImageView addSubview:self.titleLeftImageView];
    [self.bgImageView addSubview:self.titleRightImageView];
    
    [self.bgImageView addSubview:self.collectionView];
}

- (void)initConstraints {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(33);
        make.centerX.mas_equalTo(self.bgImageView);
    }];
    [self.titleLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.titleLabel.mas_left).offset(-12);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    [self.titleRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(12);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(76);
        make.left.right.mas_equalTo(self.bgImageView).inset(30);
        make.bottom.mas_equalTo(-50);
    }];
}

#pragma mark - Getters and Setters
- (void)setDataModelArray:(NSArray<CheckinRewardTodayNotice *> *)dataModelArray {
    _dataModelArray = dataModelArray;
    
    [self.collectionView reloadData];
}

- (void)setCanReplenishSign:(BOOL)canReplenishSign {
    _canReplenishSign = canReplenishSign;
    
    [self.collectionView reloadData];
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.image = [[UIImage imageNamed:@"checkin_bg_info"] resizableImageWithCapInsets:UIEdgeInsetsMake(80, 80, 80, 80)];
    }
    return _bgImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:17];
        label.textColor = TTCheckinMainColor();
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"奖励预告";
        
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIImageView *)titleLeftImageView {
    if (_titleLeftImageView == nil) {
        _titleLeftImageView = [[UIImageView alloc] init];
        _titleLeftImageView.image = [UIImage imageNamed:@"checkin_ico_prize_preview_right"];
    }
    return _titleLeftImageView;
}

- (UIImageView *)titleRightImageView {
    if (_titleRightImageView == nil) {
        _titleRightImageView = [[UIImageView alloc] init];
        _titleRightImageView.image = [UIImage imageNamed:@"checkin_ico_prize_preview_left"];
    }
    return _titleRightImageView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        CGFloat cellWidth = (KScreenWidth - 30*2 - 10*2) / 4;
        CGFloat imageWidth = cellWidth - 20;
        CGFloat height = imageWidth + 47;
        
        layout.itemSize = CGSizeMake(cellWidth, height);
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        view.delegate = self;
        view.dataSource = self;
        view.backgroundColor = [UIColor whiteColor];
        view.scrollEnabled = NO;
        
        [view registerClass:TTCheckinPrizePreviewViewCell.class forCellWithReuseIdentifier:kCellID];
        
        _collectionView = view;
    }
    return _collectionView;
}

@end
