//
//  TTMineMomentTimelineView.m
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/11/26.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTMineMomentTimelineView.h"

#import "XCTheme.h"

#import <Masonry/Masonry.h>

@implementation TTMineMomentTimelineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.topLine];
        [self addSubview:self.bottomLine];
        [self addSubview:self.iconImageView];
        
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(36);
            make.width.mas_equalTo(2);
            make.height.mas_equalTo(20);
        }];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.topLine);
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(9);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(self.topLine);
        }];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.topLine);
            make.top.mas_equalTo(8);
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
    }
    return self;
}

#pragma mark - Lazy Load
- (void)setType:(UserMomentType)type {
    _type = type;
    
    NSString *image = nil;
    switch (type) {
        case UserMomentTypeText:
            image = @"mine_moment_item_text";
            break;
        case UserMomentTypePic:
            image = @"mine_moment_item_pic";
            break;
        case UserMomentTypeVideo:
            image = @"mine_moment_item_video";
            break;
        case UserMomentTypeVoice:
            image = @"mine_moment_item_voice";
            break;
        case UserMomentTypeVoicePair:
            image = @"mine_moment_item_bottle";
            break;
        default:
            //这里默认设置了文本的图标，其实是不合理的~
            image = @"mine_moment_item_text";
            break;
    }
    
    self.iconImageView.image = [UIImage imageNamed:image];
}

- (UIView *)topLine {
    if (_topLine == nil) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _topLine.hidden = YES;//暂时不用了
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = UIColorFromRGB(0xf0f0f0);
    }
    return _bottomLine;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

@end
