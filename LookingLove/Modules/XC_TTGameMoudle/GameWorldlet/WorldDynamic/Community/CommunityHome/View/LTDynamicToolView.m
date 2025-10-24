//
//  XCCommunityToolView.m
//  UKiss
//
//  Created by apple on 2018/12/3.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import "LTDynamicToolView.h"
#import "LLDynamicModel.h"
#import "AuthCore.h"
#import "UIView+XCToast.h"
#import "VKCommunityCoreClient.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "UIView+XCToast.h"
#import "UIButton+EnlargeTouchArea.h"

@interface LTDynamicToolView ()
// 更多按钮
@property (nonatomic, strong) UIButton *moreMenuBtn;
//评论
@property (nonatomic, strong) UIButton *commentBtn;
//点赞
@property (nonatomic, strong) UIButton *likeBtn;
///勾搭按钮
@property (nonatomic, strong) UIButton *shareBtn;
///触发了点赞
@property (nonatomic, assign) BOOL isLikeSender;

@property (nonatomic, strong) UIButton *deleteBtn;
/// 点赞按钮动画辅助，因为动画大小变化，不适合直接在按钮上直接做动画
@property (nonatomic, strong) UIImageView *likeAnimationImageView;
@end

@implementation LTDynamicToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

#pragma mark - VKCommunityCoreClient

- (void)initView {
    [self addSubview:self.commentBtn];
    [self addSubview:self.likeBtn];
    [self addSubview:self.shareBtn];
    [self addSubview:self.likeAnimationImageView];
    [self addSubview:self.moreMenuBtn];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];

    [self.likeAnimationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.likeBtn.imageView);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.moreMenuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.centerY.height.mas_equalTo(self.likeBtn);
    }];

    CGFloat viewWidth = KScreenWidth - 20*2 - 25*2;
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(viewWidth/3);
        make.centerY.height.mas_equalTo(self.moreMenuBtn);
    }];

    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(viewWidth * 2/3);
        make.centerY.height.mas_equalTo(self.moreMenuBtn);
    }];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(KScreenWidth - 40, 44);
}

- (void)didClickCommentButton:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(communityToolClickCommentButtonCallBack)]) {
        [self.delegate communityToolClickCommentButtonCallBack];
    }
    
    !_clickHandler ?: _clickHandler(ToolViewActionTypeComment);
}

- (void)didClickLaudButton:(UIButton *)button {
    button.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.userInteractionEnabled = YES;
    });
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(communityToolClickLaudButtonCallBackWith:)]) {
        [self.delegate communityToolClickLaudButtonCallBackWith:!self.likeBtn.selected];
    }
    
    !_clickHandler ?: _clickHandler(ToolViewActionTypeLike);
}

- (void)didClickMoreMenuButton:(UIButton *)menuButton {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(communityToolClickMoreButtonCallBack)]) {
        [self.delegate communityToolClickMoreButtonCallBack];
    }
    
    !_clickHandler ?: _clickHandler(ToolViewActionTypeMenu);
}

- (void)likeButtonAnimation {
    [self updateLikeButton];
}

///更新点赞按钮
- (void)updateLikeButton {
    self.likeBtn.selected = self.dynamicModel.isLike;
    
    NSString *like = self.dynamicModel.likeCount;
    if ([self.dynamicModel.likeCount integerValue] >= 1000) {
        like = @"  999+";
    }
    [self.likeBtn setTitle:like forState:UIControlStateNormal];
}

///更新点赞按钮
- (void)updateLaudButton {
//    self.likeBtn.selected = !self.likeBtn.selected;
    NSInteger likeCount = self.likeBtn.selected ? [self.dynamicModel.likeCount integerValue] + 1 : [self.dynamicModel.likeCount integerValue] - 1;
    likeCount = MAX(likeCount, 0);
    self.dynamicModel.likeCount = [NSString stringWithFormat:@"%ld", (long)likeCount];
    self.dynamicModel.isLike = self.likeBtn.selected;
    [self settingData];
    [self settingFrame];
}

//勾搭TA
- (void)shareButtonAction:(UIButton *)button {
    button.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.userInteractionEnabled = YES;
    });
    if (self.delegate && [self.delegate respondsToSelector:@selector(communityToolClickShareButtonCallBack)]) {
        [self.delegate communityToolClickShareButtonCallBack];
    }
    
    !_clickHandler ?: _clickHandler(ToolViewActionTypeShare);
}

#pragma mark - private method

- (void)settingData {
//    self.likeBtn.userInteractionEnabled = !self.isCommunityDetails;
    self.commentBtn.userInteractionEnabled = !self.isCommunityDetails;
    NSString *laudStr = self.dynamicModel.likeCount > 0 ? [NSString stringWithFormat:@"  %@",self.dynamicModel.likeCount] : @"点赞";
    if ([self.dynamicModel.likeCount integerValue] >= 1000) {
        laudStr = @"  999+";
    }
    NSString *commentStr = self.dynamicModel.commentCount > 0 ? [NSString stringWithFormat:@"  %@",self.dynamicModel.commentCount] : @"评论";
    if ([self.dynamicModel.commentCount integerValue] >= 1000) {
        commentStr = @"  999+";
    }
    [self.likeBtn setTitle:laudStr forState:UIControlStateNormal];
    [self.commentBtn setTitle:commentStr forState:UIControlStateNormal];
    self.likeBtn.selected = self.dynamicModel.isLike;
}

- (void)settingFrame {
    
//    self.likeBtn.frame = CGRectMake(20, 0, 90, 50);
//    self.commentBtn.frame = self.likeBtn.frame;
//    self.commentBtn.left = CGRectGetMaxX(self.likeBtn.frame) + 10;
//    self.shareBtn.frame = self.commentBtn.frame;
//    self.shareBtn.left = CGRectGetMaxX(self.commentBtn.frame) + 10;
}

#pragma mark - getters and setters

- (void)setDynamicModel:(LLDynamicModel *)dynamicModel {
    _dynamicModel = dynamicModel;
    [self settingData];
    [self settingFrame];
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:[UIImage imageNamed:@"community_post_comment"] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(didClickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
        [_commentBtn setTitleColor:UIColorFromRGB(0xABAAB3) forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        _commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _commentBtn;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:[UIImage imageNamed:@"community_post_like"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"community_post_like_sel"] forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(didClickLaudButton:) forControlEvents:UIControlEventTouchUpInside];
        [_likeBtn setTitleColor:UIColorFromRGB(0xABAAB3) forState:UIControlStateNormal];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_likeBtn setTitle:@"点赞" forState:UIControlStateNormal];
        _likeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_likeBtn setBackgroundColor:[UIColor whiteColor]];
    }
    return _likeBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"community_post_share"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _shareBtn;
}

- (UIImageView *)likeAnimationImageView {
    if (_likeAnimationImageView == nil) {
        _likeAnimationImageView = [[UIImageView alloc] init];
        _likeAnimationImageView.image = [UIImage imageNamed:@"community_post_like_sel"];
        _likeAnimationImageView.hidden = YES;
    }
    return _likeAnimationImageView;
}

- (UIButton *)moreMenuBtn{
    if (!_moreMenuBtn) {
        _moreMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreMenuBtn setImage:[UIImage imageNamed:@"dynamic_more"] forState:UIControlStateNormal];
        [_moreMenuBtn addTarget:self action:@selector(didClickMoreMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        [_moreMenuBtn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    }
    return _moreMenuBtn;
}
@end
