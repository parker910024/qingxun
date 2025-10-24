//
//  TTMineMomentOperateView.m
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/11/26.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTMineMomentOperateView.h"

#import "XCTheme.h"
#import "UIButton+EnlargeTouchArea.h"

#import <Masonry/Masonry.h>

@interface TTMineMomentOperateView ()<CAAnimationDelegate>
@property (nonatomic, strong) UIStackView *stackView;

/// 点赞按钮动画辅助，因为动画大小变化，不适合直接在按钮上直接做动画
@property (nonatomic, strong) UIImageView *likeAnimationImageView;

@end

@implementation TTMineMomentOperateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.likeButton, self.commentButton, self.shareButton, self.moreButton]];
        self.stackView.alignment = UIStackViewAlignmentCenter;
        self.stackView.distribution = UIStackViewDistributionEqualSpacing;
        [self addSubview:self.stackView];
        
        [self addSubview:self.likeAnimationImageView];
        
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [self.likeAnimationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.likeButton.imageView);
            make.width.height.mas_equalTo(50);
        }];
    }
    return self;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [self.likeButton setImage:[UIImage imageNamed:@"community_post_like"] forState:UIControlStateNormal];
    self.likeAnimationImageView.hidden = YES;

    if (flag) {
        [self updateLikeButton];
    }
}

#pragma mark - Public
- (void)likeButtonAnimation {
    
    if (!self.model.isLike) {
        self.likeAnimationImageView.hidden = YES;
        [self updateLikeButton];
        return;
    }
    
    //为防止动画过程重影，将当前按钮图片替换为等大空白图片，达到暂时隐藏作用
    [self.likeButton setImage:[UIImage imageNamed:@"community_post_like_placeholder"] forState:UIControlStateNormal];
    self.likeAnimationImageView.hidden = NO;

    //存放图片的数组
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<=13; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dynamic_like_%d", i]];
        [array addObject:(id)image.CGImage];
    }

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.delegate = self;
    animation.duration = 0.52;
    animation.values = array;
    [self.likeAnimationImageView.layer addAnimation:animation forKey:@""];
}

#pragma mark - Private
///更新点赞按钮
- (void)updateLikeButton {
    self.likeButton.selected = self.model.isLike;
    
    NSString *like = [NSString stringWithFormat:@" %ld", (long)self.model.likeCount];
    if (self.model.likeCount > 999) {
        like = @" 999+";
    }
    [self.likeButton setTitle:like forState:UIControlStateNormal];
}

///更新评论按钮
- (void)updateCommentButton {
    NSString *comment = [NSString stringWithFormat:@" %ld", (long)self.model.commentCount];
    if (self.model.likeCount > 999) {
        comment = @" 999+";
    }
    [self.commentButton setTitle:comment forState:UIControlStateNormal];
}

#pragma mark - Lazy Load
- (void)setModel:(UserMoment *)model {
    _model = model;
    
    [self updateLikeButton];
    [self updateCommentButton];
}

- (UIButton *)likeButton {
    if (_likeButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"community_post_like"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"community_post_like_sel"] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:UIColorFromRGB(0xAFAFB3) forState:UIControlStateNormal];

        [button enlargeTouchArea:UIEdgeInsetsMake(8, 8, 8, 8)];
        
        _likeButton = button;
    }
    return _likeButton;
}

- (UIButton *)commentButton {
    if (_commentButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"mine_moment_menu_comment"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:UIColorFromRGB(0xAFAFB3) forState:UIControlStateNormal];
        
        [button enlargeTouchArea:UIEdgeInsetsMake(8, 8, 8, 8)];
        
        _commentButton = button;
    }
    return _commentButton;
}

- (UIButton *)shareButton {
    if (_shareButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"mine_moment_menu_share"] forState:UIControlStateNormal];
        
        [button enlargeTouchArea:UIEdgeInsetsMake(8, 8, 8, 8)];

        _shareButton = button;
    }
    return _shareButton;
}

- (UIButton *)moreButton {
    if (_moreButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"mine_moment_menu_more"] forState:UIControlStateNormal];
        
        [button enlargeTouchArea:UIEdgeInsetsMake(8, 8, 8, 8)];

        _moreButton = button;
    }
    return _moreButton;
}

- (UIImageView *)likeAnimationImageView {
    if (_likeAnimationImageView == nil) {
        _likeAnimationImageView = [[UIImageView alloc] init];
        _likeAnimationImageView.image = [UIImage imageNamed:@"dynamic_like_0"];
        _likeAnimationImageView.hidden = YES;
    }
    return _likeAnimationImageView;
}

@end
