//
//  TTGameFocusTableViewCell.m
//  TTPlay
//
//  Created by new on 2019/3/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameFocusTableViewCell.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "NSArray+Safe.h"
#import "TTGameFocusCollectionViewCell.h"
#import "UIButton+EnlargeTouchArea.h"

static NSString *const kGameFocusItemCellID = @"kGameFocusItemID";

@interface TTGameFocusTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TTGameFocusTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
        
        [self initView];
        
        [self initConstraint];
    }
    return self;
}

- (void)initView{
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.playImageView];
    [self.backView addSubview:self.titleLabel];
}

- (void)initConstraint{
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(74);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(90);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(self.collectionView.mas_top).offset(-4);
        make.size.mas_equalTo(CGSizeMake(69, 83));
    }];
    
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(69, 69));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.playImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(69, 14));
    }];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColorRGBAlpha(0xffffff, 1);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
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

#pragma mark --- collectionDelegate ---
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.focusArray.count > 20 ? 21 : self.focusArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TTGameFocusCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGameFocusItemCellID forIndexPath:indexPath];
    
    [cell configData:self.focusArray WithIndexPath:indexPath.row];
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 20) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(focusListMoreClickWithAttention)]) {
            [self.delegate focusListMoreClickWithAttention];
        }
    }else{
        Attention *model = [self.focusArray safeObjectAtIndex:indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(focusListClieckWithAttentionModel:)]) {
            [self.delegate focusListClieckWithAttentionModel:model];
        }
    }
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(focusListClieckWithFindFriend)]) {
        [self.delegate focusListClieckWithFindFriend];
    }
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(53, 90);
        layout.sectionInset = UIEdgeInsetsMake(0, 13, 0, 12);
        layout.minimumLineSpacing = 18;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[TTGameFocusCollectionViewCell class] forCellWithReuseIdentifier:kGameFocusItemCellID];
    }
    return _collectionView;
}

- (NSMutableArray<Attention *> *)focusArray{
    if (!_focusArray) {
        _focusArray = [NSMutableArray array];
    }
    return _focusArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
