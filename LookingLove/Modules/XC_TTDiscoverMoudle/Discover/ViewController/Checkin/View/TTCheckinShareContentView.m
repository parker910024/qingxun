//
//  TTCheckinShareContentView.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCheckinShareContentView.h"

#import <Masonry/Masonry.h>
#import "XCKeyWordTool.h"
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"

@implementation TTCheckinShareContent

@end

@interface TTCheckinShareContentView ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *slogonImageView;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *avatarBorderView;//头像边框
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *uidLabel;

@property (nonatomic, strong) UIImageView *bubbleImageView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation TTCheckinShareContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, 375, 667)];
    if (self) {
        [self addSubview:self.bgImageView];
        [self addSubview:self.slogonImageView];
        
        [self addSubview:self.avatarBorderView];
        [self addSubview:self.avatarImageView];
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.uidLabel];
        
        [self addSubview:self.bubbleImageView];
        [self.bubbleImageView addSubview:self.contentLabel];
        
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [self.slogonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(78);
            make.left.right.mas_equalTo(self).inset(52);
        }];
        
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(252);
            make.left.mas_equalTo(70);
            make.width.height.mas_equalTo(42);
        }];
        [self.avatarBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.avatarImageView);
            make.width.height.mas_equalTo(46);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarImageView);
            make.left.mas_equalTo(self.avatarImageView.mas_right).offset(20);
            make.right.mas_lessThanOrEqualTo(-40);
        }];
        [self.uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(self.nameLabel);
            make.right.mas_lessThanOrEqualTo(-40);
        }];
        
        [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(4);
            make.left.mas_equalTo(48);
            make.right.mas_equalTo(-64);
        }];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(37, 33, 37, 35));
        }];
    }
    return self;
}

- (void)captureImageWithModel:(TTCheckinShareContent *)model completion:(void (^)(UIImage * _Nonnull))completion {
    
    self.nameLabel.text = model.name;
    self.uidLabel.text = [NSString stringWithFormat:@"ID:%@", model.uid];
    [self layoutIfNeeded];
    
    __weak typeof(self) weakself = self;
    [self.avatarImageView qn_setImageImageWithUrl:model.avatar
                                 placeholderImage:[XCTheme defaultTheme].default_avatar
                                             type:ImageTypeUserIcon
                                          success:^(UIImage *image) {
                                              
                                              __strong typeof(weakself) strongself = self;
                                              UIImage *captureImage = [strongself snapshotInRect:self.bounds opaque:YES];
                                              !completion ?: completion(captureImage);
                                          }];
}

/**
 截图
 */
- (UIImage *)snapshotInRect:(CGRect)rect opaque:(BOOL)opaque {
    if (CGRectIsEmpty(rect)) {
        rect = self.bounds;
    }
    
    UIImage * img = nil;
    UIGraphicsBeginImageContextWithOptions(rect.size, opaque, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (ctx) {
        CGContextTranslateCTM(ctx, -rect.origin.x, -rect.origin.y);
        [self.layer renderInContext:ctx];
        img = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark Settter Getter
- (void)setModel:(TTCheckinShareContent *)model {
    _model = model;
    
    self.nameLabel.text = model.name;
    self.uidLabel.text = model.uid;
    
    [self.avatarImageView qn_setImageImageWithUrl:model.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"checkin_share_bg"];
    }
    return _bgImageView;
}

- (UIImageView *)slogonImageView {
    if (_slogonImageView == nil) {
        _slogonImageView = [[UIImageView alloc] init];
        _slogonImageView.image = [UIImage imageNamed:@"checkin_share_slogon"];
    }
    return _slogonImageView;
}

- (UIImageView *)bubbleImageView {
    if (_bubbleImageView == nil) {
        _bubbleImageView = [[UIImageView alloc] init];
        _bubbleImageView.image = [[UIImage imageNamed:@"checkin_share_bubble"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 40, 40, 40)];
    }
    return _bubbleImageView;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = UIColorFromRGB(0x9B48FF);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        
        NSString *text = [NSString stringWithFormat:@"听说%@签到可以赚金币不能让我一个人独享，宝贝快来和我一起发家致富呀~~", [XCKeyWordTool sharedInstance].myAppName];
        NSString *keyword = @"赚金币";
        NSRange keywordRange = [text rangeOfString:keyword];
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:text];
        [attri addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFD6964) range:keywordRange];
        _contentLabel.attributedText = attri;
        
    }
    return _contentLabel;
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.image = [UIImage imageNamed:[XCTheme defaultTheme].default_avatar];
        _avatarImageView.layer.cornerRadius = 21;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UIView *)avatarBorderView {
    if (_avatarBorderView == nil) {
        _avatarBorderView = [[UIView alloc] init];
        _avatarBorderView.backgroundColor = UIColorFromRGB(0x9B48FF);
        _avatarBorderView.layer.cornerRadius = 23;
        _avatarBorderView.layer.masksToBounds = YES;
        _avatarBorderView.layer.borderColor = UIColor.whiteColor.CGColor;
        _avatarBorderView.layer.borderWidth = 3;
    }
    return _avatarBorderView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:17];
        _nameLabel.textColor = UIColorFromRGB(0xFFF726);
        _nameLabel.text = @"name";
    }
    return _nameLabel;
}

- (UILabel *)uidLabel {
    if (_uidLabel == nil) {
        _uidLabel = [[UILabel alloc] init];
        _uidLabel.font = [UIFont systemFontOfSize:12];
        _uidLabel.textColor = UIColor.whiteColor;
        _uidLabel.text = @"ID:";
    }
    return _uidLabel;
}

@end
