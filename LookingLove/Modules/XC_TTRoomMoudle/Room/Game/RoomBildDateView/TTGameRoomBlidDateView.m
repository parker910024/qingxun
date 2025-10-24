//
//  TTGameRoomBlidDateView.m
//  CeEr
//
//  Created by jiangfuyuan on 2020/12/18.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTGameRoomBlidDateView.h"

#import "RoomQueueCoreV2.h"
#import "AuthCore.h"
#import "ImRoomCoreV2.h"
#import "TTBlindDateCore.h"
#import "TTBlindDateCoreClient.h"
#import "TTHalfWebAlertView.h"

#import "TTPopup.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "XCHtmlUrl.h"

#import "TTStatisticsService.h"
#import "UIFont+FontCollection.h"
#import "SVGAParserManager.h"
#import "SVGAImageView.h"
#import <Masonry/Masonry.h>

@interface TTGameRoomBlidDateView ()

@property (nonatomic, strong) UIButton *bildDateBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *nextStepBtn;
// 相亲房流程动画
@property (nonatomic, strong) SVGAImageView *effectView;

@property (nonatomic, strong) SVGAParserManager *parserManager;

@end

@implementation TTGameRoomBlidDateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
        AddCoreClient(TTBlindDateCoreClient, self);
    }
    return self;
}

- (void)countDownTimer:(NSInteger)time {
    RoomInfo *info = GetCore(ImRoomCoreV2).currentRoomInfo;
    if (info.procedure == BlindDateProcedure_selectLove || info.procedure == BlindDateProcedure_selectLoveTimerEnd) {
        self.titleLabel.text = [NSString stringWithFormat:@"心动选择\n%02ld:%02ld",time / 60, time % 60];
        if (time == 0) {
            self.titleLabel.text = @"心动选择";
        }
    }
}

- (void)roomInfoUpdateAndUpdateLoveRoomStatus:(RoomInfo *)info {
    BOOL isOnMic = [GetCore(RoomQueueCoreV2) isOnMicro:GetCore(AuthCore).getUid.userIDValue];
    if (isOnMic) {
        int positionValue = [GetCore(RoomQueueCoreV2) findThePositionByUid:GetCore(AuthCore).getUid.userIDValue].intValue;
        if (positionValue == -1 && ((GetCore(RoomQueueCoreV2).myMember.type == NIMChatroomMemberTypeCreator) || (GetCore(RoomQueueCoreV2).myMember.type == NIMChatroomMemberTypeManager))) {
            [self updateStatusWithHost];
        } else {
            [self updateStatusWithOnMicUser];
        }
    } else {
        [self updateStatusWithDownMicUser];
    }
}

- (void)nextStepClick:(UIButton *)sender {
    RoomInfo *info = GetCore(ImRoomCoreV2).currentRoomInfo;
    if (info.procedure == BlindDateProcedure_Indroduce) {
        [TTStatisticsService trackEvent:@"room_blinddate_next" eventDescribe:@"点击下一步"];
        [TTPopup alertWithMessage:@"当前正在自我介绍阶段，是否确认开始心动选择？" confirmHandler:^{
            [TTPopup dismiss];
            [GetCore(TTBlindDateCore) updateLoveRoomProcedureWithRoomUid:info.uid uid:GetCore(AuthCore).getUid.userIDValue position:-1 procedure:BlindDateProcedure_selectLove];
        } cancelHandler:^{
            [TTPopup dismiss];
        }];
    } else if (info.procedure == BlindDateProcedure_selectLove || info.procedure == BlindDateProcedure_selectLoveTimerEnd) {
        [TTStatisticsService trackEvent:@"room_blinddate_next" eventDescribe:@"点击下一步"];
        [TTPopup alertWithMessage:@"当前正在心动选择阶段，是否确认公布心动？" confirmHandler:^{
            [TTPopup dismiss];
            [GetCore(TTBlindDateCore) updateLoveRoomProcedureWithRoomUid:info.uid uid:GetCore(AuthCore).getUid.userIDValue position:-1 procedure:BlindDateProcedure_publicLove];
        } cancelHandler:^{
            [TTPopup dismiss];
        }];
    } else if (info.procedure == BlindDateProcedure_publicLove || info.procedure == BlindDateProcedure_resetIndroduce) {
        [TTStatisticsService trackEvent:@"room_blinddate_restart" eventDescribe:@"点击重新开始"];
        [TTPopup alertWithMessage:@"当前正在公布心动阶段，重新开始后将会清空用户的心动值与已选对象，确认重新开始吗？" confirmHandler:^{
            [TTPopup dismiss];
            [GetCore(TTBlindDateCore) updateLoveRoomProcedureWithRoomUid:info.uid uid:GetCore(AuthCore).getUid.userIDValue position:-1 procedure:BlindDateProcedure_Indroduce];
        } cancelHandler:^{
            [TTPopup dismiss];
        }];
    }
}

// 大头麦上的是管理员或者房主，正常操作
- (void)updateStatusWithHost {
    self.nextStepBtn.hidden = NO;
    [self roominfoUpdateAndChangeCurrentType];
}

// 大头麦上的是普通用户，那就和其他麦位一样的处理，无操作权限
- (void)updateStatusWithOnMicUser {
    self.nextStepBtn.hidden = YES;
    [self roominfoUpdateAndChangeCurrentType];
}

// 麦下用户状态
- (void)updateStatusWithDownMicUser {
    self.nextStepBtn.hidden = YES;
    [self roominfoUpdateAndChangeCurrentType];
}

- (void)roominfoUpdateAndChangeCurrentType {
    RoomInfo *info = GetCore(ImRoomCoreV2).currentRoomInfo;
    [self.nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    switch (info.procedure) {
        case BlindDateProcedure_Indroduce:
            [GetCore(TTBlindDateCore) stopTimer];
            self.titleLabel.text = @"自我介绍";
            break;
        case BlindDateProcedure_selectLove:
        case BlindDateProcedure_selectLoveTimerEnd:
            self.titleLabel.text = @"心动选择";
            if (info.remainderTime.integerValue <= 0) {
                [GetCore(TTBlindDateCore) stopTimer];
                self.titleLabel.text = @"心动选择";
            } else {
                [GetCore(TTBlindDateCore) createSelectLoveTimer:info.chooseTime];
            }
            break;
        case BlindDateProcedure_publicLove:
        case BlindDateProcedure_resetIndroduce:
            [GetCore(TTBlindDateCore) stopTimer];
            self.titleLabel.text = @"公布心动";
            [self.nextStepBtn setTitle:@"重新开始" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

// 创建心动选择倒计时 计时器
//- (void)createSelectLoveTimer:(NSString *)startTime {
//    RoomInfo *info = GetCore(ImRoomCoreV2).currentRoomInfo;
//
//    if (info.remainderTime.integerValue <= 0) {
//        if (self.selectLoveTimer) {
//            dispatch_source_cancel(self.selectLoveTimer);
//            self.selectLoveTimer = nil;
//        }
//        self.titleLabel.text = @"心动选择";
//        return;
//    }
//    @weakify(self);
//    if (!self.selectLoveTimer) {
//        self.timerTime = info.remainderTime.integerValue;
//        dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//        self.selectLoveTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
//
//        dispatch_source_set_timer(self.selectLoveTimer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//
//        dispatch_source_set_event_handler(self.selectLoveTimer, ^{
//            @strongify(self);
//            //1. 每调用一次 时间-1s
//            self.timerTime--;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                @strongify(self);
//                self.titleLabel.text = [NSString stringWithFormat:@"心动选择\n%02ld:%02ld",self.timerTime / 60, self.timerTime % 60];
//                if (self.timerTime <= 0) {
//                    dispatch_source_cancel(self.selectLoveTimer);
//                    self.selectLoveTimer = nil;
//                    self.titleLabel.text = @"心动选择";
//                }
//            });
//        });
//        dispatch_resume(self.selectLoveTimer);
//    }
//}

- (void)updateLoveRoomProcedureFailure:(NSString *)msg {
    // 本轮无人选择心动
    [TTPopup alertWithMessage:msg confirmHandler:^{
        [GetCore(TTBlindDateCore) updateLoveRoomProcedureWithRoomUid:GetCore(ImRoomCoreV2).currentRoomInfo.uid uid:GetCore(AuthCore).getUid.userIDValue position:-1 procedure:BlindDateProcedure_Indroduce];
    } cancelHandler:^{
//        [GetCore(WBBlindDateCore) updateLoveRoomProcedureWithRoomUid:GetCore(XCIMCore).chatRoomAdatper.chatRoomManager.currentRoomInfo.uid uid:GetCore(AuthCore).getUid.userIDValue position:-2 procedure:BlindDateProcedure_resetIndroduce];
    }];
}

- (void)blindDateRule:(UIButton *)sender {
    [TTStatisticsService trackEvent:@"room_blinddate_rule" eventDescribe:@"规则介绍"];
    //半屏webview
    TTHalfWebAlertView *alert = [[TTHalfWebAlertView alloc] init];
    alert.urlString = [NSString stringWithFormat:@"%@",HtmlUrlKey(kLoveRoomRule)];
    @weakify(alert);
    alert.dismissRequestHandler = ^() {
        @strongify(alert);
        [TTPopup dismiss];
        [alert removeFromSuperview];
        alert = nil;
    };
    [TTPopup popupView:alert style:TTPopupStyleActionSheet];
}

// 相亲房流程svga
- (void)procedureUpdateAndShowProcedureSvga:(BlindDateProcedure)procedure {
    switch (procedure) {
        case BlindDateProcedure_Indroduce:
            [self loadSvgaAnimation:@"introduce"];
            break;
        case BlindDateProcedure_selectLove:
            [self loadSvgaAnimation:@"chooseLove"];
            break;
        case BlindDateProcedure_publicLove:
            [self loadSvgaAnimation:@"publicLove"];
            break;
        default:
            break;
    }
}
- (void)loadSvgaAnimation:(NSString *)matchStr {
    
    NSString *matchString = [[NSBundle mainBundle] pathForResource:matchStr ofType:@"svga"];
    NSURL *matchUrl = [NSURL fileURLWithPath:matchString];
    
    @KWeakify(self);
    [self.parserManager loadSvgaWithURL:matchUrl completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        @KStrongify(self)
        self.effectView.loops = 1;
        self.effectView.clearsAfterStop = YES;
        self.effectView.videoItem = videoItem;
        [self.effectView startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
}

- (void)initViews {
    
    AddCoreClient(TTBlindDateCoreClient, self);
    [self addSubview:self.bildDateBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.nextStepBtn];
    [self addSubview:self.effectView];
}

- (void)initConstraints {
    [self.bildDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bildDateBtn.mas_bottom).offset(5);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_greaterThanOrEqualTo(16);
    }];
    
    [self.nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(24);
    }];
    
    [self.effectView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(125);
        make.center.mas_equalTo(self.bildDateBtn);
    }];
}

- (UIButton *)bildDateBtn {
    if (!_bildDateBtn) {
        _bildDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bildDateBtn setImage:[UIImage imageNamed:@"room_bildDate_center"] forState:UIControlStateNormal];
        [_bildDateBtn addTarget:self action:@selector(blindDateRule:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bildDateBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0xffffff);
        _titleLabel.font = [UIFont PingFangSC_Medium_WithFontSize:10];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = UIColorRGBAlpha(0x000000, 0.3);
        _titleLabel.layer.cornerRadius = 4;
        _titleLabel.layer.masksToBounds = YES;
    }
    return _titleLabel;
}

- (UIButton *)nextStepBtn {
    if (!_nextStepBtn) {
        _nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        _nextStepBtn.titleLabel.font = [UIFont PingFangSC_Medium_WithFontSize:10];
        _nextStepBtn.backgroundColor = XCThemeMainColor;
        _nextStepBtn.layer.cornerRadius = 12;
        _nextStepBtn.layer.masksToBounds = YES;
        _nextStepBtn.layer.borderWidth = 2;
        _nextStepBtn.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
        [_nextStepBtn addTarget:self action:@selector(nextStepClick:) forControlEvents:UIControlEventTouchUpInside];
        _nextStepBtn.hidden = YES;
    }
    return _nextStepBtn;
}

- (SVGAImageView *)effectView {
    if (!_effectView) {
        _effectView = [[SVGAImageView alloc]init];
        _effectView.userInteractionEnabled = NO;
    }
    return _effectView;
}

- (SVGAParserManager *)parserManager {
    if (!_parserManager) {
        _parserManager = [[SVGAParserManager alloc]init];
    }
    return _parserManager;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
