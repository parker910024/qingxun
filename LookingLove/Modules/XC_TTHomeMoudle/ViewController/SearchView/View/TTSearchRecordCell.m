//
//  TTSearchRecordCell.m
//  XC_TTHomeMoudle
//
//  Created by lvjunhang on 2020/3/2.
//  Copyright © 2020 YiZhuan. All rights reserved.
//

#import "TTSearchRecordCell.h"

#import "XCTheme.h"
#import "UIButton+EnlargeTouchArea.h"

#import <Masonry/Masonry.h>

static NSString *const kCellID = @"kCellID";

@interface TTSearchRecordCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cleanButton;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TTSearchRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.collectionView registerClass:TTSearchRecordCollectionCell.class forCellWithReuseIdentifier:kCellID];
        
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
    
    TTSearchRecordCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    cell.content = self.dataArray[indexPath.item];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *content = self.dataArray[indexPath.item];
    if (content.length > 15) {
        content = [content substringToIndex:15];
    }
    
    CGFloat contentWidth = [content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}].width;
    
    return CGSizeMake(contentWidth+16*2, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    //不知道为什么，当个数大于1，左边会莫名增加10pt
    //sizeForItemAtIndexPath返回值如果写死，不会出现这种问题
    CGFloat left = self.dataArray.count == 1 ? 20 : 10;
    return UIEdgeInsetsMake(0, left, 0, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    !self.selectedRecordHandler ?: self.selectedRecordHandler(self.dataArray[indexPath.item]);
}

#pragma mark - Lazy Load
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"搜索记录";
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

static CGFloat const kTextMargin = 12.0f;

@interface TTSearchRecordCollectionCell ()
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation TTSearchRecordCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [XCTheme getTTSimpleGrayColor];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 15;
        
        [self.contentView addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kTextMargin);
            make.right.mas_equalTo(-kTextMargin);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

- (void)setContent:(NSString *)content {
    _content = content;
    
    self.textLabel.text = content;
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [XCTheme getTTMainTextColor];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

@end
