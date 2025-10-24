//
//  TTDynamicMessageCell.m
//  XC_TTMessageMoudle
//
//  Created by lvjunhang on 2019/11/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTDynamicMessageCell.h"

#import "BaseAttrbutedStringHandler+Message.h"

#import "DynamicMessage.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "BaseAttrbutedStringHandler.h"
#import "UIImage+extension.h"

#import <Masonry/Masonry.h>
#import <YYText/YYText.h>
#import <YYText/YYLabel.h>

@interface TTDynamicMessageCell ()

@property (nonatomic, strong) UIImageView *coverImageView;//封面头像
@property (nonatomic, strong) UIImageView *dynamicImageView;//动态的缩略图
@property (nonatomic, strong) UILabel *dynamicLabel;//动态内容缩略

@property (nonatomic, strong) YYLabel *worldLabel;//小世界
@property (nonatomic, strong) YYLabel *nameLabel;//名称
@property (nonatomic, strong) UILabel *describeLabel;//描述
@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UILabel *commentOnLabel;//评论了你

@property (nonatomic, strong) UIView *underlineView;//分隔线

@end

@implementation TTDynamicMessageCell

#pragma mark - Life Cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
        [self initConstraints];
        
        
        @weakify(self)
        [self.nameLabel setTextTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {

            @strongify(self)
            !self.nameActionHandler ?: self.nameActionHandler();
        }];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Private Methods
#pragma mark layout
- (void)initViews {
    
    [self.contentView addSubview:self.worldLabel];
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.commentOnLabel];
    [self.contentView addSubview:self.dynamicImageView];
    [self.contentView addSubview:self.dynamicLabel];
    [self.contentView addSubview:self.describeLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.underlineView];
}

- (void)initConstraints {
    
    //封面图大小
    CGFloat coverSize = 44.0f;
    
    [self.worldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(26);
    }];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.worldLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.worldLabel);
        make.width.height.mas_equalTo(coverSize);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView);
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(12);
    }];
    
    [self.commentOnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(self.nameLabel);
    }];
    
    [self.dynamicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverImageView);
        make.left.mas_greaterThanOrEqualTo(self.commentOnLabel).offset(20);
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(60);
    }];
    
    [self.dynamicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.dynamicImageView);
    }];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.nameLabel);
        make.right.mas_lessThanOrEqualTo(self.dynamicImageView.mas_left).offset(-20);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.describeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.nameLabel);
        make.bottom.mas_lessThanOrEqualTo(-20);
    }];
    
    [self.underlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).inset(15);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

/// 配置世界名称
- (void)configWorldName:(NSString *)worldName {
    
    if (worldName == nil || worldName.length == 0) {
        self.worldLabel.hidden = YES;
        return;
    }
    
    self.worldLabel.hidden = NO;
    
    NSString *world = [NSString stringWithFormat:@" %@", worldName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:world];
    attributedString.yy_color = UIColorFromRGB(0xFF838D);
    attributedString.yy_font = [UIFont systemFontOfSize:12];
    
    CALayer *layer = [[CALayer alloc] init];
    layer.contents = (__bridge id)[UIImage imageNamed:@"mine_moment_ico_world"].CGImage;
    layer.bounds = CGRectMake(0, 0, 13, 13);
    layer.contentsGravity = kCAGravityResize;
    layer.contentsScale = [UIScreen mainScreen].scale;
    
    NSMutableAttributedString *iconString = [NSMutableAttributedString yy_attachmentStringWithContent:layer contentMode:UIViewContentModeScaleAspectFit attachmentSize:layer.frame.size alignToFont:[UIFont systemFontOfSize:12.0] alignment:YYTextVerticalAlignmentCenter];
    [attributedString insertAttributedString:iconString atIndex:0];
    
    NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"  "];
    [attributedString insertAttributedString:placeholder atIndex:0];
    [attributedString appendAttributedString:placeholder];
    
    self.worldLabel.attributedText = attributedString;
}

/// 格式化时间字符串
/// @param timeStamp 时间戳
- (NSString *)dateFormatterWithTime:(NSString *)timeStamp {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp.floatValue/1000];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

#pragma mark - Action
- (void)didTapCoverImageView {
    !self.avatarActionHandler ?: self.avatarActionHandler();
}

#pragma mark - Getters and Setters
- (void)setModel:(DynamicMessage *)model {
    _model = model;
    
    [self.coverImageView qn_setImageImageWithUrl:model.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
    [self.dynamicImageView qn_setImageImageWithUrl:model.dynamicRes.resUrl placeholderImage:XCTheme.defaultTheme.default_empty type:ImageTypeUserLibary];

    [self configWorldName:model.worldName];
    self.describeLabel.text = model.message;
    self.timeLabel.text = [self dateFormatterWithTime:model.publishTime];
    self.dynamicLabel.text = model.content;

    NSMutableAttributedString *nameAttributed = [BaseAttrbutedStringHandler nickGenderAgeAttributedStringWithNick:model.nick gender:(UserGender)model.gender age:model.age];
    self.nameLabel.attributedText = nameAttributed;
    
    BOOL isComment = model.actionType == 1;
    self.commentOnLabel.text = isComment ? @"评论了你" : @"";
    
    BOOL isText = model.type == 0;
    self.dynamicImageView.hidden = isText;
    self.dynamicLabel.hidden = !isText;
}

- (UIImageView *)coverImageView {
    if (_coverImageView == nil) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.layer.cornerRadius = 22;
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.image = [UIImage imageNamed:[XCTheme defaultTheme].placeholder_image_square];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCoverImageView)];
        [_coverImageView addGestureRecognizer:tap];
    }
    return _coverImageView;
}

- (YYLabel *)worldLabel {
    if (_worldLabel == nil) {
        _worldLabel = [[YYLabel alloc] init];
        _worldLabel.layer.cornerRadius = 13;
        _worldLabel.layer.masksToBounds = YES;
        _worldLabel.backgroundColor = UIColorRGBAlpha(0xFF838D, 0.1);
    }
    return _worldLabel;
}

- (YYLabel *)nameLabel {
    if (_nameLabel == nil) {
        YYLabel *label = [[YYLabel alloc] init];
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        label.font = [UIFont systemFontOfSize:15];
        
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UILabel *)commentOnLabel {
    if (_commentOnLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        label.font = [UIFont systemFontOfSize:15];
        
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        _commentOnLabel = label;
    }
    return _commentOnLabel;
}

- (UIImageView *)dynamicImageView {
    if (_dynamicImageView == nil) {
        _dynamicImageView = [[UIImageView alloc] init];
        _dynamicImageView.layer.cornerRadius = 8;
        _dynamicImageView.layer.masksToBounds = YES;
        _dynamicImageView.contentMode = UIViewContentModeScaleAspectFill;
        _dynamicImageView.image = [UIImage imageNamed:[XCTheme defaultTheme].placeholder_image_square];
    }
    return _dynamicImageView;
}

- (UILabel *)dynamicLabel {
    if (_dynamicLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0xB3AFAF);
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 0;
        
        _dynamicLabel = label;
    }
    return _dynamicLabel;
}

- (UILabel *)describeLabel {
    if (_describeLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [XCTheme getTTMainTextColor];
        label.font = [UIFont systemFontOfSize:15];
        
        _describeLabel = label;
    }
    return _describeLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        label.font = [UIFont systemFontOfSize:12];
        
        _timeLabel = label;
    }
    return _timeLabel;
}

- (UIView *)underlineView {
    if (_underlineView == nil) {
        _underlineView = [[UIView alloc] init];
        _underlineView.backgroundColor = UIColorFromRGB(0xF4F4F4);
    }
    return _underlineView;
}

@end

