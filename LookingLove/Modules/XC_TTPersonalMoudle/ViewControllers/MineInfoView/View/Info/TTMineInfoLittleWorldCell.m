//
//  TTMineInfoLittleWorldCell.m
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/11/22.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTMineInfoLittleWorldCell.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "NSArray+Safe.h"

#import <Masonry/Masonry.h>

static NSString *const kCellID = @"kCellID";

@interface TTMineInfoLittleWorldCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation TTMineInfoLittleWorldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
        [self initConstraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.collectionView];
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(120);
        make.width.mas_equalTo(KScreenWidth);
    }];
}

#pragma mark - Public
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

#pragma mark - UICollectionViewDelegate &UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TTMineInfoLittleWorldContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    UserLittleWorld *model = [self.dataArray safeObjectAtIndex:indexPath.item];
    [cell configData:model];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UserLittleWorld *model = [self.dataArray safeObjectAtIndex:indexPath.item];
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
        _titleLabel.text = @"Ta的小世界";
        _titleLabel.textColor = [XCTheme getMSMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(90, 120);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:TTMineInfoLittleWorldContentCell.class forCellWithReuseIdentifier:kCellID];
    }
    return _collectionView;
}

@end

@interface TTMineInfoLittleWorldContentCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation TTMineInfoLittleWorldContentCell

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
    [self.contentView addSubview:self.nameLabel];
}

- (void)initConstraint {
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(90);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(8);
    }];
}

- (void)configData:(UserLittleWorld *)data {
    
    self.nameLabel.text = data.name;

    [self.avatarImageView qn_setImageImageWithUrl:data.icon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 8;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [XCTheme getTTSubTextColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

@end
