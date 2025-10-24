//
//  TTGoddessTableFooterView.m
//  AFNetworking
//
//  Created by lvjunhang on 2019/6/3.
//

#import "TTGoddessTableFooterView.h"

#import "TTGoddessViewProtocol.h"

#import "XCMacros.h"
#import "XCTheme.h"

#import <Masonry/Masonry.h>

@interface TTGoddessTableFooterView ()
@property (nonatomic, strong) UIButton *moreButton;
@end

@implementation TTGoddessTableFooterView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    //setting default frame
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, KScreenWidth, 50);
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)didClickMoreButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTableFooterView:)]) {
        [self.delegate didClickTableFooterView:self];
    }
}

#pragma mark - Private Methods
#pragma mark layout
- (void)initViews {
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.moreButton];
}

- (void)initConstraints {
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView).inset(44);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(38);
    }];
}

#pragma mark - Getters and Setters
- (UIButton *)moreButton {
    if (_moreButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = UIColorFromRGB(0xFEF5ED);
        [button setTitle:@"没喜欢的？点击查看更多" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xFFB606) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(didClickMoreButton) forControlEvents:UIControlEventTouchUpInside];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 19;
        
        _moreButton = button;
    }
    return _moreButton;
}

@end
