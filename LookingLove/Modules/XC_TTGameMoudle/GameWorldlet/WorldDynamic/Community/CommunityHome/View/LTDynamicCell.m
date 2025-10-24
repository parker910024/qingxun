//
//  LTDynamicCell.m
//  UKiss
//
//  Created by apple on 2018/12/13.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import "LTDynamicCell.h"
#import "LTDynamicToolView.h"
#import "LTDynamicPictureView.h"
#import "CTDynamicModel.h"
#import "VKDynamicVoiceView.h"
#import "M80AttributedLabel+NIMKit.h"
#import <SDWebImage/UIImageView+WebCache.h>


//#import "KETranslateTool.h"
//#import "NSString+Language.h"
#import "UIImageView+QiNiu.h"
#import "LTDynamicCommentsView.h"
#import "M80AttributedLabel+NIMKit.h"

#import "KEMenuItemTool.h"
#import "KEReportController.h"
#import "XCCurrentVCStackManager.h"
#import "XCTheme.h"
#import "XCMacros.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import "AuthCore.h"
#import <YYImage/YYAnimatedImageView.h>
#import <YYText/YYText.h>
#import "BaseAttrbutedStringHandler+TTDynamicInfo.h"
#import "PLTimeUtil.h"
#import "UIButton+EnlargeTouchArea.h"
#import "SpriteSheetImageManager.h"
#import "TTNobleSourceHelper.h"
#import "NSString+Utils.h"
#import "AnchorOrderCoundownView.h"
#import "TTStatisticsService.h"

#define contenBgWidth (KScreenWidth - 60)

#define anHour  3600
#define aMinute 60
#define aDay anHour*24
#define aMonth aDay*30
#define aYear aMonth*12

@interface LTDynamicCell ()<
LTDynamicToolViewDelegate ,
VKDynamicVoiceViewDelegate ,
LTDynamicCommentsViewDelegate
>

///内容的背景view
@property (nonatomic, strong) UIView *contentViewBg;
//图片内容
@property (nonatomic, strong) LTDynamicPictureView *pictureBgView;
//文本内容
@property (nonatomic, strong) M80AttributedLabel *contentLab;
///长按收拾添加view
@property (nonatomic, strong) UIView *contentLabRecognizer;
//视频背景
@property (nonatomic, strong) UIImageView *videoBgImgView;
@property (nonatomic, strong) UIImageView *videoPlayImgView;
//展开/收起 button
@property (nonatomic, strong) UIButton *openUpBtn;
///底部点赞、评论view
@property (nonatomic, strong) LTDynamicToolView *toolView;
///评论view
@property (nonatomic, strong) LTDynamicCommentsView *commentsView;
///文本内容高度
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, weak) UIView *topVoiceView;
@property (nonatomic, weak) UIView *topPictureBgView;
@property (nonatomic, weak) UIView *topToolView;
@property (nonatomic, weak) UIView *topVideoView;

//头像
@property (nonatomic, strong) UIImageView *headImg;
// 头饰
@property (nonatomic, strong) YYAnimatedImageView *headwearImageView;//
@property (nonatomic, strong) SpriteSheetImageManager *manager;
//名称
@property (nonatomic, strong) YYLabel *nameLab;
// 内容
@property (nonatomic, strong) YYLabel *messageLabel;
//more
@property (nonatomic, strong) UIButton *chatButton;
///发布时间 （只用在详情）
@property (nonatomic, strong) YYLabel *putTimeLab;
@property (nonatomic, strong) UIView *lineView; //

// 主播标签
@property (nonatomic,strong) YYLabel *anchorTagLabel;

// 主播订单倒计时
@property (nonatomic, strong) AnchorOrderCoundownView *orderCountdownView;

@property (nonatomic, strong) UIStackView *stackView;
@end


@implementation LTDynamicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initLayout];
    }
    return self;
}

- (void)initView {
    self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.contentView addSubview:self.stackView];
    [self.contentView addSubview:self.headImg];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.putTimeLab];
    [self.contentView addSubview:self.chatButton];
    [self.contentView addSubview:self.headwearImageView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.anchorTagLabel];
    
    [self.stackView addArrangedSubview:self.messageLabel];
    [self.stackView addArrangedSubview:self.openUpBtn];
    [self.stackView addArrangedSubview:self.pictureBgView];
    [self.stackView addArrangedSubview:self.orderCountdownView];
    [self.stackView addArrangedSubview:self.toolView];
}

- (void)initLayout {
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@20);
        make.width.height.equalTo(@45);
    }];
    self.headImg.layer.cornerRadius = 45.f/2;
    self.headImg.layer.masksToBounds = YES;
    
    [self.headwearImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.height.width.mas_equalTo(self.headImg).multipliedBy(1.31);
       make.center.mas_equalTo(self.headImg);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImg.mas_right).offset(12);
        make.top.mas_equalTo(self.headImg);
        //KScreenWidth - 50 - 20 - 44- 20 - 10 - 10
        make.width.mas_lessThanOrEqualTo(KScreenWidth-190);
        make.height.mas_equalTo(22);
    }];

    [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(57);
        make.height.mas_equalTo(27);
        make.centerY.mas_equalTo(self.nameLab);
    }];
    
    [self.putTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(2);
    }];
    
    [self.anchorTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab);
        make.top.mas_equalTo(self.putTimeLab.mas_bottom).offset(6);
        make.height.mas_equalTo(15);
    }];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImg.mas_bottom).offset(15);
        make.bottom.mas_equalTo(self.lineView.mas_top).offset(-10);
        make.leading.trailing.mas_equalTo(self.contentView).inset(20);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-20);
    }];
}

#pragma mark -LTDynamicToolViewDelegate
// 评论
- (void)communityToolClickCommentButtonCallBack {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCommentButtonWithMyVestDynamicCell:)]) {
        [self.delegate didClickCommentButtonWithMyVestDynamicCell:self];
    }
}

// 点赞
- (void)communityToolClickLaudButtonCallBackWith:(BOOL)isLaud {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myVestDynamicCell:clickLaudButtonCallBackWith:)]) {
        [self.delegate myVestDynamicCell:self clickLaudButtonCallBackWith:isLaud];
    }
}

// 更多
- (void)communityToolClickMoreButtonCallBack {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMoreButtonDynamicCell:)]) {
        [self.delegate didClickMoreButtonDynamicCell:self];
    }
}

// 分享
- (void)communityToolClickShareButtonCallBack {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickShareButtonWithMyVestDynamicCell:)]) {
        [self.delegate didClickShareButtonWithMyVestDynamicCell:self];
    }
}

#pragma mark -VKDynamicVoiceViewDelegate

///点击声音气泡
- (void)tapVoiceImageActionWithIsPlaying:(BOOL)isPlaying {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myVestDynamicCell:tapVoiceImageActionWithIsPlaying:)]) {
        [self.delegate myVestDynamicCell:self tapVoiceImageActionWithIsPlaying:isPlaying];
    }
}

#pragma mark - LTDynamicCommentsViewDelegate
///跳转到动态详情
- (void)jumpDynamicDetailsWithReplyComment:(CTCommentReplyModel*)comment commentsView:(LTDynamicCommentsView *)commentsView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpDynamicDetailsWithReplyComment:communityCell:)]) {
        [self.delegate jumpDynamicDetailsWithReplyComment:comment communityCell:self];
    }
}

///点击名称跳转到个人详情
- (void)jumpUserDetailsWithComment:(CTCommentReplyModel*)comment commentsView:(LTDynamicCommentsView *)commentsView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickUserActionWithUserUid:communityCell:)]) {
        [self.delegate didClickUserActionWithUserUid:comment.uid communityCell:self];
    }
}

#pragma mark - event response

- (void)didClickOpenUpButton:(UIButton *)button {
    button.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.userInteractionEnabled = YES;
    });
    button.selected = !button.selected;
    self.dynamicModel.isOpenUp = button.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshMyVestDynamicCell:)]) {
        [self.delegate refreshMyVestDynamicCell:self];
    }
    
    !_refreshOpenUpHandler ? : _refreshOpenUpHandler(self.dynamicModel);
}

- (void)didClickOpenUpTranslateButton:(UIButton *)button {
}
//翻译
- (void)didClickTranslationButton:(UIButton *)button{
}

- (void)didClickChatButton:(UIButton *)btn {
    [TTStatisticsService trackEvent:@"world_moment_chat" eventDescribe:@"私聊按钮"];

    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAnchorOrderDynamicCell:)]) {
        [self.delegate didClickAnchorOrderDynamicCell:self];
    }
}

/// 点击头像跳转个人页
- (void)showUserAnonymityData:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickUserActionWithUserUid:communityCell:)]) {
        [self.delegate didClickUserActionWithUserUid:self.dynamicModel.uid communityCell:self];
    }
}

- (void)onTapVideo{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickVideoCell:)]) {
        [self.delegate didClickVideoCell:self];
    }
}

- (void)updateLikeButtonStatus {
    // 点赞动画
    [self.toolView likeButtonAnimation];
}

#pragma mark - private method
///得到动态文本的行数
- (NSInteger)getDynamicContentRows {
    CGFloat contentMaxHeight = [self.dynamicModel getContentTextNoEmptyText:self.dynamicModel.content];
    contentMaxHeight = MAX(contentMaxHeight, [self.contentLab sizeThatFits:CGSizeMake(KScreenWidth - 46, CGFLOAT_MAX)].height);
    NSInteger contentRow = contentMaxHeight / self.contentLab.font.lineHeight;
    CGFloat height = (contentRow > 6 && !self.dynamicModel.isOpenUp) ? self.contentLab.font.lineHeight * 6 + 20 :[self.contentLab sizeThatFits:CGSizeMake(KScreenWidth - 40, CGFLOAT_MAX)].height;
    self.contentHeight = height;
    return contentRow;
}

- (void)setTopViewWithPreviousView:(UIView *)previousView newTopView:(UIView *)newTopView {
    if (!previousView) {//没有值才设置
        previousView = newTopView;
    }
}

- (NSString *)stringWithTimeStamp:(NSString *)timeStamp {
    
    // 转为秒为单位
    NSTimeInterval second = timeStamp.longLongValue / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];

    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    // 时间 10点10分
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    // 日期 2月18号
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"MM月dd日"];
    // 日期 年月日
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [yearFormatter setDateFormat:@"YYYY年MM月dd日"];
    
    //得到与当前时间差
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    
    long temp = 0;
    NSString *result;
    
    BOOL isSameDay = [[NSCalendar currentCalendar] isDateInToday:date]; // 是否是同一天
    
    // A. 当天，且 timeInterval < 1分钟，显示“刚刚”；
    if (timeInterval < aMinute) {
        return [NSString stringWithFormat:@"刚刚"];
        
        // B. 当天，且1分钟≤ timeInterval <60分钟，显示“n分钟前”；
    } else if((temp = timeInterval/aMinute) < 60){
        return [NSString stringWithFormat:@"%ld分钟前",temp];
        
        // C. 当天，且n≥60分钟，显示“xx:xx”；
    } else if((temp = temp/60) < 24 && isSameDay){
        return [timeFormatter stringFromDate:date];
        
        // C. 非当天，且n≥60分钟，显示“xx:xx”；
    } else if((temp = temp/60) < 24 && !isSameDay){
        return [dayFormatter stringFromDate:date];
        
        // D. 跨天，且未跨年，显示“mm-dd”；
    } else if((temp = temp/30) < 30){
        return [dayFormatter stringFromDate:date];
        
    } else {
        // E. 跨年，显示“yyyy-mm-dd”；
        return [yearFormatter stringFromDate:date];
    }

    return result;
}

/// 时间富文本
/// @param time 时间
/// @param showTime 是否显示时间
/// @param cert 官方主播认证
- (NSMutableAttributedString *)timeAttributedStringWithTime:(NSString *)time showTime:(BOOL)showTime cert:(UserOfficialAnchorCertification *)cert {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    if (cert && cert.fixedWord.length > 0) {
        NSMutableAttributedString *certTag = [BaseAttrbutedStringHandler certificationTagWithName:cert.fixedWord image:cert.iconPic];
        [str appendAttributedString:certTag];
        [str appendAttributedString:[BaseAttrbutedStringHandler creatPlaceholderAttributedStringByWidth:5]];
    }
    
    if (showTime) {
        NSMutableAttributedString *timeStr = [[NSMutableAttributedString alloc] initWithString:time];
        timeStr.yy_font = [UIFont systemFontOfSize:12];
        timeStr.yy_color = UIColorRGBAlpha(0x222222, 0.3);
        [str appendAttributedString:timeStr];
    }
    
    return str;
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
    label.textColor = [XCTheme getMainDefaultColor];
    label.layer.cornerRadius = 7.5;
    label.layer.masksToBounds = YES;
    label.backgroundColor = UIColorFromRGB(0xEFFFFE);
    
    NSMutableAttributedString *dateLabelString = [NSMutableAttributedString yy_attachmentStringWithContent:label contentMode:UIViewContentModeScaleAspectFit attachmentSize:label.frame.size alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
    return dateLabelString;
}

#pragma mark - getters and setters

- (void)setDynamicModel:(CTDynamicModel *)dynamicModel {
    _dynamicModel = dynamicModel;

    NSString *time = [self stringWithTimeStamp:dynamicModel.publishTime];
    self.putTimeLab.attributedText = [self timeAttributedStringWithTime:time showTime:YES cert:dynamicModel.nameplate];
    self.messageLabel.numberOfLines = dynamicModel.isOpenUp ? 0 : 6;
    self.messageLabel.attributedText = [BaseAttrbutedStringHandler creatFirstDynamicIcon_content:dynamicModel];
    
    self.openUpBtn.selected = self.dynamicModel.isOpenUp;
    // 头饰
    [self.headImg qn_setImageImageWithUrl:self.dynamicModel.avatar placeholderImage:default_bg type:ImageTypeUserIcon];//default_bg
    if (dynamicModel.headwearPic) { // 如果有头饰，且使用
        NSURL *url = [NSURL URLWithString:dynamicModel.headwearPic];
        [self.manager loadSpriteSheetImageWithURL:url completionBlock:^(YYSpriteSheetImage * _Nullable sprit) {
            self.headwearImageView.image = sprit;
        } failureBlock:^(NSError * _Nullable error) {

        }];
    } else if (dynamicModel.micDecorate) { // 如果有贵族头饰
        [TTNobleSourceHelper disposeImageView:self.headwearImageView withSource:dynamicModel.micDecorate imageType:ImageTypeUserLibary];
    } else {
        self.headwearImageView.image = nil;
    }

    self.nameLab.attributedText = [BaseAttrbutedStringHandler creatNick_userAge_charmRank_constellationByDynamicModel:dynamicModel];
    
    NSInteger contentRow = [self getDynamicContentRows];
    
    self.toolView.dynamicModel = dynamicModel;
    self.pictureBgView.imageUrls = dynamicModel.dynamicResList;
    
    self.openUpBtn.hidden = contentRow < 6;
    self.messageLabel.hidden = !dynamicModel.content;
    self.pictureBgView.hidden = !dynamicModel.dynamicResList.count;
    self.toolView.hidden = dynamicModel.isCommunityDetails;
    
    BOOL selfDynamic = [GetCore(AuthCore).getUid isEqualToString:dynamicModel.uid];
    self.chatButton.hidden = dynamicModel.workOrder == nil || selfDynamic;
    
    //主播标签
    BOOL haveTag = dynamicModel.tagList.count > 0;
    self.anchorTagLabel.attributedText = [self anchorTagAttributedStringTags:dynamicModel.tagList];
    
    // 主播订单倒计时
    self.orderCountdownView.hidden = !dynamicModel.workOrder;
    self.orderCountdownView.order = dynamicModel.workOrder;
    
    [self.stackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImg.mas_bottom).offset(haveTag ? 35 : 15);
    }];
}

- (void)setTopToolView:(UIView *)topToolView {
    if (_topToolView == nil) {
        _topToolView = topToolView;
    }
}

- (void)setTopPictureBgView:(UIView *)topPictureBgView {
    if (_topPictureBgView == nil) {
        _topPictureBgView = topPictureBgView;
    }
}

- (void)setTopVoiceView:(UIView *)topVoiceView {
    if (_topVoiceView == nil) {
        _topVoiceView = topVoiceView;
    }
}

- (void)setIsDetailVc:(BOOL)isDetailVc {
    _isDetailVc = isDetailVc;
    self.toolView.hidden = isDetailVc;
}

- (YYLabel *)putTimeLab {
    if (!_putTimeLab) {
        _putTimeLab = [[YYLabel alloc] init];
        _putTimeLab.textColor = UIColorRGBAlpha(0x222222, 0.3);
        _putTimeLab.font = [UIFont systemFontOfSize:12];
    }
    return _putTimeLab;
}

- (UIView *)contentViewBg {
    if (!_contentViewBg) {
        _contentViewBg = [[UIView alloc]init];
        _contentViewBg.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _contentViewBg;
}

- (M80AttributedLabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[M80AttributedLabel alloc]init];
        _contentLab.textColor = UIColorRGBAlpha(0x333333, 1);
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.numberOfLines = 6;
        _contentLab.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLab.autoDetectLinks = NO;
        _contentLab.backgroundColor = [UIColor clearColor];
    }
    return _contentLab;
}

- (YYLabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[YYLabel alloc] init];
        _messageLabel.textColor = UIColorRGBAlpha(0x333333, 1);
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.numberOfLines = 6;
        _messageLabel.preferredMaxLayoutWidth = KScreenWidth - 40;
        _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _messageLabel;
}

- (UIView *)contentLabRecognizer {
    if (!_contentLabRecognizer) {
        _contentLabRecognizer = [[UIView alloc]init];
        _contentLabRecognizer.backgroundColor = [UIColor clearColor];
        _contentLabRecognizer.userInteractionEnabled = YES;
    }
    return _contentLabRecognizer;
}

- (LTDynamicPictureView *)pictureBgView {
    if (!_pictureBgView) {
        _pictureBgView = [[LTDynamicPictureView alloc] initWithStyle:LLDynamicPicViewStyleLittleWorld];
        _pictureBgView.backgroundColor = [UIColor clearColor];
        
        @weakify(self)
        _pictureBgView.didTapEmptyAreaHandler = ^{
            @strongify(self)
            !self.albumEmptyAreaHandler ?: self.albumEmptyAreaHandler();
        };
    }
    return _pictureBgView;
}

- (UIButton *)openUpBtn {
    if (!_openUpBtn) {
        _openUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openUpBtn setTitle:@"展开" forState:UIControlStateNormal];
        [_openUpBtn setTitle:@"收起" forState:UIControlStateSelected];
        [_openUpBtn setTitleColor:UIColorFromRGB(0x34A7FF) forState:UIControlStateNormal];
        _openUpBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_openUpBtn addTarget:self action:@selector(didClickOpenUpButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openUpBtn;
}

- (LTDynamicToolView *)toolView {
    if (!_toolView) {
        _toolView = [[LTDynamicToolView alloc]init];
//        _toolView.bounds = CGRectMake(0, 0, KScreenWidth, 44);
        _toolView.delegate = self;
    }
    return _toolView;
}

- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [[UIImageView alloc]init];
        _headImg.userInteractionEnabled = YES;
        _headImg.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserAnonymityData:)];
        [_headImg addGestureRecognizer:tap];
    }
    return _headImg;
}

- (YYLabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[YYLabel alloc]init];
        _nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserAnonymityData:)];
        [_nameLab addGestureRecognizer:tap];
    }
    return _nameLab;
}

- (UIImageView *)videoBgImgView{
    if (!_videoBgImgView) {
        _videoBgImgView = [[UIImageView alloc] init];
        _videoBgImgView.hidden = YES;
        _videoBgImgView.layer.cornerRadius = 5;
        _videoBgImgView.layer.masksToBounds = YES;
        _videoBgImgView.userInteractionEnabled = YES;
        _videoBgImgView.contentMode = UIViewContentModeScaleAspectFill;

          UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapVideo)];
        [_videoBgImgView addGestureRecognizer:tap];
    }
    return _videoBgImgView;
}

- (UIImageView *)videoPlayImgView{
    if (!_videoPlayImgView) {
        _videoPlayImgView = [[UIImageView alloc] init];
        _videoPlayImgView.image = [UIImage imageNamed:@"temp_qu_play"];
        _videoPlayImgView.hidden = YES;
        _videoPlayImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapVideo)];
        [_videoPlayImgView addGestureRecognizer:tap];
    }
    return _videoPlayImgView;
}

- (UIButton *)chatButton {
    if (!_chatButton) {
        
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setTitle:@"私聊" forState:UIControlStateNormal];
        [_chatButton setTitleColor:[XCTheme getMainDefaultColor] forState:UIControlStateNormal];
        [_chatButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_chatButton addTarget:self action:@selector(didClickChatButton:) forControlEvents:UIControlEventTouchUpInside];
        _chatButton.layer.cornerRadius = 13.5;
        _chatButton.layer.masksToBounds = YES;
        _chatButton.layer.borderColor = [XCTheme getMainDefaultColor].CGColor;
        _chatButton.layer.borderWidth = 1.f;
        
        [_chatButton setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
        
        _chatButton.hidden = YES;
    }
    return _chatButton;
}

- (LTDynamicCommentsView *)commentsView {
    if (!_commentsView) {
        _commentsView = [[LTDynamicCommentsView alloc]init];
        _commentsView.delegate = self;
    }
    return _commentsView;
}

- (YYAnimatedImageView *)headwearImageView {
    if (!_headwearImageView) {
        _headwearImageView = [[YYAnimatedImageView alloc] init];
    }
    return _headwearImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xF4F4F4);
    }
    return _lineView;
}

- (SpriteSheetImageManager *)manager {
    if (!_manager) {
        _manager = [[SpriteSheetImageManager alloc] init];
    }
    return _manager;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.distribution = UIStackViewDistributionFillProportionally;
        _stackView.alignment = UIStackViewAlignmentLeading;
        _stackView.spacing = 8;
    }
    return _stackView;
}

- (YYLabel *)anchorTagLabel {
    if (_anchorTagLabel == nil) {
        _anchorTagLabel = [[YYLabel alloc]init];
    }
    return _anchorTagLabel;
}

- (AnchorOrderCoundownView *)orderCountdownView {
    if (_orderCountdownView == nil) {
        _orderCountdownView = [[AnchorOrderCoundownView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 16)];
        
        @weakify(self)
        [_orderCountdownView tapOrderHandler:^{
            @strongify(self)
            [TTStatisticsService trackEvent:@"world_moment_chat" eventDescribe:@"接单信息"];

            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAnchorOrderDynamicCell:)]) {
                [self.delegate didClickAnchorOrderDynamicCell:self];
            }
        }];
        [_orderCountdownView tapMarkHandler:^{
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAnchorOrderMarkDynamicCell:)]) {
                [self.delegate didClickAnchorOrderMarkDynamicCell:self];
            }
        }];
    }
    return _orderCountdownView;
}

@end
