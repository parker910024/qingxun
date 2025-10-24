//
//  TTInvitaFriendCollectionViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/1.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTInvitaFriendCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "UserInfo.h"
#import "TTInvitaFriendModel.h"

@interface TTInvitaFriendCollectionViewCell ()
/** 邀请好友 */
@property (nonatomic, strong) UILabel *titleLabel;
/** detailLabel */
@property (nonatomic, strong) UILabel *detailLabel;
/** 图片 */
@property (nonatomic, strong) UIImageView *iconImageView;
/** 头像数组 */
@property (nonatomic, strong) NSMutableArray *avatarArray;
/** 箭头*/
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UIView *lineView;
/** hot 标签 */
@property (nonatomic, strong) UIImageView *hotImageView;
@end

@implementation TTInvitaFriendCollectionViewCell

#pragma Mark- life cycle
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.arrowButton];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.hotImageView];
}

- (void)initContrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.titleLabel);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(17);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-32);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(11);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-17);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView).inset(15);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
}

#pragma mark - setters and getters
- (void)setModel:(TTInvitaFriendModel *)model {
    _model = model;
    
    self.iconImageView.image = model.iconImage;
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.detail;
    
    [self.avatarArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.avatarArray removeAllObjects];
    
    for (int i = 0; i < model.users.count; i++) {
        
        UserInfo *info = model.users[i];
        
        UIImageView *avatar = [[UIImageView alloc] init];
        avatar.layer.cornerRadius = 10;
        avatar.layer.masksToBounds = YES;
        avatar.layer.borderColor = [[UIColor whiteColor] CGColor];
        avatar.layer.borderWidth = 1;
        [self addSubview:avatar];
        [avatar qn_setImageImageWithUrl:info.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserIcon];
        
        CGFloat right = 34 + 10 * i;
        [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-right);
            make.centerY.mas_equalTo(self);
            make.width.height.mas_equalTo(20);
        }];
        [self.avatarArray addObject:avatar];
    }
}

#pragma mark -
#pragma mark getter & setter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.hidden = YES;
        // 现在隐藏掉了。 UI 把之前的旧稿拿出来用了。
    }
    return _iconImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  =  [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor  =  UIColorFromRGB(0xFF7162);
        _detailLabel.font = [UIFont systemFontOfSize:12];
    }
    return _detailLabel;
}

- (UIButton *)arrowButton{
    if (!_arrowButton) {
        _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowButton setImage:[UIImage imageNamed:@"discover_family_arrow"] forState:UIControlStateNormal];
    }
    return _arrowButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xF4F4F4);
    }
    return _lineView;
}

- (NSMutableArray *)avatarArray {
    if (!_avatarArray) {
        _avatarArray = [NSMutableArray array];
    }
    return _avatarArray;
}

- (UIImageView *)hotImageView {
    if (!_hotImageView) {
        _hotImageView = [[UIImageView alloc] init];
    }
    return _hotImageView;
}


@end
