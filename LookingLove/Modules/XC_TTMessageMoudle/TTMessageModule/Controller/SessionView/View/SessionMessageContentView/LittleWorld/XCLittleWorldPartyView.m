//
//  XCLittleWorldPartyView.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/9.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "XCLittleWorldPartyView.h"
#import <YYText/YYLabel.h>
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "BaseAttrbutedStringHandler.h"
#import "UIImage+Utils.h"
@interface XCLittleWorldPartyView ()

/** 显示的内容*/
@property (nonatomic,strong) UILabel *contentLabel;
/** 图标*/
@property (nonatomic,strong) UIImageView *logoImageView;
/** 箭头*/
@property (nonatomic,strong) UIImageView *arrowImageView;
/** 背景图*/
@property (nonatomic,strong) UIImageView *backImageView;
@end

@implementation XCLittleWorldPartyView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.backImageView];
    [self addSubview:self.logoImageView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.arrowImageView];
}

- (void)initContrations {
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(14);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(28, 31));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.logoImageView.mas_right).offset(2);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}



#pragma mark - setters and getters
- (void)setLittleWorldAttach:(XCLittleWorldAttachment *)littleWorldAttach {
    _littleWorldAttach = littleWorldAttach;
    if (_littleWorldAttach) {
        NSString * imageName;
        UIColor * titleColor;
        NSString * arrowImageName;
        if (_littleWorldAttach.ownerFlag) {
                imageName = @"littleworld_owner_party";
                titleColor = [UIColor whiteColor];
                arrowImageName = @"littleworld_owner_party_arrow";
        }else {
            if (self.isOutGoing) {
                imageName = @"littleworld_owner_party";
                titleColor = [UIColor whiteColor];
                arrowImageName = @"littleworld_owner_party_arrow";
            }else {
                imageName = @"littleworld_member_party";
                titleColor = UIColorFromRGB(0xFE6974);
                arrowImageName = @"littleworld_member_party_arrow";
            }
        }
        self.contentLabel.textColor = titleColor;
        self.arrowImageView.image = [UIImage imageNamed:arrowImageName];
        self.logoImageView.image = [UIImage imageNamed:imageName];
        
        if (self.isOutGoing) {
            UIImage * image = [UIImage imageNamed:@"littleworld_team_party_member_bg"];
            if (image) {
                self.backImageView.image = image;
            }
        }else {
            if (self.littleWorldAttach.ownerFlag) {
                UIImage * image = [UIImage imageNamed:@"littleworld_team_party_owner_bg"];
                if (image) {
                    self.backImageView.image = image;
                }
            }else {
                UIImage * image = [UIImage imageNamed:@"littleworld_team_party_other_bg"];
                if (image) {
                    self.backImageView.image = image;
                }
            }
        }
    }
}


- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.text = @"发起了语音派对";
    }
    return _contentLabel;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.layer.masksToBounds = YES;
         _backImageView.layer.cornerRadius = 5;
    }
    return _backImageView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
    }
    return _logoImageView;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
    }
    return _arrowImageView;
}

@end
