//
//  TTEmptyPackGiftView.m
//  TTSendGiftView
//
//  Created by Macx on 2019/4/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTEmptyPackGiftView.h"

#import "TTSendGiftViewConfig.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTEmptyPackGiftView ()
@property (nonatomic, strong) UILabel *emptyPackTip;//礼物背包空的提示语
@end

@implementation TTEmptyPackGiftView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response

#pragma mark - private method

- (void)initView {
    [self addSubview:self.emptyPackTip];
}

- (void)initConstrations {
    [self.emptyPackTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
}

#pragma mark - getters and setters

- (UILabel *)emptyPackTip {
    if (!_emptyPackTip) {
        _emptyPackTip = [[UILabel alloc] init];
        _emptyPackTip.text = [TTSendGiftViewConfig globalConfig].room_gift_package_tip;
        _emptyPackTip.textColor = UIColorFromRGB(0x999999);
        _emptyPackTip.font = [UIFont systemFontOfSize:12];
    }
    return _emptyPackTip;
}

@end
