//
//  XCTurntableMessageView.m
//  XChat
//
//  Created by 卫明何 on 2018/1/3.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "XCTurntableMessageView.h"
#import "XCTheme.h"
#import <Masonry.h>

@implementation XCTurntableMessageView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        [self addSubview:self.titleLabel];
        [self initContrations];
    }
    return self;
}

#pragma mark - private method
- (void)initContrations
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - setters and getters
- (UILabel *)titleLabel
{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font =[UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"恭喜你，获取抽奖机会，点击我抽奖>>";
        _titleLabel.userInteractionEnabled = YES;
    }
    return _titleLabel;
}


@end
