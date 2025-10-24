//
//  WBGameView.m
//  WanBan
//
//  Created by ShenJun_Mac on 2020/10/9.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "WBGameView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIButton+EnlargeTouchArea.h"

@interface WBGameView()
@property(nonatomic, strong) UIImageView *iconView;

@property(nonatomic, strong) UIButton *deleteBtn;
@end

@implementation WBGameView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initView];
        
        [self initConstraint];
    }
    
    return self;
}

- (void)initView {
    [self addSubview:self.iconView];
    [self addSubview:self.deleteBtn];
    
    
}

- (void)initConstraint {
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
    }];
}

- (void)deleteBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickCloseGameBtn:)]) {
        [self.delegate onClickCloseGameBtn:self.gameInfo];
    }
}

- (void)imageViewClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickWBGameView:)]) {
        [self.delegate onClickWBGameView:self.gameInfo];
    }
}

#pragma mark - Setter && Getter
- (void)setGameInfo:(CPGameListModel *)gameInfo {
    _gameInfo = gameInfo;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:gameInfo.gamePicture]];
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
        [_deleteBtn setBackgroundImage: [UIImage imageNamed:@"room_half_web_game_status_close"] forState:normal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn enlargeTouchArea:UIEdgeInsetsMake(12, 12, 12, 12)];
    }
    return _deleteBtn;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick)];
        [_iconView addGestureRecognizer:ges];
        
    }
    return _iconView;
}

- (void)setShowDeleteBtn:(BOOL)showDeleteBtn {
    _showDeleteBtn = showDeleteBtn;
    if (showDeleteBtn) {
        self.deleteBtn.hidden = NO;
    } else {
        self.deleteBtn.hidden = YES;
    }
}

@end
