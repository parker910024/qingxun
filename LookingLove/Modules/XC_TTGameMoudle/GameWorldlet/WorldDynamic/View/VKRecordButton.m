//
//  VKRecordButton.m
//  UKiss
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019 yizhuan. All rights reserved.
//

#import "VKRecordButton.h"
#import "VKCircleProgressView.h"
#import <SDWebImage/UIImageView+WebCache.h>


#import <UIImage+GIF.h>
#import "UIView+XCToast.h"
#import "UIView+NTES.h"

@interface VKRecordButton ()

///主按钮功能
@property (nonatomic, strong) UIButton *mainBtn;
///白色圆  还没录制前
@property (nonatomic, strong) UIView *blankView;
///中心状态图片
@property (nonatomic, strong) UIImageView *focusStateImg;
///圆形进度view
//@property (nonatomic, strong) VKCircleProgressView *progressView;

@end

@implementation VKRecordButton

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

- (void)didClickMainFunctionAction:(UIButton *)button {
    button.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.userInteractionEnabled = YES;
    });
//    if (GetCore(ImRoomCoreV2).currentRoomInfo) {//当前房间不为空
//        [UIView showError:@"当前正在连麦中，暂不可使用"];
//        return;
//    }
    if (self.status < VKRecordViewStatusPlaying) {
        self.status++;
    }else {//正在播放
        self.status--;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickRecordButton:changeRecordStatusCallBack:)]) {
        [self.delegate didClickRecordButton:self changeRecordStatusCallBack:self.status];
    }
}

#pragma mark - private method

- (void)initView {
    self.bounds = CGRectMake(0, 0, 90, 90);
    [self addSubview:self.mainBtn];
    [self addSubview:self.blankView];
    [self addSubview:self.focusStateImg];
//    [self addSubview:self.progressView];
}

- (void)initConstrations {
    self.mainBtn.top = 0;
    self.mainBtn.centerX = self.width/2.0;
    self.blankView.center = self.mainBtn.center;
//    self.progressView.center = self.mainBtn.center;
}

#pragma mark - getters and setters

- (void)setStatus:(VKRecordViewStatus)status {
    _status = status;
    BOOL hiddenFlag = (status == VKRecordViewStatusEmpty || status == VKRecordViewStatusRecording);
//    self.progressView.hidden = status != VKRecordViewStatusRecording;
//    if (status == VKRecordViewStatusEmpty) {
//        self.progressView.progress = 0;
//    }
    if (status == VKRecordViewStatusRecording) {//正在录制 有动画
        [UIView animateWithDuration:0.25 animations:^{
            self.blankView.bounds = CGRectMake(0, 0, 22, 22);
            self.blankView.layer.cornerRadius = 4;
        } completion:^(BOOL finished) {
            NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"community_recording_icon.gif" ofType:nil];
            NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
            self.focusStateImg.bounds = CGRectMake(0, 0, 22, 22);
            self.focusStateImg.image = [UIImage sd_animatedGIFWithData:imageData];
            self.focusStateImg.hidden = NO;
            self.blankView.hidden = YES;
            self.blankView.bounds = CGRectMake(0, 0, 57, 57);
            self.blankView.layer.cornerRadius = self.blankView.height/2.0;
        }];
    }else {//不是正在录制
        self.focusStateImg.hidden = status == VKRecordViewStatusEmpty;
        self.blankView.hidden = status != VKRecordViewStatusEmpty;
    }
    self.focusStateImg.center = self.blankView.center;
    if (status == VKRecordViewStatusCompleteRecorded) {//录制完成
        self.focusStateImg.image = [UIImage imageNamed:@"community_play_icon"];
        [self.focusStateImg sizeToFit];
        self.focusStateImg.center = CGPointMake(self.blankView.center.x+2, self.blankView.center.y);
    }
    if (status == VKRecordViewStatusPlaying) {//播放
        self.focusStateImg.image = [UIImage imageNamed:@"community_pause_icon"];
        [self.focusStateImg sizeToFit];
        self.focusStateImg.center = self.blankView.center;
    }
    
    
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
//    self.progressView.progress = progress;
}

- (void)setIsDrawerStyle:(BOOL)isDrawerStyle {
    _isDrawerStyle = isDrawerStyle;
    NSString *imgName = self.isDrawerStyle ? @"homeDrawer_record_bg" : @"community_recording_bg";
    [self.mainBtn setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}

- (UIButton *)mainBtn {
    if (!_mainBtn) {
        _mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mainBtn setBackgroundImage:[UIImage imageNamed:@"community_recording_bg"] forState:UIControlStateNormal];
        [_mainBtn sizeToFit];
        [_mainBtn addTarget:self action:@selector(didClickMainFunctionAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mainBtn;
}

- (UIView *)blankView {
    if (!_blankView) {
        _blankView = [[UIView alloc]init];
        _blankView.backgroundColor = [UIColor whiteColor];
        _blankView.bounds = CGRectMake(0, 0, 57, 57);
        _blankView.layer.cornerRadius = _blankView.height/2.0;
        _blankView.layer.masksToBounds = YES;
        _blankView.userInteractionEnabled = NO;
    }
    return _blankView;
}

- (UIImageView *)focusStateImg {
    if (!_focusStateImg) {
        _focusStateImg = [[UIImageView alloc]init];
    }
    return _focusStateImg;
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
