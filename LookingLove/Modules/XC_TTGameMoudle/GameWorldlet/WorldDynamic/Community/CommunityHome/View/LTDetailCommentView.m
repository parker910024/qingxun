//
//  LTCommentCell.m
//  UKiss
//
//  Created by apple on 2018/12/7.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import "LTDetailCommentView.h"
#import "CTCommentReplyModel.h"
#import <SDWebImage/UIImageView+WebCache.h>


#import "M80AttributedLabel+NIMKit.h"
#import "UIImageView+QiNiu.h"

#import "UserCore.h"
#import "AuthCore.h"
#import "VKDynamicVoiceView.h"
#import "XCCurrentVCStackManager.h"

#import "KEMenuItemTool.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+XCToast.h"
#import "UIView+NTES.h"
#import "TTStatisticsService.h"

@interface  LTDetailCommentView()
///头像
@property (nonatomic, strong) UIImageView *headImg;
///名称
@property (nonatomic, strong) UILabel *nameLab;
///发布时间 （只用在详情）
@property (nonatomic, strong) UILabel *putTimeLab;
///楼主、Match
@property (nonatomic, strong) UIButton *flagTipBtn;
///举报、删除
@property (nonatomic, strong) UIButton *moreBtn;

//文本内容
@property (nonatomic, strong) M80AttributedLabel *contentLab;

@property (nonatomic, strong) UIView *lineView; // 底部lineView;
@end

@interface LTDetailCommentView ()

@end

@implementation LTDetailCommentView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.headImg];
    [self addSubview:self.nameLab];
    [self addSubview:self.flagTipBtn];
//    [self addSubview:self.moreBtn];
    [self addSubview:self.contentLab];
    [self addSubview:self.putTimeLab];
    [self addSubview:self.lineView];
}

- (void)initConstrations {
    [self.headImg mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(self).offset(15);
         make.left.mas_equalTo(self).offset(20);
         make.width.height.equalTo(@(45));
     }];
     
     [self.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.headImg.mas_right).offset(10);
         make.top.mas_equalTo(self.headImg.mas_top).mas_offset(5);
         make.height.mas_equalTo(15);
     }];
     
     [self.flagTipBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.nameLab.mas_right).offset(5);
         make.centerY.mas_equalTo(self.nameLab);
         make.height.mas_equalTo(15);
         make.width.mas_equalTo(32);
     }];
     
    [self.putTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(10);
        make.height.mas_equalTo(12);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(70);
        make.left.mas_equalTo(self.nameLab);
        make.right.mas_equalTo(self.mas_right).offset(-20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self);
    }];
}

- (void)settingFrame {
    CGFloat msgBubbleMaxWidth = (KScreenWidth - 75);
    CGSize  contentSize = [self.contentLab sizeThatFits:CGSizeMake(msgBubbleMaxWidth, CGFLOAT_MAX)];
    [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImg.mas_bottom).offset(10);
        make.height.mas_equalTo(contentSize.height);
        make.left.mas_equalTo(self.nameLab);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.bottom.mas_equalTo(-10);
    }];

}

- (void)settingData {
    [self.headImg qn_setImageImageWithUrl:self.commentReplyModel.avatar placeholderImage:@"placeholder_image_square" type:ImageTypeUserIcon];
    self.nameLab.text = self.commentReplyModel.nick;
    
    NSString *nick = self.commentReplyModel.nick;
    if (self.nameLab.text.length > 7) {
        self.nameLab.text = [NSString stringWithFormat:@"%@...", [nick substringToIndex:7]];
    }
    
    [self.contentLab nim_setText:self.commentReplyModel.content];
    self.flagTipBtn.hidden = !self.commentReplyModel.landLordFlag;
    self.putTimeLab.text = [self stringWithTimeStamp:self.commentReplyModel.publishTime];
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
    BOOL isSameDay = [[NSCalendar currentCalendar] isDateInToday:date]; // 是否是同一天
    
    // A. 当天，且 timeInterval < 1分钟，显示“刚刚”；
    if (timeInterval < 60) {
        return [NSString stringWithFormat:@"刚刚"];
        
        // B. 当天，且1分钟≤ timeInterval <60分钟，显示“n分钟前”；
    } else if((temp = timeInterval/60) < 60){
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

#pragma mark - evntAction

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    if ([longPress isKindOfClass:[UILongPressGestureRecognizer class]] &&
        longPress.state == UIGestureRecognizerStateBegan) {
        if (!self.commentReplyModel.content) {
            return;
        }
        @weakify(self);
        KEMenuItemTool * vv = [[KEMenuItemTool alloc] init];
        
        NSDictionary *copy = @{kItemTextKey : @"复制", kItemIconKey : @"dynamic_menu_item_icon_copy", kItemTypeKey : @(KEMenuItemToolTypeCopy)};
        NSDictionary *delete = @{kItemTextKey : @"删除", kItemIconKey : @"dynamic_menu_item_icon_delete", kItemTypeKey : @(KEMenuItemToolTypeDelete)};
        NSDictionary *report = @{kItemTextKey : @"举报", kItemIconKey : @"dynamic_menu_item_icon_report", kItemTypeKey : @(KEMenuItemToolTypeReport)};

        NSMutableArray *itemNames = [NSMutableArray arrayWithArray:@[copy]];
        
        // 自己 or 是楼主
        if ([self.commentReplyModel.uid isEqualToString:GetCore(AuthCore).getUid] ||
            [self.littleWorldOwerUid isEqualToString:GetCore(AuthCore).getUid]) {
            [itemNames addObject:delete];
        }
        
        // 非自己的评论
        if (![self.commentReplyModel.uid isEqualToString:GetCore(AuthCore).getUid]) {
            [itemNames addObject:report];
        }
        
        [vv showMoreTypeView:self.contentLab actionNames:itemNames.copy complete:^(KEMenuItemToolType type) {
            @strongify(self);
            switch (type) {
                case KEMenuItemToolTypeCopy:
                {
                    [TTStatisticsService trackEvent:@"world_copy_comment" eventDescribe:@"复制评论"];
                    // 复制
                    if (self.commentReplyModel.content) {
                        [UIPasteboard generalPasteboard].string = self.commentReplyModel.content;
                        [UIView showSuccess:@"已复制"];
                    }else{
                        [UIView showSuccess:@"复制失败"];
                    }
                }
                    break;
                    case KEMenuItemToolTypeReport:
                {
                    [TTStatisticsService trackEvent:@"world_report_comment" eventDescribe:@"举报评论"];
                    // 举报
                    if (self.delegate && [self.delegate respondsToSelector:@selector(reportCommentWithDetailCommentView:)]) {
                        [self.delegate reportCommentWithDetailCommentView:self];
                    }
                }
                    break;
                case KEMenuItemToolTypeDelete:
                {
                    [TTStatisticsService trackEvent:@"world_delete_comment" eventDescribe:@"删除评论"];
                    // 删除
                    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteCommentWithDetailCommentView:)]) {
                        [self.delegate deleteCommentWithDetailCommentView:self];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(replyCommentActionWithDetailCommentView:)]) {
        [self.delegate replyCommentActionWithDetailCommentView:self];
    }
}

///点击昵称
- (void)tapUserNameAction:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpUserDetailsWithDetailCommentView:)]) {
        [self.delegate jumpUserDetailsWithDetailCommentView:self];
    }
}

- (void)didClickMoreButton:(UIButton *)button {
    NSString *titleStr = @"userSetting_report_title";
    if ([self.commentReplyModel.uid isEqualToString:GetCore(AuthCore).getUid]) {
        titleStr = @"public_delete";
    }
    @weakify(self);
    KEMenuItemTool * vv = [[KEMenuItemTool alloc] init];
    [vv showRightMoreButton:button title:titleStr complete:^{
        @strongify(self);
        if ([titleStr isEqualToString:@"public_delete"]) {//删除
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteCommentWithDetailCommentView:)]) {
                [self.delegate deleteCommentWithDetailCommentView:self];
            }
        }else {//举报

        }
    }];
}

#pragma mark - getters and setters

- (void)setCommentReplyModel:(CTCommentReplyModel *)commentReplyModel {
    _commentReplyModel = commentReplyModel;
    [self settingData];
    [self settingFrame];
}

- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [[UIImageView alloc]init];
        _headImg.layer.cornerRadius = 45.f/2;
        _headImg.layer.masksToBounds = YES;
        _headImg.userInteractionEnabled = YES;
//        _headImg.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserNameAction:)];
        [_headImg addGestureRecognizer:tap];
    }
    return _headImg;
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc]init];
        _nameLab.textColor = UIColorFromRGB(0x666666);
        _nameLab.font = [UIFont boldSystemFontOfSize:15];
        _nameLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserNameAction:)];
        [_nameLab addGestureRecognizer:tap];
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
        _contentLab.lineSpacing = 22;
    }
    return _contentLab;
}

-(UILabel *)putTimeLab {
    if (!_putTimeLab) {
        _putTimeLab = [[UILabel alloc]init];
        _putTimeLab.textColor = [UIColorFromRGB(0x222222) colorWithAlphaComponent:0.3];
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

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xF4F4F4);
    }
    return _lineView;
}
@end
