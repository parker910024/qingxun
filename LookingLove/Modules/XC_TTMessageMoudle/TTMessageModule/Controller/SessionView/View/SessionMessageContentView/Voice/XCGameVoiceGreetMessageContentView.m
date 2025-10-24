//
//  XCGameVoiceGreetMessageContentView.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/5.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "XCGameVoiceGreetMessageContentView.h"
#import "UIView+NIM.h"
//XC_tt
#import "XCCurrentVCStackManager.h"
#import "TTStatisticsService.h"
#import "TTNewbieGuideView.h"
//core
#import "AuthCore.h"
#import "Attachment.h"
#import "ImMessageCore.h"
//view
#import "XCGameVoiceGreetView.h"
#import "TTVoiceBottleGreetView.h"
#import "TTVoiceNewUserGuide.h"

#import <pop/POP.h>

#define FS(x) (x *M_PI /180)

static NSString * const KVoiceBottleGreetNewUserGuderKey = @"KVoiceBottleGreetNewUserGuderKey";

@interface XCGameVoiceGreetMessageContentView ()

/** 显示打招呼*/
@property (nonatomic,strong) XCGameVoiceGreetView *greetView;

/** 当前的回话*/
@property (nonatomic,strong) NIMMessage *message;

/** attach*/
@property (nonatomic,strong) XCGameVoiceBottleAttachment *voiceAttach;

@end

@implementation XCGameVoiceGreetMessageContentView
#pragma mark - life cycle
- (instancetype)initSessionMessageContentView {
    if ([super initSessionMessageContentView]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.bubbleImageView.hidden = YES;
    [self addSubview:self.greetView];
    @weakify(self);
    self.greetView.clickGreet = ^(UIButton * _Nonnull sender) {
        @strongify(self);
        [TTStatisticsService trackEvent:@"private_chat_sayHello" eventDescribe:@"打个招呼"];
        [self addGreetAnimation];
        if (self.voiceAttach && self.message) {
            self.voiceAttach.isGreet = YES;
            self.message.localExt = [self.voiceAttach model2dictionary];
            [GetCore(ImMessageCore) updateMessage:self.message session:self.message.session];
            [self performSelector:@selector(sendMessageToFriend) withObject:nil afterDelay:1];
        }
       
    };
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    Attachment * attach = (Attachment *)object.attachment;
    if (attach.first == Custom_Noti_Header_Game_VoiceBottle) {
        if (attach.second == Custom_Noti_Sub_Voice_Bottle_Hello) {
            // 轻寻不展示新手引导
            if (projectType() != ProjectType_LookingLove || projectType() != ProjectType_Planet) {
                [self showNewUserGuide];
            }
            self.message = data.message;
            if (data.message.localExt) {
                XCGameVoiceBottleAttachment * mentoringAtttach = [XCGameVoiceBottleAttachment modelDictionary:data.message.localExt];
                self.voiceAttach = mentoringAtttach;
                self.voiceAttach.message = mentoringAtttach.data[@"message"];
                NSString * voiceUid = mentoringAtttach.data[@"voiceUid"];
                self.voiceAttach.voiceUid = voiceUid.userIDValue;
                self.greetView.voiceAttach = mentoringAtttach;
            }else{
                XCGameVoiceBottleAttachment * mentoringAtttach = [XCGameVoiceBottleAttachment modelDictionary:attach.data];
                  self.voiceAttach = mentoringAtttach;
                self.greetView.voiceAttach = mentoringAtttach;
            }
        }
    }
}

- (void)showNewUserGuide {
    NSString * key = [NSString stringWithFormat:@"%@_%@", KVoiceBottleGreetNewUserGuderKey, GetCore(AuthCore).getUid];
    BOOL isShow = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    if (!isShow) {
        TTVoiceNewUserGuide * guide = [[TTVoiceNewUserGuide alloc] init];
        [guide showVoiceNewUserGuide];
        guide.show = ^(BOOL show) {
            if (show) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
            }
        };
    }
}
    

- (void)sendMessageToFriend {
    //自动发送一句话 给徒弟
     NSString * message = @"Hi~我在声音瓶子喜欢了你";
    self.voiceAttach.message = self.voiceAttach.message ? self.voiceAttach.message : message;
    Attachment * attach = [[Attachment alloc] init];
    attach.first = Custom_Noti_Header_Game_VoiceBottle;
    attach.second = Custom_Noti_Sub_Voice_Bottle_Heart;
    attach.data = self.voiceAttach.data;
    
    [GetCore(ImMessageCore) sendCustomMessageAttachement:attach sessionId:[NSString stringWithFormat:@"%lld", self.voiceAttach.voiceUid] type:NIMSessionTypeP2P yidunEnabled:YES needApns:NO apnsContent:nil];
}

- (void)addGreetAnimation {

    TTVoiceBottleGreetView *view = [[TTVoiceBottleGreetView alloc] init];
    view.center = [XCCurrentVCStackManager shareManager].getCurrentVC.view.center;
    [[XCCurrentVCStackManager shareManager].getCurrentVC.view addSubview:view];
    


    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(1), @(1.2), @(1)];
    animation.keyTimes = @[@(0) , @(0.25), @(0.5)];
    animation.duration = 0.5;
    animation.removedOnCompletion = NO;
    animation.repeatCount = 1;
    
    CAKeyframeAnimation * alphaAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animation.values = @[@(0), @(0.5), @(1)];
    animation.keyTimes = @[@(0) , @(0.25), @(0.5)];
    animation.duration = 0.5;
    animation.removedOnCompletion = NO;
    animation.repeatCount = 1;
    
    
    CAKeyframeAnimation * rotation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.values = @[@(FS(0)), @(FS(-10)), @(FS(10)),@(FS(0)),@(FS(-10)), @(FS(10)),@(FS(0))];
    rotation.keyTimes = @[@(0.1),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(0.7)];
    rotation.repeatCount = 1;
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotation.duration = 0.7;
    rotation.beginTime = 0.65;
    rotation.removedOnCompletion = NO;
    
//    CASpringAnimation * spring = [CASpringAnimation animationWithKeyPath:@"transform.rotation"];
//    spring.beginTime = 0.65;
//    spring.mass = 5;
//    spring.damping = 5;
//    spring.fromValue = @(FS(0));
//    spring.toValue = @(FS(-10));
//    spring.duration = 0.1;
    
//    CASpringAnimation * spring = [CASpringAnimation animationWithKeyPath:@"transform.rotation"];
//    spring.beginTime = 0.65;
//    spring.mass = 5;
//    spring.damping = 5;
//    spring.fromValue = @(FS(-10));
//    spring.toValue = @(FS(10));
//    spring.duration = 0.7;
    
    
    
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations = @[alphaAnimation, animation, rotation];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.duration = 1.35;
    group.repeatCount = 1;
    group.removedOnCompletion = NO;
    [view.backImageView.layer addAnimation:group forKey:@"greet"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [view removeFromSuperview];
    });

}


- (void)layoutSubviews {
    if (self.frame.origin.x >= 0) {
        self.greetView.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f;
    }else {
        self.greetView.nim_centerX = [UIScreen mainScreen].bounds.size.width * .5f + 26;
    }
    self.greetView.nim_centerY = self.nim_centerY;
    self.greetView.nim_width = [UIScreen mainScreen].bounds.size.width;
    self.greetView.nim_height = 70;
}

- (XCGameVoiceGreetView *)greetView {
    if (!_greetView) {
        _greetView = [[XCGameVoiceGreetView alloc] init];
    }
    return _greetView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
