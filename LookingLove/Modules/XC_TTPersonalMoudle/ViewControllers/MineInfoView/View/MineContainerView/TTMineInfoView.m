//
//  TTMineInfoView.m
//  TuTu
//
//  Created by lee on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMineInfoView.h"

#import "TTMineInfoBubbleView.h"
#import "TTEditRecordViewController.h"
#import "TTNobleSourceHelper.h"
// cate
#import "BaseAttrbutedStringHandler+TTMineInfo.h"

#import <YYText/YYText.h>
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+QiNiu.h"
#import "UIView+ZJFrame.h"
#import "NSString+AutoMessageDigest.h"
#import "XCHUDTool.h"
#import <YYImage/YYAnimatedImageView.h>
#import "SpriteSheetImageManager.h"
#import "XCCurrentVCStackManager.h"
#import "SVGA.h"
#import "NSString+Utils.h"

// core
#import "UserInfo.h"
#import "FileCore.h"
#import "FileCoreClient.h"
#import "MediaCore.h"
#import "MediaCoreClient.h"

@interface TTMineInfoView ()
<
    FileCoreClient,
    MediaCoreClient,
    SVGAPlayerDelegate
>
@property (nonatomic, assign) TTMineInfoViewStyle mineViewStyle;
// icon
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) YYAnimatedImageView *headwearImageView;  // 头饰
@property (nonatomic, strong) SpriteSheetImageManager *manager;
// info
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIButton *genderBtn;
/**
 管|靓|ID
 */
@property (nonatomic, strong) YYLabel * IDLabel;
@property (nonatomic, strong) YYLabel *userTitleTagLabel;

// 主播标签
@property (nonatomic,strong) YYLabel *anchorTagLabel;

// vioce
//@property (nonatomic, strong) UIButton *voiceAccostBtn; // 语音招呼
@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic, strong) TTMineInfoBubbleView *followView; // 关注
@property (nonatomic, strong) TTMineInfoBubbleView *fansView;   // 粉丝
@property (nonatomic, strong) TTMineInfoBubbleView *foundView;  // 找到 TA
@property (nonatomic, strong) TTMineInfoBubbleView *someOneRoomView; // TA 的房间
@property (nonatomic, strong) NSString *filePath; // 语音y信息地址
@property (nonatomic, strong) UserHeadWear *headWear;

@property (nonatomic, strong) SVGAImageView *svgaImageView;
@property (nonatomic, strong) SVGAParser *svgaParser;

@end

@implementation TTMineInfoView


- (void)dealloc {
    RemoveCoreClient(FileCoreClient, self);
    RemoveCoreClient(MediaCoreClient, self);
//    RemoveCoreClient(UserCoreClient, self);
}

- (instancetype)initWithFrame:(CGRect)frame style:(TTMineInfoViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        _mineViewStyle = style;
        [self initViews];
        [self initConstraints];
        [self initBottomView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViews];
        [self initConstraints];
        [self initBottomView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    // 语音留言按钮 左侧半切圆角
//    [self drawViewLayer:self.voiceAccostBtn
//             rectCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft
//            cornerRadii:CGSizeMake(13, 13)];
}

#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    
//    AddCoreClient(UserCoreClient, self);
    AddCoreClient(MediaCoreClient, self);
    AddCoreClient(FileCoreClient, self);
    
    [self addSubview:self.bgImageView];
    [self addSubview:self.blurView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.headwearImageView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.IDLabel];
    [self addSubview:self.userTitleTagLabel];
//    [self addSubview:self.voiceAccostBtn];
    [self addSubview:self.stackView];
    [self addSubview:self.genderBtn];
    [self addSubview:self.svgaImageView];
    [self addSubview:self.anchorTagLabel];
    
}

- (void)initConstraints {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusbarHeight + kMineInfoHeadTopMargin);
        make.size.mas_equalTo(CGSizeMake(kIconImageViewW, kIconImageViewW));
        make.centerX.mas_equalTo(self);
    }];
    
    [self.headwearImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.iconImageView);
        make.size.mas_equalTo(self.iconImageView).multipliedBy(1.31);
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.equalTo(self.headwearImageView.mas_bottom).offset(5);
    }];
    
    [self.genderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickNameLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(self.nickNameLabel);
    }];
    
    
    [self.IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom).offset(6);
        make.height.mas_equalTo(14);
    }];
    
    [self.userTitleTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.IDLabel.mas_bottom).offset(13);
    }];
    
    [self.anchorTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.userTitleTagLabel.mas_bottom).offset(10);
    }];
    
//    [self.voiceAccostBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self);
//        make.centerY.equalTo(self.iconImageView);
//        make.height.mas_equalTo(26);
//        make.width.mas_equalTo(60);
//    }];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(KScreenWidth * 0.5);
    }];
}

- (void)initBottomView {
    
    [_stackView addArrangedSubview:self.followView];
    [_stackView addArrangedSubview:self.fansView];
    _fansView.lineHidden = YES;
    
    if (_mineViewStyle == TTMineInfoViewStyleOhter) {  // 如果不是看自己的个人主页 需要显示四个标签
        [_stackView addArrangedSubview:self.foundView];
        [_stackView addArrangedSubview:self.someOneRoomView];
        
        _fansView.lineHidden = NO;
        _someOneRoomView.lineHidden = YES;
        
        [_stackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self);
        }];
    }
}
#pragma mark -
#pragma mark button custom event
- (void)clickBtnPlayVoiceMessage:(UIButton *)button {
    // play voice message
    if (!_userInfo.userVoice.length) {
        
        if (self.mineViewStyle == TTMineInfoViewStyleOhter) {
            return;
        }
        
        TTEditRecordViewController *vc = [[TTEditRecordViewController alloc] init];
        vc.info = self.userInfo;
        [[[XCCurrentVCStackManager shareManager] currentNavigationController] pushViewController:vc animated:YES];
        return;
    }
    
    if (!self.filePath || ![self.filePath isEqualToString:GetCore(FileCore).filePath]) {
        [GetCore(FileCore) downloadVoice:self.userInfo.userVoice];
    } else {
        if ([GetCore(MediaCore) isPlaying]) {
            [GetCore(MediaCore) stopPlay];
        } else {
            [GetCore(MediaCore) play:self.filePath];
        }
    }
    button.selected = [GetCore(MediaCore) isPlaying];
}

//播放特效
- (void)startCarEffectWith:(NSString *)effect {
    @weakify(self);
    if (!effect) {
        return;
    }
    [self.svgaParser parseWithURL:[NSURL URLWithString:effect] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        @strongify(self);
        dispatch_main_sync_safe(^{
            self.svgaImageView.hidden = NO;
            self.svgaImageView.loops = 1;
            self.svgaImageView.clearsAfterStop = YES;
            self.svgaImageView.videoItem = videoItem;
            [self.svgaImageView startAnimation];
        });
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
    
}

- (void)didClickAvatarAction:(UITapGestureRecognizer *)tap {
    if (self.headerAvatarClickHandler) {
        self.headerAvatarClickHandler();
    }
}

#pragma mark - SVGAPlayerDelegate
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player{
    self.svgaImageView.hidden = YES;
}

/*
#pragma mark - MediaCoreClient
//play
- (void) onPlayAudioBegan:(NSString *)filePath{
    if (self.filePath != nil && [self.filePath isEqualToString:filePath]) {
//        [self.tableView reloadData];
        _voiceAccostBtn.selected = [GetCore(MediaCore) isPlaying];
    }
}

- (void)onPlayAudioComplete:(NSString *)filePath{
//    [self.tableView reloadData];
    _voiceAccostBtn.selected = [GetCore(MediaCore) isPlaying];
}

#pragma mark - FileCoreClient
//下载完成
- (void)onDownloadVoiceSuccess:(NSString *)filePath{
    self.filePath = filePath;
    if ([GetCore(MediaCore) isPlaying]) {
        [GetCore(MediaCore) stopPlay];
    }
    [GetCore(MediaCore) play:filePath];
}

- (void)onDownloadVoiceFailth:(NSError *)error{
    [XCHUDTool showErrorWithMessage:@"播放失败，请检查网络"];
}
*/
#pragma mark -
#pragma mark private methods
// 左边切圆角
- (void)drawViewLayer:(__kindof UIView *)view rectCorner:(UIRectCorner)rectCorner cornerRadii:(CGSize)cornerSize
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:cornerSize];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = view.bounds;
    //设置图形样子
    maskLayer.path = bezierPath.CGPath;
    view.layer.mask = maskLayer;
}

/// 主播标签富文本
/// @param tagList 标签列表
- (NSMutableAttributedString *)anchorTagAttributedStringTags:(NSArray *)tagList {
    
    if (tagList.count == 0) {
        return nil;
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    for (NSString *tag in tagList) {
        if (str.length > 0) {
            [str appendAttributedString:[BaseAttrbutedStringHandler placeholderAttributedString:4]];
        }
        NSAttributedString *tagStr = [self tagAttributedString:tag];
        [str appendAttributedString:tagStr];
    }
    
    return str;
}

/// 主播标签富文本
/// @param tag 技能标签
- (NSAttributedString *)tagAttributedString:(NSString *)tag {
    if (tag == nil) {
        return nil;
    }
    
    NSString *content = [NSString stringWithFormat:@"%@", tag];
    UIFont *font = [UIFont systemFontOfSize:10];
    CGFloat width = [NSString sizeWithText:content font:font maxSize:CGSizeMake(200, 30)].width;
    
    width += 10;//边距
    
    UILabel *label = [[UILabel alloc] init];
    label.bounds = CGRectMake(0, 0, width, 15);
    label.font = font;
    label.text = content;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor.whiteColor;
    label.layer.cornerRadius = 3;
    label.layer.masksToBounds = YES;
    label.backgroundColor = UIColorRGBAlpha(0xF2EEFF, 0.2);
    
    NSMutableAttributedString *dateLabelString = [NSMutableAttributedString yy_attachmentStringWithContent:label contentMode:UIViewContentModeScaleAspectFit attachmentSize:label.frame.size alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
    return dateLabelString;
}

#pragma mark -
#pragma mark getter & setter
- (void)setUserInfo:(UserInfo *)userInfo {
    _userInfo = userInfo;
    [self.iconImageView qn_setImageImageWithUrl:userInfo.avatar placeholderImage:[XCTheme defaultTheme].default_avatar type:ImageTypeUserIcon];
    
    //主页背景优先级：官方主播>贵族＞普通用户
    if (userInfo.attestationBackPic) {
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.attestationBackPic]];
        self.blurView.hidden = YES;
    } else if (userInfo.nobleUsers) { // 贵族
        if (userInfo.nobleUsers.zonebg) {
            NSString *url = [NSString stringWithFormat:@"%@", userInfo.nobleUsers.zonebg];
            [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:url]];
            self.blurView.hidden = YES;
        }
    } else { // 没有贵族
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar]];
    }
  
    if (userInfo.userHeadwear.status == Headwear_Status_ok) { // 如果有头饰，且使用
        NSURL *url = [NSURL URLWithString:userInfo.userHeadwear.effect];
        [self.manager loadSpriteSheetImageWithURL:url completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
            self.headwearImageView.image = sprit;
        } failureBlock:^(NSError * _Nullable error) {
            
        }];
    } else if (userInfo.nobleUsers.headwear) { // 如果有贵族头饰
        [TTNobleSourceHelper disposeImageView:self.headwearImageView withSource:userInfo.nobleUsers.headwear imageType:ImageTypeUserLibary];
    } else {
        self.headwearImageView.image = nil;
    }
    
    self.nickNameLabel.text = userInfo.nick;
    _followView.countNum = [NSString stringWithFormat:@"%ld", userInfo.followNum];
    _fansView.countNum = [NSString stringWithFormat:@"%ld", userInfo.fansNum];
    
   //管|靓号|兔兔玩友号
    self.IDLabel.attributedText = [BaseAttrbutedStringHandler createTitle_Offical_Beauty_ID_LoactionWith:userInfo];
    
//    [self.voiceAccostBtn setTitle:[NSString stringWithFormat:@"%ld '", (long)userInfo.voiceDura] forState:UIControlStateNormal];
    NSString *imageName;
    switch (userInfo.gender) {
        case UserInfo_Male:
            imageName = [XCTheme defaultTheme].common_sex_male;
            break;
        case UserInfo_Female:
            imageName = [XCTheme defaultTheme].common_sex_female;
            break;
        default:
            break;
    }
    
    [self.genderBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
    self.userTitleTagLabel.attributedText = [BaseAttrbutedStringHandler creatTitle_userRank_charmRank_constellationByUserInfo:userInfo];
    
    //主播标签
    self.anchorTagLabel.attributedText = [self anchorTagAttributedStringTags:userInfo.tagList];
}

- (UIVisualEffectView *)blurView {
    if (!_blurView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    }
    return _blurView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.clipsToBounds = YES;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[XCTheme defaultTheme].default_avatar]];
        _iconImageView.layer.cornerRadius = 67.f * 0.5;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.borderWidth = 4.f;
        _iconImageView.layer.borderColor = UIColorRGBAlpha(0xFFFFFF, 0.1).CGColor;
        _iconImageView.backgroundColor = UIColorFromRGB(0xEE6A59);
        [_iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickAvatarAction:)]];
        _iconImageView.userInteractionEnabled = YES;
    }
    return _iconImageView;
}

- (YYAnimatedImageView *)headwearImageView {
    if (!_headwearImageView) {
        _headwearImageView = [[YYAnimatedImageView alloc] init];
    }
    return _headwearImageView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.font = [UIFont systemFontOfSize:16.f];
        _nickNameLabel.adjustsFontSizeToFitWidth = YES;
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nickNameLabel;
}

- (UIButton *)genderBtn {
    if (!_genderBtn) {
        _genderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _genderBtn.enabled = NO;
    }
    return _genderBtn;
}


- (YYLabel *)userTitleTagLabel {
    if (!_userTitleTagLabel) {
        _userTitleTagLabel = [[YYLabel alloc] init];
        _userTitleTagLabel.displaysAsynchronously = YES;
        _userTitleTagLabel.fadeOnAsynchronouslyDisplay = NO;
        _userTitleTagLabel.fadeOnHighlight = NO;
    }
    return _userTitleTagLabel;
}

- (YYLabel *)IDLabel {
    if (!_IDLabel) {
        _IDLabel = [[YYLabel alloc] init];
    }
    return _IDLabel;
}

- (YYLabel *)anchorTagLabel {
    if (_anchorTagLabel == nil) {
        _anchorTagLabel = [[YYLabel alloc]init];
    }
    return _anchorTagLabel;
}

//- (UIButton *)voiceAccostBtn {
//    if (!_voiceAccostBtn) {
//        _voiceAccostBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_voiceAccostBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
//        [_voiceAccostBtn setBackgroundColor:UIColorRGBAlpha(0xFFB606, 0.5)];
//        [_voiceAccostBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//        [_voiceAccostBtn setImage:[UIImage imageNamed:@"meInfo_voice_play"] forState:UIControlStateNormal];
//        [_voiceAccostBtn setImage:[UIImage imageNamed:@"meInfo_voice_pause"] forState:UIControlStateSelected];
//        _voiceAccostBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
//        [_voiceAccostBtn addTarget:self action:@selector(clickBtnPlayVoiceMessage:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _voiceAccostBtn;
//}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.spacing = 10.f;
    }
    return _stackView;
}

- (TTMineInfoBubbleView *)followView {
    if (!_followView) {
        _followView = [[TTMineInfoBubbleView alloc] initWithText:@"关注"];
        @weakify(self);
        _followView.bubbleClickHandler = ^{
            // 关注列表
            @strongify(self);
            !self.bubbleClickHandler ? : self.bubbleClickHandler(TTBubbleViewTypeFollow);
        };
    }
    return _followView;
}

- (TTMineInfoBubbleView *)fansView {
    if (!_fansView) {
        _fansView = [[TTMineInfoBubbleView alloc] initWithText:@"粉丝"];
        @weakify(self);
        _fansView.bubbleClickHandler = ^{
            // 粉丝列表
            @strongify(self);
            !self.bubbleClickHandler ? : self.bubbleClickHandler(TTBubbleViewTypeFans);
        };
    }
    return _fansView;
}

- (TTMineInfoBubbleView *)foundView {
    if (!_foundView) {
        _foundView = [[TTMineInfoBubbleView alloc] initWithText:@"找到TA"];
        _foundView.iconName = @"meInfo_found_icon";
        @weakify(self);
        _foundView.bubbleClickHandler = ^{
            // 找到他
            @strongify(self);
            !self.bubbleClickHandler ? : self.bubbleClickHandler(TTBubbleViewTypeFindTA);
        };
    }
    return _foundView;
}

- (TTMineInfoBubbleView *)someOneRoomView {
    if (!_someOneRoomView) {
        _someOneRoomView = [[TTMineInfoBubbleView alloc] initWithText:@"TA的房间"];
        _someOneRoomView.iconName = @"meInfo_room_icon";
        @weakify(self);
        _someOneRoomView.bubbleClickHandler = ^{
            // 跳转他人房间
            @strongify(self);
            !self.bubbleClickHandler ? : self.bubbleClickHandler(TTBubbleViewTypeRoom);
        };
    }
    return _someOneRoomView;
}

- (SpriteSheetImageManager *)manager {
    if (!_manager) {
        _manager = [[SpriteSheetImageManager alloc] init];
    }
    return _manager;
}

- (SVGAImageView *)svgaImageView {
    if (!_svgaImageView) {
        _svgaImageView = [[SVGAImageView alloc]init];
        _svgaImageView.backgroundColor = [UIColor clearColor];
        _svgaImageView.contentMode = UIViewContentModeCenter;
        _svgaImageView.frame = CGRectMake(0, 120, KScreenWidth, 346);
        _svgaImageView.hidden = YES;
        _svgaImageView.delegate = self;
        _svgaImageView.userInteractionEnabled = NO;
    }
    return _svgaImageView;
}
- (SVGAParser *)svgaParser {
    if (!_svgaParser) {
        _svgaParser = [[SVGAParser alloc]init];
    }
    return _svgaParser;
}

@end

