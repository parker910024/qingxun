//
//  XCShowHandlerView.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCBoxShowView.h"
#import <Masonry.h>
#import "XCTheme.h"


@interface XCBoxShowView()

@property (nonatomic, strong) UIButton *recodeButton;//中奖记录
@property (nonatomic, strong) UIButton *helpButton;//帮助
@property (nonatomic, strong) UIButton *jackpotButton;//奖池

@end

@implementation XCBoxShowView

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupSubviews];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupSubviewsConstraints];
}

#pragma mark - event response
- (void)buttonDidClick:(UIButton *)button{
    if (self.BoxShowViewBlock) {
        self.BoxShowViewBlock(button.tag);
    }
}

#pragma mark - Private
- (void)setupSubviews{
    [self addSubview:self.recodeButton];
    [self addSubview:self.helpButton];
    [self addSubview:self.jackpotButton];
}
- (void)setupSubviewsConstraints{
    [self.recodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.equalTo(@78);
        make.height.equalTo(@35);
    }];
    
    [self.jackpotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.recodeButton);
        make.top.equalTo(self.recodeButton.mas_bottom).offset(20);
    }];
    
    [self.helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.recodeButton);
        make.top.equalTo(self.jackpotButton.mas_bottom).offset(15);
    }];
}

- (UIButton *)buttonWithImage:(NSString *)imgName tag:(int)tag{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Getter
- (UIButton *)recodeButton{
    if (!_recodeButton) {
        _recodeButton = [self buttonWithImage:@"room_box_recode" tag:XCBoxShowTypeRecode];
    }
    return _recodeButton;
}
- (UIButton *)helpButton{
    if (!_helpButton) {
        _helpButton = [self buttonWithImage:@"room_box_help" tag:XCBoxShowTypeHelp];
    }
    return _helpButton;
}
- (UIButton *)jackpotButton{
    if (!_jackpotButton) {
        _jackpotButton = [self buttonWithImage:@"room_box_jackpot" tag:XCBoxShowTypeJackpot];
    }
    return _jackpotButton;
}

@end
