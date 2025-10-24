//
//  TTNewbieGuideView.m
//  AFNetworking
//
//  Created by apple on 2019/5/21.
//

#import "TTNewbieGuideView.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "NSArray+Safe.h"
#import "UIView+NTES.h"

#define kScale(x) ((x) / 375.0 * KScreenWidth)

@interface TTNewbieGuideView ()
/** 兔兔图标 */
@property (nonatomic, strong) UIImageView *tutuImageView;

/** 需要抠图时的文字指引 */
@property (nonatomic, strong) UIImageView *guideImageView;

/** 知道了 */
@property (nonatomic, strong) UIButton *skipButton;

/** 下一步 */
@property (nonatomic, strong) UIButton *nextStepButton;

/** 当前页面不止一个新手引导时 */
@property (nonatomic, assign) NSInteger typeIndex;

/** 当前页面半透明层 */
@property (nonatomic, strong) CAShapeLayer *fillLayer;

/** 需要抠图的frame */
@property (nonatomic, assign) CGRect rect;

/** 跳过指引 */
@property (nonatomic, strong) UIButton *skipGuideBtn;

/** 当前属于哪个页面的判断 */
@property (nonatomic, assign) TTGuideViewPageType pageIndex;

@end

@implementation TTNewbieGuideView

- (instancetype)initWithFrame:(CGRect)frame withArcWithFrame:(CGRect )rect withSpace:(BOOL)space withCorner:(NSInteger )corner withPage:(TTGuideViewPageType )pageIndex {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorRGBAlpha(0x000000, 0.65);
        
        self.opaque = NO;
        
        _rect = rect;
        
        _pageIndex = pageIndex;
        
        if (space) {
            [self addArcWithFrame:rect withCorner:corner];
        }
        
        [self initViewWithPageName:pageIndex];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideViewAction:)];
        [self addGestureRecognizer:tapGes];
        
        self.typeIndex = 0;
    }
    return self;
}

- (void)initViewWithPageName:(TTGuideViewPageType )pageIndex {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self initView];
    
    [self initConstraintWithPageName:pageIndex];
}

- (void)setDataArray:(NSArray *)dataArray {
    
    [self addArcWithFrameArray:dataArray withCorner:14];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self initView];
    
    [self initConstraintWithPageName:_pageIndex];
}

- (void)initView {
    [self addSubview:self.tutuImageView];
    [self addSubview:self.guideImageView];
    [self addSubview:self.skipButton];
    [self addSubview:self.nextStepButton];
    [self addSubview:self.skipGuideBtn];
}

- (void)initConstraintWithPageName:(NSInteger )pageIndex {
    _pageIndex = pageIndex;
    
    if (pageIndex == TTGuideViewPage_Home) {
        self.guideImageView.frame = CGRectMake(kScale(33), CGRectGetMaxY(self.rect) + 21, kScale(295), kScale(97));
        self.guideImageView.image = [UIImage imageNamed:@"guide_HomePage"];
        self.guideImageView.hidden = NO;
        
        self.skipButton.frame = CGRectMake(CGRectGetMaxX(self.guideImageView.frame) - 76, CGRectGetMaxY(self.guideImageView.frame) + 21, 76, 34);
        
        [self.skipButton setImage:[UIImage imageNamed:@"guide_nextStep"] forState:UIControlStateNormal];
        
        self.skipButton.hidden = NO;
    } else if (pageIndex == TTGuideViewPage_Message) {
        
        self.tutuImageView.hidden = NO;
        
        self.guideImageView.hidden = NO;
        self.guideImageView.image = [UIImage imageNamed:@"guide_messagePage"];
        
        [self.guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-25);
            make.bottom.mas_equalTo(self.tutuImageView.mas_top).offset(-29);
        }];
        
        self.skipButton.hidden = NO;
        [self.skipButton setImage:[UIImage imageNamed:@"guide_nextStep"] forState:UIControlStateNormal];
        
        [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.guideImageView.mas_bottom).offset(21);
            make.right.mas_equalTo(self.guideImageView.mas_right).offset(-26);
        }];
    } else if (pageIndex == TTGuideViewPage_Person) {
        
        self.guideImageView.hidden = NO;
        
        self.guideImageView.image = [UIImage imageNamed:@"guide_myPage"];
        
        self.guideImageView.frame = CGRectMake(kScale(33), CGRectGetMinY(self.rect) - 21 - kScale(97), kScale(295), kScale(97));
        
        self.skipButton.hidden = NO;
        
        [self.skipButton setImage:[UIImage imageNamed:@"guide_nextStep"] forState:UIControlStateNormal];
        
        self.skipButton.frame = CGRectMake(CGRectGetMaxX(self.guideImageView.frame) - 76, CGRectGetMinY(self.guideImageView.frame) - 21 - 34, 76, 34);
    } else if (pageIndex == TTGuideViewPage_Room) {
        switch (self.typeIndex) {
            case 0:{
                self.guideImageView.hidden = NO;
                
                self.guideImageView.image = [UIImage imageNamed:@"guide_roomPage_upMic"];
                
                self.guideImageView.frame = CGRectMake(CGRectGetMinX(self.rect) + self.rect.size.width / 2 - kScale(209), CGRectGetMaxY(self.rect) + 14, kScale(209), kScale(66));
                
                self.nextStepButton.hidden = NO;
                
                self.skipGuideBtn.hidden = NO;
                
                self.nextStepButton.frame = CGRectMake(CGRectGetMaxX(self.guideImageView.frame) - 76, CGRectGetMaxY(self.guideImageView.frame) + 21, 76, 34);
                
                break;}
            case 1:{
                self.guideImageView.hidden = NO;
                
                self.guideImageView.image = [UIImage imageNamed:@"guide_roomPage_enterGift"];
                
                self.guideImageView.frame = CGRectMake(KScreenWidth - 36 - kScale(156), CGRectGetMinY(self.rect) - 21 - kScale(66), kScale(156), kScale(66));
                
                self.nextStepButton.hidden = YES;
                
                self.skipGuideBtn.hidden = YES;
                
                self.skipButton.hidden = NO;
                
                self.skipButton.frame = CGRectMake(KScreenWidth - 36 - 76, CGRectGetMinY(self.guideImageView.frame) - 21 - 34, 76, 34);
                
                break;}
            default:
                break;
        }
    } else if (pageIndex == TTGuideViewPage_Gift) {
        
        self.guideImageView.hidden = NO;
        
        self.guideImageView.image = [UIImage imageNamed:@"guide_roomPage_allMic"];
        
        self.guideImageView.frame = CGRectMake(kScale(34), CGRectGetMinY(self.rect) - 21 - kScale(66), kScale(315), kScale(66));
        
        self.skipButton.hidden = NO;
        
        self.skipButton.frame = CGRectMake(CGRectGetMaxX(self.guideImageView.frame) - 76, CGRectGetMinY(self.guideImageView.frame) - 21 - 34, 76, 34);
    } else if (pageIndex == TTGuideViewPage_Voice) {
        switch (self.typeIndex) {
            case 0:{
                self.guideImageView.hidden = NO;
                
                self.guideImageView.image = [UIImage imageNamed:@"voice_findVoice_guide"];
                
                self.guideImageView.frame = CGRectMake(KScreenWidth - kScale(216) - kScale(60), CGRectGetMinY(self.rect) - kScale(21) - kScale(96), kScale(216), kScale(96));
                
                self.nextStepButton.hidden = NO;
                
                self.skipGuideBtn.hidden = NO;
                
                self.nextStepButton.frame = CGRectMake(CGRectGetMaxX(self.guideImageView.frame) - 76, CGRectGetMinY(self.guideImageView.frame) - 21 - 34, 76, 34);
                break;}
            case 1:{
                self.guideImageView.hidden = NO;
                
                self.guideImageView.image = [UIImage imageNamed:@"voice_recordVoice_guide"];
                
                self.guideImageView.frame = CGRectMake(KScreenWidth - kScale(190) - kScale(36), CGRectGetMaxY(self.rect) + 21, kScale(190), kScale(97));
                
                self.nextStepButton.hidden = YES;
                
                self.skipGuideBtn.hidden = YES;
                
                self.skipButton.hidden = NO;
                
                self.skipButton.frame = CGRectMake(CGRectGetMaxX(self.guideImageView.frame) - 76, CGRectGetMaxY(self.guideImageView.frame) + 21, 76, 34);
                break;}
                
            default:
                break;
        }
        
    } else if (pageIndex == TTGuideViewPage_GameHome) {
                
        if (self.typeIndex == 0) {
            CGFloat textImageWidth = 276.0f;
            CGFloat textImageX = (KScreenWidth - textImageWidth) / 2.0f;
            
            self.guideImageView.hidden = NO;
            self.guideImageView.frame = CGRectMake(textImageX, CGRectGetMaxY(self.rect) + 21, textImageWidth, 97);
            self.guideImageView.image = [UIImage imageNamed:@"game_home_guide_text_1"];
            
            
            self.nextStepButton.hidden = NO;
            self.nextStepButton.frame = CGRectMake(CGRectGetMaxX(self.guideImageView.frame) - 76, CGRectGetMaxY(self.guideImageView.frame) + 21, 76, 34);
            
            self.skipGuideBtn.hidden = NO;
            
            self.tutuImageView.hidden = NO;
            self.tutuImageView.image = [UIImage imageNamed:@"game_home_guide_avatar"];
            
            self.tutuImageView.size = CGSizeMake(112, 222);
            self.tutuImageView.top = self.guideImageView.bottom;
            self.tutuImageView.left = 0;
            
        } else {
            
            CGFloat textImageWidth = 278.0f;
            CGFloat textImageX = (KScreenWidth - textImageWidth) / 2.0f;
            
            self.guideImageView.hidden = NO;
            self.guideImageView.image = [UIImage imageNamed:@"game_home_guide_text_2"];
            
            self.guideImageView.size = CGSizeMake(textImageWidth, 96);
            self.guideImageView.bottom = CGRectGetMinY(self.rect) - 20;
            self.guideImageView.left = textImageX;
            
            self.skipGuideBtn.hidden = YES;
            self.nextStepButton.hidden = YES;
            self.skipButton.hidden = NO;
            
            self.skipButton.size = CGSizeMake(76, 34);
            self.skipButton.bottom = self.guideImageView.top - 20;
            self.skipButton.right = self.guideImageView.right;
            
            self.tutuImageView.hidden = NO;
            self.tutuImageView.image = [UIImage imageNamed:@"game_home_guide_avatar_small"];
            
            self.tutuImageView.size = CGSizeMake(125, 125);
            self.tutuImageView.bottom = KScreenHeight;
            self.tutuImageView.right = KScreenWidth;
        }
        
    } else if (pageIndex == TTGuideViewPage_WorldSquare) {

        UIImage *guideImage = [UIImage imageNamed:@"world_guide_slice_square"];
        CGFloat textImageX = (KScreenWidth - guideImage.size.width) / 2.0f;
        
        self.guideImageView.hidden = NO;
        self.guideImageView.image = guideImage;
        
        self.guideImageView.size = guideImage.size;
        self.guideImageView.bottom = KScreenHeight - 211 - kSafeAreaBottomHeight;
        self.guideImageView.left = textImageX;
        
        self.skipGuideBtn.hidden = YES;
        self.nextStepButton.hidden = YES;
        self.skipButton.hidden = NO;
        
        self.skipButton.size = CGSizeMake(76, 34);
        self.skipButton.top = self.guideImageView.bottom + 12;
        self.skipButton.right = self.guideImageView.right;
        
        self.tutuImageView.hidden = NO;
        self.tutuImageView.image = [UIImage imageNamed:@"world_guide_slice_logo"];
        
        self.tutuImageView.size = CGSizeMake(125, 125);
        self.tutuImageView.bottom = KScreenHeight;
        self.tutuImageView.left = 0;
        
    } else if (pageIndex == TTGuideViewPage_WorldJoin) {

        UIImage *guideImage = [UIImage imageNamed:@"world_guide_slice_join"];
        CGFloat textImageX = (KScreenWidth - guideImage.size.width) / 2.0f;
        
        self.guideImageView.hidden = NO;
        self.guideImageView.image = guideImage;
        
        self.guideImageView.size = guideImage.size;
        self.guideImageView.bottom = KScreenHeight - 120 - kSafeAreaBottomHeight;
        self.guideImageView.left = textImageX;
        
        self.skipGuideBtn.hidden = YES;
        self.nextStepButton.hidden = YES;
        self.skipButton.hidden = NO;
        
        self.skipButton.size = CGSizeMake(76, 34);
        self.skipButton.top = self.guideImageView.top + 60;
        self.skipButton.right = self.guideImageView.right;

        self.tutuImageView.hidden = YES;
        
    } else if (pageIndex == TTGuideViewPage_WorldMessage) {
        
        UIImage *guideImage = [UIImage imageNamed:@"world_guide_slice_message"];
        CGFloat textImageX = (KScreenWidth - guideImage.size.width) / 2.0f;
        
        self.guideImageView.hidden = NO;
        self.guideImageView.image = guideImage;
        
        self.guideImageView.size = guideImage.size;
        self.guideImageView.bottom = KScreenHeight - 120 - kSafeAreaBottomHeight;
        self.guideImageView.left = textImageX;
        
        self.skipGuideBtn.hidden = YES;
        self.nextStepButton.hidden = YES;
        self.skipButton.hidden = NO;
        
        self.skipButton.size = CGSizeMake(76, 34);
        self.skipButton.top = self.guideImageView.top + 60;
        self.skipButton.right = self.guideImageView.right;
        
        self.tutuImageView.hidden = YES;
    }
}

- (void)guideViewAction:(UITapGestureRecognizer *)sender {
    if (self.pageIndex == TTGuideViewPage_Room || self.pageIndex == TTGuideViewPage_Voice || self.pageIndex == TTGuideViewPage_GameHome) {
        if (self.typeIndex == 1) {
            [self removeFromSuperview];
            [self dismissBlock];
            return;
        }
        self.typeIndex ++;
        if (self.currentType) {
            self.currentType(self.typeIndex);
        }
    } else {
        [self removeFromSuperview];
        [self dismissBlock];
    }
}

- (void)nextStepBtnAciton:(UIButton *)sender {
    self.typeIndex ++;
    if (self.currentType) {
        self.currentType(self.typeIndex);
    }
}

- (void)addArcWithFrame:(CGRect )rect withCorner:(NSInteger )corner {
    
    _rect = rect;
    
    self.backgroundColor = UIColor.clearColor;
    
    self.opaque = NO;
    
    //中间镂空的矩形框
    CGRect myRect = rect;
    
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds cornerRadius:0];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:myRect cornerRadius:corner];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    if (self.fillLayer) {
        [self.fillLayer removeFromSuperlayer];
    }
    self.fillLayer = [CAShapeLayer layer];
    _fillLayer.path = path.CGPath;
    _fillLayer.fillRule = kCAFillRuleEvenOdd;
    _fillLayer.fillColor = UIColorRGBAlpha(0x000000, 0.65).CGColor;
    [self.layer addSublayer:_fillLayer];
}

- (void)addArcWithFrameArray:(NSArray *)rectArray withCorner:(NSInteger )corner {

    CGRect rect = [[rectArray firstObject] CGRectValue];
    
    _rect = rect;
    
    self.backgroundColor = UIColor.clearColor;
    
    self.opaque = NO;
    
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds cornerRadius:0];
    
    for (int i = 0; i < rectArray.count; i++) {
        //中间镂空的矩形框
        CGRect myRect = [[rectArray safeObjectAtIndex:i] CGRectValue];

        //镂空
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:myRect cornerRadius:corner];
        [path appendPath:circlePath];
        [path setUsesEvenOddFillRule:YES];
    }

    if (self.fillLayer) {
        [self.fillLayer removeFromSuperlayer];
    }
    self.fillLayer = [CAShapeLayer layer];
    _fillLayer.path = path.CGPath;
    _fillLayer.fillRule = kCAFillRuleEvenOdd;
    _fillLayer.fillColor = UIColorRGBAlpha(0x000000, 0.65).CGColor;
    [self.layer addSublayer:_fillLayer];
}
    
- (void)skipBtnAciton:(UIButton *)sender {
    [self removeFromSuperview];
    [self dismissBlock];
}

- (void)skipGuideBtnAciton:(UIButton *)sender {
    [self removeFromSuperview];
    [self dismissBlock];
}

- (void)dismissBlock {
    !_dismissingBlock ?: _dismissingBlock();
}

- (UIImageView *)tutuImageView {
    if (!_tutuImageView) {
        _tutuImageView = [[UIImageView alloc] init];
        _tutuImageView.image = [UIImage imageNamed:@"puding_Newbieguide"];
        _tutuImageView.hidden = YES;
        [_tutuImageView sizeToFit];
        _tutuImageView.left = 0;
        _tutuImageView.bottom = KScreenHeight;
    }
    return _tutuImageView;
}

- (UIImageView *)guideImageView {
    if (!_guideImageView) {
        _guideImageView = [[UIImageView alloc] init];
        _guideImageView.image = [UIImage imageNamed:@"guide_GamePage"];
        _guideImageView.hidden = YES;
    }
    return _guideImageView;
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipButton setImage:[UIImage imageNamed:@"guide_nextStep"] forState:UIControlStateNormal];
        [_skipButton addTarget:self action:@selector(skipBtnAciton:) forControlEvents:UIControlEventTouchUpInside];
        _skipButton.hidden = YES;
    }
    return _skipButton;
}

- (UIButton *)nextStepButton {
    if (!_nextStepButton) {
        _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextStepButton setImage:[UIImage imageNamed:@"guide_roomNextStep"] forState:UIControlStateNormal];
        [_nextStepButton addTarget:self action:@selector(nextStepBtnAciton:) forControlEvents:UIControlEventTouchUpInside];
        _nextStepButton.hidden = YES;
    }
    return _nextStepButton;
}

- (UIButton *)skipGuideBtn {
    if (!_skipGuideBtn) {
        _skipGuideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipGuideBtn setTitle:@"跳过指引" forState:UIControlStateNormal];
        [_skipGuideBtn setTitleColor:UIColorRGBAlpha(0xffffff, 0.3) forState:UIControlStateNormal];
        _skipGuideBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_skipGuideBtn addTarget:self action:@selector(skipGuideBtnAciton:) forControlEvents:UIControlEventTouchUpInside];
        [_skipGuideBtn sizeToFit];
        _skipGuideBtn.centerX = self.centerX;
        _skipGuideBtn.bottom = KScreenHeight - 60 - kSafeAreaBottomHeight;
        _skipGuideBtn.hidden = YES;
    }
    return _skipGuideBtn;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
