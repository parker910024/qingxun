//
//  XCAnchorOrderTipsContentMessageView.m
//  XC_TTMessageMoudle
//
//  Created by lvjunhang on 2020/5/11.
//  Copyright © 2020 WJHD. All rights reserved.
//

#import "XCAnchorOrderTipsContentMessageView.h"

#import "XCCPGamePrivateSysNotiAttachment.h"

#import "NSString+Utils.h"
#import "XCMacros.h"

#import <Masonry/Masonry.h>

@implementation XCAnchorOrderTipsContentMessageView

- (instancetype)initSessionMessageContentView {
    if (self = [super initSessionMessageContentView]) {
        
        CGFloat labelHorizMargin = 14;
        CGFloat labelVertMargin = 14;
        
        self.bubbleImageView.hidden = YES;
        
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.contentLabel];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 20));
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.topMargin.mas_equalTo(labelVertMargin);
            make.left.right.mas_equalTo(self.bgView).inset(labelHorizMargin);
            make.bottom.mas_lessThanOrEqualTo(0);
        }];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    XCCPGamePrivateSysNotiAttachment *attach = (XCCPGamePrivateSysNotiAttachment*)object.attachment;
    self.contentLabel.text = [attach.data objectForKey:@"msg"];
}

#pragma mark - Getter Setter
- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = UIColor.whiteColor;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.1];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 8;
    }
    return _bgView;
}
@end
