//
//  TTGiftSpringView.m
//  TuTu
//
//  Created by KevinWang on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGiftSpringView.h"
//core
#import "GiftCore.h"
#import "RoomQueueCoreV2.h"

//tool
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import <Masonry/Masonry.h>

@interface TTGiftSpringView()

@property (strong, nonatomic) UIImageView *giftAnimateBg;//礼物横幅背景
@property (strong, nonatomic) UILabel *sendTipLable;//赠送

@property (strong, nonatomic) UIImageView *senderAvatar;//发送者头像
@property (strong, nonatomic) UILabel *senderNickLabel;//发送者昵称

@property (strong, nonatomic) UIImageView *reveiverAvatar;// 接收者头像
@property (strong, nonatomic) UILabel *receiverNickLabel;//接收者昵称

@property (strong, nonatomic) UIImageView *giftBgImageView;//礼物bg图片
@property (strong, nonatomic) UIImageView *giftIconImageView;//礼物图片
@property (strong, nonatomic) UILabel *giftNumLabel;//礼物数量
/** 礼物名称 */
@property (nonatomic, strong) UILabel *giftNameLabel;
@end

@implementation TTGiftSpringView

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupSubviews];
        [self setupSubviewsConstraints];
    }
    return self;
}

#pragma mark - puble method
- (void)setGiftReceiveInfo:(GiftAllMicroSendInfo *)giftReceiveInfo {
    
    _giftReceiveInfo = giftReceiveInfo;
    NSInteger giftTotal = 0;
//    GiftInfo *info = [GetCore(GiftCore) findGiftInfoByGiftId:giftReceiveInfo.giftId];
//    if (!info) {
//        info = giftReceiveInfo.gift;
//    }
    GiftInfo *info = giftReceiveInfo.gift;

    [self.senderAvatar qn_setImageImageWithUrl:giftReceiveInfo.avatar placeholderImage:nil type:(ImageType)ImageTypeRoomMagic];
    [self.senderNickLabel setText:giftReceiveInfo.nick];
    [self.giftIconImageView qn_setImageImageWithUrl:info.giftUrl placeholderImage:nil type:(ImageType)ImageTypeRoomGift];
    self.giftNumLabel.text = [NSString stringWithFormat:@" x %ld",giftReceiveInfo.giftNum];
    self.giftNameLabel.text = giftReceiveInfo.giftInfo.giftName;
    
    if (giftReceiveInfo.targetUids.count == 1) {
        
        [self.reveiverAvatar qn_setImageImageWithUrl:giftReceiveInfo.targetAvatar placeholderImage:nil type:(ImageType)ImageTypeRoomGift];
        [self.receiverNickLabel setText:giftReceiveInfo.targetNick];
        giftTotal = giftReceiveInfo.giftNum * info.goldPrice;
        
    } else if (giftReceiveInfo.targetUids.count > 1) {
        
        if (giftReceiveInfo.isBatch) { // 非全麦 多人送礼
            
            NSString *subTitle = @"";
            for (NSString *targetUid in giftReceiveInfo.targetUids) {
                NSString *destinationPosition = [GetCore(RoomQueueCoreV2)findThePositionByUid:[targetUid integerValue]];
                
                if (destinationPosition.length == 0) {
                    continue; // 收礼人已经下麦了, 则不展示
                }
                
                if (subTitle.length > 0) {
                    subTitle = [subTitle stringByAppendingFormat:@",%i麦", [destinationPosition intValue] + 1];
                } else {
                    subTitle = [subTitle stringByAppendingFormat:@"%i麦", [destinationPosition intValue] + 1];
                }
            }
            
            [self.reveiverAvatar setImage:[UIImage imageNamed:@"puding_logo"]];
            [self.receiverNickLabel setText:subTitle];
            giftTotal = giftReceiveInfo.giftNum * info.goldPrice * giftReceiveInfo.targetUids.count;
        } else { // 全麦
            [self.reveiverAvatar setImage:[UIImage imageNamed:@"puding_logo"]];
            [self.receiverNickLabel setText:@"全麦"];
            giftTotal = giftReceiveInfo.giftNum * info.goldPrice * giftReceiveInfo.targetUids.count;
        }
    } else if (info.consumeType == GiftConsumeTypeBox) {
        info = [GetCore(GiftCore) findPrizeGiftByGiftId:giftReceiveInfo.receiveGiftId];
        giftTotal = info.goldPrice * giftReceiveInfo.giftNum;
    }
    
    [self configAnimateImageByGiftTotal:giftTotal];
}

#pragma mark - Private
- (void)configAnimateImageByGiftTotal:(NSInteger)giftTotal{
    if (giftTotal >= 520 && giftTotal < 4999) {
        
        self.giftAnimateBg.image = [UIImage imageNamed:@"room_spring_animate_bg_3"];
    }else if (giftTotal >= 4999 && giftTotal < 9999) {
        
        self.giftAnimateBg.image = [UIImage imageNamed:@"room_spring_animate_bg_2"];
    }else if (giftTotal >= 9999) {
        
        self.giftAnimateBg.image = [UIImage imageNamed:@"room_spring_animate_bg_1"];
    }
}

- (void)setupSubviews{
    [self addSubview:self.giftAnimateBg];
    
    [self addSubview:self.senderAvatar];
    [self addSubview:self.senderNickLabel];
    
    [self addSubview:self.sendTipLable];
    
    [self addSubview:self.reveiverAvatar];
    [self addSubview:self.receiverNickLabel];
    
    [self addSubview:self.giftBgImageView];
    [self addSubview:self.giftIconImageView];
    [self addSubview:self.giftNumLabel];
    [self addSubview:self.giftNameLabel];
    
}

- (void)setupSubviewsConstraints{
    
    [self.giftAnimateBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.senderAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(49);
        make.top.equalTo(self).offset(49);
        make.width.height.equalTo(@40);
    }];
    [self.senderNickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.senderAvatar.mas_centerX);
        make.top.equalTo(self.senderAvatar.mas_bottom).offset(2);
        make.width.mas_lessThanOrEqualTo(70);
    }];
    
    [self.sendTipLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.senderAvatar.mas_right).offset(24);
        make.centerY.equalTo(self.senderAvatar.mas_centerY);
    }];
    
    [self.reveiverAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendTipLable.mas_right).offset(24);
        make.centerY.equalTo(self.sendTipLable);
        make.width.height.equalTo(self.senderAvatar);
        
    }];
    [self.receiverNickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.reveiverAvatar);
        make.top.equalTo(self.senderNickLabel);
        make.width.mas_lessThanOrEqualTo(70);
    }];
    
    [self.giftBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reveiverAvatar.mas_right).offset(4);
        make.centerY.equalTo(self.sendTipLable);
        make.width.height.equalTo(@100);
    }];
    [self.giftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.center.equalTo(self.giftBgImageView);
    }];
    
    [self.giftNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-36);
    }];
    
    [self.giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.receiverNickLabel);
        make.centerX.equalTo(self.giftIconImageView);
        make.width.mas_lessThanOrEqualTo(70);
    }];
}

#pragma mark - Getter

- (UIImageView *)giftAnimateBg {
    if (!_giftAnimateBg) {
        _giftAnimateBg = [[UIImageView alloc]init];
        _giftAnimateBg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _giftAnimateBg;
}


- (UIImageView *)senderAvatar {
    if (!_senderAvatar) {
        _senderAvatar = [[UIImageView alloc]init];
        _senderAvatar.layer.cornerRadius = 17.5;
        _senderAvatar.layer.masksToBounds = YES;
    }
    return _senderAvatar;
}

- (UILabel *)senderNickLabel {
    if (!_senderNickLabel) {
        _senderNickLabel = [[UILabel alloc]init];
        _senderNickLabel.textColor = UIColorFromRGB(0xffffff);
        _senderNickLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _senderNickLabel;
}

- (UILabel *)sendTipLable {
    if (!_sendTipLable) {
        _sendTipLable = [[UILabel alloc]init];
        _sendTipLable.text = @"赠送";
        _sendTipLable.textColor = [UIColor whiteColor];
        _sendTipLable.font = [UIFont systemFontOfSize:10.0];
    }
    return _sendTipLable;
}


- (UIImageView *)reveiverAvatar {
    if (!_reveiverAvatar) {
        _reveiverAvatar = [[UIImageView alloc]init];
        _reveiverAvatar.layer.cornerRadius = 17.5;
        _reveiverAvatar
        .layer.masksToBounds = YES;
    }
    return _reveiverAvatar;
}

- (UILabel *)receiverNickLabel {
    if (!_receiverNickLabel) {
        _receiverNickLabel = [[UILabel alloc]init];
        _receiverNickLabel.textColor = UIColorFromRGB(0xffffff);
        _receiverNickLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _receiverNickLabel;
}

- (UIImageView *)giftBgImageView{
    if (!_giftBgImageView) {
        _giftBgImageView = [[UIImageView alloc]init];
        _giftBgImageView.image = [UIImage imageNamed:@"room_spring_gift_bg"];
    }
    return _giftBgImageView;
}

- (UIImageView *)giftIconImageView {
    if (!_giftIconImageView) {
        _giftIconImageView = [[UIImageView alloc]init];
    }
    return _giftIconImageView;
}

- (UILabel *)giftNumLabel {
    if (!_giftNumLabel) {
        _giftNumLabel = [[UILabel alloc]init];
        _giftNumLabel.font = [UIFont systemFontOfSize:20.f weight:UIFontWeightBold];
        _giftNumLabel.textColor = UIColorFromRGB(0xFFF226);
    }
    return _giftNumLabel;
}

- (UILabel *)giftNameLabel {
    if (!_giftNameLabel) {
        _giftNameLabel = [[UILabel alloc] init];
        _giftNameLabel.font = [UIFont systemFontOfSize:12];
        _giftNameLabel.textColor = [UIColor whiteColor];
    }
    return _giftNameLabel;
}

@end
