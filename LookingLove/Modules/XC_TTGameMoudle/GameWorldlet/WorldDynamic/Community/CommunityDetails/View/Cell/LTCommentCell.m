//
//  LTCommentCell.m
//  UKiss
//
//  Created by apple on 2018/12/7.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import "LTCommentCell.h"
#import "CTCommentReplyModel.h"
#import <SDWebImage/UIImageView+WebCache.h>



#import "UserCore.h"
#import "AuthCore.h"
//#import "KEAlertDailogView.h"
#import "VKDynamicVoiceView.h"
#import "XCCurrentVCStackManager.h"

#import "KEMenuItemTool.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+XCToast.h"
#import "UIView+NTES.h"

@interface  LTCommentCell()
///名称
@property (nonatomic, strong) UILabel *nameLab;
///楼主、Match
@property (nonatomic, strong) UIButton *flagTipBtn;
///发布时间 （只用在详情）
@property (nonatomic, strong) UILabel *putTimeLab;

@end

@interface LTCommentCell ()

@end

@implementation LTCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.flagTipBtn];
    [self.contentView addSubview:self.putTimeLab];
    [self.contentView addSubview:self.contentLab];
}

- (void)initConstrations {
    [self.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(15));
        make.top.mas_equalTo(self.contentView).mas_offset(10);
    }];
    
    [self.flagTipBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab.mas_right).offset(5);
        make.centerY.mas_equalTo(self.nameLab);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(@(self.flagTipBtn.width + 5));
    }];
    
    [self.putTimeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.flagTipBtn);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.left.mas_greaterThanOrEqualTo(self.flagTipBtn.mas_right).offset(5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)settingFrame {
    CGFloat msgBubbleMaxWidth    =  (KScreenWidth - 70);
    CGSize  contentSize = [self.contentLab sizeThatFits:CGSizeMake(msgBubbleMaxWidth, CGFLOAT_MAX)];
    [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(5);
        make.height.mas_equalTo(contentSize.height);
        make.left.mas_equalTo(@(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];

}

- (void)settingData {
//    self.nameLab.text = self.commentReplyModel.communityNick;
    [self.contentLab nim_setText:self.commentReplyModel.content];
//    self.flagTipBtn.hidden = !self.commentReplyModel.owner;
//    self.putTimeLab.text = self.commentReplyModel.publishTime;
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
        [vv showCenterMoreView:self.contentLab title:@"复制" complete:^{
            @strongify(self);
            if (self.commentReplyModel.content) {
                [UIPasteboard generalPasteboard].string = self.commentReplyModel.content;
                [UIView showSuccess:@"已复制"];
            }else{
                [UIView showSuccess:@"复制失败"];
            }
        }];
    }
}

///点击昵称
- (void)tapUserNameAction:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpUserDetailsWithCell:)]) {
        [self.delegate jumpUserDetailsWithCell:self];
    }
}

#pragma mark - getters and setters

- (void)setCommentReplyModel:(CTCommentReplyModel *)commentReplyModel {
    _commentReplyModel = commentReplyModel;
    [self settingData];
    [self settingFrame];
//    [self layoutIfNeeded];
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc]init];
        _nameLab.textColor = UIColorFromRGB(0x222222);
        _nameLab.font = [UIFont boldSystemFontOfSize:13];
        _nameLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserNameAction:)];
        [_nameLab addGestureRecognizer:tap];
    }
    return _nameLab;
}

- (UIButton *)flagTipBtn {
    if (!_flagTipBtn) {
        _flagTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flagTipBtn setTitle:[NSString stringWithFormat:@" %@ ", @"楼主"] forState:UIControlStateNormal];
        [_flagTipBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        _flagTipBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_flagTipBtn setBackgroundColor:UIColorFromRGB(0x222222)];
        _flagTipBtn.layer.cornerRadius = 2;
        _flagTipBtn.layer.masksToBounds = YES;
        _flagTipBtn.adjustsImageWhenHighlighted = NO;
        [_flagTipBtn sizeToFit];
    }
    return _flagTipBtn;
}

- (M80AttributedLabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[M80AttributedLabel alloc]init];
        _contentLab.textColor = UIColorFromRGB(0x666666);
        _contentLab.font = [UIFont systemFontOfSize:14];
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
        _putTimeLab.textColor = [UIColorFromRGB(0x222222) colorWithAlphaComponent:0.3];
        _putTimeLab.font = [UIFont systemFontOfSize:12];
        [_putTimeLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    }
    return _putTimeLab;
}

@end
