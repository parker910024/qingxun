//
//  TTUserCardFunctionView.m
//  TuTu
//
//  Created by 卫明 on 2018/11/16.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTUserCardFunctionView.h"

//mas
#import <Masonry/Masonry.h>

//theme
#import "XCTheme.h"

@interface TTUserCardFunctionView ()

@property (strong, nonatomic) UIImageView *icon;

@property (strong, nonatomic) UILabel *title;

@end

@implementation TTUserCardFunctionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    @weakify(self);
    [RACObserve(self, item)subscribeNext:^(id x) {
        @strongify(self);
        if (!self.item.isDisable) {
            self.icon.image = self.item.normalIcon;
            self.title.text = self.item.normalTitle;
        }else {
            self.icon.image = self.item.disableIcon;
            self.title.text = self.item.disableTitle;
        }
    }];
    
    [RACObserve(self, item.isDisable) subscribeNext:^(id x) {
        @strongify(self);
        if (!self.item.isDisable) {
            self.icon.image = self.item.normalIcon;
            self.title.text = self.item.normalTitle;
        }else {
            self.icon.image = self.item.disableIcon;
            self.title.text = self.item.disableTitle;
        }

    }];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.title];
}

- (void)initConstrations {
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.icon.mas_bottom).offset(10);
    }];
}

- (void)setItem:(TTUserCardFunctionItem *)item {
    _item = item;
    
}

#pragma mark - setter && getter

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = [UIFont systemFontOfSize:10.f];
        _title.textColor = UIColorFromRGB(0x999999);
    }
    return _title;
}

@end
