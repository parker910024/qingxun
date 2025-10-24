//
//  XCRedPackeMessagetView.m
//  XChat
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "TTRedPackeMessageView.h"
#import "XCTheme.h"
#import <Masonry.h>

@implementation TTRedPackeMessageView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initView];
        [self initContrastions];
    }
    return self;
}

#pragma mark - private method
- (void)initView{
    [self addSubview:self.redIcon];
    [self addSubview:self.redLabel];
}
- (void)initContrastions{
    [self.redIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(45);
        make.left.mas_equalTo(self).offset(10);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.redIcon.mas_right).offset(10);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(5);
    }];
}

#pragma mark - setters and getters
- (UIImageView *)redIcon{
    if(!_redIcon){
        _redIcon = [[UIImageView alloc] init];
    }
    return _redIcon;
}

- (UILabel *)redLabel{
    if(!_redLabel){
        _redLabel = [[UILabel alloc] init];
        _redLabel.textColor = UIColorFromRGB(0x333333);
        _redLabel.font = [UIFont systemFontOfSize:15];
        _redLabel.numberOfLines = 2;
        _redLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _redLabel;
}


@end
