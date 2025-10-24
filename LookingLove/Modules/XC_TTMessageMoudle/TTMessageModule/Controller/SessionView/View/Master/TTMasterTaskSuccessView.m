//
//  TTMasterTaskSuccessView.m
//  TTPlay
//
//  Created by Macx on 2019/1/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMasterTaskSuccessView.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import <Masonry/Masonry.h>
#import "XCMentoringShipAttachment.h"

@interface TTMasterTaskSuccessView ()
/** bgImageView */
@property (nonatomic, strong) UIImageView *bgImageView;
/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TTMasterTaskSuccessView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
        
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didTapBGView:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(masterTaskSuccessView:didClickCloseButton:)]) {
        [self.delegate masterTaskSuccessView:self didClickCloseButton:tap.view];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.titleLabel];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBGView:)]];
}

- (void)initConstrations {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(275);
        make.height.mas_equalTo(128);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgImageView);
        make.top.mas_equalTo(75);
    }];
}

#pragma mark - getters and setters

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"message_master_task_success"];
    }
    return _bgImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"·您已完成师徒任务·";
        _titleLabel.textColor = RGBCOLOR(102, 102, 102);
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

@end
