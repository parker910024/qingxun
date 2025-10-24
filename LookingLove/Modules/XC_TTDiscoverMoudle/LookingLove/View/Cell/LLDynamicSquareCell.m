//
//  LLDynamicSquareCell.m
//  XC_TTDiscoverMoudle
//
//  Created by Lee on 2020/1/7.
//  Copyright © 2020 fengshuo. All rights reserved.
//

#import "LLDynamicSquareCell.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import "CTDynamicModel.h"
#import "LTDynamicCell.h"
#import "LLStatusToolView.h"
#import "LLDynamicLayoutModel.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import "LTDynamicToolView.h"
#import "LTDynamicPictureView.h"
#import "CTDynamicModel.h"
#import "M80AttributedLabel+NIMKit.h"
#import <SDWebImage/UIImageView+WebCache.h>


//#import "KETranslateTool.h"
//#import "NSString+Language.h"
#import "UIImageView+QiNiu.h"
#import "LTDynamicCommentsView.h"
#import "M80AttributedLabel+NIMKit.h"

#import "KEMenuItemTool.h"
#import "KEReportController.h"
#import "XCCurrentVCStackManager.h"
#import "XCTheme.h"
#import "XCMacros.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import "AuthCore.h"
#import <YYImage/YYAnimatedImageView.h>
#import <YYText/YYText.h>
#import "BaseAttrbutedStringHandler+TTDynamicInfo.h"
#import "PLTimeUtil.h"
#import "UIButton+EnlargeTouchArea.h"
#import "SpriteSheetImageManager.h"
#import "TTNobleSourceHelper.h"
#import "LLProfileView.h"
#import "LTDynamicPictureView.h"
#import "AnchorOrderCoundownView.h"
#import "TTStatisticsService.h"

@interface LLDynamicSquareCell ()
//展开/收起 button
@property (nonatomic, strong) UIButton *openUpBtn;
//图片内容
@property (nonatomic, strong) LTDynamicPictureView *pictureView;
// 内容
@property (nonatomic, strong) YYLabel *messageLabel;
// 头部
@property (nonatomic, strong) LLProfileView *profileView;
@property (nonatomic, strong) LLStatusToolView *worldView;
///底部点赞、评论view
@property (nonatomic, strong) LTDynamicToolView *toolView;
// 分割view
@property (nonatomic, strong) UIView *lineView;
// 主播订单倒计时
@property (nonatomic, strong) AnchorOrderCoundownView *orderCountdownView;

@end

@implementation LLDynamicSquareCell

#pragma mark - lifeCyle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
        self.backgroundColor = UIColorFromRGB(0xFAFAFA);
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
        [self initConstraints];
        self.backgroundColor = UIColorFromRGB(0xFAFAFA);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)initViews {
    [self.contentView addSubview:self.profileView];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.pictureView];
    [self.contentView addSubview:self.toolView];
    [self.contentView addSubview:self.openUpBtn];
    [self.contentView addSubview:self.worldView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.orderCountdownView];
}

- (void)initConstraints {
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(15, 20, 0, 20));
    }];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    //设置圆角
    CGSize radio = CGSizeMake(8, 8);

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:radio];
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];
    masklayer.frame = self.contentView.bounds;
    masklayer.path = path.CGPath;
    self.contentView.layer.mask = masklayer;
}

- (void)setLayout:(LLDynamicLayoutModel *)layout {
    _layout = layout;
    
    // head
    self.profileView.layout = layout;
    // text
    self.messageLabel.frame = layout.textF;
    self.openUpBtn.frame = layout.openUpBtnF;
    // pics
    self.pictureView.frame = layout.sudokuPicsF;
    // 主播订单倒计时
    self.orderCountdownView.frame = layout.orderBarF;
    // tool
    self.toolView.frame = layout.toolBarF;
    
    self.openUpBtn.selected = layout.dynamicModel.isOpenUp;
    self.messageLabel.attributedText = [BaseAttrbutedStringHandler creatFirstDynamicIcon_content:layout.dynamicModel];

    // 主播订单倒计时
    self.orderCountdownView.hidden = !layout.dynamicModel.workOrder;
    self.orderCountdownView.order = layout.dynamicModel.workOrder;
    
    self.pictureView.imageUrls = layout.dynamicModel.dynamicResList;
    self.toolView.dynamicModel = layout.dynamicModel;
    
    self.worldView.layout = layout;
    // tool
    self.toolView.dynamicModel = layout.dynamicModel;
    self.toolView.hidden = layout.dynamicModel.worldId <= 0;
    // lineView
    self.lineView.frame = CGRectMake(0, layout.rowHeight - 10, KScreenWidth, 0);
}

- (void)didClickOpenUpButton:(UIButton *)button {
    !self.openUpBlock ? : self.openUpBlock();
}

- (LLProfileView *)profileView {
    if (!_profileView) {
        _profileView = [[LLProfileView alloc] init];
        
        @weakify(self);
        _profileView.clickHandler = ^(ProfileViewActionType type) {
            @strongify(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectProfileAtCellLayoutModel:actionType:)]) {
                [self.delegate didSelectProfileAtCellLayoutModel:self.layout actionType:type];
            }
        };
    }
    return _profileView;
}

- (YYLabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[YYLabel alloc] init];
        _messageLabel.fadeOnHighlight = NO;
        _messageLabel.displaysAsynchronously = YES;
        _messageLabel.fadeOnAsynchronouslyDisplay = NO;
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:15];
    }
    return _messageLabel;
}

- (LTDynamicPictureView *)pictureView {
    if (!_pictureView) {
        _pictureView = [[LTDynamicPictureView alloc] initWithStyle:LLDynamicPicViewStyleLittleWorld];
        
        @weakify(self)
        _pictureView.didTapEmptyAreaHandler = ^{
            @strongify(self)
            !self.albumEmptyAreaHandler ?: self.albumEmptyAreaHandler();
        };
    }
    return _pictureView;
}

- (LLStatusToolView *)worldView {
    if (!_worldView) {
        _worldView = [[LLStatusToolView alloc] init];
    }
    return _worldView;
}

- (LTDynamicToolView *)toolView {
    if (!_toolView) {
        _toolView = [[LTDynamicToolView alloc]init];
        @weakify(self);
        _toolView.clickHandler = ^(ToolViewActionType type) {
            @strongify(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectToolBarViewAtCellLayoutModel:actionType:toolView:)]) {
                [self.delegate didSelectToolBarViewAtCellLayoutModel:self.layout actionType:type toolView:self.toolView];
            }
        };
    }
    return _toolView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xF3F2F5);
    }
    return _lineView;
}
- (UIButton *)openUpBtn {
    if (!_openUpBtn) {
        _openUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openUpBtn setTitle:@"展开" forState:UIControlStateNormal];
        [_openUpBtn setTitle:@"收起" forState:UIControlStateSelected];
        [_openUpBtn setTitleColor:XCThemeSubTextColor forState:UIControlStateNormal];
        _openUpBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_openUpBtn setBackgroundColor:UIColorFromRGB(0xF3F2F5)];
        [_openUpBtn addTarget:self action:@selector(didClickOpenUpButton:) forControlEvents:UIControlEventTouchUpInside];
        [_openUpBtn setEnlargeEdgeWithTop:15 right:15 bottom:0 left:15];
        _openUpBtn.layer.cornerRadius = 4;
        _openUpBtn.layer.masksToBounds = YES;
    }
    return _openUpBtn;
}

- (AnchorOrderCoundownView *)orderCountdownView {
    if (_orderCountdownView == nil) {
        _orderCountdownView = [[AnchorOrderCoundownView alloc] init];
        
        @weakify(self)
        [_orderCountdownView tapOrderHandler:^{
            
            [TTStatisticsService trackEvent:@"world_moment_chat" eventDescribe:@"接单信息"];

            @strongify(self)
            if ([self.delegate respondsToSelector:@selector(didSelectProfileAtCellLayoutModel:actionType:)]) {
                [self.delegate didSelectProfileAtCellLayoutModel:self.layout actionType:ProfileViewActionTypeAnchorChat];
            }
        }];
        [_orderCountdownView tapMarkHandler:^{
            
            [TTStatisticsService trackEvent:@"world_order_explain" eventDescribe:@"广场动态列表"];

            @strongify(self)
            if ([self.delegate respondsToSelector:@selector(didSelectProfileAtCellLayoutModel:actionType:)]) {
                [self.delegate didSelectProfileAtCellLayoutModel:self.layout actionType:ProfileViewActionTypeAnchorMark];
            }
        }];
    }
    return _orderCountdownView;
}

@end
