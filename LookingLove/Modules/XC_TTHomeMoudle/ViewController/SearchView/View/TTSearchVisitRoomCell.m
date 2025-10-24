//
//  TTSearchVisitRoomCell.m
//  XC_TTHomeMoudle
//
//  Created by lvjunhang on 2020/3/2.
//  Copyright © 2020 YiZhuan. All rights reserved.
//

#import "TTSearchVisitRoomCell.h"

#import "RoomVisitRecord.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "UIButton+EnlargeTouchArea.h"
#import "UIImageView+QiNiu.h"

#import <Masonry/Masonry.h>

static NSString *const kCellID = @"kCellID";

@interface TTSearchVisitRoomCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cleanButton;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TTSearchVisitRoomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.collectionView registerClass:TTSearchVisitRoomCollectionCell.class forCellWithReuseIdentifier:kCellID];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.cleanButton];
        [self.contentView addSubview:self.collectionView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(32);
            make.left.mas_equalTo(20);
        }];
        [self.cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(self.titleLabel);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
            make.left.right.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)didClickCleanButton {
    !self.cleanRecordHandler ?: self.cleanRecordHandler();
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TTSearchVisitRoomCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(50, 80);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    !self.selectedRoomHandler ?: self.selectedRoomHandler(self.dataArray[indexPath.item]);
}

#pragma mark - Lazy Load
- (void)setDataArray:(NSArray<RoomVisitRecord *> *)dataArray {
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"进房记录";
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}

- (UIButton *)cleanButton {
    if (_cleanButton == nil) {
        _cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cleanButton setTitle:@"清空" forState:UIControlStateNormal];
        [_cleanButton setTitleColor:UIColorFromRGB(0xABAAB2) forState:UIControlStateNormal];
        _cleanButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_cleanButton enlargeTouchArea:UIEdgeInsetsMake(6, 6, 6, 6)];
        
        [_cleanButton addTarget:self action:@selector(didClickCleanButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cleanButton;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 16;
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        view.delegate = self;
        view.dataSource = self;
        view.backgroundColor = [UIColor whiteColor];
        view.showsHorizontalScrollIndicator = NO;
                
        _collectionView = view;
    }
    return _collectionView;
}

@end

@interface TTSearchVisitRoomCollectionCell ()
@property (nonatomic, strong) UIImageView *avatarView;//房间头像
@property (nonatomic, strong) UILabel *textLabel;//房间标题
@property (nonatomic, strong) UILabel *onlineLabel;//直播中
@end

@implementation TTSearchVisitRoomCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.onlineLabel];
        
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(50);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarView.mas_bottom).offset(6);
            make.left.right.mas_equalTo(0);
        }];
        [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.avatarView.mas_bottom);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(38);
        }];
    }
    return self;
}

- (void)setModel:(RoomVisitRecord *)model {
    _model = model;
    
    self.textLabel.text = model.title;
    self.onlineLabel.hidden = !model.valid;
    
    [self.avatarView qn_setImageImageWithUrl:model.avatar placeholderImage:XCTheme.defaultTheme.default_avatar type:ImageTypeCornerAvatar cornerRadious:25];
}

- (UIImageView *)avatarView {
    if (_avatarView == nil) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.layer.cornerRadius = 25;
        _avatarView.layer.masksToBounds = YES;
    }
    return _avatarView;
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [XCTheme getTTMainTextColor];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UILabel *)onlineLabel {
    if (_onlineLabel == nil) {
        _onlineLabel = [[UILabel alloc] init];
        _onlineLabel.backgroundColor = UIColorFromRGB(0xFF5864);
        _onlineLabel.text = @"直播中";
        _onlineLabel.textColor = UIColor.whiteColor;
        _onlineLabel.font = [UIFont systemFontOfSize:10];
        _onlineLabel.textAlignment = NSTextAlignmentCenter;
        _onlineLabel.layer.cornerRadius = 7.5;
        _onlineLabel.layer.masksToBounds = YES;
    }
    return _onlineLabel;
}

@end
