//
//  TTHomeRecommendRoomTVCell.m
//  TTPlay
//
//  Created by lvjunhang on 2019/2/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTHomeRecommendRoomTVCell.h"

#import "BaseAttrbutedStringHandler+TTHome.h"
#import "TTHomeRecommendViewProtocol.h"

#import <YYText/YYText.h>
#import <Masonry/Masonry.h>

#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "TTHomeV4DetailData.h"
#import "HomePageInfo.h"

@interface TTHomeRecommendRoomTVCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) YYLabel *onlineLabel;
@end

@implementation TTHomeRecommendRoomTVCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        [self initConstraints];
    }
    return self;
}

#pragma mark - public method
#pragma mark - system protocols
#pragma mark - custom protocols
#pragma mark - core protocols
#pragma mark - event response
#pragma mark - private method
- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.whiteColor;
    
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.tagImageView];
    [self.contentView addSubview:self.onlineLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.lockImageView];
    [self.contentView addSubview:self.separateLine];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)initConstraints {
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(60);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImageView.mas_top).offset(4);
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(12);
    }];
    
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(34);
    }];
    
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(9);
        make.left.mas_equalTo(self.tagImageView.mas_right);
        make.height.mas_equalTo(16);
    }];
    
    [self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(4);
        make.right.mas_lessThanOrEqualTo(-15);
        make.centerY.mas_equalTo(self.nameLabel);
        make.width.height.mas_equalTo(15);
    }];
    
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)tapGestureRecognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectSmallRoomCell:data:)]) {
        [self.delegate didSelectSmallRoomCell:self data:self.model];
    }
}

#pragma mark - getters and setters
- (void)setModel:(TTHomeV4DetailData *)model {
    _model = model;
    
    self.lockImageView.hidden = model == nil || model.roomPwd.length == 0;
    
    [self.avatarImageView qn_setImageImageWithUrl:model.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeHomePageItem];
    self.nameLabel.text = model.title.length > 0 ? model.title : @" ";
    
    [self.tagImageView qn_setImageImageWithUrl:model.tagPict placeholderImage:[XCTheme defaultTheme].placeholder_image_rectangle type:ImageTypeHomePageItem success:^(UIImage *image) {
        if (image) {
            [self.tagImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(image.size.width / (image.size.height / 15));
            }];
        }
    }];
    
    NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] init];
//    [attM appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 34, 15) urlString:model.tagPict imageName:nil]];
    
    if (model.isRecom) {
        [attM appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:8]];
        [attM appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 67, 15) urlString:nil imageName:@"home_emperor"]];
    }
    
    if (model.badge.length > 0) {
        [attM appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:8]];
        [attM appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 67, 15) urlString:model.badge imageName:nil]];
    }
    
    [attM appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:8]];
    NSString *onlineStr = [NSString stringWithFormat:@"%ld人在线", (long)model.onlineNum];
    [attM appendAttributedString:[[NSAttributedString alloc] initWithString:onlineStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [XCTheme getTTDeepGrayTextColor]}]];
    
    self.onlineLabel.attributedText = attM;
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 30;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarImageView;
}

- (UIImageView *)lockImageView {
    if (_lockImageView == nil) {
        _lockImageView = [[UIImageView alloc] init];
        _lockImageView.image = [UIImage imageNamed:@"home_room_lock_small"];
    }
    return _lockImageView;
}

- (UIImageView *)tagImageView {
    if (_tagImageView == nil) {
        _tagImageView = [[UIImageView alloc] init];
    }
    return _tagImageView;
}

- (YYLabel *)onlineLabel {
    if (_onlineLabel == nil) {
        _onlineLabel = [[YYLabel alloc] init];
        _onlineLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _onlineLabel;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [XCTheme getMSMainTextColor];
    }
    return _nameLabel;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc] init];
        _separateLine.backgroundColor = UIColorFromRGB(0xf2f2f2);
    }
    return _separateLine;
}

@end

