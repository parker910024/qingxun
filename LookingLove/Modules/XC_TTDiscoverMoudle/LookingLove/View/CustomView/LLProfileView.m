//
//  LLProfileView.m
//  XC_TTDiscoverMoudle
//
//  Created by Lee on 2020/1/7.
//  Copyright © 2020 fengshuo. All rights reserved.
//

#import "LLProfileView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import <YYText/YYLabel.h>
#import "SpriteSheetImageManager.h"
#import "TTNobleSourceHelper.h"
#import <YYWebImage/YYWebImage.h>
#import "LLDynamicLayoutModel.h"
#import "CTDynamicModel.h"
#import "UIImageView+QiNiu.h"
#import "BaseAttrbutedStringHandler+TTDynamicInfo.h"
#import "UIButton+EnlargeTouchArea.h"
#import <YYText/YYText.h>
#import "NSString+Utils.h"
#import "AuthCore.h"
#import "TTStatisticsService.h"

@interface LLProfileView ()
// 昵称
@property (nonatomic,strong) YYLabel *nameLabel;
// 时间
@property (nonatomic,strong) YYLabel *dateSourceLabel;
// 主播标签
@property (nonatomic,strong) YYLabel *anchorTagLabel;
// 头像
@property (nonatomic,strong) UIImageView *headImageView;
// 头饰
@property (nonatomic, strong) YYAnimatedImageView *headwearImageView;//
@property (nonatomic, strong) SpriteSheetImageManager *manager;
// 更多按钮
@property (nonatomic, strong) UIButton *chatBtn;

@end


@implementation LLProfileView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initViews];
        [self initConstraints];
        [self addGestureRecognizer];
        
    }
    return self;
}

#pragma mark - lifeCyle

- (void)initViews {
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.dateSourceLabel];
    [self addSubview:self.headwearImageView];
    [self addSubview:self.chatBtn];
    [self addSubview:self.anchorTagLabel];
}

- (void)initConstraints {
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(27);
        make.centerY.mas_equalTo(self.headImageView);
    }];
    
    [self.headwearImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.height.width.mas_equalTo(self.headImageView).multipliedBy(1.31);
       make.center.mas_equalTo(self.headImageView);
    }];
}

- (void)addGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickProfile:)];
    [self.headImageView addGestureRecognizer:tap];
}

- (void)setLayout:(LLDynamicLayoutModel *)layout {
    _layout = layout;
    // frame
    self.frame = layout.profileF;
    self.headImageView.frame = layout.AvatarF;
    self.nameLabel.frame = layout.nameF;
    self.dateSourceLabel.frame = layout.dateSourceF;
    self.anchorTagLabel.frame = layout.anchorTagF;
    
    BOOL selfDynamic = [GetCore(AuthCore).getUid isEqualToString:layout.dynamicModel.uid];
    self.chatBtn.hidden = layout.dynamicModel.workOrder == nil || selfDynamic;

    // model
    // 头饰
    [self.headImageView qn_setImageImageWithUrl:layout.dynamicModel.avatar placeholderImage:@"placeholder_image_square" type:ImageTypeUserIcon];//default_bg
    if (layout.dynamicModel.headwearPic) { // 如果有头饰，且使用
        NSURL *url = [NSURL URLWithString:layout.dynamicModel.headwearPic];
        [self.manager loadSpriteSheetImageWithURL:url completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
            self.headwearImageView.image = sprit;
        } failureBlock:^(NSError * _Nullable error) {

        }];
    } else if (layout.dynamicModel.micDecorate) { // 如果有贵族头饰
        [TTNobleSourceHelper disposeImageView:self.headwearImageView withSource:layout.dynamicModel.micDecorate imageType:ImageTypeUserLibary];
    } else {
        self.headwearImageView.image = nil;
    }

    // 昵称
    self.nameLabel.attributedText = [BaseAttrbutedStringHandler creatNick_userAge_charmRank_constellationByDynamicModel:layout.dynamicModel];
    //时间、主播认证
    self.dateSourceLabel.attributedText = [self timeAttributedStringWithTime:layout.timeStr showTime:!layout.isRecommendDynamic cert:layout.dynamicModel.nameplate];
    //主播标签
    self.anchorTagLabel.attributedText = [self anchorTagAttributedStringTags:layout.dynamicModel.tagList];
    self.anchorTagLabel.hidden = layout.dynamicModel.tagList.count == 0;
}

/// 主播标签富文本
/// @param tagList 标签列表
- (NSMutableAttributedString *)anchorTagAttributedStringTags:(NSArray *)tagList {
    
    if (tagList.count == 0) {
        return nil;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    for (NSString *tag in tagList) {
        if (str.length > 0) {
            [str appendAttributedString:[BaseAttrbutedStringHandler placeholderAttributedString:4]];
        }
        NSAttributedString *tagStr = [self tagAttributedString:tag];
        [str appendAttributedString:tagStr];
    }
    
    return str;
}

/// 主播标签富文本
/// @param tag 技能标签
- (NSAttributedString *)tagAttributedString:(NSString *)tag {
    if (tag == nil) {
        return nil;
    }
    
    NSString *content = [NSString stringWithFormat:@"%@", tag];
    UIFont *font = [UIFont systemFontOfSize:10];
    CGFloat width = [NSString sizeWithText:content font:font maxSize:CGSizeMake(200, 30)].width;
    
    width += 10;//边距
    
    UILabel *label = [[UILabel alloc] init];
    label.bounds = CGRectMake(0, 0, width, 15);
    label.font = font;
    label.text = content;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [XCTheme getMainDefaultColor];
    label.layer.cornerRadius = 7.5;
    label.layer.masksToBounds = YES;
    label.backgroundColor = UIColorFromRGB(0xEFFFFE);
    
    NSMutableAttributedString *dateLabelString = [NSMutableAttributedString yy_attachmentStringWithContent:label contentMode:UIViewContentModeScaleAspectFit attachmentSize:label.frame.size alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
    return dateLabelString;
}

/// 时间富文本
/// @param time 时间
/// @param showTime 是否显示时间
/// @param cert 官方主播认证
- (NSMutableAttributedString *)timeAttributedStringWithTime:(NSString *)time showTime:(BOOL)showTime cert:(UserOfficialAnchorCertification *)cert {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    if (cert && cert.fixedWord.length > 0) {
        NSMutableAttributedString *certTag = [BaseAttrbutedStringHandler certificationTagWithName:cert.fixedWord image:cert.iconPic];
        [str appendAttributedString:certTag];
        [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
    }
    
    if (showTime) {
        NSMutableAttributedString *timeStr = [[NSMutableAttributedString alloc] initWithString:time];
        timeStr.yy_font = [UIFont systemFontOfSize:12];
        timeStr.yy_color = UIColorRGBAlpha(0x999999, 1);
        [str appendAttributedString:timeStr];
    }
    
    return str;
}

#pragma mark - Button Events
- (void)didClickChatButton:(UIButton *)menuButton {
    [TTStatisticsService trackEvent:@"world_moment_chat" eventDescribe:@"私聊按钮"];

    !_clickHandler ?: _clickHandler(ProfileViewActionTypeAnchorChat);
}

- (void)didClickProfile:(UITapGestureRecognizer *)tap {
    !_clickHandler ?: _clickHandler(ProfileViewActionTypeProfile);
}

#pragma mark - Getter && Setter
- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.layer.cornerRadius = 45/2;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

- (YYLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[YYLabel alloc]init];
        _nameLabel.textColor = XCThemeMainTextColor;
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _nameLabel.displaysAsynchronously = YES;
        _nameLabel.fadeOnAsynchronouslyDisplay = NO;
        _nameLabel.fadeOnHighlight = NO;
        @weakify(self);
        _nameLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            [self didClickProfile:nil];
        };
    }
    return _nameLabel;
}

- (YYLabel *)dateSourceLabel {
    if (_dateSourceLabel == nil) {
        _dateSourceLabel = [[YYLabel alloc]init];
        _dateSourceLabel.font = [UIFont systemFontOfSize:12];
        _dateSourceLabel.textColor = UIColorRGBAlpha(0x222222, 0.3);
        _dateSourceLabel.displaysAsynchronously = YES;
        _dateSourceLabel.fadeOnAsynchronouslyDisplay = NO;
        _dateSourceLabel.fadeOnHighlight = NO;
    }
    return _dateSourceLabel;
}

- (YYLabel *)anchorTagLabel {
    if (_anchorTagLabel == nil) {
        _anchorTagLabel = [[YYLabel alloc]init];
    }
    return _anchorTagLabel;
}

- (UIButton *)chatBtn{
    if (!_chatBtn) {
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatBtn setTitle:@"私聊" forState:UIControlStateNormal];
        [_chatBtn setTitleColor:[XCTheme getMainDefaultColor] forState:UIControlStateNormal];
        [_chatBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_chatBtn addTarget:self action:@selector(didClickChatButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_chatBtn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
        _chatBtn.layer.cornerRadius = 13.5;
        _chatBtn.layer.masksToBounds = YES;
        _chatBtn.layer.borderColor = [XCTheme getMainDefaultColor].CGColor;
        _chatBtn.layer.borderWidth = 1.f;
    }
    return _chatBtn;
}

- (SpriteSheetImageManager *)manager {
    if (!_manager) {
        _manager = [[SpriteSheetImageManager alloc] init];
    }
    return _manager;
}

- (YYAnimatedImageView *)headwearImageView {
    if (!_headwearImageView) {
        _headwearImageView = [[YYAnimatedImageView alloc] init];
    }
    return _headwearImageView;
}

@end
