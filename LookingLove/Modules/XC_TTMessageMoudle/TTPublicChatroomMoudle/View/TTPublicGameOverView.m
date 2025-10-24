//
//  TTPublicGameOverView.m
//  TTPlay
//
//  Created by new on 2019/2/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTPublicGameOverView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIView+Layout.h"

@interface TTPublicGameOverView ()
@property (nonatomic, strong) UIButton *titleButton;
@end

@implementation TTPublicGameOverView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.titleButton];
}

- (void)initConstrations{
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(0);
        make.centerX.mas_equalTo(self);
    }];
}

- (void)setTextString:(NSString *)textString{
    [self.titleButton setTitle:textString forState:UIControlStateNormal];
}


- (UIButton *)titleButton{
    if (_titleButton == nil) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _titleButton.backgroundColor = UIColorFromRGB(0xD6D6D6);
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _titleButton.layer.cornerRadius = 12;
        _titleButton.titleLabel.numberOfLines = 0;
        _titleButton.userInteractionEnabled = NO;
        [_titleButton setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                      forAxis:UILayoutConstraintAxisHorizontal];
        [_titleButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
