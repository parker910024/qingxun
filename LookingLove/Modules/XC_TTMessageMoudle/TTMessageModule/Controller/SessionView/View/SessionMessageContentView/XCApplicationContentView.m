//
//  XCApplicationContentView.m
//  XChat
//
//  Created by gzlx on 2018/6/13.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "XCApplicationContentView.h"
#import "XCApplicationSharement.h"
#import "NSObject+YYModel.h"
#import "XCFamily.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIImageView+QiNiu.h"
#import "RoomInfo.h"
#import "GroupModel.h"
#import "LittleWorldListModel.h"

NSString * const XCApplicationContentViewClick = @"XCApplicationContentViewClick";

@interface XCApplicationContentView()
@property (nonatomic,strong) UIView *backView;
@property (nonatomic, strong)UILabel * contentLabel;
@property (nonatomic, strong) UIImageView * avaratImageView;
@property (nonatomic, strong) UIView * sepView;
@property (nonatomic, strong) UIButton * enterButton;

@end


@implementation XCApplicationContentView

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        [self initView];
        [self layoutSubViewFrame];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    XCApplicationSharement *customObject = (XCApplicationSharement*)object.attachment;
    if (!(customObject.avatar.length > 0 && customObject.title.length > 0)) {
        customObject = [XCApplicationSharement yy_modelWithJSON:customObject.data];
    }
    self.contentLabel.text = customObject.title;
    [self.enterButton setTitle:customObject.actionName forState:UIControlStateNormal];
    if (customObject.routerType == P2PInteractive_SkipType_Family) {
        XCFamily * family = [XCFamily yy_modelWithDictionary:customObject.data[@"info"]];
        [self.avaratImageView qn_setImageImageWithUrl:family.familyIcon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
    }else if (customObject.routerType == P2PInteractive_SkipType_Group){
        GroupModel* family = [GroupModel yy_modelWithDictionary:customObject.data[@"info"]];
        [self.avaratImageView qn_setImageImageWithUrl:family.icon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
    }else if (customObject.routerType == P2PInteractive_SkipType_Room){
        RoomInfo * roomInfo = [RoomInfo yy_modelWithDictionary:customObject.data[@"info"]];
        [self.avaratImageView qn_setImageImageWithUrl:roomInfo.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
    }else if (customObject.routerType == P2PInteractive_SkipType_LittleWorldGuestPage) {
        LittleWorldListItem * item = [LittleWorldListItem yy_modelWithDictionary:customObject.data[@"info"]];
         [self.avaratImageView qn_setImageImageWithUrl:item.icon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeHomePageItem];
    }
}


- (void)enterButtonAction:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = XCApplicationContentViewClick;
        event.messageModel = self.model;
        event.data = self;
        [self.delegate onCatchEvent:event];
    }
}


- (void)initView
{
    [self addSubview:self.backView];
    [self.backView addSubview:self.contentLabel];
    [self.backView addSubview:self.avaratImageView];
    [self.backView addSubview:self.sepView];
    [self.backView addSubview:self.enterButton];
}

- (void)layoutSubViewFrame
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
         make.top.mas_equalTo(self).offset(-2);
        make.bottom.mas_equalTo(self).offset(2);
        make.right.mas_equalTo(self).offset(2);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.backView).offset(15);
        make.right.mas_equalTo(self.backView).offset(-80);
    }];
    
    [self.avaratImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.right.mas_equalTo(self.backView).offset(-15);
        make.top.mas_equalTo(self.backView).offset(15);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.backView);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.backView).offset(-40);
    }];
    
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.backView);
        make.height.mas_equalTo(40);
    }];
}

- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = UIColorFromRGB(0x333333);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}

- (UIView *)sepView
{
    if (_sepView == nil) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    return _sepView;
}

- (UIImageView *)avaratImageView
{
    if (_avaratImageView == nil) {
        _avaratImageView = [[UIImageView alloc] init];
        _avaratImageView.contentMode = UIViewContentModeScaleToFill;
        _avaratImageView.userInteractionEnabled = YES;
        _avaratImageView.layer.masksToBounds = YES;
        _avaratImageView.layer.cornerRadius = 5;
    }
    return _avaratImageView;
}


- (UIButton *)enterButton
{
    if (_enterButton == nil) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        _enterButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_enterButton addTarget:self action:@selector(enterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 5;
        
    }
    return _backView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
