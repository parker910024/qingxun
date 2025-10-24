//
//  TTLittleWorldPartyTableViewCell.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/1.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTLittleWorldPartyTableViewCell.h"

#import <YYText/YYLabel.h>
#import <Masonry/Masonry.h>
//XC_类
#import "XCTheme.h"
#import "XCMacros.h"
#import "BaseAttrbutedStringHandler.h"
#import "UIImageView+QiNiu.h"
#import "XCMediator+TTRoomMoudleBridge.h"
#import "TTPopup.h"
#import "LittleWorldCore.h"
#import "TTStatisticsService.h"
#import "AuthCore.h"

@interface TTLittleWorldPartyTableViewCell ()
/** 头像*/
@property (nonatomic,strong) UIImageView *avatarImageView;
/** 小圆圈*/
@property (nonatomic,strong) UIView *cirleView;
/** 名字*/
@property (nonatomic,strong) YYLabel *nameLable;
/** 在线人数*/
@property (nonatomic,strong) YYLabel *numberLable;
/** 加入*/
@property (nonatomic,strong) UIButton *enterButton;
@end

@implementation TTLittleWorldPartyTableViewCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}
#pragma mark - public methods
#pragma mark - delegate
#pragma mark - event response
- (void)enterButtonAction:(UIButton *)sender {
    
    [TTPopup dismiss];
    
    [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:self.partyModel.roomUid];
    
    [GetCore(LittleWorldCore) reportWorldMemberoActiveType:4 reportUid:GetCore(AuthCore).getUid.userIDValue worldId:GetCore(LittleWorldCore).reportWorldID];
    
    NSString *des = [NSString stringWithFormat:@"加入语音派对-小世界：%@", self.partyModel.worldName];
    [TTStatisticsService trackEvent:@"world_page_enter_party_b" eventDescribe:des];
    [TTStatisticsService trackEvent:@"world_page_enter_party" eventDescribe:@"加入语音派对:小世界群聊"];
}

#pragma mark - private method
- (NSMutableAttributedString *)createLittleWorldPartyCellNameAttributeWithMember:(TTLittleWorldPartyModel *)model {
    NSMutableAttributedString * attrritbut = [[NSMutableAttributedString alloc] init];
    
    CGFloat maxWidth = KScreenWidth - 190;
    if (model.ownerFlag) {
        maxWidth = maxWidth - 50;
    }
    UIColor * nickColor;
    if (model.ownerFlag) {
      nickColor = UIColorFromRGB(0xFF3B30);
    }else {
      nickColor = [XCTheme getTTMainTextColor];
    }
    NSDictionary *attribute = @{k_NickLabel_Font:[UIFont systemFontOfSize:15],
                                k_NickLabel_Color:nickColor,
                                k_NickLabel_MaxWidth:@(maxWidth),
                                k_NickLabel_LabelHeight:@(22)
                                };
    [attrritbut appendAttributedString:[BaseAttrbutedStringHandler makeLabelNick:model.title labelAttribute:attribute]];
    BaseAttributedUserGender gender;
    if (model.gender == UserInfo_Male) {
        gender = BaseAttributedUserGender_Male;
    }else {
        gender = BaseAttributedUserGender_Female;
    }
    [attrritbut appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
    NSMutableAttributedString * genderAttributString = [BaseAttrbutedStringHandler makeGender:gender];
    [attrritbut appendAttributedString:genderAttributString];
    if (model.ownerFlag) {
        [attrritbut appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
        [attrritbut appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 38, 15) urlString:nil imageName:@"worldletCreator"]];
    }
    
    return  attrritbut;
}

- (NSMutableAttributedString *)createLittleWorldPartyCellNumberPersonAttributeWithMember:(TTLittleWorldPartyModel *)model {
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] init];
    if (model.tagPict) {
      [attribute appendAttributedString:[BaseAttrbutedStringHandler makeImageAttributedString:CGRectMake(0, 0, 37, 15) urlString:model.tagPict imageName:nil]];
        [attribute appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
    }
    
    [attribute appendAttributedString:[BaseAttrbutedStringHandler creatStrAttrByStr:[NSString stringWithFormat:@"%d人在线", model.onlineNum] attributed:@{NSFontAttributeName:[UIFont systemFontOfSize:11], NSForegroundColorAttributeName:[XCTheme getTTDeepGrayTextColor]}]];
    return attribute;
}

- (void)initView {
     [self.contentView addSubview:self.cirleView];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.numberLable];
    [self.contentView addSubview:self.enterButton];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.enterButton addTarget:self action:@selector(enterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)initConstrations {
    [self.cirleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.avatarImageView);
        make.size.mas_equalTo(CGSizeMake(62, 62));
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(55, 55));
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(11);
        make.right.mas_equalTo(self.enterButton.mas_left).offset(-5);
        make.top.mas_equalTo(self.avatarImageView).offset(8);
    }];
    
    [self.numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLable);
        make.top.mas_equalTo(self.nameLable.mas_bottom).offset(5);
    }];
    
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(55, 28));
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-20);
    }];

}
#pragma mark - getters and setters
- (void)setPartyModel:(TTLittleWorldPartyModel *)partyModel {
    _partyModel = partyModel;
    if (_partyModel) {
        if (_partyModel.ownerFlag) {
            self.backgroundColor = UIColorFromRGB(0xf7f7f7);
            [self.enterButton setBackgroundColor:UIColorFromRGB(0xFF6671)];
            self.cirleView.hidden = NO;
        }else {
            self.backgroundColor = [UIColor whiteColor];
            [self.enterButton setBackgroundColor:[XCTheme getTTMainColor]];
            self.cirleView.hidden = YES;
        }
        [self.avatarImageView qn_setImageImageWithUrl:partyModel.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeRoomMagic];
        self.nameLable.attributedText = [self createLittleWorldPartyCellNameAttributeWithMember:_partyModel];
        self.numberLable.attributedText = [self createLittleWorldPartyCellNumberPersonAttributeWithMember:_partyModel];
    }
}
- (UIView *)cirleView {
    if (!_cirleView) {
        _cirleView = [[UIView alloc] init];
        _cirleView.layer.masksToBounds = YES;
        _cirleView.layer.borderWidth = 2;
        _cirleView.layer.cornerRadius = 31;
        _cirleView.layer.borderColor = UIColorFromRGB(0xFF3E50).CGColor;
        _cirleView.backgroundColor = [UIColor whiteColor];
        _cirleView.hidden = YES;
    }
    return _cirleView;
}

- (YYLabel *)nameLable {
    if (!_nameLable) {
        _nameLable = [[YYLabel alloc] init];
    }
    return _nameLable;
}

- (YYLabel *)numberLable {
    if (!_numberLable) {
        _numberLable = [[YYLabel alloc] init];
    }
    return _numberLable;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitle:@"加入" forState:UIControlStateNormal];
        [_enterButton setTitle:@"加入" forState:UIControlStateSelected];
        [_enterButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_enterButton setBackgroundColor:[XCTheme getTTMainColor]];
        _enterButton.layer.masksToBounds = YES;
        _enterButton.layer.cornerRadius = 14;
    }
    return _enterButton;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 55/2;
    }
    return _avatarImageView;
}

@end
