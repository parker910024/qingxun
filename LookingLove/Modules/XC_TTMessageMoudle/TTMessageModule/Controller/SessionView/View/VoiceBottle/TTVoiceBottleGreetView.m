//
//  TTVoiceBottleGreetView.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/12.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTVoiceBottleGreetView.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTVoiceBottleGreetView ()

/** 背景图*/
@property (nonatomic,strong) UIImageView *backImageView;

/** 显示内容*/
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation TTVoiceBottleGreetView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, 210, 225);
        [self initView];
        [self initContrations];
    }
    return self;
}


#pragma mark - private method
- (void)initView {
    [self addSubview:self.backImageView];
    [self addSubview:self.titleLabel];
}

- (void)initContrations {
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(210, 210));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(0);
    }];
}

#pragma mark - setters and getters
- (void)setContent:(NSString *)content {
    _content = content;
    if (_content) {
        self.titleLabel.text = _content;
    }
}


- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = [UIImage imageNamed:@"gam_voice_greet"];
    }
    return _backImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  = [XCTheme getTTDeepGrayTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"已向对方发送一颗小心心~";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
