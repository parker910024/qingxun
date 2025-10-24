//
//  TTRoomSettingsTagPickerView.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTRoomSettingsTagPickerView.h"
#import "TTRoomSettingsTagPickerCell.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "NSArray+Safe.h"
#import "HomeTag.h"
#import "TTPopup.h"
#import "XCCurrentVCStackManager.h"

#import <Masonry/Masonry.h>

static NSString *const kCellId = @"kCellId";

@interface TTRoomSettingsTagPickerView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) PickerViewSelectCompletion completion;
@property (nonatomic, copy) PickerViewCancelDismiss dismiss;

@end

@implementation TTRoomSettingsTagPickerView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    /// 设置默认宽高
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.95];
        
        [self initView];
        [self initConstraints];
    }
    return self;
}

#pragma mark - Public Methods
- (void)showAlertWithCompletion:(PickerViewSelectCompletion)completion dismiss:(PickerViewCancelDismiss)dismiss {
    
    self.completion = completion;
    self.dismiss = dismiss;
    
    [TTPopup popupView:self style:TTPopupStyleActionSheet];
}

#pragma mark - Event Response
- (void)closeButtonTapped:(UIButton *)sender {
    
    [TTPopup dismiss];
    
    if (self.dismiss) {
        self.dismiss();
    }
}

- (void)confirmButtonTapped:(UIButton *)sender {
    
    [TTPopup dismiss];
    
    if (self.completion) {
        self.completion(self.selectedTag);
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTRoomSettingsTagPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    HomeTag *homeTag = [self.tagList safeObjectAtIndex:indexPath.row];
    cell.homeTag = homeTag;
    cell.isSelect = self.selectedTag.id == homeTag.id;
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 0, 10, 0);;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeTag *homeTag = [self.tagList safeObjectAtIndex:indexPath.row];
    CGFloat width = [homeTag.name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.width;
    
    return CGSizeMake(width + 26, 26);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedTag = [self.tagList safeObjectAtIndex:indexPath.row];
    [collectionView reloadData];
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.confirmButton];
    [self addSubview:self.closeButton];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
    
    [self.collectionView registerClass:TTRoomSettingsTagPickerCell.class forCellWithReuseIdentifier:kCellId];
}

- (void)initConstraints {
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.right.mas_equalTo(self).inset(90);
        make.bottom.mas_equalTo(-100);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(32);
        make.top.mas_equalTo(36-5);
        make.right.mas_equalTo(-23+5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(135);
        make.left.mas_equalTo(44);
        make.height.mas_equalTo(24);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(30);
        make.left.right.mas_equalTo(self).inset(44);
        make.bottom.mas_equalTo(self.confirmButton.mas_top).offset(-30);
    }];
}

#pragma mark - Getter & Setter
- (void)setTagList:(NSArray *)tagList {
    _tagList = tagList;
    [self.collectionView reloadData];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:22];
        _titleLabel.text = @"快给您的房间选个标签吧！";
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"room_settings_tag_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _confirmButton.backgroundColor = [XCTheme getTTMainColor];
        [_confirmButton addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.layer.cornerRadius = 22;
    }
    return _confirmButton;
}

@end
