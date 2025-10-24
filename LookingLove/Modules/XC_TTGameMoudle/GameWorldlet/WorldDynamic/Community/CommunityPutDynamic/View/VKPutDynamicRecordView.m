//
//  VKPutDynamicRecordView.m
//  UKiss
//
//  Created by apple on 2019/2/19.
//  Copyright © 2019 yizhuan. All rights reserved.
//

#import "VKPutDynamicRecordView.h"
#import "VKCircleProgressView.h"
#import <UIImage+GIF.h>
#import "UIView+NTES.h"
#import "XCMacros.h"
#import "XCTheme.h"

@interface VKPutDynamicRecordView () <VKRecordButtonDelegate>


@property (nonatomic, strong) UILabel *titleLab;
//录制按钮
@property (nonatomic, strong) VKRecordButton *recordBtn;
///删除按钮
@property (nonatomic, strong) UIButton *deleteBtn;
///完成按钮
@property (nonatomic, strong) UIButton *finishedBtn;

@end

@implementation VKPutDynamicRecordView

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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}//去除复制、粘贴

#pragma mark - [自定义控件的Protocol]

#pragma mark - VKRecordButtonDelegate

- (void)didClickRecordButton:(VKRecordButton *)recordButton changeRecordStatusCallBack:(VKRecordViewStatus)status {
    if (self.status != status) {
        self.status = status;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(putDynamicRecordView:changeRecordStatusCallBack:)]) {
        [self.delegate putDynamicRecordView:self changeRecordStatusCallBack:self.status];
    }
}


#pragma mark - [core相关的Protocol] 

#pragma mark - event response

///删除
- (void)deleteAudioFile:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteRecordFileCallBack)]) {
        [self.delegate deleteRecordFileCallBack];
    }
}

///完成
- (void)finishedAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishedActionCallBack)]) {
        [self.delegate finishedActionCallBack];
    }
}


#pragma mark - private method

- (void)initView {
    self.backgroundColor = UIColorFromRGB(0xffffff);
    [self addSubview:self.titleLab];
    [self addSubview:self.recordBtn];
    [self addSubview:self.deleteBtn];
    [self addSubview:self.finishedBtn];
    self.status = VKRecordViewStatusEmpty;
}

- (void)initConstrations {
    self.titleLab.top = 40;
    self.titleLab.centerX = KScreenWidth / 2.0;
    self.recordBtn.top = CGRectGetMaxY(self.titleLab.frame) + 40;
    self.recordBtn.centerX = self.titleLab.centerX;
    self.deleteBtn.centerY = self.recordBtn.centerY-5;
    self.deleteBtn.left = 40;
    self.finishedBtn.centerY = self.deleteBtn.centerY;
    self.finishedBtn.right = KScreenWidth - 40;
}

#pragma mark - getters and setters

- (void)setStatus:(VKRecordViewStatus)status {
    _status = status;
    if (self.recordBtn.status != status) {
        self.recordBtn.status = status;
    }
    BOOL hiddenFlag = (status == VKRecordViewStatusEmpty || status == VKRecordViewStatusRecording);
    self.deleteBtn.hidden = hiddenFlag;
    self.finishedBtn.hidden = hiddenFlag;
    if (status == VKRecordViewStatusEmpty) {
        self.progress = 0;
        self.titleStr = @"点击开始录制";
    }
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    CGPoint center = self.titleLab.center;
    self.titleLab.text = titleStr;
    [self.titleLab sizeToFit];
    self.titleLab.center = center;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.recordBtn.progress = progress;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = [UIFont systemFontOfSize:17];
        _titleLab.textColor = UIColorFromRGB(0x222222);
        _titleLab.text = @"点击开始录制";
        [_titleLab sizeToFit];
    }
    return _titleLab;
}

- (VKRecordButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [[VKRecordButton alloc]init];
        _recordBtn.delegate = self;
        _recordBtn.bounds = CGRectMake(0, 0, 90, 90);
    }
    return _recordBtn;
}

//- (UIButton *)mainBtn {
//    if (!_mainBtn) {
//        _mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_mainBtn setBackgroundImage:[UIImage imageNamed:@"community_recording_bg"] forState:UIControlStateNormal];
//        [_mainBtn sizeToFit];
//        [_mainBtn addTarget:self action:@selector(didClickMainFunctionAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _mainBtn;
//}
//
//- (UIView *)blankView {
//    if (!_blankView) {
//        _blankView = [[UIView alloc]init];
//        _blankView.backgroundColor = [UIColor whiteColor];
//        _blankView.bounds = CGRectMake(0, 0, 57, 57);
//        _blankView.layer.cornerRadius = _blankView.height/2.0;
//        _blankView.layer.masksToBounds = YES;
//        _blankView.userInteractionEnabled = NO;
//    }
//    return _blankView;
//}

//- (UIImageView *)focusStateImg {
//    if (!_focusStateImg) {
//        _focusStateImg = [[UIImageView alloc]init];
//    }
//    return _focusStateImg;
//}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"community_delete_voice_icon"] forState:UIControlStateNormal];
        [_deleteBtn sizeToFit];
        [_deleteBtn addTarget:self action:@selector(deleteAudioFile:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIButton *)finishedBtn {
    if (!_finishedBtn) {
        _finishedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishedBtn setBackgroundImage:[UIImage imageNamed:@"community_voicefin_icon"] forState:UIControlStateNormal];
        [_finishedBtn sizeToFit];
        [_finishedBtn addTarget:self action:@selector(finishedAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _finishedBtn;
}

//- (VKCircleProgressView *)progressView {
//    if (!_progressView) {
//        _progressView = [[VKCircleProgressView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
//        _progressView.backgroundColor = [UIColor clearColor];
//        _progressView.userInteractionEnabled = NO;
//        _progressView.progress = 0;
//        _progressView.hidden = YES;
//    }
//    return _progressView;
//}

@end
