//
//  TTPersonEditImageCell.m
//  TuTu
//
//  Created by Macx on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTPersonEditImageCell.h"
#import "TTPersonEditPhotosCell.h"

#import "UserPhoto.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>
//
#import "UIImageView+QiNiu.h"

#import "NSArray+Safe.h"

@interface TTPersonEditImageCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIImageView  *arrow;//
@property (nonatomic, strong) UICollectionView  *collectionView;//
@property (nonatomic, strong) UILabel *tipsLabel;
@end

@implementation TTPersonEditImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrow];
    [self.contentView addSubview:self.tipsLabel];
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrow.mas_right).offset(-15);
        make.left.mas_lessThanOrEqualTo(self.titleLabel.mas_right);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(35);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-36);
        make.centerY.mas_equalTo(0);
    }];
}

#pragma mark - CoreClient
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(35, 35);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTPersonEditPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTPersonEditPhotosCell" forIndexPath:indexPath];
    UserPhoto *photo = [self.photos safeObjectAtIndex:indexPath.item];
    [cell.photos qn_setImageImageWithUrl:photo.photoUrl placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:ImageTypeUserIcon];
    
    return cell;
}


#pragma mark - Getter && Setter
- (void)setPhotos:(NSArray<UserPhoto *> *)photos {
    _photos = photos;
    if (photos.count) {
        self.tipsLabel.hidden = YES;
    }
    [self.collectionView reloadData];
}

- (UIImageView *)arrow {
    if (!_arrow) {
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_setting_arrow"]];
    }
    return _arrow;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.userInteractionEnabled = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setTransform:CGAffineTransformMakeScale(-1, 1)]; // 翻转
        [_collectionView registerClass:[TTPersonEditPhotosCell class] forCellWithReuseIdentifier:@"TTPersonEditPhotosCell"];
    }
    return _collectionView;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"你还没有上传照片哦..";
        _tipsLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _tipsLabel.font = [UIFont systemFontOfSize:14.f];
        _tipsLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _tipsLabel;
}


@end
