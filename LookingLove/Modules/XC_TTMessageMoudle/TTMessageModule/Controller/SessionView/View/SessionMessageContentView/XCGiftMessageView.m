//
//  XCGiftMessageView.m
//  XChat
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCGiftMessageView.h"
#import "XCTheme.h"
#import <Masonry.h>
#import "UIImage+Utils.h"

@implementation XCGiftMessageView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self initView];
        [self initContrastions];
    }
    return self;
}

- (void)layoutSubviews {
    [self initContrastions];
}


#pragma private method
- (void)initView
{
    [self addSubview:self.giftImageView];
    [self addSubview:self.giftName];
    [self addSubview:self.giftNum];
}



- (void)initContrastions {
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.mas_equalTo(self).offset(12);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.giftName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.giftImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.giftImageView.mas_top).offset(10);
    }];
    
    [self.giftNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.giftName);
        make.top.mas_equalTo(self.giftName.mas_bottom).offset(10);
        make.width.mas_lessThanOrEqualTo(205-90);
    }];
}

#pragma mark - setters and getters

- (UIImageView *)giftImageView
{
    if(!_giftImageView){
        _giftImageView = [[UIImageView alloc] init];
        _giftImageView.layer.masksToBounds = YES;
        _giftImageView.layer.cornerRadius = 12;
    }
    return _giftImageView;
}

- (UILabel *)giftNum
{
    if(!_giftNum){
        _giftNum = [[UILabel alloc] init];
        _giftNum.textColor = UIColorFromRGB(0x333333);
        _giftNum.font = [UIFont systemFontOfSize:12];
        _giftNum.textAlignment= NSTextAlignmentLeft;
    }
    return _giftNum;
}

- (UILabel *)giftName
{
    if(!_giftName){
        _giftName = [[UILabel alloc] init];
        _giftName.textColor = UIColorFromRGB(0x333333);
        _giftName.font = [UIFont systemFontOfSize:15];
        _giftName.textAlignment= NSTextAlignmentLeft;
    }
    return _giftName;
}




@end
