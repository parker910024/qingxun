//
//  TTRedListView.m
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/5/12.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTRedListView.h"
#import "TTRedListItemView.h"

#import "RoomRedListItem.h"
#import "RoomRedDetail.h"

#import "UIButton+EnlargeTouchArea.h"
#import "NSArray+Safe.h"
#import "XCTheme.h"
#import "BaseAttrbutedStringHandler.h"
#import "TTWKWebViewViewController.h"
#import "XCHtmlUrl.h"
#import "TTStatisticsService.h"

#import <Masonry/Masonry.h>
#import <YYText/YYText.h>

static NSString *const kBgViewRepeatAnimationKey = @"kBgViewRepeatAnimationKey";//背景上下飘动动画

@interface TTRedListView ()
@property (nonatomic, strong) UIView *tapView;


@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;

/// 无数据
@property (nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, strong) UIImageView *emptyImageView;

@property (nonatomic, strong) UIView *detailBgView;
@property (nonatomic, strong) YYLabel *detailLabel;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *markButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *recordButton;

/// 存放红包列表
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) TTRedListItemView *itemView1;//红包1
@property (nonatomic, strong) TTRedListItemView *itemView2;//红包2
@property (nonatomic, strong) TTRedListItemView *itemView3;//红包3

@property (nonatomic, strong) RoomRedDetail *redDetail;//当前红包详情

@property (nonatomic, strong) TTWKWebViewViewController *webVC;//红包说明

@end

@implementation TTRedListView
- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = UIScreen.mainScreen.bounds;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorRGBAlpha(0x0C0C1F, 0.65);

        [self setupUI];
        [self layoutUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.tapView];
    [self addSubview:self.bgImageView];
    [self addSubview:self.closeButton];
    
    [self.bgImageView addSubview:self.bottomImageView];
    [self.bgImageView addSubview:self.topImageView];
    [self.bgImageView addSubview:self.emptyImageView];
    [self.bgImageView addSubview:self.emptyLabel];
    [self.bgImageView addSubview:self.detailBgView];
    [self.detailBgView addSubview:self.detailLabel];
    [self.bgImageView addSubview:self.markButton];
    [self.bgImageView addSubview:self.sendButton];
    [self.bgImageView addSubview:self.recordButton];
    [self.bgImageView addSubview:self.stackView];
    [self.bgImageView addSubview:self.webVC.view];
}

- (void)layoutUI {
    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(295);
        make.height.mas_equalTo(385);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(25);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.right.mas_equalTo(0);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(54);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(150);
    }];
    
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.emptyImageView.mas_top).offset(120);
    }];
    
    [self.detailBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.right.mas_equalTo(self.bgImageView).inset(20);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.detailBgView).inset(8);
        make.left.right.mas_equalTo(self.detailBgView).inset(0);
    }];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(116);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.width.height.mas_equalTo(16);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomImageView);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(100);
    }];
    
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sendButton.mas_bottom).offset(0);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.webVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - Action
- (void)didClickCloseButton {
    [self action:TTRedListViewActionClose];
    
    if (!self.webVC.view.isHidden) {
        self.webVC.view.hidden = YES;
    }
    
    //关闭视图后结束动画
    [self endAnimation];
}

- (void)didClickMarkButton {
    self.webVC.view.hidden = NO;
    
    [TTStatisticsService trackEvent:@"room_red_paper_rule" eventDescribe:@"红包_红包规则"];
}

- (void)didClickSendButton {
    [self action:TTRedListViewActionSend];
}

- (void)didClickRecordButton {
    [self action:TTRedListViewActionRecord];
}

- (void)action:(TTRedListViewAction)action {
    if ([self.delegate respondsToSelector:@selector(redListView:didAction:)]) {
        [self.delegate redListView:self didAction:action];
    }
}

- (void)didTapView {
    [self endEditing:YES];
}

/// 关注
- (void)didClickFocusButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(redListView:focus:)]) {
        [self.delegate redListView:self focus:self.redDetail];
    }
}

#pragma mark - Private
- (NSMutableAttributedString *)redInfoAttributedString:(RoomRedDetail *)red {
    if (!red) {
        return nil;
    }
    
    NSString *who = [NSString stringWithFormat:@"%@ 的红包", red.nick];
    NSString *time = [self timeWithStamp:red.startTime];
    NSString *when = [NSString stringWithFormat:@"%@ 开抢", time];
    NSString *what = [NSString stringWithFormat:@"抢红包条件：%@", red.requirementDesc];
    NSMutableString *content = [NSMutableString stringWithFormat:@"%@\n%@", who, when];
    if (red.requirement != 0) {
        [content appendFormat:@"\n%@", what];
    }
    
    NSRange nickRange = [content rangeOfString:red.nick];
    NSRange timeRange = [content rangeOfString:red.startTime];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
    str.yy_font = [UIFont systemFontOfSize:12];
    str.yy_color = [UIColor.whiteColor colorWithAlphaComponent:0.8];
    str.yy_alignment = NSTextAlignmentCenter;
    [str yy_setColor:UIColorFromRGB(0xFFD961) range:nickRange];
    [str yy_setColor:UIColorFromRGB(0xFFD961) range:timeRange];
    
    if (red.requirement != 0) {
        if (!red.reachRequirement) {
            [str appendAttributedString:[BaseAttrbutedStringHandler placeholderAttributedString:4]];
        }
        
        [str appendAttributedString:[self focusAttributedString:red.reachRequirement]];
    }
    
    str.yy_lineSpacing = 5;
    
    return str;
}

- (NSAttributedString *)focusAttributedString:(BOOL)reachRequirement {
    if (reachRequirement) {
        return [[NSAttributedString alloc] initWithString:@"（已满足）" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFFD961)}];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 45, 20);
    [button setTitle:@"关注" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xFF3E3D) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    button.backgroundColor = UIColorFromRGB(0xFFD961);
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(didClickFocusButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString *str = [NSMutableAttributedString yy_attachmentStringWithContent:button contentMode:UIViewContentModeScaleAspectFit attachmentSize:button.frame.size alignToFont:[UIFont systemFontOfSize:12.0] alignment:YYTextVerticalAlignmentCenter];
    return str.copy;
}

/// 通过时间戳返回分秒
- (NSString *)timeWithStamp:(NSString *)timeStamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp.doubleValue/1000];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

#pragma mark - Public
/// 显示一个红包详情
- (void)showRed:(RoomRedDetail *)red {
    
    self.redDetail = red;
    
    self.detailBgView.hidden = !red;
    
    if (red) {
        self.detailLabel.attributedText = [self redInfoAttributedString:red];
    }
}

/// 显示动画
- (void)showAnimation {

    self.alpha = 0;
    self.bgImageView.transform = CGAffineTransformMakeScale(0.96, 0.96);
    
    [UIView animateKeyframesWithDuration:1.1 delay:0.0
    options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        //启动缩放关键帧
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.2 animations:^{
            self.alpha = 1;
        }];
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.4 animations:^{
            self.bgImageView.transform = CGAffineTransformMakeScale(1.02, 1.02);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.4 animations:^{
            self.bgImageView.transform = CGAffineTransformMakeScale(0.98, 0.98);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.3 animations:^{
            self.bgImageView.transform = CGAffineTransformMakeScale(1, 1);
        }];
        
    } completion:^(BOOL finished) {
        //循环上下浮动
        CABasicAnimation *posAni = [CABasicAnimation animationWithKeyPath:@"position"];
        posAni.fromValue = [NSValue valueWithCGPoint:self.bgImageView.center];
        posAni.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bgImageView.center.x, self.bgImageView.center.y+10)];
        posAni.repeatCount = CGFLOAT_MAX;
        posAni.autoreverses = YES;
        posAni.duration = 2;
        posAni.removedOnCompletion = NO;
        [self.bgImageView.layer addAnimation:posAni forKey:kBgViewRepeatAnimationKey];
    }];
}

/// 结束动画
- (void)endAnimation {
    
    //设置结束状态，准备下一次展现初始化状态
    self.alpha = 0;
    self.bgImageView.transform = CGAffineTransformMakeScale(0.96, 0.96);
    
    //因为 removedOnCompletion = NO，需手动移除，否者view不能销毁
    [self.bgImageView.layer removeAnimationForKey:kBgViewRepeatAnimationKey];
}

#pragma mark - Lazy Load
- (void)setDataArray:(NSArray<RoomRedListItem *> *)dataArray {
    _dataArray = dataArray;
    
    //初始化清空详情
    [self showRed:nil];
    
    BOOL empty = !dataArray || dataArray.count == 0;
    self.emptyImageView.hidden = !empty;
    self.emptyLabel.hidden = !empty;
    self.stackView.hidden = empty;
    
    RoomRedListItem *item0 = [dataArray safeObjectAtIndex:0];
    RoomRedListItem *item1 = [dataArray safeObjectAtIndex:1];
    RoomRedListItem *item2 = [dataArray safeObjectAtIndex:2];
    self.itemView1.model = item0;
    self.itemView2.model = item1;
    self.itemView3.model = item2;
}

- (void)setDelegate:(id<TTRedListViewDelegate,TTRedListItemViewDelegate>)delegate {
    _delegate = delegate;
    
    self.itemView1.delegate = delegate;
    self.itemView2.delegate = delegate;
    self.itemView3.delegate = delegate;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_red_list_bg"]];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UIImageView *)topImageView {
    if (_topImageView == nil) {
        _topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_red_list_bg_top"]];
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView {
    if (_bottomImageView == nil) {
        _bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_red_list_bg_bottom"]];
    }
    return _bottomImageView;
}

- (UIImageView *)emptyImageView {
    if (_emptyImageView == nil) {
        _emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_red_list_empty"]];
    }
    return _emptyImageView;
}

- (UILabel *)emptyLabel {
    if (_emptyLabel == nil) {
        _emptyLabel = [[UILabel alloc] init];
        _emptyLabel.text = @"暂无可抢的红包哦~";
        _emptyLabel.font = [UIFont systemFontOfSize:13];
        _emptyLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.3];
    }
    return _emptyLabel;
}

- (UIView *)detailBgView {
    if (_detailBgView == nil) {
        _detailBgView = [[UIView alloc] init];
        _detailBgView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.05];
        _detailBgView.layer.cornerRadius = 12;
        _detailBgView.layer.masksToBounds = YES;
        
        _detailBgView.hidden = YES;
    }
    return _detailBgView;
}

- (YYLabel *)detailLabel {
    if (_detailLabel == nil) {
        _detailLabel = [[YYLabel alloc] init];
        _detailLabel.numberOfLines = 0;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"room_red_list_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(didClickCloseButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_closeButton enlargeTouchArea:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _closeButton;
}

- (UIButton *)markButton {
    if (_markButton == nil) {
        _markButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_markButton setImage:[UIImage imageNamed:@"room_red_list_mark"] forState:UIControlStateNormal];
        [_markButton addTarget:self action:@selector(didClickMarkButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_markButton enlargeTouchArea:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _markButton;
}

- (UIButton *)sendButton {
    if (_sendButton == nil) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setImage:[UIImage imageNamed:@"room_red_list_send"] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(didClickSendButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UIButton *)recordButton {
    if (_recordButton == nil) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton setTitle:@"红包记录>" forState:UIControlStateNormal];
        [_recordButton setTitleColor:UIColorFromRGB(0xFFBF48) forState:UIControlStateNormal];
        _recordButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_recordButton addTarget:self action:@selector(didClickRecordButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_recordButton enlargeTouchArea:UIEdgeInsetsMake(4, 4, 4, 4)];
    }
    return _recordButton;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.itemView1, self.itemView2, self.itemView3]];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.alignment = UIStackViewAlignmentLeading;
        _stackView.spacing = 0;
    }
    return _stackView;
}

- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [UIView new];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
        [_tapView addGestureRecognizer:tapGR];
    }
    return _tapView;
}

- (TTRedListItemView *)itemView1 {
    if (_itemView1 == nil) {
        _itemView1 = [[TTRedListItemView alloc] init];
    }
    return _itemView1;
}

- (TTRedListItemView *)itemView2 {
    if (_itemView2 == nil) {
        _itemView2 = [[TTRedListItemView alloc] init];
    }
    return _itemView2;
}

- (TTRedListItemView *)itemView3 {
    if (_itemView3 == nil) {
        _itemView3 = [[TTRedListItemView alloc] init];
    }
    return _itemView3;
}

- (TTWKWebViewViewController *)webVC {
    if (_webVC == nil) {
        _webVC = [[TTWKWebViewViewController alloc] init];
        _webVC.view.layer.cornerRadius = 12;
        _webVC.view.layer.masksToBounds = YES;
        _webVC.view.backgroundColor = UIColor.clearColor;
        _webVC.webview.opaque = NO;
        _webVC.webview.backgroundColor = UIColor.whiteColor;
        _webVC.webview.scrollView.backgroundColor = UIColor.clearColor;
        _webVC.webview.scrollView.bounces = NO;
        _webVC.urlString = HtmlUrlKey(kRedRuleURL);
        _webVC.view.hidden = YES;
        
        __weak typeof(self) weakSelf = self;
        _webVC.dismissRequestHandler = ^{
            weakSelf.webVC.view.hidden = YES;
        };
        
        _webVC.urlLoadCompletedHandler = ^(BOOL result, NSError *error) {
            
            UIColor *aimColor = result ? UIColor.clearColor : UIColor.whiteColor;
            if (weakSelf.webVC.webview.backgroundColor != aimColor) {
                weakSelf.webVC.webview.backgroundColor = aimColor;
            }
        };
    }
    return _webVC;
}

@end
