//
//  LLRoomJoinPartyRoomGuideView.m
//  XC_TTRoomMoudle
//
//  Created by Lee on 2019/10/12.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLRoomJoinPartyRoomGuideView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"

@interface LLRoomJoinPartyRoomGuideView ()

@property (nonatomic, strong) UIImageView *imageView; // 图片
@property (nonatomic, strong) UILabel *textLabel; // 滑动试试？
@property (nonatomic, strong) UILabel *tipLabel; // 发现更多嗨聊房!

@end

@implementation LLRoomJoinPartyRoomGuideView

#pragma mark - lifeCyle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.65];
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];
    [self addSubview:self.tipLabel];
}

- (void)initConstraints {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(24);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(8);
        make.centerX.mas_equalTo(self);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

#pragma mark -
#pragma mark getter && setter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_SwipeRoom_icon"]];
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"滑动试试？";
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = UIColor.whiteColor;
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"发现更多嗨聊房!";
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [XCTheme getTTMainColor];
    }
    return _tipLabel;
}
@end
