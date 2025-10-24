//
//  TTMusicEntrance.m
//  TuTu
//
//  Created by Mac on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMusicEntrance.h"
//3rd
#import <Masonry/Masonry.h>

//core
#import "MeetingCore.h"

@interface TTMusicEntrance ()

@property (strong, nonatomic) UIImageView *entranceButton;

@end

@implementation TTMusicEntrance


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.entranceButton];
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onEntranceClick:)];
    [self.entranceButton addGestureRecognizer:tap];
}

- (void)initConstrations {
    [self.entranceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self);
        make.center.mas_equalTo(self);
    }];
}

- (void)dealloc {
    
}


#pragma mark - user respone

- (void)onEntranceClick:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(onDidTapToShowMusicPlayerMusicEntrance:)]) {
        [self.delegate onDidTapToShowMusicPlayerMusicEntrance:self];
    }
}



#pragma mark - getter & setter

- (UIImageView *)entranceButton {
    if (!_entranceButton) {
        _entranceButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"room_music_player_entrance"]];
        _entranceButton.userInteractionEnabled = YES;
    }
    return _entranceButton;
}


@end
