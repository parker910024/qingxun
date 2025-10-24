//
//  TTApprenticeFollowView.m
//  TTPlay
//
//  Created by Macx on 2019/1/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTApprenticeFollowView.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import <Masonry/Masonry.h>
#import "XCMentoringShipAttachment.h"
#import "UserInfo.h"
#import "UserCore.h"
#import "BaseAttrbutedStringHandler+Message.h"
#import "UIImageView+QiNiu.h"
#import <YYText/YYLabel.h>
#import "XCKeyWordTool.h"

@interface TTApprenticeFollowView ()
/** 背景图*/
@property (nonatomic, strong) UIImageView *backImageView;
/** contentView */
@property (nonatomic, strong) UIView *contentView;
/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;
/** report */
@property (nonatomic, strong) UIButton *reportButton;
/** lineView */
@property (nonatomic, strong) UIView *lineView;
/** tip */
@property (nonatomic, strong) UILabel *tipLabel;
/** tip2 兔兔所有问题都可以问Ta哦~ */
@property (nonatomic, strong) UILabel *tip2Label;
/** 头像 */
@property (nonatomic, strong) UIImageView *avatarImageView;
/** name + sex */
@property (nonatomic, strong) YYLabel *nameLabel;

@end

@implementation TTApprenticeFollowView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickReportButton:(UIButton *)btn {
    if (self.reportButtonDidClickBlcok) {
        self.reportButtonDidClickBlcok();
    }
}

- (void)avatarImageViewRecognizer:(UITapGestureRecognizer *)tap{
    if (self.avatarImageBlock) {
        self.avatarImageBlock();
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.backImageView];
    
    [self.backImageView addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.reportButton];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.tip2Label];
    
    [self.reportButton addTarget:self action:@selector(didClickReportButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewRecognizer:)];
    [self.avatarImageView addGestureRecognizer:tap];
}

- (void)initConstrations {
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backImageView).offset(14);
        make.left.mas_equalTo(self.backImageView).offset(11);
        make.right.mas_equalTo(self.backImageView).offset(-11);
        make.bottom.mas_equalTo(self.backImageView).offset(-14);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(34);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(97);
        make.left.mas_equalTo(26);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(4);
    }];
    
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-13);
        make.top.mas_equalTo(self.contentView).offset(16);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(21);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(122);
        make.left.mas_equalTo(self.contentView).offset(94);
        make.right.mas_equalTo(self.contentView).offset(-38);
    }];
    
    [self.tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(198);
        make.left.mas_equalTo(self.tipLabel);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(33);
        make.top.mas_equalTo(123);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.avatarImageView);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).offset(5);
        make.height.mas_equalTo(13);
    }];
}

#pragma mark - getters and setters

- (void)setApprenticeFollowAttach:(XCMentoringShipAttachment *)apprenticeFollowAttach {
    _apprenticeFollowAttach = apprenticeFollowAttach;
    
    self.titleLabel.text = apprenticeFollowAttach.title;
    
    for (int i = 0; i < apprenticeFollowAttach.content.count; i++) {
        NSString *text = apprenticeFollowAttach.content[i];
        if (i == 0) {
            self.tipLabel.text = text;
        } else if (i == 1) {
            self.tip2Label.text = text;
        }
    }
    
    UserInfo * infor = [UserInfo yy_modelWithDictionary:apprenticeFollowAttach.extendData];
    if (infor) {
        [self.avatarImageView qn_setImageImageWithUrl:infor.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserIcon];
        
        // 昵称(最多四个字, 多的...) + 性别
        self.nameLabel.attributedText = [BaseAttrbutedStringHandler creatNick_SexLimitByUserInfo:infor textColor:RGBCOLOR(26, 26, 26) font:[UIFont systemFontOfSize:11]];
    }else{
        @KWeakify(self);
        [GetCore(UserCore) getUserInfo:apprenticeFollowAttach.masterUid refresh:YES success:^(UserInfo *info) { @KStrongify(self);
            [self.avatarImageView qn_setImageImageWithUrl:info.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserIcon];
            
            // 昵称(最多四个字, 多的...) + 性别
            self.nameLabel.attributedText = [BaseAttrbutedStringHandler creatNick_SexLimitByUserInfo:info textColor:RGBCOLOR(26, 26, 26) font:[UIFont systemFontOfSize:11]];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.image = [UIImage imageNamed:@"message_master_backimage"];
    }
    return _backImageView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}



- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.numberOfLines =2;
    }
    return _titleLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [XCTheme getTTMainTextColor];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UILabel *)tip2Label {
    if (!_tip2Label) {
        _tip2Label = [[UILabel alloc] init];
        _tip2Label.text = [NSString stringWithFormat: @"%@所有问题都可以问Ta哦~", [XCKeyWordTool sharedInstance].myAppName];
        _tip2Label.textColor = [XCTheme getTTMainColor];
        _tip2Label.font = [UIFont systemFontOfSize:13];
    }
    return _tip2Label;
}

- (UIButton *)reportButton {
    if (!_reportButton) {
        _reportButton = [[UIButton alloc] init];
        [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
        [_reportButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _reportButton.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _reportButton;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 20.0;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
    }
    return _avatarImageView;
}

- (YYLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc] init];
        _nameLabel.textColor = RGBCOLOR(26, 26, 26);
        _nameLabel.font = [UIFont systemFontOfSize:11];
    }
    return _nameLabel;
}
@end
