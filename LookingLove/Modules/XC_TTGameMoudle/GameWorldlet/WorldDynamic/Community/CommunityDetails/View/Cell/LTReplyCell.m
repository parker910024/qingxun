//
//  LTReplyCell.m
//  LTChat
//
//  Created by apple on 2019/10/28.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "LTReplyCell.h"
#import <YYLabel.h>
#import "M80AttributedLabel+NIMKit.h"
#import <Masonry.h>
#import "KEMenuItemTool.h"
#import "XCCurrentVCStackManager.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+NTES.h"
#import "UIView+XCToast.h"
#import "AuthCore.h"
#import "UIImageView+QiNiu.h"
#import "UIView+NTES.h"
#import "TTStatisticsService.h"

@interface LTReplyCell ()

///内容背景
@property (nonatomic, strong) UIView *bgContentView;
///名称
@property (nonatomic, strong) YYLabel *nameLab;
///内容
@property (nonatomic, strong) M80AttributedLabel *contentLab;
///楼主、Match
@property (nonatomic, strong) UIButton *flagTipBtn;
///举报、删除
@property (nonatomic, strong) UIButton *moreBtn;
///发布时间 （只用在详情）
@property (nonatomic, strong) UILabel *putTimeLab;

///头像
@property (nonatomic, strong) UIImageView *headImg;
///名称
@property (nonatomic, strong) UILabel *nick;

@property (nonatomic, strong) UIView *lineView;
@end

@implementation LTReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showMoreDeleteView {
    [self didClickMoreButton:self.moreBtn];
}

#pragma mark - event action
- (void)didClickMoreButton:(UIButton *)button {
    NSString *titleStr = @"userSetting_report_title";
    if ([self.replyModel.uid isEqualToString:GetCore(AuthCore).getUid]) {
        titleStr = @"public_delete";
    }
    @weakify(self);
    KEMenuItemTool * vv = [[KEMenuItemTool alloc] init];
    [vv showRightMoreButton:button title:titleStr complete:^{
        @strongify(self);
        if ([titleStr isEqualToString:@"public_delete"]) {//删除
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteReplyWithReplyCell:)]) {
                [self.delegate deleteReplyWithReplyCell:self];
            }
        }else {//举报
        }
    }];
}



- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    if ([longPress isKindOfClass:[UILongPressGestureRecognizer class]] &&
        longPress.state == UIGestureRecognizerStateBegan) {
        
        [self becomeFirstResponder];
        
        if (!self.replyModel.content) {
            return;
        }
        
        @weakify(self);
        KEMenuItemTool * vv = [[KEMenuItemTool alloc] init];
        
        NSDictionary *copy = @{kItemTextKey : @"复制", kItemIconKey : @"dynamic_menu_item_icon_copy", kItemTypeKey : @(KEMenuItemToolTypeCopy)};
        NSDictionary *delete = @{kItemTextKey : @"删除", kItemIconKey : @"dynamic_menu_item_icon_delete", kItemTypeKey : @(KEMenuItemToolTypeDelete)};
        NSDictionary *report = @{kItemTextKey : @"举报", kItemIconKey : @"dynamic_menu_item_icon_report", kItemTypeKey : @(KEMenuItemToolTypeReport)};

        NSMutableArray *itemNames = [NSMutableArray arrayWithArray:@[copy]];
        
        // 如果当前用户是小世界的归属人，或者是本人所写。可以删除
        NSString *currentUid = GetCore(AuthCore).getUid;
        
        if ([self.replyModel.uid isEqualToString:currentUid] ||
            [self.littleWorldOwerUid isEqualToString:currentUid]) {
            [itemNames addObject:delete];
        }
        
        // 如果不是自己评论的则可举报
        if (![self.replyModel.uid isEqualToString:currentUid]) {
            [itemNames addObject:report];
        }
        
        [vv showMoreTypeView:self.contentLab actionNames:itemNames.copy complete:^(KEMenuItemToolType type) {
            @strongify(self);
            switch (type) {
                case KEMenuItemToolTypeCopy:
                {
                    [TTStatisticsService trackEvent:@"world_copy_comment" eventDescribe:@"复制评论"];
                    // 复制
                    if (self.replyModel.content) {
                        [UIPasteboard generalPasteboard].string = self.replyModel.content;
                        [UIView showSuccess:@"已复制"];
                    }else{
                        [UIView showSuccess:@"复制失败"];
                    }
                }
                    break;
                    case KEMenuItemToolTypeReport:
                {
                    // 举报
                    if (self.delegate && [self.delegate respondsToSelector:@selector(reportReplyWithReplyCell:)]) {
                        [self.delegate reportReplyWithReplyCell:self];
                    }
                    [TTStatisticsService trackEvent:@"world_report_comment" eventDescribe:@"举报评论"];
                }
                    break;
                case KEMenuItemToolTypeDelete:
                {
                    [TTStatisticsService trackEvent:@"world_delete_comment" eventDescribe:@"删除评论"];
                    // 删除
                    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteReplyWithReplyCell:)]) {
                        [self.delegate deleteReplyWithReplyCell:self];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }];
    }
}

#pragma mark - 私有方法

- (void)initView {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.bgContentView];
    [self.bgContentView addSubview:self.nameLab];
    [self.bgContentView addSubview:self.flagTipBtn];
    [self.bgContentView addSubview:self.contentLab];
    [self.bgContentView addSubview:self.putTimeLab];
//    [self.bgContentView addSubview:self.moreBtn];
    [self.bgContentView addSubview:self.nick];
    [self.bgContentView addSubview:self.headImg];
    [self.bgContentView addSubview:self.putTimeLab];
    [self.bgContentView addSubview:self.lineView];
}

- (void)initConstrations {

    [self.bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@55);
        make.right.equalTo(self.contentView.mas_right).mas_offset(-20);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(4);
        make.height.width.mas_equalTo(30);
    }];
    
    [self.putTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nick);
        make.top.mas_equalTo(self.nick.mas_bottom).offset(7);
        make.height.mas_equalTo(12);
    }];
    
    [self.nick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImg.mas_right).offset(10);
        make.top.mas_equalTo(self.headImg);
        make.height.mas_equalTo(15);
    }];

    [self.flagTipBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nick.mas_right).offset(5);
        make.centerY.mas_equalTo(self.nick);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(32);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nick);
        make.bottom.mas_equalTo(self.bgContentView);
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(self.bgContentView);
    }];
}

- (void)settingFrame {
    CGFloat msgBubbleMaxWidth    = (KScreenWidth - 105);
    CGSize  contentSize = [self.contentLab sizeThatFits:CGSizeMake(msgBubbleMaxWidth, CGFLOAT_MAX)];
    [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImg.mas_bottom).offset(15);
        make.height.mas_equalTo(contentSize.height);
        make.left.mas_equalTo(self.nick);
        make.right.mas_equalTo(self.bgContentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.bgContentView).offset(-15);
    }];
}

- (void)settingData {
    
    [self.headImg qn_setImageImageWithUrl:self.replyModel.avatar placeholderImage:@"placeholder_image_square" type:ImageTypeUserIcon];
    self.nick.text = self.replyModel.nick;
    
    NSString *nick = self.replyModel.nick;
    if (self.nick.text.length > 7) {
        self.nick.text = [NSString stringWithFormat:@"%@...", [nick substringToIndex:7]];
    }
    
    NSString * content = [NSString stringWithFormat:@"@%@ %@",self.replyModel.toNick, self.replyModel.content];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName: UIColorRGBAlpha(0x333333, 1)}];
    [att addAttributes:@{
        NSForegroundColorAttributeName:UIColorRGBAlpha(0x34A7FF, 1),
        NSFontAttributeName : [UIFont systemFontOfSize:15]
    } range:[content rangeOfString:[NSString stringWithFormat:@"@%@", self.replyModel.toNick]]];
    self.nameLab.attributedText = att;
    
    @weakify(self);
    [self.nameLab setTextTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self);
        if (NSLocationInRange(range.location, [content rangeOfString:self.replyModel.nick])) {//
            if (self.delegate && [self.delegate respondsToSelector:@selector(jumpReplyUserDetailsWithCell:userUid:)]) {
                [self.delegate jumpReplyUserDetailsWithCell:self userUid:self.replyModel.uid];
            }
        }
    }];
    
    [self.contentLab nim_setText:self.replyModel.content replyNickName:[NSString stringWithFormat:@"@%@ ", self.replyModel.toNick]];
    self.flagTipBtn.hidden = !self.replyModel.landLordFlag;
    self.putTimeLab.text = [self stringWithTimeStamp:self.replyModel.publishTime];
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
    //标准时间和北京时间差8个小时
    // timeInterval = timeInterval - 86060;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [timeFormatter stringFromDate:date];
    }

    else if((temp = temp/24) <30){
        result = [dayFormatter stringFromDate:date];
    } else {
        temp = temp/12;
        result = [yearFormatter stringFromDate:date];
    }

    return result;
}

- (void)tapUserNameAction:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpReplyUserDetailsWithCell:userUid:)]) {
        [self.delegate jumpReplyUserDetailsWithCell:self userUid:self.replyModel.uid];
    }
}

#pragma mark - set/get

- (void)setReplyModel:(CTReplyModel *)replyModel {
    _replyModel = replyModel;
    [self settingData];
    [self settingFrame];
    [self layoutIfNeeded];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    dispatch_async(dispatch_get_main_queue(), ^{//刷新tabbleView之后才能获取高度
        if (indexPath.row == 0) {
            CGSize radio = CGSizeMake(5, 5);//圆角尺寸
            UIRectCorner corner = UIRectCornerTopLeft|UIRectCornerTopRight;//这只圆角位置
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bgContentView.bounds byRoundingCorners:corner cornerRadii:radio];
            CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];//创建shapelayer
            masklayer.frame = self.bgContentView.bounds;
            masklayer.path = path.CGPath;//设置路径
            self.bgContentView.layer.mask = masklayer;
        }else {
            self.bgContentView.layer.mask = nil;
        }
    });
}

- (UIView *)bgContentView {
    if (!_bgContentView) {
        _bgContentView = [[UIView alloc]init];
        _bgContentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    }
    return _bgContentView;
}

- (YYLabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[YYLabel alloc]init];
        _nameLab.textColor = UIColorFromRGB(0x222222);
        _nameLab.font = [UIFont boldSystemFontOfSize:13];
        _nameLab.userInteractionEnabled = YES;
        _nameLab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLab;
}

- (UIButton *)flagTipBtn {
    if (!_flagTipBtn) {
        _flagTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flagTipBtn setImage:[UIImage imageNamed:@"dynamic_landLordFlag"] forState:UIControlStateNormal];
    }
    return _flagTipBtn;
}

- (M80AttributedLabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[M80AttributedLabel alloc]init];
        _contentLab.textColor = UIColorFromRGB(0x333333);
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.numberOfLines = 0;
        _contentLab.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLab.autoDetectLinks = NO;
        _contentLab.backgroundColor = [UIColor clearColor];
    }
    return _contentLab;
}

-(UILabel *)putTimeLab {
    if (!_putTimeLab) {
        _putTimeLab = [[UILabel alloc]init];
        _putTimeLab.textColor = UIColorFromRGB(0x999999);
        _putTimeLab.font = [UIFont systemFontOfSize:12];
    }
    return _putTimeLab;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"dynamic_more"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(didClickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [[UIImageView alloc]init];
        _headImg.layer.cornerRadius = 30.f/2;
        _headImg.layer.masksToBounds = YES;
        _headImg.userInteractionEnabled = YES;
//        _headImg.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserNameAction:)];
        [_headImg addGestureRecognizer:tap];
    }
    return _headImg;
}

- (UILabel *)nick {
    if (!_nick) {
        _nick = [[UILabel alloc]init];
        _nick.textColor = UIColorFromRGB(0x666666);
        _nick.font = [UIFont boldSystemFontOfSize:15];
        _nick.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserNameAction:)];
        [_nick addGestureRecognizer:tap];
    }
    return _nick;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xF4F4F4);
    }
    return _lineView;
}
@end
