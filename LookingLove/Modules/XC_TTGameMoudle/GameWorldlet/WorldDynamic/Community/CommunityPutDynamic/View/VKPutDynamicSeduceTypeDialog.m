//
//  VKPutDynamicSeduceTypeDialog.m
//  UKiss
//
//  Created by apple on 2019/2/21.
//  Copyright © 2019 yizhuan. All rights reserved.
//  勾引方式弹框

#import "VKPutDynamicSeduceTypeDialog.h"
#import "XCAlertControllerCenter.h"
#import "UIView+NTES.h"
#import "XCTheme.h"
#import "XCMacros.h"

@interface VKPutDynamicSeduceTypeDialog ()

///标题
@property (nonatomic, strong) UILabel *titleLab;
///选中的图片
@property (nonatomic, strong) UIImageView *selectedTipImg;
///文字私聊
@property (nonatomic, strong) UIView *textSeduceView;
///语音私聊
@property (nonatomic, strong) UIView *voiceSeduceView;
///关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation VKPutDynamicSeduceTypeDialog

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]

#pragma mark - [自定义控件的Protocol]

#pragma mark - [core相关的Protocol] 

#pragma mark - event response

- (void)tapSelectedSeduce:(UITapGestureRecognizer *)tap {
    UIView *senderView = tap.view;
    self.type = (senderView == self.textSeduceView) ? VKPutDynamicSeduceTypeText : VKPutDynamicSeduceTypeVoice;
    if (self.selectedBlock) {
        self.selectedBlock(self.type);
    }
}

- (void)hidden {
    [[XCAlertControllerCenter defaultCenter] dismissAlertNeedBlock:NO andAnimate:YES];
}

#pragma mark - private method

- (void)initView {
    self.backgroundColor = UIColorFromRGB(0xffffff);
    [self setSingleRediusWithView:self];
    self.textSeduceView = [self createSeduceViewWithIsText:YES];
    self.voiceSeduceView = [self createSeduceViewWithIsText:NO];
    [self addSubview:self.titleLab];
    [self addSubview:self.selectedTipImg];
    [self addSubview:self.textSeduceView];
    [self addSubview:self.voiceSeduceView];
    [self addSubview:self.closeBtn];
    

}

- (void)initConstrations {
    self.titleLab.centerY = 23;
    self.titleLab.centerX = KScreenWidth/2.0;
    self.textSeduceView.top = 46;
    self.voiceSeduceView.top = CGRectGetMaxY(self.textSeduceView.frame);
    self.closeBtn.top = CGRectGetMaxY(self.voiceSeduceView.frame) - 16;
    self.closeBtn.centerX = self.voiceSeduceView.centerX;
}

///创建私聊view
- (UIView *)createSeduceViewWithIsText:(BOOL)isText {
    UIView *contentBgView = [[UIView alloc]init];
    contentBgView.frame = CGRectMake(0, 0, KScreenWidth, 74);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelectedSeduce:)];
    [contentBgView addGestureRecognizer:tap];
    
    NSString *imgName = isText ? @"community_time_Text" : @"community__time_voice";
    NSString *titleStr = isText ? @"文字私聊" : @"语音私聊";
    NSString *detailStr = isText ? @"30分钟内,其他用户用文字私聊方式勾搭你" : @"10分钟内，其他用户用语音房连麦方式来勾搭你";
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    UILabel *titleLab = ({
        UILabel *label = [[UILabel alloc]init];
        label.tag = 101;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x8986AA);
        label.text = titleStr;
        [label sizeToFit];
        label;
    });
    UILabel *detailLab = ({
        UILabel *label = [[UILabel alloc]init];
        label.tag = 102;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0x8986AA);
        label.text = detailStr;
        [label sizeToFit];
        label;
    });
    if (isText) {
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5)];
        topLine.backgroundColor = UIColorFromRGB(0x2B2541);
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(15, contentBgView.height - 1, KScreenWidth - 30, 0.5)];
        bottomLine.backgroundColor = UIColorFromRGB(0x2B2541);
        [contentBgView addSubview:topLine];
        [contentBgView addSubview:bottomLine];
    }
    imgView.left = 30;
    imgView.centerY = contentBgView.height / 2.0;
    titleLab.left = CGRectGetMaxX(imgView.frame) + 8;
    titleLab.bottom = contentBgView.height / 2.0 - 3;
    detailLab.left = titleLab.left;
    detailLab.top = CGRectGetMaxY(titleLab.frame) + 6;
    [contentBgView addSubview:imgView];
    [contentBgView addSubview:titleLab];
    [contentBgView addSubview:detailLab];
    return contentBgView;
}

- (void)setSeduceViewTextColorWith:(UIView *)seduceView textColor:(UIColor *)textColor {
    UILabel *titleLab = [seduceView viewWithTag:101];
    UILabel *detailLab = [seduceView viewWithTag:102];
    titleLab.textColor = textColor;
    detailLab.textColor = textColor;
}

///设置圆角
- (void)setSingleRediusWithView:(UIView *)view {
    CGSize radio = CGSizeMake(20, 20);//圆角尺寸
    UIRectCorner corner = UIRectCornerTopLeft|UIRectCornerTopRight;//这只圆角位置
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:radio];
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];
    masklayer.path = path.CGPath;//设置路径
    view.layer.mask = masklayer;
}

#pragma mark - getters and setters

- (void)setType:(VKPutDynamicSeduceType)type {
    _type = type;
    [self setSeduceViewTextColorWith:self.textSeduceView textColor:UIColorFromRGB(0x8986AA)];
    [self setSeduceViewTextColorWith:self.voiceSeduceView textColor:UIColorFromRGB(0x8986AA)];
    UIView *seduceView = (self.type == VKPutDynamicSeduceTypeText) ? self.textSeduceView : self.voiceSeduceView;
    [self setSeduceViewTextColorWith:seduceView textColor:UIColorFromRGB(0xC1BEE3)];
    self.selectedTipImg.centerY = seduceView.centerY;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = UIColorFromRGB(0x9B95F9);
        _titleLab.text = @"选择你的勾搭方式";
        [_titleLab sizeToFit];
    }
    return _titleLab;
}

- (UIImageView *)selectedTipImg {
    if (!_selectedTipImg) {
        _selectedTipImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"morringEvening_selMusic"]];
        _selectedTipImg.right = KScreenWidth - 15;
    }
    return _selectedTipImg;
}


- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"community_shutdown"] forState:UIControlStateNormal];
        _closeBtn.bounds = CGRectMake(0, 0, 44, 44);
        [_closeBtn addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
@end
