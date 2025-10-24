//
//  TTGuildAddMemberSheetView.m
//  TTPlay
//
//  Created by lee on 2019/2/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildAddMemberSheetView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

static NSString *const kCellIconKey = @"kCellIconKey";
static NSString *const kCellTextKey = @"kCellTextKey";

static NSString *const kAddMemberSheetCellConst = @"kAddMemberSheetCellConst";

@interface TTGuildAddMemberSheetCell ()
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation TTGuildAddMemberSheetCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self.contentView addSubview:self.iconImage];
    [self.contentView addSubview:self.textLabel];
}

- (void)initConstraints {
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(15);
        make.height.width.mas_equalTo(49);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImage.mas_bottom).offset(8);
        make.centerX.mas_equalTo(0);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter
- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [XCTheme getMSMainTextColor];
        _textLabel.font = [UIFont systemFontOfSize:12.f];
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
    }
    return _iconImage;
}

@end

#pragma mark -
#pragma mark sheetView
@interface TTGuildAddMemberSheetView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) NSArray<NSString *>* imgArray;
@property (nonatomic, strong) NSArray<NSString *>* textArray;
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSString *> *> *dataArray;

@end

@implementation TTGuildAddMemberSheetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}
#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self addSubview:self.contentView];
    [self addSubview:self.cancelBtn];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.collectionView];
}

- (void)initConstraints {
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).inset(15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(162);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_bottom).offset(15);
        make.left.right.mas_equalTo(self).inset(15);
        make.height.mas_equalTo(51);
    }];
}

#pragma mark -
#pragma mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTGuildAddMemberSheetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAddMemberSheetCellConst forIndexPath:indexPath];
    NSDictionary *dict = self.dataArray[indexPath.item];
    cell.iconImage.image = [UIImage imageNamed:dict[kCellIconKey]];
    cell.textLabel.text = dict[kCellTextKey];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 将类型传递出去
    if ([self.delegate respondsToSelector:@selector(didClickSheetViewItemAction:)]) {
        [self.delegate didClickSheetViewItemAction:(TTSheetViewClickType)indexPath.item];
    }
    
    [self onCancelBtnClickAction:nil];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events
-(void)onCancelBtnClickAction:(UIButton *)cancelBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCancelAction)]) {
        [self.delegate didClickCancelAction];
    }
}

#pragma mark -
#pragma mark getter & setter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"添加成员";
        _titleLabel.textColor = [XCTheme getMSMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorFromRGB(0x4D4D4D) forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [_cancelBtn setBackgroundColor:[UIColor whiteColor]];
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.cornerRadius = 14;
        [_cancelBtn addTarget:self action:@selector(onCancelBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 14;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        CGFloat itemW = (KScreenWidth - 30) / 3;
        flowLayout.itemSize = CGSizeMake(floorf(itemW), floorf(itemW));
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[TTGuildAddMemberSheetCell class] forCellWithReuseIdentifier:kAddMemberSheetCellConst];
    }
    return _collectionView;
}

- (NSArray<NSDictionary<NSString *,NSString *> *> *)dataArray {
    if (!_dataArray) {
        
        NSDictionary *ttDict = @{kCellIconKey : @"guild_addSheet_TuTu", kCellTextKey : @"用户ID添加"};
        NSDictionary *wxDict = @{kCellIconKey : @"guild_addSheet_WX", kCellTextKey : @"微信导入"};
        NSDictionary *qqDict = @{kCellIconKey : @"guild_addSheet_QQ", kCellTextKey : @"QQ导入"};

        _dataArray = @[ttDict, wxDict, qqDict];
    }
    return _dataArray;
}

@end
