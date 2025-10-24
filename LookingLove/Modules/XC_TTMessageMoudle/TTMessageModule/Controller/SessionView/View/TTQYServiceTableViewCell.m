//
//  TTQYServiceView.m
//  TTPlay
//
//  Created by fengshuo on 2019/3/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTQYServiceTableViewCell.h"
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIImageView+QiNiu.h"
#import "NIMKitUtil.h"
#import "UIView+NIM.h"
#import "TTServiceCore.h"
#import "TTServiceCoreClient.h"

@interface TTQYServiceTableViewCell ()<TTServiceCoreClient>

@property (nonatomic, strong) UIImageView * logoImageView;

@property (nonatomic, strong) UILabel * nameLabel;

@property (nonatomic, strong) UILabel * desLabel;



@property (nonatomic, strong) UILabel * dateLabel;
@end


@implementation TTQYServiceTableViewCell

#pragma mark - life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}
#define NameLabelMaxWidth    160.f
#define MessageLabelMaxWidth 200.f
//- (void)onReceiveQYMessageUpdateUI:(QYMessageInfo *)message{
//    if (message) {
//        NSString * type;
//        if (message.type == QYMessageTypeAudio) {
//            type = @"语音";
//        }else if(message.type == QYMessageTypeImage){
//            type = @"图片";
//        }else if (message.type == QYMessageTypeVideo){
//            type = @"视频";
//        }else if (message.type == QYMessageTypeText){
//            type = message.text;
//        }else{
//            type = @"消息";
//        }
//
//
//        NSString * imageUrl;
//        if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
//            self.nameLabel.text = @"官方客服";
//            imageUrl = @"https://img.erbanyy.com/new_kficon.png";
//        }else {
//            self.nameLabel.text = @"兔兔客服";
//            imageUrl = @"https://img.erbanyy.com/icon_tutukf.png";
//        }
//       [self.logoImageView qn_setImageImageWithUrl:imageUrl placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
//
//        self.desLabel.attributedText= [[NSMutableAttributedString alloc] initWithString:type attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[XCTheme getTTDeepGrayTextColor]}];
//
//        NSInteger badge = [[QYSDK sharedSDK].conversationManager  allUnreadCount];
//        if (badge > 0) {
//            self.badgeView.hidden = NO;
//             self.badgeView.badgeValue = [NSString stringWithFormat:@"%ld", badge];
//        }else{
//            self.badgeView.hidden = YES;
//        }
//        self.dateLabel.text = [NIMKitUtil showTime:message.timeStamp showDetail:NO];
//        self.nameLabel.nim_width = self.nameLabel .nim_width > NameLabelMaxWidth ? NameLabelMaxWidth : self.nameLabel.nim_width;
//        self.desLabel.nim_width = self.desLabel.nim_width > MessageLabelMaxWidth ? MessageLabelMaxWidth : self.desLabel.nim_width;
//    }
//}

#pragma mark - public method
- (void)refresh {
    NSString * imageUrl;
    self.badgeView.hidden = YES;
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        self.nameLabel.text = @"官方客服";
        imageUrl = @"https://img.erbanyy.com/new_kficon.png";
    }else {
        self.nameLabel.text = @"兔兔客服";
        imageUrl = @"https://img.erbanyy.com/icon_tutukf.png";
    }
    [self.logoImageView qn_setImageImageWithUrl:imageUrl placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
    
    [self.nameLabel sizeToFit];
    self.desLabel.attributedText= [[NSMutableAttributedString alloc] initWithString:@"[消息]" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[XCTheme getTTDeepGrayTextColor]}];
    [self.desLabel sizeToFit];
    
    self.nameLabel.nim_width = self.nameLabel .nim_width > NameLabelMaxWidth ? NameLabelMaxWidth : self.nameLabel.nim_width;
    self.desLabel.nim_width = self.desLabel.nim_width > MessageLabelMaxWidth ? MessageLabelMaxWidth : self.desLabel.nim_width;
}

#pragma mark - private method
- (void)initView{
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.desLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.badgeView];
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
    _logoImageView.nim_size = CGSizeMake(55, 55);
    _logoImageView.nim_left    = sessionListAvatarLeft;
    _logoImageView.nim_centerY = self.nim_height * .5f;
    _nameLabel.nim_top           = sessionListNameTop;
    _nameLabel.nim_left          = _logoImageView.nim_right + sessionListNameLeftToAvatar;
    _desLabel.nim_left       = _logoImageView.nim_right + sessionListMessageLeftToAvatar;
    _desLabel.nim_bottom     = self.nim_height - sessionListMessageBottom;
    _dateLabel.nim_right         = self.nim_width - sessionListTimeRight;
    _dateLabel.nim_top           = sessionListTimeTop;
    _badgeView.nim_right         = self.nim_width - sessionBadgeTimeRight;
    _badgeView.nim_bottom        = self.nim_height - sessionBadgeTimeBottom;
}

#pragma mark - setters and getters
- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
    }
    return _logoImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor  =  [XCTheme getTTMainTextColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}


- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textColor  =  [XCTheme getTTDeepGrayTextColor];
        _desLabel.font = [UIFont systemFontOfSize:12];
    }
    return _desLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor  =  UIColorFromRGB(0xacacac);
        _dateLabel.font = [UIFont systemFontOfSize:11];
    }
    return _dateLabel;
}

- (NIMBadgeView *)badgeView{
    if (!_badgeView) {
        _badgeView = [NIMBadgeView viewWithBadgeTip:@""];
    }
    return _badgeView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
