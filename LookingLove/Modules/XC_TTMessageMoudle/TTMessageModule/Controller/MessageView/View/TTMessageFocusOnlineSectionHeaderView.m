//
//  TTMessageFocusOnlineSectionHeaderView.m
//  XC_TTMessageMoudle
//
//  Created by lvjunhang on 2019/11/18.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTMessageFocusOnlineSectionHeaderView.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "NSArray+Safe.h"
#import "UIButton+EnlargeTouchArea.h"
#import "UIImageView+QiNiu.h"

#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

static NSString *const kGameFocusItemCellID = @"kGameFocusItemID";

//显示“更多入口”所需数据的最小值
static NSUInteger const kShowMoreEntranceMinimum = 21;

@interface TTMessageFocusOnlineSectionHeaderView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *togetherBgView;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TTMessageFocusOnlineSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        [self initView];
        [self initConstraint];
    }
    return self;
}

- (void)initView {
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.togetherBgView];
    [self.togetherBgView addSubview:self.playImageView];
    [self.togetherBgView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.collectionView];
}

- (void)initConstraint {
    
    CGFloat togetherBgViewLeftMargin = self.hideTogetherButton ? 0 : 8;
    CGFloat togetherBgViewWidth = self.hideTogetherButton ? 0 : 78;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(self.togetherBgView.mas_right);
    }];
    
    [self.togetherBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(togetherBgViewLeftMargin);
        make.width.mas_equalTo(togetherBgViewWidth);
    }];
    
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playImageView.mas_bottom);
        make.centerX.mas_equalTo(0);
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.focusArray.count >= kShowMoreEntranceMinimum ? kShowMoreEntranceMinimum : self.focusArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TTMessageFocusOnlineSectionHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGameFocusItemCellID forIndexPath:indexPath];
    
    Attention *model = [self.focusArray safeObjectAtIndex:indexPath.item];
    [cell configData:model];
    cell.isMoreItemStyle = indexPath.item == kShowMoreEntranceMinimum-1;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TTMessageFocusOnlineSectionHeaderCell *cell = (TTMessageFocusOnlineSectionHeaderCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isMoreItemStyle) {
        
        if ([self.delegate respondsToSelector:@selector(sectionHeaderViewDidClickMore:)]) {
            [self.delegate sectionHeaderViewDidClickMore:self];
        }
        return;
    }
    
    Attention *model = [self.focusArray safeObjectAtIndex:indexPath.item];
    if ([self.delegate respondsToSelector:@selector(sectionHeaderView:didSelectedAttention:)]) {
        [self.delegate sectionHeaderView:self didSelectedAttention:model];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(sectionHeaderViewDidClickTogether:)]) {
        [self.delegate sectionHeaderViewDidClickTogether:self];
    }
}

#pragma mark - Setter Getter
- (void)setHideTogetherButton:(BOOL)hideTogetherButton {
    _hideTogetherButton = hideTogetherButton;
    
    self.togetherBgView.hidden = hideTogetherButton;
    
    [self initConstraint];
}

- (void)setFocusArray:(NSArray<Attention *> *)focusArray {
    
    if (_focusArray == focusArray) {
        return;
    }
    
    _focusArray = focusArray;
    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(55, 90);
        layout.sectionInset = UIEdgeInsetsMake(0, 13, 0, 12);
        layout.minimumLineSpacing = 18;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[TTMessageFocusOnlineSectionHeaderCell class] forCellWithReuseIdentifier:kGameFocusItemCellID];
    }
    return _collectionView;
}

- (UIView *)togetherBgView {
    if (!_togetherBgView) {
        _togetherBgView = [[UIView alloc] init];
        _togetherBgView.backgroundColor = UIColorRGBAlpha(0xffffff, 1);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_togetherBgView addGestureRecognizer:tap];
    }
    return _togetherBgView;
}

- (UIImageView *)playImageView {
    if (!_playImageView) {
        _playImageView = [[UIImageView alloc] init];
        _playImageView.image = [UIImage imageNamed:@"game_findFriend_overlays"];
    }
    return _playImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"找人玩";
        _titleLabel.textColor = UIColorFromRGB(0xA49EFE);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end

static CGFloat kAvatarSize = 50.0f;

@interface TTMessageFocusOnlineSectionHeaderCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation TTMessageFocusOnlineSectionHeaderCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorRGBAlpha(0xffffff, 1);
        
        [self initView];
        [self initConstraint];
    }
    return self;
}

- (void)initView {
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tipsLabel];
}

- (void)initConstraint {
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(kAvatarSize);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(6);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
}

- (void)configData:(Attention *)attention {
    
    self.titleLabel.text = attention.nick;

    [self.avatarImageView qn_setImageImageWithUrl:attention.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
}

- (void)setIsMoreItemStyle:(BOOL)isMoreItemStyle {
    _isMoreItemStyle = isMoreItemStyle;
    
    self.titleLabel.hidden = isMoreItemStyle;
    self.tipsLabel.hidden = isMoreItemStyle;
    
    if (isMoreItemStyle) {
        [self.avatarImageView sd_cancelCurrentAnimationImagesLoad];
        [self.avatarImageView sd_setImageWithURL:nil];
        self.avatarImageView.image = [UIImage imageNamed:@"home_friend_more"];
    }
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = kAvatarSize / 2;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _tipsLabel.font = [UIFont systemFontOfSize:11];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.text = @"嗨聊中";
    }
    return _tipsLabel;
}

@end
