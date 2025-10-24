//
//  XCBoxView.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCDiamondBoxMainView.h"
#import "XCDiamondBoxShowView.h"
#import "XCEnergyProgressView.h"
#import "XCBoxGoldView.h"
#import "XCCountdownView.h"
#import "XCKeyFrameAnimationView.h"
#import <POP.h>
#import <Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "XCDiamondBoxBuyLabel.h"
//m
#import "BoxPrizeModel.h"

//t
#import "UIView+XCToast.h"
#import "BaseAttrbutedStringHandler.h"

@interface XCDiamondBoxMainView()<CAAnimationDelegate, XCEnergyProgressViewDelegate, XCDiamondBoxBuyLabelDelegate>

@property (nonatomic, strong) UIImageView *bgImgView;//bg
@property (nonatomic, strong) UIButton *closeButton;//close
@property (nonatomic, strong) XCDiamondBoxShowView *showView;//显示记录 帮助 奖池
@property (nonatomic, strong) UIImageView *boxImgView;//箱子

//@property (nonatomic, strong) XCEnergyProgressView *progressView;// 能量进度条
@property (nonatomic, strong) XCCountdownView *countdownView;// 暴击倒计时的 view
@property (nonatomic, strong) UIImageView *boxSeatImgView;//箱子底座
@property (nonatomic, strong) UIImageView *boxLightArroundView;//箱子底座灯光
@property (nonatomic, strong) UIImageView *boxLightCenterView;//箱子光芒
@property (nonatomic, strong) XCBoxSelecteView *selectedView;//选择开箱子次数
@property (nonatomic, strong) XCDiamondBoxBuyLabel *buyLabel;// 购买
@property (nonatomic, strong) UIButton *openButton;// 自动/暂停
@property (nonatomic, strong) UIButton *tipButton;//是否显示发送通知
@property (nonatomic, strong) XCBoxGoldView *goldView;//gold

@property (nonatomic, assign) XCBoxSelectOpenCountType openCountType;//开奖次数
@property (nonatomic, assign) XCDiamondBoxMainViewMessageTipState state;//是否发中奖消息
@property (strong,nonatomic) NSMutableSet * prizeDequePool;//复用池
@property (strong,nonatomic) NSMutableSet * prizeVisiablePool;//可见池
@property (nonatomic, strong) NSMutableArray *openPrizeQueue;//奖品队列
@property (nonatomic ,strong) dispatch_source_t timer;//扫描队列定时器
@property (nonatomic, assign) BOOL isAnimating;
@end

static int kBOX_WIDTH = 345;

@implementation XCDiamondBoxMainView

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupSubviews];
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.state = XCDiamondBoxMainViewMessageTipStateOpen;
        self.openCountType = XCBoxSelectOpenCountTypeOne;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupSubviewsConstraints];
}

- (void)dealloc{
    NSLog(@"XCDiamondBoxMainView dealloc");
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    [self triggerOpenBoxAnimation];
    BOOL sendMessage = self.state == XCDiamondBoxMainViewMessageTipStateOpen ? YES:NO;
    [self.delegate diamondBoxMainViewOpenBox:self openCountType:XCBoxSelectOpenCountTypeHundred sendMessage:sendMessage];
}

#pragma mark - BuyLabelDelegate

- (void)onDiamondBoxBuyButtonCliked {
    [self.delegate diamondBoxMainView:self eventType:XCDiamondBoxMainViewEventTypeBuyKey];
}

#pragma mark - ProgressViewDelegate

- (void)onEnergyProgressViewLuckyValueQuestionCliked {
    [self.delegate diamondBoxMainView:self eventType:XCDiamondBoxMainViewEventTypeEnergyQuestion];
}

#pragma mark - event response

- (void)tipButtonClick:(UIButton *)tipButton{
    tipButton.selected = !tipButton.selected;
    if (tipButton.selected) {
        self.state = XCDiamondBoxMainViewMessageTipStateClose;
    }else{
        self.state = XCDiamondBoxMainViewMessageTipStateOpen;
    }
    BOOL sendMessage = self.state == XCDiamondBoxMainViewMessageTipStateOpen ? YES:NO;
    [self.delegate diamondBoxMainView:self didChangeMessageTipState:sendMessage];
}

//开箱子
- (void)openButtonClick:(UIButton *)openButton{
    if (self.openCountType == XCBoxSelectOpenCountTypeAuto) {
        [self openBoxAuto];
    }else{
        [self openBoxNormal];
    }
}


- (void)close{
    [self.delegate diamondBoxMainView:self eventType:XCDiamondBoxMainViewEventTypeClose];
    [self.openPrizeQueue removeAllObjects];
    _timer = nil;
}

#pragma mark - 动画
// 序列帧
- (NSArray *)initialImageArray {
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 1; i < 8; i++) {
        NSString *imageName = [NSString stringWithFormat:@"gold_egg_%d", i];
        UIImage *image = [UIImage imageNamed:imageName];
        [imageArray addObject:image];
    }
    return imageArray;
}
// 配置imageview的序列帧动画属性
- (void)ttconfigMainImageView {
    self.boxImgView.animationImages = [self initialImageArray];// 序列帧动画的uiimage数组
    self.boxImgView.animationDuration = 1.2f;// 序列帧全部播放完所用时间
    self.boxImgView.animationRepeatCount = 1;// 序列帧动画重复次数
    [self.boxImgView startAnimating];//开始动画
    [self performSelector:@selector(ttclearImageAnimation) withObject:nil afterDelay:1.3];
}

- (void)ttclearImageAnimation{
    [self.boxImgView stopAnimating];
    self.boxImgView.animationImages = nil;
}

//自动开金蛋 切换的时候 停止
- (void)ttselectButtonChangePuaseAutomatic{
    if (self.openButton.selected) {
        self.openButton.selected = NO;
        [self.delegate diamondBoxMainView:self didChangeAutoOpenState:XCDiamondBoxMainViewAutoOpenBoxStatePause];
        [self performSelector:@selector(resetBox) withObject:nil afterDelay:1.5];
    }
}


#pragma mark - Public Method
/**
 暴击活动开始
 
 @param cirtData 暴击活动模型
 */
- (void)beginCirtActivity:(BoxCirtData *)cirtData{
    [self.countdownView setHidden:NO];
}

/**
 暴击活动结束
 */
- (void)endCirtActivity{
    [self.countdownView setHidden:YES];
    [self.countdownView stopCountdown];
}

- (void)stopOpenAnimation {
    [self.boxImgView.layer removeAllAnimations];
}

- (void)updateKey:(int)count{
    [self.buyLabel updateKeyNumber:count];
}

- (void)updateGold:(NSString *)gold {
    self.goldView.goldLabel.text = [NSString stringWithFormat:@"%.2f", gold.floatValue];
}

- (void)resetBox{
    self.boxImgView.image = [UIImage imageNamed:@"room_diamond_box_icon"];
}

- (void)updateBoxState:(NSArray *)boxPrizes type:(XCBoxOpenBoxType)type{
    [self ttconfigMainImageView];
    
    for (BoxPrizeModel *prizeInfo in boxPrizes) {
        [self.openPrizeQueue addObject:prizeInfo];
    }
    if (self.timer== nil) {
        [self performSelector:@selector(startPrizeQueueScanner) withObject:nil afterDelay:1.2];
    }
    if (type==XCBoxOpenBoxType_Manual) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self resetBox];
        });
    }
}

- (void)updateBg:(NSString *)bgUrl{
    [self.bgImgView qn_setImageImageWithUrl:bgUrl placeholderImage:@"room_box_bg" type:ImageTypeUserLibaryDetail];
}

- (void)resetAutoOpenBoxStatue{
    dispatch_main_sync_safe(^{
        self.openButton.selected = NO;
    });
}

- (void)updateTimeLeft:(int)timeLeft {
    if (timeLeft == 0) {
        [self.countdownView setHidden:YES];
        return;
    }
    if (self.countdownView.hidden) {
        [self.countdownView setHidden:NO];
    }
    [self.countdownView updateTimeLeft:timeLeft];
}

- (void)updateLuckyValueExpireDays:(int )days {
//    self.boxTips.attributedText = [self createValueAttributeString:[NSString stringWithFormat:@"%d", days]];
}

- (void)updateProgress:(CGFloat)value {
//    [self.progressView setProgressValue:value];
}

- (void)updateProgressWithRanges:(NSArray <NSNumber *> *)ranges; {
//    [self.progressView updateProgressWithRanges:ranges];
}

- (void)cleanProgressBoxView {
//    [self.progressView removeBoxView];
}

- (void)stopCountdown {
    [self.countdownView stopCountdown];
}

#pragma mark - Private

//- (NSAttributedString *)createValueAttributeString:(NSString *)luckyValue {
//    NSDictionary *valueAttribute = @{NSForegroundColorAttributeName:UIColorFromRGB(0xFFC909)};
//    NSDictionary *defaultAttribute = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
//    [attributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"开箱越多，幸运值越高。当前幸运值" attributes:defaultAttribute]];
//    [attributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:luckyValue attributes:valueAttribute]];
//    [attributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"天后清零" attributes:defaultAttribute]];
//    return attributedString;
//}


/// 开宝箱的动画
- (void)triggerOpenBoxAnimation {
    
    XCKeyFrameAnimationView *animImageView = [[XCKeyFrameAnimationView alloc] initWithFrame:self.boxImgView.frame];
    animImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self addSubview:animImageView];
    [self insertSubview:animImageView aboveSubview:self.boxImgView];
    
    __block NSMutableArray * imageArray = [NSMutableArray array];
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool{
            for (int i = 1; i<=18; i++) {
                
                NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"room_diamond_box_open_effect_%02d",i] ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:filePath];
                if (image) {
                    [imageArray addObject:image];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            animImageView.animationImages = imageArray;
            animImageView.animationDuration = 1.8;
            animImageView.animationRepeatCount = 1;
            [animImageView startAnimating];
            
            [self performSelector:@selector(openBoxAnimationDidFinish:) withObject:animImageView afterDelay:(animImageView.animationDuration+0.1)];
        });
    });
}

- (void)openBoxAnimationDidFinish:(XCKeyFrameAnimationView *)animImageView {
    [animImageView removeFromSuperview];
    animImageView = nil;
    [self.boxImgView setHidden:NO];
}

/**
 暴击动画
 */
- (void)triggerCirtAnimation{
    
    XCKeyFrameAnimationView *animImageView = [[XCKeyFrameAnimationView alloc] initWithFrame:self.boxImgView.frame];
    [self insertSubview:animImageView belowSubview:self.boxImgView];
    
    __block NSMutableArray * imageArray = [NSMutableArray array];
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool{
            for (int i = 1; i<28; i++) {
                
                NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"baoji_%02d",i] ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:filePath];
                if (image) {
                    [imageArray addObject:image];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            animImageView.animationImages = imageArray;
            animImageView.animationDuration = 1.68;
            animImageView.animationRepeatCount = 1;
            [animImageView startAnimating];
            
            [self performSelector:@selector(cirtAniationDidFinish:) withObject:animImageView afterDelay:(animImageView.animationDuration+0.1)];
        });
    });
}

- (void)cirtAniationDidFinish:(XCKeyFrameAnimationView *)animImageView {
    
    [animImageView removeFromSuperview];
    animImageView = nil;
}

//自动开箱子
- (void)openBoxAuto {
    
    self.openButton.selected = !self.openButton.selected;
    XCDiamondBoxMainViewAutoOpenBoxState state;
    if (self.openButton.selected) {
        state = XCDiamondBoxMainViewAutoOpenBoxStateStart;
    }else{
        state = XCDiamondBoxMainViewAutoOpenBoxStatePause;
    }
    [self.delegate diamondBoxMainView:self didChangeAutoOpenState:state];
}
//开箱子固定次数
- (void)openBoxNormal {
    BOOL sendMessage = self.state == XCDiamondBoxMainViewMessageTipStateOpen ? YES:NO;
    
    if (self.openCountType == XCBoxSelectOpenCountTypeHundred) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"transform.rotation.z";
        animation.values = @[@0,@(-M_PI/12),@0,@(M_PI/12),@0];
        animation.duration = 0.25;
        animation.repeatCount = 4;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self;
        self.boxImgView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        [self.boxImgView.layer addAnimation:animation forKey:@"animation"];
    }else{
        [self.delegate diamondBoxMainViewOpenBox:self openCountType:self.openCountType sendMessage:sendMessage];
    }
}
//扫描奖品队列
- (void)startPrizeQueueScanner {
    NSTimeInterval period = 0.2;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self);
        if (self.openPrizeQueue.count > 0) {
            @weakify(self);
            dispatch_sync(dispatch_get_main_queue(), ^{
                @strongify(self);
                BoxPrizeModel * info = self.openPrizeQueue.firstObject;
                [self createPrizeAnimation:info];
                [self.openPrizeQueue removeObject:info];
            });
            
        } else {
            dispatch_source_cancel(_timer);
            self.timer = nil;
        }
    });
    dispatch_resume(_timer);
    self.timer = _timer;
}
//创建奖品动画
- (void)createPrizeAnimation:(BoxPrizeModel *)prizeInfo {
    UIImageView *prizeImageView = [self.prizeDequePool anyObject];
    if (prizeImageView == nil) {
        prizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self.prizeVisiablePool addObject:prizeImageView];
    }else{
        [self.prizeDequePool removeObject:prizeImageView];
    }
    prizeImageView.center = self.boxSeatImgView.center;
    
    
    [prizeImageView qn_setImageImageWithUrl:prizeInfo.prizeImgUrl placeholderImage:nil type:ImageTypeRoomGift];
    
    [self addSubview:prizeImageView];
    [self bringSubviewToFront:prizeImageView];
    
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.beginTime = CACurrentMediaTime();
    scaleAnimation.duration = 1;
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.2f, 0.2f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.removedOnCompletion = YES;
    scaleAnimation.repeatCount = 1;
    
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(kBOX_WIDTH/2, CGRectGetMaxY(self.boxImgView.frame)-50)];
    int randomX = kBOX_WIDTH/2 + (arc4random() % 100 - 50);
    int randomY =  arc4random() % 40 + 20;
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(randomX, randomY)];
    positionAnimation.beginTime = CACurrentMediaTime();
    positionAnimation.duration = 1.0;
    positionAnimation.repeatCount = 1;
    positionAnimation.removedOnCompletion = YES;
    @weakify(self);
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        @strongify(self);
        if (finished) {
            [prizeImageView removeFromSuperview];
            prizeImageView.image = nil;
            [self.prizeVisiablePool removeObject:prizeImageView];
            [self.prizeDequePool addObject:prizeImageView];
        }
    }];
    [prizeImageView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [prizeImageView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)setupSubviews{
    [self addSubview:self.bgImgView];
//    [self addSubview:self.boxTips];
    [self addSubview:self.showView];
    [self addSubview:self.closeButton];
    [self addSubview:self.boxSeatImgView];
    [self addSubview:self.boxLightCenterView];
    [self addSubview:self.boxImgView];
    [self addSubview:self.countdownView];
    [self addSubview:self.boxLightArroundView];
//    [self addSubview:self.progressView];
    [self addSubview:self.selectedView];
    [self addSubview:self.openButton];
    [self addSubview:self.buyLabel];
    [self addSubview:self.tipButton];
    [self addSubview:self.goldView];
}
- (void)setupSubviewsConstraints{
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(self);
        make.center.equalTo(self);
    }];

    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.right.equalTo(self.bgImgView).offset(-12);
        make.top.equalTo(self.bgImgView).offset(12);
    }];
    
//    [self.boxLightCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.boxImgView).offset(35);
//        make.centerX.equalTo(self.boxImgView).offset(-6);
//    }];
    
    [self.boxImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(49);
        make.centerX.equalTo(self.boxSeatImgView);
        make.width.equalTo(@190);
        make.height.equalTo(@140);
    }];
    
//    [self.boxLightArroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.boxSeatImgView).offset(-28);
//        make.centerX.equalTo(self.boxSeatImgView);
//    }];
    
    [self.boxSeatImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(5);
        make.top.equalTo(self.boxImgView.mas_bottom).offset(-34);
    }];
    
    [self.countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.selectedView.mas_top).offset(-5);
        make.height.equalTo(@24);
    }];
    
    [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buyLabel.mas_bottom).offset(16);
        make.height.equalTo(@25);
        make.centerX.equalTo(self);
        make.width.equalTo(self);
    }];
    
    [self.buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.right.mas_equalTo(self).inset(8);
        make.top.equalTo(self.boxSeatImgView.mas_bottom).offset(20);
        make.height.equalTo(@25);
    }];
    
    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.selectedView.mas_bottom).offset(15);
        make.width.equalTo(@153);
        make.height.equalTo(@38);
    }];
    
    [self.tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.goldView.mas_top).offset(-8);
    }];
    
    [self.goldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.bgImgView.mas_bottom);
    }];

    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgView).offset(67);
        make.left.equalTo(self).offset(10);
        make.width.equalTo(@88);
        make.height.equalTo(@135);
    }];
}


#pragma mark - Getter
- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_box_diamond_background"]];
    }
    return _bgImgView;
}
- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"room_box_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (XCDiamondBoxShowView *)showView{
    if (!_showView) {
        _showView = [[XCDiamondBoxShowView alloc] init];
        @weakify(self)
        _showView.DiamondBoxShowViewBlock = ^(XCDiamondBoxShowType showType) {
            @strongify(self)
            switch (showType) {
                case XCDiamondBoxShowTypeRecode:
                    [self.delegate diamondBoxMainView:self eventType:XCDiamondBoxMainViewEventTypeRecode];
                    break;
                case XCDiamondBoxShowTypeHelp:
                    [self.delegate diamondBoxMainView:self eventType:XCDiamondBoxMainViewEventTypeHelp];
                    break;
                case XCDiamondBoxShowTypeJackpot:
                    [self.delegate diamondBoxMainView:self eventType:XCDiamondBoxMainViewEventTypeJackpot];
                    break;
                default:
                    break;
            }
        };
    }
    return _showView;
}
- (UIImageView *)boxImgView{
    if (!_boxImgView) {
        _boxImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_diamond_box_icon"]];
        _boxImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _boxImgView;
}
- (UIImageView *)boxSeatImgView{
    if (!_boxSeatImgView) {
        _boxSeatImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_box_diamond_seat"]];
    }
    return _boxSeatImgView;
}
- (UIImageView *)boxLightArroundView{
    if (!_boxLightArroundView) {
        _boxLightArroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_box_light_arround"]];
    }
    return _boxLightArroundView;
}
- (UIImageView *)boxLightCenterView{
    if (!_boxLightCenterView) {
        _boxLightCenterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_box_diamond_light_center"]];
    }
    return _boxLightCenterView;
}
- (XCBoxSelecteView *)selectedView{
    if (!_selectedView) {
        _selectedView = [[XCBoxSelecteView alloc] init];
        _selectedView.isDiamonBox = YES;
        @weakify(self)
        _selectedView.BoxSelecteViewBlock = ^(XCBoxSelectOpenCountType openCountType) {
            @strongify(self)
            self.openCountType = openCountType;
            [self ttselectButtonChangePuaseAutomatic];
        };
    }
    return _selectedView;
}
- (XCDiamondBoxBuyLabel *)buyLabel{
    if (!_buyLabel) {
        _buyLabel = [[XCDiamondBoxBuyLabel alloc] init];
        _buyLabel.delegate = self;
    }
    return _buyLabel;
}
- (UIButton *)openButton{
    if (!_openButton) {
        _openButton = [[UIButton alloc] init];
        [_openButton setImage:[UIImage imageNamed:@"room_diamond_box_start"] forState:UIControlStateNormal];
        [_openButton setImage:[UIImage imageNamed:@"room_diamond_box_end"] forState:UIControlStateSelected];
        [_openButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openButton;
}
- (UIButton *)tipButton{
    if (!_tipButton) {
        _tipButton = [[UIButton alloc] init];
        [_tipButton setImage:[UIImage imageNamed:@"room_box_unSelected"] forState:UIControlStateNormal];
        [_tipButton setImage:[UIImage imageNamed:@"room_box_selected"] forState:UIControlStateSelected];
        _tipButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_tipButton setTitle:@"不对外提示中奖信息" forState:UIControlStateNormal];
        [_tipButton setTitle:@"不对外提示中奖信息" forState:UIControlStateSelected];
        _tipButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [_tipButton addTarget:self action:@selector(tipButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipButton;
}
- (XCBoxGoldView *)goldView{
    if (!_goldView) {
        _goldView = [[XCBoxGoldView alloc] init];
        _goldView.isDiamondBox = YES;
        @weakify(self)
        _goldView.rechargeButtonClickBlock = ^{
            @strongify(self)
            [self.delegate diamondBoxMainView:self eventType:XCDiamondBoxMainViewEventTypeRecharge];
        };
    }
    return _goldView;
}
- (NSMutableSet *)prizeDequePool{
    if (!_prizeDequePool) {
        _prizeDequePool = [NSMutableSet set];
    }
    return _prizeDequePool;
}
- (NSMutableSet *)prizeVisiablePool{
    if (!_prizeVisiablePool) {
        _prizeVisiablePool = [NSMutableSet set];
    }
    return _prizeVisiablePool;
}
- (NSMutableArray *)openPrizeQueue {
    if (!_openPrizeQueue ) {
        _openPrizeQueue = [NSMutableArray array];
    }
    return _openPrizeQueue;
}

- (XCCountdownView *)countdownView{
    if (!_countdownView) {
        _countdownView = [[XCCountdownView alloc] init];
        _countdownView.hidden = YES;
    }
    return _countdownView;
}

@end
