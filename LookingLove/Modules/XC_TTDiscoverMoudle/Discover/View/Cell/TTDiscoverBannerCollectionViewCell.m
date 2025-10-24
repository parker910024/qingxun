//
//  TTDiscoverBannerCollectionViewCell.m
//  TuTu
//
//  Created by gzlx on 2018/11/1.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDiscoverBannerCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "UIImageView+QiNiu.h"
#import "XCTheme.h"
#import "DiscoverTofuInfo.h"
#import "XCMacros.h"

@interface TTDiscoverBannerCollectionViewCell ()
/** 大的容器*/
@property (nonatomic,strong) UIView *containerView;
/** bannder*/
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) NSArray * banners;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *countLabel; // 任务数量
@property (nonatomic, strong) UIView *countView; // 任务数量容器
@property (nonatomic, strong) UIView *redBgView; // 红点

@end

@implementation TTDiscoverBannerCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - public method
- (void)configTTDiscoverBannerCollectionViewCell:(DiscoverTofuInfo *)tofuInfo {
    [self.iconImageView qn_setImageImageWithUrl:tofuInfo.minPic placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeRoomFace];
    self.textLabel.text = tofuInfo.name;
    // 显示 or 隐藏数据
    if (tofuInfo.missionNum && [tofuInfo.name isEqualToString:@"任务"]) { // 任务数量
        self.countLabel.hidden = NO;
        self.countView.hidden = NO;
        self.countLabel.text = tofuInfo.missionNum;
    } else {
        self.countLabel.hidden = YES;
        self.countView.hidden = YES;
    }
    
    if (!tofuInfo.signStatus && [tofuInfo.name isEqualToString:@"签到"]) {
        self.countLabel.hidden = YES;
        self.redBgView.hidden = NO;
    } else {
        self.redBgView.hidden = YES;
    }
}

#pragma mark - private method
- (void)initView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.iconImageView];
        [self.containerView addSubview:self.textLabel];
        [self.contentView addSubview:self.countView];
        [self.countView addSubview:self.countLabel];
        [self.contentView addSubview:self.redBgView];
    }else {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.countView];
        [self.contentView addSubview:self.countLabel];
        [self.contentView addSubview:self.redBgView];
    }
}

- (void)initContrations {
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView);
            make.size.mas_equalTo(self);
        }];
        
        if (projectType() == ProjectType_Planet) {
            
            [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(75);
                make.centerX.mas_equalTo(self.containerView);
                make.top.mas_equalTo(self.containerView);
            }];
            [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.containerView);
                make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(-4);
            }];
            
        } else {
            [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(28);
                make.centerX.mas_equalTo(self.containerView);
                make.top.mas_equalTo(self.containerView).offset(10);
            }];
            
            [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.containerView);
                make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(4);
            }];
        }
        
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(18);
            make.centerX.mas_equalTo(self.countView);
            make.top.mas_equalTo(self.countView.mas_top);
            make.width.mas_equalTo(self.countView);
        }];
        
        [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(25);
            make.top.mas_equalTo(self.containerView);
            make.right.mas_equalTo(self.containerView);
            make.height.mas_equalTo(18);
        }];
        
        [self.redBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.containerView);
            make.top.mas_equalTo(self.containerView);
            make.height.width.mas_equalTo(12);
        }];
    }else {
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(70);
            make.center.mas_equalTo(self.contentView);
        }];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.centerX.mas_equalTo(self.contentView);
        }];
        
        
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(18);
            make.left.mas_equalTo(self.iconImageView).offset(49);
            make.top.mas_equalTo(self.iconImageView.mas_top).offset(4);
        }];
        
        [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.countLabel);
            make.left.mas_equalTo(self.countLabel).offset(-6);
            make.right.mas_equalTo(self.countLabel).offset(6);
            make.height.mas_equalTo(18);
        }];
        
        [self.redBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.iconImageView).offset(-12);
            make.top.mas_equalTo(self.iconImageView.mas_top).offset(8);
            make.height.width.mas_equalTo(12);
        }];
        _countView.layer.borderWidth = 2;
        _countView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
}

#pragma mark - setters and getters
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        if (projectType() == ProjectType_Planet) {
            _containerView.backgroundColor = [UIColor clearColor];
        } else {
            _containerView.backgroundColor = [UIColor whiteColor];
        }
        _containerView.layer.masksToBounds = YES;
        _containerView.layer.cornerRadius = 8;
    }
    return _containerView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 10.f;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [XCTheme getMSMainTextColor];
        _textLabel.font = [UIFont systemFontOfSize:13.f];
        _textLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _textLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:10];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.numberOfLines = 0;
        _countLabel.hidden = YES;
    }
    return _countLabel;
}

- (UIView *)countView {
    if (!_countView) {
        _countView = [[UIView alloc] init];
        _countView.backgroundColor = UIColorFromRGB(0xFF3B30);
        _countView.layer.cornerRadius = 9;
        _countView.layer.masksToBounds = YES;
        _countView.hidden = YES;
    }
    return _countView;
}

- (UIView *)redBgView {
    if (!_redBgView) {
        _redBgView = [[UIView alloc] init];
        _redBgView.backgroundColor = UIColorFromRGB(0xFF3B30);
        _redBgView.layer.cornerRadius = 6;
        _redBgView.layer.masksToBounds = YES;
        _redBgView.hidden = YES;
    }
    return _redBgView;
}

@end
