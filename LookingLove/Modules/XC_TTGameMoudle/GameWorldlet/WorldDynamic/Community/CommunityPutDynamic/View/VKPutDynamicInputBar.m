//
//  VKPutDynamicInputBar.m
//  UKiss
//
//  Created by apple on 2019/2/18.
//  Copyright © 2019 yizhuan. All rights reserved.
//

#import "VKPutDynamicInputBar.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "XCTheme.h"

@interface VKPutDynamicInputBar ()

///内容view
@property (nonatomic, strong) UIView *contentBgView;
///选择图片按钮
@property (nonatomic, strong) UIButton *pictureBtn;
///录音按钮
@property (nonatomic, strong) UIButton *recordBtn;
///表情按钮
@property (nonatomic, strong) UIButton *emoticonBtn;
///关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation VKPutDynamicInputBar

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

- (void)didChangeKeyboardType:(UIButton *)button {
    NSInteger type = button.tag;
    if (type != VKInputBarStatusAudio) {//录音
        if (self.isShowKeyboard) {//已经显示键盘
            button.selected = !button.selected;
            type = button.selected ? VKInputBarStatusEmoticon : VKInputBarStatusText;
        }else {//键盘没有弹出
            type = button.selected ? VKInputBarStatusEmoticon : VKInputBarStatusText;
        }
    }else{

    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(putDynamicInputBar:changeInputBarStatus:)]) {
        [self.delegate putDynamicInputBar:self changeInputBarStatus:type];
    }
    self.status = type;
}

- (void)didClickSelectedPictureButton:(UIButton *)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(putDynamicInputSelectedPictureCallBack)]) {
        [self.delegate putDynamicInputSelectedPictureCallBack];
    }
}

- (void)didClickCloseButtonAction:(UIButton *)button {
    [self.superview endEditing:YES];
}

#pragma mark - private method

- (void)initView {
//    [self addSubview:self.closeBtn];
    [self addSubview:self.contentBgView];
    [self.contentBgView addSubview:self.pictureBtn];
    [self.contentBgView addSubview:self.recordBtn];
    [self.contentBgView addSubview:self.emoticonBtn];
}

- (void)initConstrations {
    self.closeBtn.right = KScreenWidth;
    CGFloat width = KScreenWidth / 3.0;
    self.pictureBtn.centerX = 1.5 *width;
    self.recordBtn.centerX = width/2;
    self.emoticonBtn.centerX = 2.5*width;
    self.pictureBtn.centerY = self.recordBtn.centerY = self.emoticonBtn.centerY = (self.height - kSafeAreaBottomHeight)/2.f;
}

#pragma mark - getters and setters

- (void)setIsShowKeyboard:(BOOL)isShowKeyboard {
    _isShowKeyboard = isShowKeyboard;
    self.closeBtn.hidden = !isShowKeyboard;
}

- (UIView *)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.height)];
        _contentBgView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _contentBgView;
}

- (UIButton *)pictureBtn {
    if (!_pictureBtn) {
        _pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pictureBtn setImage:[UIImage imageNamed:@"community_tab_picture"] forState:UIControlStateNormal];
        [_pictureBtn setImage:[UIImage imageNamed:@"community_tab_picture_dis"] forState:UIControlStateDisabled];
        _pictureBtn.bounds = CGRectMake(0, 0, 44, 44);
        [_pictureBtn addTarget:self action:@selector(didClickSelectedPictureButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pictureBtn;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setImage:[UIImage imageNamed:@"community_voice_icon"] forState:UIControlStateNormal];
        [_recordBtn setImage:[UIImage imageNamed:@"community_voice_icon_dis"] forState:UIControlStateDisabled];
        _recordBtn.bounds = CGRectMake(0, 0, 44, 44);
        _recordBtn.tag = 1;
        [_recordBtn addTarget:self action:@selector(didChangeKeyboardType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

- (UIButton *)emoticonBtn {
    if (!_emoticonBtn) {
        _emoticonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emoticonBtn setImage:[UIImage imageNamed:@"community_face_icon"] forState:UIControlStateNormal];
        [_emoticonBtn setImage:[UIImage imageNamed:@"community_expression_icon"] forState:UIControlStateSelected];
        _emoticonBtn.bounds = CGRectMake(0, 0, 44, 44);
        _emoticonBtn.tag = 2;
        [_emoticonBtn addTarget:self action:@selector(didChangeKeyboardType:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _emoticonBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"community_shrink_bg"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"community_shrink"] forState:UIControlStateNormal];
        [_closeBtn sizeToFit];
        [_closeBtn addTarget:self action:@selector(didClickCloseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
        _closeBtn.hidden = YES;
    }
    return _closeBtn;
}


@end
