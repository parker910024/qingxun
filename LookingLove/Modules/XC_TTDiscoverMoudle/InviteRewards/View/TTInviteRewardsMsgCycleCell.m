//
//  TTInviteRewardsMsgCycleCell.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/21.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTInviteRewardsMsgCycleCell.h"

#import <Masonry/Masonry.h>

@interface TTInviteRewardsMsgCycleCell ()
@property (nonatomic, strong) UIButton *rewardsMsgButton;
@end

@implementation TTInviteRewardsMsgCycleCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.rewardsMsgButton];
        [self.rewardsMsgButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)setContent:(NSString *)content {
    _content = content;
    
    [self.rewardsMsgButton setTitle:content forState:UIControlStateNormal];
}

- (UIButton *)rewardsMsgButton {
    if (_rewardsMsgButton == nil) {
        _rewardsMsgButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_rewardsMsgButton setImage:[UIImage imageNamed:@"invite_rewards_speaker"] forState:UIControlStateNormal];
//        [_rewardsMsgButton setTitle:@"XXX 刚刚 xcGetCF 了100元" forState:UIControlStateNormal];
        _rewardsMsgButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _rewardsMsgButton.userInteractionEnabled = NO;
    }
    return _rewardsMsgButton;
}
@end
