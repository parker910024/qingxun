//
//  TuTuNobleCollectionFooterView.m
//  XChat
//
//  Created by Mac on 2018/1/17.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "TTNobleCollectionFooterView.h"

#import "XCMacros.h"
#import "XCTheme.h"

@interface TTNobleCollectionFooterView()
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation TTNobleCollectionFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupSubViews{
    [self addSubview:self.tipLabel];
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 13)];
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"仅展示爵位最高的前60名贵族";
        _tipLabel.textColor = UIColorRGBAlpha(0xffffff, 0.4);
    }
    return _tipLabel;
}
 
@end
