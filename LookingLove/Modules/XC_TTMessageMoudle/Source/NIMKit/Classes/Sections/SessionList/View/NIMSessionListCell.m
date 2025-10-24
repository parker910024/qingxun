//
//  NTESSessionListCell.m
//  NIMDemo
//
//  Created by chris on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMSessionListCell.h"
#import "NIMAvatarImageView.h"
#import "UIView+NIM.h"
#import "NIMKitUtil.h"
#import "NIMBadgeView.h"
#import "XCTheme.h"
#import <YYModel/YYModel.h>

@implementation NIMSessionListCell
#define AvatarWidth 40
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageView = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
        _avatarImageView.userInteractionEnabled = NO;
        [self addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font            = [UIFont systemFontOfSize:15.f];
        _nameLabel.textColor =  UIColorFromRGB(0x333333);
        [self addSubview:_nameLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.font            = [UIFont systemFontOfSize:12.f];
        _messageLabel.textColor       = UIColorFromRGB(0x999999);
        [self addSubview:_messageLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font            = [UIFont systemFontOfSize:11.f];
        _timeLabel.textColor       = UIColorFromRGB(0xacacac);
        [self addSubview:_timeLabel];
        
        _badgeView = [NIMBadgeView viewWithBadgeTip:@""];
        [self addSubview:_badgeView];
        
        _noNotifyIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.nim_width - 30, self.nim_top + _timeLabel.nim_bottom + 5, 15, 17)];
        _noNotifyIcon.image = [UIImage imageNamed:@"message_list_item_nonotify"];
        _noNotifyIcon.hidden = YES;
        [self addSubview:_noNotifyIcon];
        
        _littleWorldImageView = [[UIImageView alloc] init];
        _littleWorldImageView.image = [UIImage imageNamed:@"littleworld_team_tag"];
        _littleWorldImageView.hidden = YES;
        [self addSubview:_littleWorldImageView];
    }
    return self;
}


#define NameLabelMaxWidth    160.f
#define MessageLabelMaxWidth 200.f
- (void)refresh:(NIMRecentSession*)recent{
    self.nameLabel.nim_width = self.nameLabel.nim_width > NameLabelMaxWidth ? NameLabelMaxWidth : self.nameLabel.nim_width;
    self.messageLabel.nim_width = self.messageLabel.nim_width > MessageLabelMaxWidth ? MessageLabelMaxWidth : self.messageLabel.nim_width;
    if (recent.unreadCount) {
        self.badgeView.hidden = NO;
        self.badgeView.badgeValue = @(recent.unreadCount).stringValue;
    }else{
        self.badgeView.hidden = YES;
    }
    self.littleWorldImageView.hidden = YES;
    if (recent.session.sessionType == NIMSessionTypeTeam) {
        
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recent.session.sessionId];
        if (team.serverCustomInfo) {
            NSDictionary * dic = @{@"type":@2};
            NSString * customInfo = [dic yy_modelToJSONString];
            if ([customInfo isEqualToString:team.serverCustomInfo]) {
                self.littleWorldImageView.hidden = NO;
            }
        }
        
        if (team.notifyStateForNewMsg == NIMTeamNotifyStateNone || team.notifyStateForNewMsg == NIMTeamNotifyStateOnlyManager) {
            self.noNotifyIcon.hidden = NO;
            self.badgeView.hidden = YES;
        }else {
            self.noNotifyIcon.hidden = YES;
//            self.badgeView.hidden = NO;
        }
    }else {
        self.noNotifyIcon.hidden = YES;
//        self.badgeView.hidden = NO;
    }
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    //Session List
    NSInteger sessionListAvatarLeft             = 15;
    NSInteger sessionListNameTop                = 15;
    NSInteger sessionListNameLeftToAvatar       = 15;
    NSInteger sessionListMessageLeftToAvatar    = 15;
    NSInteger sessionListMessageBottom          = 15;
    NSInteger sessionListTimeRight              = 15;
    NSInteger sessionListTimeTop                = 15;
    NSInteger sessionBadgeTimeBottom            = 15;
    NSInteger sessionBadgeTimeRight             = 15;
    
    _avatarImageView.nim_left    = sessionListAvatarLeft;
    _avatarImageView.nim_centerY = self.nim_height * .5f;
    _nameLabel.nim_top           = sessionListNameTop;
    _nameLabel.nim_left          = _avatarImageView.nim_right + sessionListNameLeftToAvatar;
    _messageLabel.nim_left       = _avatarImageView.nim_right + sessionListMessageLeftToAvatar;
    _messageLabel.nim_bottom     = self.nim_height - sessionListMessageBottom;
    _timeLabel.nim_right         = self.nim_width - sessionListTimeRight;
    _timeLabel.nim_top           = sessionListTimeTop;
    _badgeView.nim_right         = self.nim_width - sessionBadgeTimeRight;
    _badgeView.nim_bottom        = self.nim_height - sessionBadgeTimeBottom;
    _noNotifyIcon.nim_right      = self.nim_width - sessionBadgeTimeRight;
    _noNotifyIcon.nim_top        = _timeLabel.nim_bottom + 5;
    _noNotifyIcon.nim_width      = 15;
    _noNotifyIcon.nim_height     = 17;
    
    _littleWorldImageView.nim_width = 31;
    _littleWorldImageView.nim_height = 15;
    _littleWorldImageView.nim_bottom = self.avatarImageView.nim_bottom;
    _littleWorldImageView.nim_right = self.avatarImageView.nim_right;
   
}



@end
