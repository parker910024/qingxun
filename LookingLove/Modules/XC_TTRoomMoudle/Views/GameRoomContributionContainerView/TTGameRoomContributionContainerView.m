//
//  TTGameRoomContributionContainerView.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameRoomContributionContainerView.h"
#import <Masonry/Masonry.h>

@interface TTGameRoomContributionContainerView ()
@property (nonatomic, strong) UIView *maskView;
@end

@implementation TTGameRoomContributionContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.maskView];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskViewAction)];
        [self.maskView addGestureRecognizer:tapGR];
    }
    return self;
}

#pragma mark - Private Method
/**
 遮罩视图手势点击事件
 */
- (void)tapMaskViewAction {
    !self.maskViewTapActionBlock ?: self.maskViewTapActionBlock();
}

#pragma mark - Setter Getter
- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
    }
    return _maskView;
}

@end
