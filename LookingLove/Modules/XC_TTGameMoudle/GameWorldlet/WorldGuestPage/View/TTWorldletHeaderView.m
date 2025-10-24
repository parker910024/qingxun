//
//  TTWorldletHeaderView.m
//  AFNetworking
//
//  Created by apple on 2019/6/28.
//

#import "TTWorldletHeaderView.h"

#import "TTRollView.h"
#import "TTWorldletMainPartyRoomView.h"

#import "XCMediator+TTDiscoverModuleBridge.h"

#import "UIImageView+QiNiu.h"
#import "NSString+Utils.h"
#import "UIView+NTES.h"
#import "TTStatisticsService.h"
#import "TTPopup.h"
#import "XCHUDTool.h"
#import "XCShareView.h"
#import "XCCurrentVCStackManager.h"
#import "XCTheme.h"
#import "XCMacros.h"

#import "ShareCore.h"
#import "AuthCore.h"
#import "LittleWorldCoreClient.h"
#import "LittleWorldCore.h"

#import <Masonry/Masonry.h>
#import <YYText/YYLabel.h>
#import <YYText.h>

static CGFloat const kPartyRoomViewHeight = 130.0f;

@interface TTWorldletHeaderView ()<XCShareViewDelegate,LittleWorldCoreClient>

@property (nonatomic, strong) UIImageView *avatorImageView; // 头像
@property (nonatomic, strong) UILabel *titleLabel; // 名称
@property (nonatomic, strong) TTRollView *rollView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIButton *numberButton;
@property (nonatomic, strong) UIImageView *guideImageView;
@property (nonatomic, strong) UIButton *inviteButton;
@property (nonatomic, strong) UILabel *introduceLabel;

@property (nonatomic, assign) SharePlatFormType platform;//选择的分享平台保存

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *contentView; // 容器view
@property (nonatomic, strong) UILabel *nickLabel; // 昵称标题

@property (nonatomic, strong) TTWorldletMainPartyRoomView *partyRoomView;//语音派对

@end

@implementation TTWorldletHeaderView

- (void)dealloc {
    RemoveCoreClientAll(self);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initConstraint];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.contentView];
    [self addSubview:self.avatorImageView];
    [self addSubview:self.rollView];
    [self addSubview:self.leftImageView];
    [self addSubview:self.centerImageView];
    [self addSubview:self.rightImageView];
    [self addSubview:self.numberButton];
    [self addSubview:self.guideImageView];
    [self addSubview:self.inviteButton];
    [self addSubview:self.introduceLabel];
    [self addSubview:self.partyRoomView];
    
    [self.contentView addSubview:self.backgroundImageView];
    [self.contentView addSubview:self.effectView];
    [self.contentView addSubview:self.coverView];
    [self.contentView addSubview:self.nickLabel];
    
    if (projectType() == ProjectType_Planet) {
        self.inviteButton.hidden = YES;
    }
}

- (void)initConstraint {
    [self.avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(kNavigationHeight + 15);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    
    [self.rollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatorImageView.mas_top).offset(10);
        make.left.mas_equalTo(self.avatorImageView.mas_right).offset(15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(KScreenWidth - 105 - 90);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rollView);
        make.top.mas_equalTo(self.rollView.mas_bottom).offset(11);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImageView.mas_right).offset(5);
        make.bottom.mas_equalTo(self.leftImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.centerImageView.mas_right).offset(5);
        make.bottom.mas_equalTo(self.centerImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [self.numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rightImageView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.rightImageView.mas_centerY);
    }];
    
    [self.guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numberButton.mas_right).offset(5);
        make.centerY.mas_equalTo(self.numberButton.mas_centerY);
    }];
    
    [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(75, 35));
        make.centerY.mas_equalTo(self.avatorImageView);
    }];
    
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatorImageView.mas_bottom).offset(24);
        make.left.mas_equalTo(18);
        make.width.mas_equalTo(KScreenWidth - 18 * 2);
    }];
    
    [self.partyRoomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_greaterThanOrEqualTo(self.introduceLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backgroundImageView);
    }];

    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backgroundImageView);
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(46);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)numberBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberBtnClickAction:)]) {
        [self.delegate numberBtnClickAction:self];
    }
}

- (void)inviteBtnAction:(UIButton *)sender {
    [TTStatisticsService trackEvent:@"world-page-invitation-members" eventDescribe:@" 世界客态页-成员后面的邀请成员"];
    CGSize itemSize = CGSizeMake((KScreenWidth-2*22)/4, 76);
    
    XCShareView *shareView = [[XCShareView alloc] initWithShareViewStyle:XCShareViewStyleCenterAndBottom items:[self getShareItems] itemSize:itemSize edgeInsets:UIEdgeInsetsMake(12, 22, 12, 22)];
    
    shareView.delegate = self;
    
    [TTPopup popupView:shareView style:TTPopupStyleActionSheet];
}

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY {
    CGFloat alpha = contentOffsetY / (self.height - kStatusBarHeight);
    if (alpha > 0.7) {
        [self bringSubviewToFront:self.contentView];
        self.nickLabel.hidden = NO;
    } else {
        [self sendSubviewToBack:self.contentView];
        self.nickLabel.hidden = YES;
    }
}

#pragma mark --- LittleWorldCoreClient ---
/**
 获取世界分享图片
 */
- (void)responseWorldSharePic:(NSString *)data code:(NSNumber *)errorCode msg:(NSString *)msg {
    
    RemoveCoreClient(LittleWorldCoreClient, self);
    
    [XCHUDTool hideHUD];
    
    if (msg.length > 0) {
        [XCHUDTool showErrorWithMessage:msg];
        return;
    }
    
    if (![data isKindOfClass:[NSString class]]) {
        [XCHUDTool showErrorWithMessage:@"获取分享图片失败"];
        return;
    }
    
    if (data.length == 0) {
        [XCHUDTool showErrorWithMessage:@"获取分享图片失败"];
        return;
    }
    
    [GetCore(ShareCore) shareH5WithTitle:nil url:nil imgUrl:data desc:nil platform: self.platform];
}

#pragma mark - Share
- (void)shareView:(XCShareView *)shareView didSelected:(XCShareItemTag)itemTag {
    SharePlatFormType sharePlatFormType;
    
    [TTPopup dismiss];
    
    switch (itemTag) {
        case XCShareItemTagAppFriends:
            sharePlatFormType = Share_Platfrom_Type_Within_Application;
            break;
        case XCShareItemTagMoments:
            sharePlatFormType = Share_Platform_Type_Wechat_Circle;
            break;
        case XCShareItemTagWeChat:
            sharePlatFormType = Share_Platform_Type_Wechat;
            break;
        case XCShareItemTagQQZone:
            sharePlatFormType = Share_Platform_Type_QQ_Zone;
            break;
        case XCShareItemTagQQ:
            sharePlatFormType = Share_Platform_Type_QQ;
            break;
        default:
            sharePlatFormType = Share_Platform_Type_Wechat_Circle;
            break;
    }
    [self handleShare:sharePlatFormType];
}

- (void)shareViewDidClickCancle:(XCShareView *)shareView {
    [TTPopup dismiss];
}

- (void)handleShare:(SharePlatFormType)platform {
    if (platform == Share_Platfrom_Type_Within_Application) {
        ShareModelInfor *model = [[ShareModelInfor alloc] init];
        model.currentVC = [XCCurrentVCStackManager shareManager].getCurrentVC;
        model.shareType = Custom_Noti_Sub_Share_LittleWorld;
        model.worldletInfor = self.model;
        [GetCore(ShareCore) reloadShareModel:model];
        UIViewController * controller = [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyShareContainViewController];
        [[XCCurrentVCStackManager shareManager].getCurrentVC.navigationController pushViewController:controller animated:YES];
    }else{
//        UserID uid = [GetCore(AuthCore) getUid].userIDValue;
//        [GetCore(ShareCore) shareLittleWorldWithUid:uid worldInfo:self.model platform:platform];
        
        AddCoreClient(LittleWorldCoreClient, self);
        
        //保存分享平台
        self.platform = platform;
        
        //获取分享图片
        [XCHUDTool showGIFLoading];
        [GetCore(LittleWorldCore) requestWorldSharePicWithWorldId:self.model.worldId];
    }
}

- (NSArray<XCShareItem *>*)getShareItems {
    
    BOOL installWeChat = [GetCore(ShareCore) isInstallWechat];
    BOOL installQQ = [GetCore(ShareCore) isInstallQQ];
    
    XCShareItem *tutuItem = [XCShareItem itemWitTag:XCShareItemTagAppFriends title:@"好友" imageName:@"share_friend" disableImageName:@"share_friend" disable:NO];
    
    XCShareItem *momentItem = [XCShareItem itemWitTag:XCShareItemTagMoments title:@"朋友圈" imageName:@"share_wxcircle" disableImageName:@"share_wxcircle_disable" disable:!installWeChat];
    XCShareItem *weChatItem = [XCShareItem itemWitTag:XCShareItemTagWeChat title:@"微信好友" imageName:@"share_wx" disableImageName:@"share_wx_disable" disable:!installWeChat];
    XCShareItem *qqZoneItem = [XCShareItem itemWitTag:XCShareItemTagQQZone title:@"QQ空间" imageName:@"share_qqzone" disableImageName:@"share_qqzone_disable" disable:!installQQ];
    XCShareItem *qqItem = [XCShareItem itemWitTag:XCShareItemTagQQ title:@"QQ好友" imageName:@"share_qq" disableImageName:@"share_qq_disable" disable:!installQQ];
    
    return @[tutuItem,momentItem,weChatItem,qqZoneItem,qqItem];
}

#pragma mark - Public
- (CGFloat)height {
    
    CGSize size = [NSString sizeThatFitsWithText:self.model.desc maxSize:CGSizeMake((KScreenWidth - 18 * 2), MAXFLOAT) font:[UIFont systemFontOfSize:14]];
    CGFloat partyRoomViewHeight = self.partyRoomList.count>0 ? kPartyRoomViewHeight : 0.01;
    CGFloat introduceLabelBottomMargin = 30;
    CGFloat height = 120 + size.height + introduceLabelBottomMargin + partyRoomViewHeight;
    
    return height;
}

#pragma mark - Lazy Load
- (void)setModel:(LittleWorldListItem *)model {
    _model = model;
    
    self.imageArray = [NSMutableArray array];
    [self.backgroundImageView qn_setImageImageWithUrl:model.icon placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:(ImageType)ImageTypeUserLibaryDetail];
    [self.avatorImageView qn_setImageImageWithUrl:model.icon placeholderImage:[XCTheme defaultTheme].placeholder_image_square type:(ImageType)ImageTypeUserIcon];
    
    self.rollView.marqueeLabel.text = model.name;
    self.nickLabel.text = model.name;
    
    if (model.members.count >= 3) {
        
        [self.imageArray addObject:self.leftImageView];
        [self.imageArray addObject:self.centerImageView];
        [self.imageArray addObject:self.rightImageView];
        
        [self.numberButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.rightImageView.mas_right).offset(5);
            make.centerY.mas_equalTo(self.rightImageView.mas_centerY);
        }];
        
    } else if (model.members.count == 2) {
        [self.imageArray addObject:self.leftImageView];
        [self.imageArray addObject:self.centerImageView];
        
        [self.numberButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.centerImageView.mas_right).offset(5);
            make.centerY.mas_equalTo(self.centerImageView.mas_centerY);
        }];
    } else {
        [self.imageArray addObject:self.leftImageView];
        
        [self.numberButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftImageView.mas_right).offset(5);
            make.centerY.mas_equalTo(self.centerImageView.mas_centerY);
        }];
    }
    
    self.leftImageView.hidden = YES;
    self.centerImageView.hidden = YES;
    self.rightImageView.hidden = YES;
    
    for (int i = 0; i < model.members.count; i++) {
        if (i >= 3) {
            break;
        }
        LittleWorldListItemMember *memberModel = model.members[i];
        
        UIImageView *imageView = self.imageArray[i];
        
        imageView.hidden = NO;
        
        [imageView qn_setImageImageWithUrl:memberModel.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:(ImageType)ImageTypeUserIcon];
    }
    
    [_numberButton setTitle:[NSString stringWithFormat:@"%ld成员",model.memberNum] forState:UIControlStateNormal];
    
    _introduceLabel.text = model.desc;
}

- (void)setPartyRoomList:(NSArray<LittleWorldPartyRoom *> *)partyRoomList {
    _partyRoomList = partyRoomList;
    
    self.partyRoomView.dataArray = partyRoomList;
    
    [self.partyRoomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(partyRoomList.count>0 ? kPartyRoomViewHeight : 0.01);
    }];
}

- (UIImageView *)avatorImageView {
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.layer.cornerRadius = 12;
        _avatorImageView.layer.masksToBounds = YES;
        _avatorImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatorImageView;
}

- (TTRollView *)rollView {
    if (!_rollView) {
        _rollView = [[TTRollView alloc] init];
    }
    return _rollView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.layer.cornerRadius = 27 / 2;
        _leftImageView.layer.masksToBounds = YES;
    }
    return _leftImageView;
}

- (UIImageView *)centerImageView {
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] init];
        _centerImageView.layer.cornerRadius = 10;
        _centerImageView.layer.masksToBounds = YES;
    }
    return _centerImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.layer.cornerRadius = 10;
        _rightImageView.layer.masksToBounds = YES;
    }
    return _rightImageView;
}

- (UIButton *)numberButton {
    if (!_numberButton) {
        _numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_numberButton setTitleColor:UIColorRGBAlpha(0xffffff, 0.8) forState:UIControlStateNormal];
        _numberButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_numberButton addTarget:self action:@selector(numberBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _numberButton;
}

- (UIImageView *)guideImageView {
    if (!_guideImageView) {
        _guideImageView = [[UIImageView alloc] init];
        _guideImageView.image = [UIImage imageNamed:@"worldletMore"];
    }
    return _guideImageView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundImageView;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
        _effectView.alpha = 0.95;
    }
    return _effectView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = UIColorRGBAlpha(0x001C34, 0.35);
    }
    return _coverView;
}

- (UIButton *)inviteButton {
    if (!_inviteButton) {
        _inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inviteButton setTitle:@"邀请" forState:UIControlStateNormal];
        _inviteButton.backgroundColor = UIColorRGBAlpha(0xffffff, 0.15);
        [_inviteButton setTitleColor:UIColorRGBAlpha(0xffffff, 0.8) forState:UIControlStateNormal];
        _inviteButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _inviteButton.layer.cornerRadius = 18;
        [_inviteButton addTarget:self action:@selector(inviteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteButton;
}

- (UILabel *)introduceLabel {
    if (!_introduceLabel) {
        _introduceLabel = [[UILabel alloc] init];
        _introduceLabel.textColor = UIColorRGBAlpha(0xffffff, 0.8);
        _introduceLabel.font = [UIFont systemFontOfSize:14];
        _introduceLabel.numberOfLines = 0;
    }
    return _introduceLabel;
}

- (UILabel *)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.textColor = [UIColor whiteColor];
        _nickLabel.font = [UIFont systemFontOfSize:18];
        _nickLabel.textAlignment = NSTextAlignmentLeft;
        _nickLabel.hidden = YES;
    }
    return _nickLabel;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (TTWorldletMainPartyRoomView *)partyRoomView {
    if (_partyRoomView == nil) {
        _partyRoomView = [[TTWorldletMainPartyRoomView alloc] init];
        
        @weakify(self)
        _partyRoomView.selectedBlock = ^(LittleWorldPartyRoom * _Nonnull room) {
            @strongify(self)
            if ([self.delegate respondsToSelector:@selector(headerView:didSelectedPartyRoom:)]) {
                [self.delegate headerView:self didSelectedPartyRoom:room];
            }
        };
    }
    return _partyRoomView;
}

@end
