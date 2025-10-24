//
//  TTGuildTofuCell.m
//  TuTu
//
//  Created by lee on 2019/1/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGuildTofuCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIImageView+QiNiu.h"
#import "GuildHallMenu.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TTGuildTofuCell ()

@property (nonatomic, strong) UIImageView *bgImgeView;

@end

@implementation TTGuildTofuCell

#pragma mark -
#pragma mark lifeCycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}
- (void)initViews {
    [self addSubview:self.bgImgeView];
}

- (void)initConstraints {
    [self.bgImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods
- (void)setHallMenu:(GuildHallMenu *)hallMenu {
    _hallMenu = hallMenu;
    
    NSString *picUrl = self.isShowThirdPic ? hallMenu.minImage : hallMenu.maxImage;
    [self.bgImgeView sd_setImageWithURL:[NSURL URLWithString:picUrl]];
}

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter
- (UIImageView *)bgImgeView
{
    if (!_bgImgeView) {
        _bgImgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guild_tofu_default"]];
        _bgImgeView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bgImgeView;
}

@end
