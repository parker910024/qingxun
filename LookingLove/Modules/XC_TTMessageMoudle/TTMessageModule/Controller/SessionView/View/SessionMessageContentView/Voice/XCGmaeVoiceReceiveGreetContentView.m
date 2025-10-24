//
//  XCGmaeVoiceReceiveGreetContentView.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/17.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "XCGmaeVoiceReceiveGreetContentView.h"

#import "TTVoiceBottleGreetView.h"

#import "XCCurrentVCStackManager.h"

#import "ImMessageCore.h"
#import "ImMessageCoreClient.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"

#define FS(x) (x *M_PI /180)

@interface XCGmaeVoiceReceiveGreetContentView ()<ImMessageCoreClient>

/** 显示打招呼的文字*/
@property (nonatomic,strong) UILabel *contentLabel;

/** 消息实体*/
@property (nonatomic,strong) XCGameVoiceBottleAttachment *voiceAttach;

/** 消息*/
@property (nonatomic,strong) NIMMessage *message;

/** 是不是已经出现过动画*/
@property (nonatomic,assign) BOOL isShowAnimation;;

@end

@implementation XCGmaeVoiceReceiveGreetContentView

#pragma mark - life cycle
- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (instancetype)initSessionMessageContentView  {
    if (self = [super initSessionMessageContentView]) {
        AddCoreClient(ImMessageCoreClient, self);
        [self addSubview:self.contentLabel];
        [self initContrations];
    }
    return self;
}

- (void)initContrations {
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self);
    }];
}

- (void)addGreetAnimation {
    
    TTVoiceBottleGreetView *view = [[TTVoiceBottleGreetView alloc] init];
    view.content = @"Ta向你发送了一颗小心心~";
    view.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
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
    rotation.values = @[@(FS(0)),@(FS(-5)), @(FS(-10)), @(FS(10)),@(FS(5)),@(FS(0)),@(FS(-5)),@(FS(-10)), @(FS(10)),@(FS(5)),@(FS(0))];
    rotation.keyTimes = @[@(0),@(0.1),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(0.7), @(0.8), @(0.9), @(1.0)];
    rotation.repeatCount = 1;
    rotation.duration = 1;
    rotation.beginTime = 0.65;
    rotation.removedOnCompletion = NO;
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations = @[alphaAnimation, animation, rotation];
    group.duration = 1.65;
    group.repeatCount = 1;
    group.removedOnCompletion = NO;
    [view.backImageView.layer addAnimation:group forKey:@"greet"];
    
    self.isShowAnimation = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view removeFromSuperview];
        
        self.voiceAttach.isReceiveGreet = YES;
        self.message.localExt = [self.voiceAttach model2dictionary];
        [GetCore(ImMessageCore) updateMessage:self.message session:self.message.session];
    });
    
}


- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    Attachment * attach = (Attachment *)object.attachment;
    if (attach.first == Custom_Noti_Header_Game_VoiceBottle) {
        if (attach.second == Custom_Noti_Sub_Voice_Bottle_Heart) {
            self.message = data.message;
            if (data.message.localExt) {
               XCGameVoiceBottleAttachment * mentoringAtttach = [XCGameVoiceBottleAttachment modelDictionary:data.message.localExt];
                self.voiceAttach = mentoringAtttach;
                self.contentLabel.text = [NSString stringWithFormat:@"  %@", mentoringAtttach.message];
                if (!mentoringAtttach.isReceiveGreet && !self.model.message.isOutgoingMsg && !self.isShowAnimation) {
                    [self addGreetAnimation];
                }
              
            }else {
                XCGameVoiceBottleAttachment * mentoringAtttach = [XCGameVoiceBottleAttachment modelDictionary:attach.data];
                self.voiceAttach = mentoringAtttach;
                self.contentLabel.text = [NSString stringWithFormat:@"  %@", mentoringAtttach.message];
                if (!self.model.message.isOutgoingMsg && !self.isShowAnimation) {
                       [self addGreetAnimation];
                }
            }
           
            if (self.model.message.isOutgoingMsg) {
                self.contentLabel.textAlignment = NSTextAlignmentRight;
                self.contentLabel.textColor = [UIColor whiteColor];
            }else{
                self.contentLabel.textAlignment = NSTextAlignmentLeft;
                self.contentLabel.textColor = [XCTheme getTTMainTextColor];
            }
        }
    }
}
#pragma mark - setters and getters
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
