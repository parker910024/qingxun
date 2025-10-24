//
//  TTPositionVipView.m
//  TTPositionView
//
//  Created by fengshuo on 2019/5/20.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "TTPositionVipView.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"

@implementation TTPositionVipView
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}
#pragma mark - public method
- (void)positionVipStartAnimation {
    CABasicAnimation *rotationAnim = [[CABasicAnimation alloc] init];
    rotationAnim.keyPath = @"transform.rotation.z";
    rotationAnim.fromValue = @(0);
    rotationAnim.toValue = @(M_PI*2);
    rotationAnim.duration = 3.0;
    rotationAnim.repeatCount = CGFLOAT_MAX;
    rotationAnim.removedOnCompletion = NO;
    [_positionVipImageView.layer addAnimation:rotationAnim forKey:nil];
}

- (void)positionVipStopAnimation {
    [_positionVipImageView.layer removeAllAnimations];
}

- (void)hiddenPositionVipView {
    self.hidden = YES;
    self.positionVipImageView.hidden = YES;
    self.positionVipImageView.hidden = YES;
}

- (void)showPositionVipView {
    self.hidden = NO;
    self.positionVipImageView.hidden = NO;
    self.positionSeatImageView.hidden = NO;
}

#pragma mark - Private method
- (void)initView {

    [self addSubview:self.positionVipImageView];
    [self addSubview:self.positionSeatImageView];
    if (projectType() != ProjectType_CeEr || projectType() == ProjectType_LookingLove) {
       [self positionVipStartAnimation];
    }
    
}

- (void)initContrations {
    
    if (projectType() == ProjectType_CeEr || projectType() == ProjectType_LookingLove) {
        [self.positionVipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(self.mas_width);
            make.center.mas_equalTo(self);
        }];
        
        [self.positionSeatImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(self.mas_height);
        }];
    }else {
        [self.positionVipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(self.mas_width);
            make.center.mas_equalTo(self);
        }];
        
        [self.positionSeatImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(self.mas_width).multipliedBy(37/32* 1.2);
            make.height.mas_equalTo(self.mas_height).multipliedBy(1.2);
        }];
    }
}

#pragma mark - setters and getters
- (UIImageView *)positionVipImageView {
    if (!_positionVipImageView) {
        _positionVipImageView = [[UIImageView alloc] init];
        _positionVipImageView.hidden = YES;
        _positionVipImageView.image = [UIImage imageNamed:@"room_game_position_vip_sun"];
    }
    return _positionVipImageView;
}

- (UIImageView *)positionSeatImageView {
    if (!_positionSeatImageView) {
        _positionSeatImageView = [[UIImageView alloc] init];
        _positionSeatImageView.hidden = YES;
        _positionSeatImageView.image = [UIImage imageNamed:@"room_game_position_vip_seat"];
    }
    return _positionSeatImageView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
