//
//  TTEditRecordViewController.h
//  TuTu
//
//  Created by Macx on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"
#import <AVFoundation/AVFoundation.h>

@class UserInfo;

typedef void(^TTRecordVoiceRefreshHandler)(NSString *filePath);

@interface TTEditRecordViewController : BaseUIViewController
@property (nonatomic, strong) UserInfo  *info;//

@property (nonatomic, strong) UIButton  *playOrPauseBtn;//

@property (nonatomic, strong) UILabel  *recordTimeLabel;//
@property (nonatomic, assign) int  secondTime;//
@property (nonatomic, strong) NSString  *filePath;//
@property (nonatomic, strong) NSTimer  *timer;//
@property (nonatomic, copy) TTRecordVoiceRefreshHandler recordVoiceRefreshHandler;

- (void)onClickPlayOrPauseAction:(UIButton *)btn;

@end
