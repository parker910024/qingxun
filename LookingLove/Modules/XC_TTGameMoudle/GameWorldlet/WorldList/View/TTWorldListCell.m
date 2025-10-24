//
//  TTWorldListCell.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/1.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldListCell.h"

#import "LittleWorldSquare.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "BaseAttrbutedStringHandler.h"
#import "UIImage+extension.h"
#import <Masonry/Masonry.h>
#import <YYText/YYText.h>

@interface TTWorldListCell ()

@property (nonatomic, strong) UIImageView *coverImageView;//封面头像

@property (nonatomic, strong) UIView *bgView;//灰色背景

@property (nonatomic, strong) UILabel *nameLabel;//名称
@property (nonatomic, strong) UILabel *describeLabel;//描述
@property (nonatomic, strong) YYLabel *memberAttributedLabel;//成员头像和成员数量富文本
@property (nonatomic, strong) UIImageView *arrowImageView;//箭头

@end

@implementation TTWorldListCell

#pragma mark - Life Cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Public Methods
#pragma mark - System Protocols
#pragma mark - Custom Protocols
#pragma mark - Event Responses
#pragma mark - Private Methods
#pragma mark layout
- (void)initViews {
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    self.bgView.layer.cornerRadius = 12;
    self.bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.bgView];
    
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.layer.cornerRadius = 12;
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.image = [UIImage imageNamed:[XCTheme defaultTheme].placeholder_image_square];
    [self.contentView addSubview:self.coverImageView];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.describeLabel];
    [self.contentView addSubview:self.memberAttributedLabel];
    
    UIImage *arrowImage = [UIImage imageNamed:@"discover_arrow_more"];
    self.arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
    [self.contentView addSubview:self.arrowImageView];
}

- (void)initConstraints {
    
    //封面图大小
    CGFloat coverSize = 88.0f;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.coverImageView.mas_centerX);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-20);
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(coverSize);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView.mas_top).offset(16);
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(16);
        make.right.mas_lessThanOrEqualTo(self.arrowImageView.mas_left).offset(-4);
    }];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(6);
        make.left.mas_equalTo(self.nameLabel);
        make.right.mas_lessThanOrEqualTo(self.arrowImageView.mas_left).offset(-4);
    }];
    
    [self.memberAttributedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.bottom.mas_equalTo(self.coverImageView.mas_bottom);
        make.right.mas_lessThanOrEqualTo(self.arrowImageView.mas_left).offset(-4);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(11);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-15);
    }];
}

/**
 构造在线人数富文本
 */
- (NSMutableAttributedString *)makeOnlineNumberAttributedWithModel:(LittleWorldListItem *)model {
    
    NSMutableAttributedString *onlineAttri = [[NSMutableAttributedString alloc] init];
    for (LittleWorldListItemMember *member in model.members) {
        
        if (onlineAttri.length > 0) {
            [onlineAttri appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:4]];
        }
        
        NSMutableAttributedString *imageAttri = [self imageAttachWithImage:member.avatar];
        [onlineAttri appendAttributedString:imageAttri];
    }
    
    if (onlineAttri.length > 0) {
        [onlineAttri appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:6]];
    }
    
    NSString *num = [NSString stringWithFormat:@"%ld成员", (long)model.memberNum];
    NSMutableAttributedString *numAttri = [[NSMutableAttributedString alloc] initWithString:num];
    numAttri.yy_color = [XCTheme getTTDeepGrayTextColor];
    [onlineAttri appendAttributedString:numAttri];
    
    return onlineAttri;
}

- (NSMutableAttributedString *)imageAttachWithImage:(NSString *)imageName {
    
    UIFont *font = [UIFont systemFontOfSize:16];
    CGFloat imageSize = 16.f;
    
    UIImageView *charmImageView = [[UIImageView alloc]init];
    charmImageView.layer.cornerRadius = imageSize/2;
    charmImageView.layer.masksToBounds = YES;
    charmImageView.bounds = CGRectMake(0, 0, imageSize, imageSize);
    charmImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [charmImageView qn_setImageImageWithUrl:imageName
                           placeholderImage:[XCTheme defaultTheme].default_avatar
                                       type:ImageTypeUserIcon
                              cornerRadious:imageSize/2];
    
    NSMutableAttributedString *imageText = [NSMutableAttributedString yy_attachmentStringWithContent:charmImageView contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(imageSize, imageSize) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    
    return imageText;
}

#pragma mark - Getters and Setters
- (void)setModel:(LittleWorldListItem *)model {
    _model = model;
    
    self.nameLabel.text = model.name;
    self.describeLabel.text = model.desc;
    
    [self.coverImageView qn_setImageImageWithUrl:model.icon placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeHomePageItem];
    
    self.memberAttributedLabel.attributedText = [self makeOnlineNumberAttributedWithModel:model];
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [XCTheme getTTMainTextColor];
        label.font = [UIFont systemFontOfSize:17];
        
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UILabel *)describeLabel {
    if (_describeLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        label.font = [UIFont systemFontOfSize:12];
        
        _describeLabel = label;
    }
    return _describeLabel;
}

- (YYLabel *)memberAttributedLabel {
    if (_memberAttributedLabel == nil) {
        YYLabel *label = [[YYLabel alloc] init];
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        label.font = [UIFont systemFontOfSize:12];
        
        _memberAttributedLabel = label;
    }
    return _memberAttributedLabel;
}

@end
