//
//  XCNewsNoticeMessageView.m
//  XChat
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCNewsNoticeMessageView.h"
#import "XCTheme.h"
#import <Masonry.h>

@implementation XCNewsNoticeMessageView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initView];
//        [self initContrastions];
    }
    return self;
}

#pragma mark - private method
- (void)initView{
    [self addSubview:self.title];
    [self addSubview:self.picImageView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.sepLineView];
    [self addSubview:self.clickCheckLabel];
    [self addSubview:self.arrowImageView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
    }];
    
    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.top.mas_equalTo(self.title.mas_bottom).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.height.mas_equalTo(70);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.top.mas_equalTo(self.picImageView.mas_bottom).offset(10);
        make.right.mas_equalTo(self).offset(-10);
    }];
    
    [self.sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.clickCheckLabel.mas_top).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    [self.clickCheckLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.bottom.mas_equalTo(self).offset(-10);
        make.height.mas_equalTo(16);
    }];
     
     [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.height.mas_equalTo(14);
         make.width.mas_equalTo(8);
         make.centerY.mas_equalTo(self.clickCheckLabel.mas_centerY);
         make.right.mas_equalTo(self).offset(-10);
    }];
}

#pragma mark - setters and getters
- (UIImageView *)picImageView{
    if (!_picImageView){
        _picImageView = [[UIImageView alloc] init];
    }
    return _picImageView;
}

- (UILabel *)title{
    if (!_title){
        _title = [[UILabel alloc] init];
        _title.textColor = UIColorFromRGB(0x333333);
        _title.font = [UIFont systemFontOfSize:16];
        _title.textAlignment = NSTextAlignmentLeft;
    }
    return _title;
}

- (UIView *)sepLineView{
    if (!_sepLineView){
        _sepLineView = [[UIView alloc] init];
        _sepLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    return _sepLineView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = UIColorFromRGB(0x999999);
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView){
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"user_right_arrow"];
    }
    return _arrowImageView;
}

- (UILabel *)clickCheckLabel{
    if (!_clickCheckLabel){
        _clickCheckLabel = [[UILabel alloc] init];
        _clickCheckLabel.textColor = [XCTheme getButtonDefaultBlueColor];
        _clickCheckLabel.text = @"点击查看";
        _clickCheckLabel.font = [UIFont systemFontOfSize:15];
        _clickCheckLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _clickCheckLabel;
}


@end
