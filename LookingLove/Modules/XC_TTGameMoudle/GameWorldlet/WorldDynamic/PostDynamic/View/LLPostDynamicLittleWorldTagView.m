//
//  LLPostDynamicLittleWorldTagView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2020/1/7.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "LLPostDynamicLittleWorldTagView.h"

#import "LittleWorldDynamicPostWorld.h"

#import "XCTheme.h"

#import <Masonry/Masonry.h>

@interface LLPostDynamicLittleWorldTagView ()
@property (nonatomic, strong) UIButton *nameButton; //小世界标签
@end

@implementation LLPostDynamicLittleWorldTagView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorRGBAlpha(0xFF838D, 0.1);
        self.layer.cornerRadius = 13;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.nameButton];
        
        [self.nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(26);
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 10));
        }];
    }
    return self;
}

- (CGFloat)textWidthWithString:(NSString *)string font:(UIFont *)font {
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 26) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :font} context:nil].size.width;
}

#pragma mark - Public
/// 获取宽度
- (CGFloat)width {
    CGFloat const margin = 10;
    CGFloat txtLeftMargin = margin + 20;
    CGFloat txtRightMargin = margin;
    CGFloat txtWidth = [self textWidthWithString:self.model.worldName font:self.nameButton.titleLabel.font];
    CGFloat width = txtLeftMargin + txtRightMargin + txtWidth;
    return width;
}

#pragma mark - Actions
- (void)didClickNameButton:(UIButton *)sender {
    !self.selectTagHandler ?: self.selectTagHandler();
}

#pragma mark - Setter Getter
- (void)setModel:(LittleWorldDynamicPostWorld *)model {
    _model = model;
    
    [self.nameButton setTitle:model.worldName forState:UIControlStateNormal];
}

- (UIButton *)nameButton {
    if (!_nameButton) {
        _nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nameButton setImage:[UIImage imageNamed:@"littleWorld_Dynamic_typeIcon"] forState:UIControlStateNormal];
        [_nameButton setTitleColor:UIColorFromRGB(0xFF838D) forState:UIControlStateNormal];
        [_nameButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _nameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -6);
        _nameButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
        _nameButton.layer.cornerRadius = 13;
        
        [_nameButton addTarget:self action:@selector(didClickNameButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nameButton;
}

@end
