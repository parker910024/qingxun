//
//  XCGuildMessageContentControlView.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/15.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "XCGuildMessageContentControlView.h"
#import <YYLabel.h>
#import "UIImage+Utils.h"
#import "UIColor+UIColor_Hex.h"
#import "ImMessageCore.h"
#import "FamilyCore.h"
#import "TTMessageAttributedString.h"

#import <Masonry/Masonry.h>

#import "XCGuildAttachment.h"

#import "XCTheme.h"
#import "UIView+NTES.h"

@interface XCGuildMessageContentControlView ()

@property (strong, nonatomic) YYLabel *statusLabel;

@property (nonatomic, strong) UIView *separateLine;//顶部分割线

@end

@implementation XCGuildMessageContentControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstraints];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.rejectButton];
    [self addSubview:self.agreeButton];
    [self addSubview:self.statusLabel];
    [self addSubview:self.separateLine];
}

- (void)initConstraints  {
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(self).inset(15);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(70, 26));
        make.right.mas_equalTo(self.agreeButton.mas_left).offset(-10);
    }];
    
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rejectButton);
        make.size.mas_equalTo(self.rejectButton);
        make.centerX.mas_equalTo(70/2+5);
    }];
}

- (void)setAttachment:(XCGuildAttachment *)attachment {
    _attachment = attachment;
    
    if (attachment.msgStatus == 0) {
        attachment.msgStatus = XCGuildAttachmentStatusUntreated;
    }
    
    switch (attachment.msgStatus) {
            case XCGuildAttachmentStatusUntreated: {
                self.statusLabel.text = @"";
                
                //当只有一个同意按钮时
                BOOL isApplyExit = attachment.second == Custom_Noti_Sub_HALL_APPLY_EXIT;
                CGFloat centerX = isApplyExit ? 0 : 70/2.0+5;
                
                self.rejectButton.hidden = isApplyExit;
                self.agreeButton.hidden = NO;
                [self.agreeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(centerX);
                }];
            }
            break;
            case XCGuildAttachmentStatusAgree: {
                [self hideButton];
                self.statusLabel.text = @"已同意";
                self.statusLabel.textColor = UIColorRGBAlpha(0x09BB07, 0.6);
            }
            break;
            case XCGuildAttachmentStatusReject: {
                [self hideButton];
                self.statusLabel.text = @"已拒绝";
                self.statusLabel.textColor = UIColorRGBAlpha(0xFF3852, 0.6);
            }
            break;
            case XCGuildAttachmentStatusExpired: {
                [self hideButton];
                self.statusLabel.text = @"已过期";
                self.statusLabel.textColor = UIColorRGBAlpha(0x333333, 0.6);
            }
            break;
            case XCGuildAttachmentStatusProcessed: {
                [self hideButton];
                self.statusLabel.text = @"已处理";
                self.statusLabel.textColor = UIColorRGBAlpha(0x333333, 0.6);
            }
            break;
        default:
            break;
    }
    
    self.separateLine.hidden = self.statusLabel.text.length == 0;
}

- (void)hideButton {
    self.rejectButton.hidden = YES;
    self.agreeButton.hidden = YES;
}

- (void)showButton {
    self.rejectButton.hidden = NO;
    self.agreeButton.hidden = NO;
}

#pragma mark - Getter

- (UIButton *)rejectButton {
    if (!_rejectButton) {
        _rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rejectButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [_rejectButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _rejectButton.titleLabel.font = [UIFont systemFontOfSize:13];
        
        _rejectButton.layer.cornerRadius = 13;
        _rejectButton.layer.masksToBounds = YES;
        _rejectButton.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        _rejectButton.layer.borderWidth = 0.5;
    }
    return _rejectButton;
}

- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _agreeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _agreeButton.backgroundColor = [XCTheme getTTMainColor];
        
        _agreeButton.layer.cornerRadius = 13;
        _agreeButton.layer.masksToBounds = YES;
    }
    return _agreeButton;
}

- (YYLabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[YYLabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:12];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.userInteractionEnabled = NO;
    }
    return _statusLabel;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc] init];
        _separateLine.backgroundColor = [XCTheme getLineDefaultGrayColor];
        _separateLine.hidden = YES;
    }
    return _separateLine;
}

@end
