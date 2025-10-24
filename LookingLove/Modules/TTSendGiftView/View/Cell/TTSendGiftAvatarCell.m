//
//  TTSendGiftAvatarCell.m
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSendGiftAvatarCell.h"

//m
#import "GiftSendAllMicroAvatarInfo.h"
//T
#import <Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIImageView+QiNiu.h"
#import "RoomCoreV2.h"
#import "RoomQueueCoreV2.h"


@interface TTSendGiftAvatarCell()
@property (nonatomic, strong) UIImageView *allmicImageView;//全麦图片视图，用于替换 allmicLabel
@property (nonatomic, strong) UIView *maskView;//头像未选中的遮罩
/** 序号未选中遮罩 */
@property (nonatomic, strong) UIView *positionMaskView;
/** 房主位未选中遮罩 */
@property (nonatomic, strong) UIView *ownerMaskView;
@property (nonatomic, strong) UIImageView *avatarImageView; //头像
@property (nonatomic, strong) UILabel *microPositionLabel;//麦位
@property (nonatomic, strong) UIView *microPositionView;//麦位
@property (nonatomic, strong) UILabel *ownerPositionLabel;//房主位

@property (nonatomic, assign) BOOL isAllMicSend;//是否全麦
@property (nonatomic, strong) GiftSendAllMicroAvatarInfo *model;
@end

@implementation TTSendGiftAvatarCell

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
        [self setupSubviewsConstraints];
    }
    return self;
}

#pragma mark - puble method
- (void)configModle:(GiftSendAllMicroAvatarInfo *)model isAllMicSend:(BOOL)isAllMicSend {
    _model = model;
    _isAllMicSend = isAllMicSend;
    
    self.microPositionLabel.hidden = _model.isAllMic;
    self.ownerPositionLabel.hidden = _model.isAllMic;
    self.microPositionView.hidden = _model.isAllMic;
    self.maskView.hidden = _model.isAllMic;
    self.positionMaskView.hidden = _model.isAllMic;
    self.ownerMaskView.hidden = _model.isAllMic;
    
    if (model.isAllMic) { //是否0号位置的全麦item
        self.avatarImageView.hidden = YES;
        NSString *allmicPic = self.isAllMicSend ? @"room_gift_allmic_select" : @"room_gift_allmic_noselect";
        self.allmicImageView.image = [UIImage imageNamed:allmicPic];
    } else {
        self.microPositionLabel.text = [self getTheMicrosName:model];
        self.avatarImageView.hidden = NO;
        [self.avatarImageView qn_setImageImageWithUrl:_model.member.roomAvatar placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:ImageTypeRoomFace];
    }
    
    if (!model.isAllMic) {
        self.maskView.hidden = model.isSelected;
        self.positionMaskView.hidden = model.isSelected;
        self.ownerMaskView.hidden = model.isSelected;
    }
    if (self.isAllMicSend) {
        self.avatarImageView.layer.borderColor = [XCTheme getTTMainColor].CGColor;
        self.maskView.hidden = YES;
        self.positionMaskView.hidden = YES;
        self.ownerMaskView.hidden = YES;
    } else {
        self.ownerPositionLabel.backgroundColor = [XCTheme getTTMainColor];
        self.microPositionLabel.backgroundColor = [XCTheme getTTMainColor];
        self.avatarImageView.layer.borderColor = model.isSelected ? [XCTheme getTTMainColor].CGColor:[UIColor clearColor].CGColor;
    }
}

#pragma mark - Private

- (NSString *)getTheMicrosName:(GiftSendAllMicroAvatarInfo *)displayInfo {
    
    if ([displayInfo.position isEqualToString:@"-1"]) {
        self.ownerPositionLabel.hidden = NO;
        self.microPositionLabel.hidden = YES;
        self.microPositionView.hidden = YES;
        return @" 0 ";
    } else {
        self.ownerPositionLabel.hidden = YES;
        self.microPositionLabel.hidden = NO;
        self.microPositionView.hidden = NO;
        return [NSString stringWithFormat:@" %ld ",[displayInfo.position integerValue] + 1];
    }
}

- (void)setupSubviews {
    [self.contentView addSubview:self.allmicImageView];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.maskView];
    [self.contentView addSubview:self.microPositionView];
    [self.microPositionView addSubview:self.microPositionLabel];
    [self.contentView addSubview:self.ownerPositionLabel];
    [self.microPositionView addSubview:self.positionMaskView];
    [self.ownerPositionLabel addSubview:self.ownerMaskView];
}

- (void)setupSubviewsConstraints{
    
    [self.allmicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(38);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(38);
    }];
    
    [self.microPositionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(12);
        make.bottom.right.mas_equalTo(self.avatarImageView);
    }];
    
    [self.microPositionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.microPositionView);
    }];
    
    [self.ownerPositionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(12);
        make.centerX.bottom.equalTo(self.avatarImageView);
    }];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.avatarImageView);
    }];
    
    [self.positionMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.microPositionView);
    }];
    
    [self.ownerMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.ownerPositionLabel);
    }];
}

#pragma mark - Getter & Setter
- (UIImageView *)allmicImageView {
    if (!_allmicImageView) {
        _allmicImageView = [[UIImageView alloc] init];
        _allmicImageView.image = [UIImage imageNamed:@"room_gift_allmic_noselect"];
    }
    return _allmicImageView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 38/2;
        _avatarImageView.layer.borderColor = [[XCTheme getTTMainColor] CGColor];
        _avatarImageView.layer.borderWidth = 1;
    }
    return _avatarImageView;
}

- (UILabel *)ownerPositionLabel{
    if(!_ownerPositionLabel){
        _ownerPositionLabel = [[UILabel alloc] init];
        _ownerPositionLabel.text = @"房主位";
        _ownerPositionLabel.backgroundColor = [XCTheme getTTMainColor];
        if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
            _ownerPositionLabel.textColor = XCTheme.getTTMainTextColor;
        } else {
            _ownerPositionLabel.textColor = UIColor.whiteColor;
        }
        _ownerPositionLabel.layer.masksToBounds = YES;
        _ownerPositionLabel.layer.cornerRadius = 6;
        _ownerPositionLabel.font = [UIFont systemFontOfSize:7];
        _ownerPositionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _ownerPositionLabel;
}

- (UILabel *)microPositionLabel {
    if (!_microPositionLabel) {
        _microPositionLabel = [[UILabel alloc] init];
        if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
            _microPositionLabel.textColor = XCTheme.getTTMainTextColor;
        } else {
            _microPositionLabel.textColor = UIColor.whiteColor;
        }
        _microPositionLabel.font = [UIFont systemFontOfSize:8];
    }
    return _microPositionLabel;
}

- (UIView *)microPositionView {
    if (!_microPositionView) {
        _microPositionView = [[UIView alloc] init];
        _microPositionView.backgroundColor = [XCTheme getMainDefaultColor];
        _microPositionView.layer.masksToBounds = YES;
        _microPositionView.layer.cornerRadius = 6;
    }
    return _microPositionView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = UIColorRGBAlpha(0x000000, 0.3);
        _maskView.layer.masksToBounds = YES;
        _maskView.layer.cornerRadius = 38/2;
    }
    return _maskView;
}

- (UIView *)positionMaskView {
    if (!_positionMaskView) {
        _positionMaskView = [[UIView alloc] init];
        _positionMaskView.backgroundColor = UIColorRGBAlpha(0x000000, 0.3);
    }
    return _positionMaskView;
}

- (UIView *)ownerMaskView {
    if (!_ownerMaskView) {
        _ownerMaskView = [[UIView alloc] init];
        _ownerMaskView.backgroundColor = UIColorRGBAlpha(0x000000, 0.3);
    }
    return _ownerMaskView;
}
@end
