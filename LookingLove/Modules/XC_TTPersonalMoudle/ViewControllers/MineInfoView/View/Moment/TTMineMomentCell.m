//
//  TTMineMomentCell.m
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/11/25.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTMineMomentCell.h"
#import "TTMineMomentOperateView.h"
#import "TTMineMomentTimelineView.h"
#import "TTMineMomentResourceContainerView.h"
#import "AnchorOrderCoundownView.h"

#import "BaseAttrbutedStringHandler+TTDynamicInfo.h"

#import "XCTheme.h"
#import "XCMacros.h"

#import <Masonry/Masonry.h>
#import <YYText/YYLabel.h>
#import <YYText/YYText.h>

static CGFloat const kOperateViewHeight = 58.0f;
static CGFloat const kContentUnfoldHeight = 120.0f;

@interface TTMineMomentCell ()
@property (nonatomic, strong) TTMineMomentOperateView *operateView;//底部操作视图
@property (nonatomic, strong) TTMineMomentTimelineView *timelineView;//时间线
@property (nonatomic, strong) TTMineMomentResourceContainerView *containerView;//资源容器

@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) YYLabel *worldLabel;//小世界
@property (nonatomic, strong) UILabel *contentLabel;//内容文案
@property (nonatomic, strong) UIButton *foldButton;//展开折叠按钮
@property (nonatomic, strong) AnchorOrderCoundownView *orderCountdownView;// 主播订单倒计时
@property (nonatomic, strong) UIView *underlineView;//底部分隔线

@property (nonatomic, assign) BOOL hidenOperateView;//是否隐藏操作视图，default:NO

@end

@implementation TTMineMomentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initViews];
        [self initConstraints];
        
        @weakify(self)
        [self.worldLabel setTextTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {

            @strongify(self)
            !self.worldBlock ?: self.worldBlock();
        }];
    }
    return self;
}

#pragma mark - Layout
- (void)initViews {
    [self.contentView addSubview:self.timelineView];
    [self.contentView addSubview:self.operateView];
    [self.contentView addSubview:self.containerView];
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.worldLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.underlineView];
    [self.contentView addSubview:self.foldButton];
    [self.contentView addSubview:self.orderCountdownView];
}

- (void)initConstraints {
    [self.timelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timelineView.mas_right).offset(8);
//        make.centerY.mas_equalTo(self.timelineView.iconImageView);
        make.centerY.mas_equalTo(self.contentView.mas_top).offset(16);
    }];
    
    [self.worldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.timeLabel);
        make.left.mas_greaterThanOrEqualTo(self.timeLabel.mas_right).offset(20);
        make.height.mas_equalTo(26);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(24);
        make.left.mas_equalTo(self.timeLabel);
        make.right.mas_equalTo(self.worldLabel);
        make.height.mas_equalTo(0);
    }];
    
    [self.foldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(self.timeLabel);
        make.height.mas_equalTo(0);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.foldButton.mas_bottom).offset(12);
        make.left.mas_equalTo(self.timeLabel);
        make.right.mas_equalTo(self.underlineView);
        make.height.mas_equalTo(0);
    }];
    
    [self.orderCountdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.timeLabel);
        make.right.mas_equalTo(self.underlineView);
        make.height.mas_equalTo(0);
    }];
    
    [self.operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderCountdownView.mas_bottom);
        make.left.mas_equalTo(self.timeLabel);
        make.right.mas_equalTo(self.underlineView);
        make.height.mas_equalTo(kOperateViewHeight);
    }];
    
    [self.underlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.operateView.mas_bottom);
        make.left.mas_equalTo(self.timeLabel);
        make.bottom.mas_equalTo(-22);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - Public
/// 更新点赞按钮状态
- (void)updateLikeButtonStatus {
    [self.operateView likeButtonAnimation];
}

#pragma mark - Action
- (void)didClickLikeButton:(UIButton *)sender {
    !self.likeBlock ?: self.likeBlock();
}

- (void)didClickCommentButton:(UIButton *)sender {
    !self.commentBlock ?: self.commentBlock();
}

- (void)didClickShareButton:(UIButton *)sender {
    !self.shareBlock ?: self.shareBlock();
}

- (void)didClickMoreButton:(UIButton *)sender {
    !self.moreBlock ?: self.moreBlock();
}

- (void)didClickFoldButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.model.fold = sender.selected;
    
    !self.foldBlock ?: self.foldBlock();
}

#pragma mark - Private
/// 配置世界名称
- (void)configWorldName:(NSString *)worldName {
    
    if (worldName == nil || worldName.length == 0) {
        self.worldLabel.hidden = YES;
        return;
    }
    
    self.worldLabel.hidden = NO;
    
    NSString *world = [NSString stringWithFormat:@" %@", worldName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:world];
    attributedString.yy_color = UIColorFromRGB(0x626166);
    attributedString.yy_font = [UIFont systemFontOfSize:13];
    
    CALayer *layer = [[CALayer alloc] init];
    layer.contents = (__bridge id)[UIImage imageNamed:@"littleWorld_Dynamic_typeIcon"].CGImage;
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

/// 配置操作视图
- (void)configOperateView {
    
    self.operateView.model = self.model;
    
    BOOL hidenView = self.model.type == UserMomentTypeGreeting;
    if (self.operateView.hidden == hidenView) {
        return;
    }
    
    self.operateView.hidden = hidenView;
    [self.operateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(hidenView ? CGFLOAT_MIN : kOperateViewHeight);
    }];
}

/// 配置容器视图
- (void)configContainerView {
    
    self.containerView.model = self.model;
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([self.containerView height]);
    }];
}

/// 配置分隔线
- (void)configUnderlineView {
    
    self.operateView.model = self.model;
    
    BOOL hidenView = self.model.type == UserMomentTypeGreeting;
    if (self.underlineView.hidden == hidenView) {
        return;
    }
    
    self.underlineView.hidden = hidenView;
}

/// 配置文本
- (void)configContent {
    
    self.contentLabel.text = self.model.content;
    
    CGFloat txtHeight = [self contentHeight];
    BOOL showfoldButton = txtHeight > kContentUnfoldHeight;
    
    self.foldButton.selected = self.model.fold;
    self.foldButton.hidden = !showfoldButton;
    [self.foldButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(showfoldButton ? 28 : 0);
    }];
    
    if (txtHeight > kContentUnfoldHeight && !self.model.fold) {
        txtHeight = kContentUnfoldHeight;
    }
    
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(txtHeight);
    }];
}

/// 配置主播订单
- (void)configAnchorOrder {
    
    BOOL hasPic = self.model.type == UserMomentTypePic && self.model.dynamicResList.count>0;
    BOOL hasOrder = self.model.workOrder != nil;
    CGFloat interval = hasPic && hasOrder ? 12 : 0;//与图片容器间距

    self.orderCountdownView.order = self.model.workOrder;
    self.orderCountdownView.hidden = !hasOrder;
    
    [self.orderCountdownView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView.mas_bottom).offset(interval);
        make.height.mas_equalTo(hasOrder ? 30 : 0);
    }];
}

/// 文本内容高度
- (CGFloat)contentHeight {
    
    NSDictionary *attrs = @{NSFontAttributeName : self.contentLabel.font};
    CGFloat width = KScreenWidth - 68 - 20;
    CGFloat height = [self.model.content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
    //ceilf函数补足部分高度，避免计算高度不够导致被截行
    return ceilf(height);
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

#pragma mark - Lazy Load
- (void)setModel:(UserMoment *)model {
    _model = model;
    
    self.timelineView.type = model.type;
    self.timeLabel.text = [self dateFormatterWithTime:model.publishTime];
    
    [self configWorldName:model.tag];
    [self configOperateView];
    [self configContainerView];
    [self configUnderlineView];
    [self configContent];
    [self configAnchorOrder];
}

- (void)setHidenTimelineView:(BOOL)hidenTimelineView {
    if (_hidenTimelineView == hidenTimelineView) {
        return;
    }
    
    _hidenTimelineView = hidenTimelineView;
    
    self.timelineView.bottomLine.hidden = hidenTimelineView;
}

- (TTMineMomentOperateView *)operateView {
    if (_operateView == nil) {
        _operateView = [[TTMineMomentOperateView alloc] init];
        [_operateView.likeButton addTarget:self action:@selector(didClickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
        [_operateView.commentButton addTarget:self action:@selector(didClickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
        [_operateView.shareButton addTarget:self action:@selector(didClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
        [_operateView.moreButton addTarget:self action:@selector(didClickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operateView;
}

- (TTMineMomentTimelineView *)timelineView {
    if (_timelineView == nil) {
        _timelineView = [[TTMineMomentTimelineView alloc] init];
    }
    return _timelineView;
}

- (TTMineMomentResourceContainerView *)containerView {
    if (_containerView == nil) {
        _containerView = [[TTMineMomentResourceContainerView alloc] init];
    }
    return _containerView;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(0xb3b3b3);
        _timeLabel.font = [UIFont systemFontOfSize:12];
        
        [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = XCThemeMainTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIButton *)foldButton {
    if (_foldButton == nil) {
        _foldButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_foldButton setTitle:@"展开" forState:UIControlStateNormal];
        [_foldButton setTitle:@"收起" forState:UIControlStateSelected];
        [_foldButton setTitleColor:UIColorFromRGB(0x34A7FF) forState:UIControlStateNormal];
        [_foldButton setTitleColor:UIColorFromRGB(0x34A7FF) forState:UIControlStateSelected];
        _foldButton.titleLabel.font = [UIFont systemFontOfSize:15];

        [_foldButton addTarget:self action:@selector(didClickFoldButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _foldButton;
}

- (YYLabel *)worldLabel {
    if (_worldLabel == nil) {
        _worldLabel = [[YYLabel alloc] init];
        _worldLabel.layer.cornerRadius = 6;
        _worldLabel.layer.masksToBounds = YES;
        _worldLabel.backgroundColor = UIColorRGBAlpha(0xF3F2F5, 1);
    }
    return _worldLabel;
}

- (UIView *)underlineView {
    if (_underlineView == nil) {
        _underlineView = [[UIView alloc] init];
        _underlineView.backgroundColor = UIColorFromRGB(0xf4f4f4);
    }
    return _underlineView;
}

- (AnchorOrderCoundownView *)orderCountdownView {
    if (_orderCountdownView == nil) {
        _orderCountdownView = [[AnchorOrderCoundownView alloc] init];
        
        @weakify(self)
        [_orderCountdownView tapOrderHandler:^{
            @strongify(self)
            !self.tapAnchorOrderHandler ?: self.tapAnchorOrderHandler();
        }];
    }
    return _orderCountdownView;
}

@end
