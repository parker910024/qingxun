//
//  TTWorldletMainPartyRoomView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/11/30.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTWorldletMainPartyRoomView.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "NSArray+Safe.h"
#import "LXSEQView.h"

#import <Masonry/Masonry.h>

static NSString *const kCellID = @"kCellID";

@interface TTWorldletMainPartyRoomView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation TTWorldletMainPartyRoomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(14);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - UICollectionViewDelegate &UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TTWorldletMainPartyRoomContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    LittleWorldPartyRoom *model = [self.dataArray safeObjectAtIndex:indexPath.item];
    [cell configData:model];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LittleWorldPartyRoom *model = [self.dataArray safeObjectAtIndex:indexPath.item];
    if (model) {
        !self.selectedBlock ?: self.selectedBlock(model);
    }
}

#pragma mark - Lazy Load
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"语音派对";
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(66, 90);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 20;
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:TTWorldletMainPartyRoomContentCell.class forCellWithReuseIdentifier:kCellID];
    }
    return _collectionView;
}

@end

@interface TTWorldletMainPartyRoomContentCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) LXSEQView *voiceImageView;//音符动画
@property (nonatomic, strong) UIView *voiceBgView;

@end

@implementation TTWorldletMainPartyRoomContentCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColor.clearColor;
        
        [self initView];
        [self initConstraint];
    }
    return self;
}

- (void)initView {
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nameLabel];
    
    [self.contentView addSubview:self.voiceBgView];
    [self.voiceBgView addSubview:self.voiceImageView];
}

- (void)initConstraint {
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(56);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(6);
    }];
    
    [self.voiceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(self.avatarImageView);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    [self.voiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.voiceBgView);
        make.centerX.mas_equalTo(self.voiceBgView).offset(1);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(8);
    }];
}

- (void)configData:(LittleWorldPartyRoom *)data {
    
    self.nameLabel.text = data.title;

    [self.avatarImageView qn_setImageImageWithUrl:data.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
    
    if (data) {
        [self.voiceImageView startAnimation];
    } else {
        [self.voiceImageView stopAnimation];
    }
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 28;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorRGBAlpha(0xffffff, 0.8);
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIView *)voiceBgView {
    if (_voiceBgView == nil) {
        _voiceBgView = [[UIView alloc] init];
        _voiceBgView.backgroundColor = UIColor.whiteColor;
        _voiceBgView.layer.cornerRadius = 8;
        _voiceBgView.layer.masksToBounds = YES;
    }
    return _voiceBgView;
}

- (LXSEQView *)voiceImageView {
    if (_voiceImageView == nil) {
        _voiceImageView = [[LXSEQView alloc] init];
        _voiceImageView.pillarWidth = 2.3;
        _voiceImageView.pillarColor = [XCTheme getTTMainTextColor];
    }
    return _voiceImageView;
}

@end
