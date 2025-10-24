//
//  TTPersonalFooterView.m
//  TTPlay
//
//  Created by lee on 2019/3/15.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTPersonalFooterView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"

@interface TTPersonalFooterView ()
@property (nonatomic, strong) UIView *lineView;
@end

@implementation TTPersonalFooterView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self addSubview:self.lineView];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(18, 5, KScreenWidth - 36, 0.5)];
        _lineView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    }
    return _lineView;
}
@end
