//
//  TTVoiceNewUserGuide.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/18.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTVoiceNewUserGuide.h"
//xc类
#import "XCMacros.h"



@interface TTVoiceNewUserGuide ()

/** 背景图*/
@property (nonatomic,strong) UIImageView *backImageView;

@end


@implementation TTVoiceNewUserGuide

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)tapBackImageView {
    [self removeFromSuperview];
    if (self.show) {
        self.show(YES);
    }
}

- (void)showVoiceNewUserGuide {
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
}


- (void)initView {
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self addSubview:self.backImageView];
    UIImage * backImage = [UIImage imageNamed:iPhoneXSeries ? @"game_voice_message_greet_x" : @"game_voice_message_greet"];
    self.backImageView.image = backImage;
    self.backImageView.bounds = self.frame;
    self.backImageView.center = self.center;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackImageView)];
    [self.backImageView addGestureRecognizer:tap];
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}
    
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
