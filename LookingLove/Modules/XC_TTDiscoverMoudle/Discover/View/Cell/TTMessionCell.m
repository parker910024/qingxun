//
//  TTMessionCell.m
//  TTPlay
//
//  Created by lee on 2019/3/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMessionCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
// model
#import "MissionInfo.h"
#import <SDWebImage/UIButton+WebCache.h>

// view
#import "TTMissionGuideAlertView.h"

#import "TTPopup.h"
#import "XCCurrentVCStackManager.h"

#import "UIView+Shadow.h"

static NSString *const kUnDoneImageName = @"discover_mession_goDone";
static NSString *const kReceiveImageName = @"discover_mession_getIt";
static NSString *const kDoneImageName = @"discover_mession_Done";

@interface TTMessionCell ()
@property (nonatomic, strong) UIView *containerView;        // 容器view 用于切圆角，阴影
@property (nonatomic, strong) UILabel *titleLabel;          // 任务标题
@property (nonatomic, strong) UILabel *detailLabel;         // 任务描述
@property (nonatomic, strong) UIButton *carrotCountBtn;     // 任务奖励 萝卜数量
@property (nonatomic, strong) UIButton *doneMessionBtn;     // 去完成，领取奖励

@property (nonatomic, assign) BOOL hasAddShadow;//是否添加阴影，防止重复添加，默认：NO

@end

@implementation TTMessionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.detailLabel];
    [self.containerView addSubview:self.carrotCountBtn];
    [self.containerView addSubview:self.doneMessionBtn];
}

- (void)initConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView).inset(15);
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(-12);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(20);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.doneMessionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-17);
        make.width.mas_equalTo(86);
        make.height.mas_equalTo(47);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.carrotCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.doneMessionBtn.mas_left).offset(-16);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        return;
    }
    
    if (!self.hasAddShadow) {
        
        self.hasAddShadow = YES;
        
        [UIView xc_addShadowToView:self.containerView
                     shadowOpacity:1
                       shadowColor:UIColorRGBAlpha(0x0F0A01, 0.06)
                      shadowRadius:9.f
                      cornerRadius:14.f
                       borderWidth:0.f
                       borderColor:UIColor.grayColor];
    }
}

#pragma mark -
#pragma mark clients
- (void)onClickDoneMessionBtnAction:(UIButton *)doneMessionBtn {
    if (!self.info.support) {
        // 可能是需要弹窗告知版本不支持
        [UIView showToastInKeyWindow:@"版本过低，请下载最新版本哦" duration:2.0 position:YYToastPositionCenter];
        return;
    }
    
    // 已完成，不做任何处理
    if (self.info.status == MissionStatusDoneReceive) {
        return;
    }
    
    // 如果是弹窗引导类型
    if (self.info.skipType == MissionSkipType_AlertGuide && self.info.status == MissionStatusUndone) {
        TTMissionGuideAlertView *alertView = [[TTMissionGuideAlertView alloc] initWithFrame:CGRectMake(0, 0, 295, 302) withStepPic:self.info.stepPic];
        
        alertView.dismissHandler = ^{
            [TTPopup dismiss];
        };
        
        [TTPopup popupView:alertView style:TTPopupStyleAlert];
        return;
    }
    
    NSString *configId = nil;
    if (self.info.status == MissionStatusDoneUnreceive) {
        configId = _info.configId;
    }
    !_btnClickHandler ? : _btnClickHandler(_info.routerType, configId);
}
#pragma mark -
#pragma mark private methods
- (void)setInfo:(MissionInfo *)info {
    if (!info) {
        return;
    }
    _info = info;
    self.titleLabel.text = info.name;
    self.detailLabel.text = info.descriptionStr;
    
    if (info.prizePic) { // 如果有数值才进行赋值
        [self.carrotCountBtn setTitle:[NSString stringWithFormat:@"x%@", info.prizeNum] forState:UIControlStateNormal];
        [self.carrotCountBtn sd_setImageWithURL:[NSURL URLWithString:info.prizeIcon] forState:UIControlStateNormal];
    } else {
        // 没有的时候设置为空
        [self.carrotCountBtn setImage:nil forState:UIControlStateNormal];
        [self.carrotCountBtn setTitle:@"" forState:UIControlStateNormal];
    }
    // 默认白色字体
    [self.doneMessionBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    if (info.status == MissionStatusUndone) {
        [self.doneMessionBtn setBackgroundImage:[UIImage imageNamed:kUnDoneImageName] forState:UIControlStateNormal];
        [self.doneMessionBtn setTitle:@"去完成" forState:UIControlStateNormal];
    } else if (info.status == MissionStatusDoneUnreceive) {
        [self.doneMessionBtn setBackgroundImage:[UIImage imageNamed:kReceiveImageName] forState:UIControlStateNormal];
        [self.doneMessionBtn setTitle:@"领取" forState:UIControlStateNormal];
    } else if (info.status == MissionStatusDoneReceive) {
        [self.doneMessionBtn setBackgroundImage:[UIImage imageNamed:kDoneImageName] forState:UIControlStateNormal];
        [self.doneMessionBtn setTitle:@"已完成" forState:UIControlStateNormal];
        [self.doneMessionBtn setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = UIColor.whiteColor;
    }
    return _containerView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getMSMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _detailLabel.font = [UIFont systemFontOfSize:12.f];
        _detailLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _detailLabel;
}

- (UIButton *)doneMessionBtn {
    if (!_doneMessionBtn) {
        _doneMessionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneMessionBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_doneMessionBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_doneMessionBtn addTarget:self action:@selector(onClickDoneMessionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneMessionBtn;
}

- (UIButton *)carrotCountBtn {
    if (!_carrotCountBtn) {
        _carrotCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carrotCountBtn setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_carrotCountBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        _carrotCountBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    }
    return _carrotCountBtn;
}


@end
