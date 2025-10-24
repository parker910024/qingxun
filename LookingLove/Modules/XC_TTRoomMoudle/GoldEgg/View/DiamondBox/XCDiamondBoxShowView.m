//
//  XCShowHandlerView.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCDiamondBoxShowView.h"
#import <Masonry.h>
#import "XCTheme.h"


@interface XCDiamondBoxShowView()

@property (nonatomic, strong) UIButton *recodeButton;//中奖记录
@property (nonatomic, strong) UIButton *helpButton;//帮助
@property (nonatomic, strong) UIButton *jackpotButton;//奖池

@end

@implementation XCDiamondBoxShowView

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupSubviewsConstraints];
}

#pragma mark - event response
- (void)buttonDidClick:(UIButton *)button {
    if (self.DiamondBoxShowViewBlock) {
        self.DiamondBoxShowViewBlock(button.tag);
    }
}

#pragma mark - Private
- (void)setupSubviews {
    [self addSubview:self.helpButton];
    [self addSubview:self.jackpotButton];
    [self addSubview:self.recodeButton];
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

- (UIButton *)buttonWithImage:(NSString *)imgName tag:(int)tag {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [button setTag:tag];
    [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Getter
- (UIButton *)recodeButton {
    if (!_recodeButton) {
        _recodeButton = [self buttonWithImage:@"room_box_diamond_recode" tag:XCDiamondBoxShowTypeRecode];
    }
    return _recodeButton;
}
- (UIButton *)helpButton {
    if (!_helpButton) {
        if (!_helpButton) {
            _helpButton = [self buttonWithImage:@"room_box_diamond_help" tag:XCDiamondBoxShowTypeHelp];
        }
        return _helpButton;
    }
    return _helpButton;
}
- (UIButton *)jackpotButton {
    if (!_jackpotButton) {
        _jackpotButton = [self buttonWithImage:@"room_box_diamond_jackpot" tag:XCDiamondBoxShowTypeJackpot];
    }
    return _jackpotButton;
}

@end
