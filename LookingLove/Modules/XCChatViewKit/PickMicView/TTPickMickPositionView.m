//
//  TTPickMickPositionView.m
//  WanBan
//
//  Created by lvjunhang on 2020/10/13.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTPickMickPositionView.h"

#import "XCTheme.h"

#import <Masonry/Masonry.h>

@interface TTPickMickPositionView ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;
@end

@implementation TTPickMickPositionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.button];
        [self addSubview:self.label];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(44);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.button.mas_bottom).offset(8);
            make.left.right.mas_equalTo(0);
        }];
    }
    return self;
}

/// 坑位名称
- (void)postionLabel:(NSString *)name {
    self.label.text = name;
}

- (void)setPicked:(BOOL)picked {
    _picked = picked;
    
    _button.enabled = !picked;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundImage:[UIImage imageNamed:@"room_mic_pick_pos_normal"] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:@"room_mic_pick_pos_select"] forState:UIControlStateDisabled];
        _button.userInteractionEnabled = NO;
    }
    return _button;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:11];
        _label.textColor = XCThemeThirdTextColor;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

@end
