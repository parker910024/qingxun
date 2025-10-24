//
//  TTCPGameListItemView.m
//  TuTu
//
//  Created by new on 2019/1/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCPGameListItemView.h"
#import "UIView+NTES.h"
#import "XCMacros.h"
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import <Masonry/Masonry.h>
@interface TTCPGameListItemView ()

@property (nonatomic, assign) CGFloat startScale;
@property (nonatomic, strong) UIImageView *gameBackImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIVisualEffectView *effectV;
@end

@implementation TTCPGameListItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.startScale = 1 / 1.25;
        
        [self addSubview:self.contentImageView];
        [self.contentImageView addSubview:self.gameBackImageView];
        [self.contentImageView addSubview:self.titleLabel];
        
        self.effectV = [[UIVisualEffectView alloc] init];
        _effectV.alpha = 0.6;
        _effectV.frame = CGRectMake(4, 4, self.contentImageView.width - 8, self.contentImageView.height - 8);
        _effectV.layer.cornerRadius = 9;
        _effectV.layer.masksToBounds = YES;
        _effectV.backgroundColor = UIColorRGBAlpha(0x15163B,0.6);
        [self.contentImageView addSubview:_effectV];
        

        [self resetFrame:1];
    }
    return self;
}


-(void)CPGameModel:(CPGameListModel *)model{
    
    [self.gameBackImageView qn_setImageImageWithUrl:model.gameIcon placeholderImage:@"game_home_itemBg" type:(ImageType)ImageTypeUserLibaryDetail];
    
    self.titleLabel.text = model.gameName;
}

-(UIImageView *)contentImageView{
    if (!_contentImageView) {
        self.contentImageView = [[UIImageView alloc] init];
//        [_contentImageView setImage:[UIImage imageNamed:@"room_cp_game_sel"]];
        _contentImageView.left = 0;
        _contentImageView.top = 0;
        _contentImageView.size = CGSizeMake(self.width, self.height);
        _contentImageView.layer.cornerRadius = 9;
        _contentImageView.layer.masksToBounds = YES;
        _contentImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _contentImageView;
}

-(UIImageView *)gameBackImageView{
    if (!_gameBackImageView) {
        self.gameBackImageView = [[UIImageView alloc] init];
        _gameBackImageView.left = 4;
        _gameBackImageView.top = 4;
        _gameBackImageView.size = CGSizeMake(self.contentImageView.width - 8, self.contentImageView.height - 8);
        _gameBackImageView.layer.cornerRadius = 9;
        _gameBackImageView.layer.masksToBounds = YES;
        _gameBackImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _gameBackImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.left = 0;
        _titleLabel.size = CGSizeMake(self.contentImageView.width, 15);
        _titleLabel.bottom = self.contentImageView.height - 11;
    }
    return _titleLabel;
}

- (void)resetFrame:(CGFloat)scale{
    
    float currentScale =  scale * (1 - self.startScale) + self.startScale;
    
    self.contentImageView.size = CGSizeMake(self.width * currentScale, self.height * currentScale);
    
    if (currentScale > 0.9) {
        _effectV.alpha = 1 - currentScale;
    }else{
        _effectV.alpha = 1 - currentScale + 0.2;
        
    }
    _effectV.frame = CGRectMake(4, 4, self.contentImageView.width - 8, self.contentImageView.height - 8);
    
    self.gameBackImageView.size = CGSizeMake(self.contentImageView.width - 8, self.contentImageView.height - 8);
    
    self.titleLabel.size = CGSizeMake(self.contentImageView.width, 15);
    
    self.titleLabel.bottom = self.contentImageView.height - 11;
    
    self.titleLabel.font = [UIFont systemFontOfSize:currentScale * 14];
    
    self.contentImageView.center = CGPointMake(self.width / 2.0, self.height / 2.0);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
