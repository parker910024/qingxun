//
//  XCShareItemCell.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/9/2.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCShareItemCell.h"
#import "XCTheme.h"
#import <Masonry.h>
#import "XCMacros.h"
#import "DarkModeTool.h"

@interface XCShareItemCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation XCShareItemCell

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupSubviews];
        [self setupSubviewsConstraints];
    }
    return self;
}

#pragma mark - puble method
- (void)setShareItem:(XCShareItem *)shareItem{
    _shareItem = shareItem;
    self.userInteractionEnabled = !shareItem.disable;
    if (shareItem.disable) {
        self.iconImageView.image = [UIImage imageNamed:shareItem.disableImageName];
    }else{
        self.iconImageView.image = [UIImage imageNamed:shareItem.imageName];
    }
    self.titleLabel.text = shareItem.title;
    
    
}

#pragma mark - Private
- (void)setupSubviews{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    if (projectType() == ProjectType_VKiss) {
        self.titleLabel.textColor = UIColorFromRGB(0xC1BEE3);
    }
    
}
- (void)setupSubviewsConstraints{
    CGFloat wh = 30;
    if (projectType() == ProjectType_VKiss) {
        wh = 44;
    } else if (projectType() == ProjectType_CatASMR || projectType() == ProjectType_CatEar) {
        wh = 40;
    }
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(wh));
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
    }];
}

#pragma mark - Getter
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [[DarkModeTool shareInstance] configColorWithLight:UIColorFromRGB(0x333333) Dark:[UIColor whiteColor]];
        _titleLabel.font = [UIFont systemFontOfSize:10.0];
    }
    return _titleLabel;
}
@end
