//
//  TTMessageHeaderView.m
//  TuTu
//
//  Created by KevinWang on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageHeaderView.h"
#import "TTMessageViewConst.h"

#import "UserCore.h"
#import "RoomInfo.h"
#import "ImRoomCoreV2.h"
#import "AuthCore.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "NSString+Utils.h"
#import "NSDate+TimeCategory.h"

@interface TTMessageHeaderView()

/** 官方绿色消息 */
@property (nonatomic, strong) UIView *ttBlueTextView;
@property (nonatomic, strong) UILabel *ttBlueLabel;

/** 房间介绍 */
@property (nonatomic, strong) UIView *ttIntroduceView;
@property (nonatomic, strong) UILabel *ttIntroduceLabel;
/** 点击查看房间玩法 */
@property (nonatomic, strong) UIView *ttTipView;
@property (nonatomic, strong) UILabel *ttTipLabel;

@end

@implementation TTMessageHeaderView

#pragma mark - Life Style

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

#pragma mark - Event
- (void)didTapttTipView:(UIGestureRecognizer *)ges {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ttMessageHeaderView:didClickTipView:)]) {
        [self.delegate ttMessageHeaderView:self didClickTipView:self.ttTipLabel];
    }
}

#pragma mark - Private
- (void)initView {
    [self addSubview:self.ttBlueTextView];
    [self.ttBlueTextView addSubview:self.ttBlueLabel];
    [self addSubview:self.ttIntroduceView];
    [self.ttIntroduceView addSubview:self.ttIntroduceLabel];
    [self addSubview:self.ttTipView];
    [self.ttTipView addSubview:self.ttTipLabel];
}

- (void)updateRoomInfo {
    
    if (self.roomInfo == nil) {
        self.frame = CGRectZero;
        return;
    }
    
    BOOL isRoomOwner = (self.roomInfo.uid == [[GetCore(AuthCore) getUid] userIDValue]);
    
    // 设置绿色消息
    NSString *title = @"封面、背景及内容含低俗、引导、暴露等都会被屏蔽处理，泄露用户隐私、导流第三方平台、欺诈用户等将被封号处理。请珍惜自己的直播间哦！";
    CGFloat labelW = [UIScreen mainScreen].bounds.size.width - 120;
    CGFloat margin = 12;
    CGFloat vertMargin = 6;
    CGSize titleSzie = [self sizeWithText:title font:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize] maxSize:CGSizeMake(labelW, CGFLOAT_MAX)];
    self.ttBlueTextView.frame = CGRectMake(0, 0, labelW+2*margin, titleSzie.height+2*margin);
    self.ttBlueLabel.frame = CGRectMake(margin, margin, labelW, titleSzie.height);
    self.ttBlueLabel.text = title;
    
    // 房间介绍 (如果是当天第一次进入此房间, 则展示介绍)
    BOOL showIntroduceText = NO;
    if (self.roomInfo.introduction.length > 0 && !isRoomOwner) { // 有房间介绍
        UserEnterRoomInfo *info = [GetCore(UserCore) getUserEnterRoomInfoInDB:[NSString stringWithFormat:@"%zd", self.roomInfo.roomId]];
        if (info == nil || info.enterTime.length == 0) { // 没有进过此房间记录
            showIntroduceText = YES;
        } else { // 有进过此房间记录
            NSDate *needFormatDate = [NSDate dateWithTimeIntervalSince1970:[info.enterTime doubleValue]];
            BOOL isToday = [needFormatDate isToday];
            if (isToday) {
                // 不显示
                showIntroduceText = NO;
            } else {
                showIntroduceText = YES;
            }
        }
    } else {
        showIntroduceText = NO;
    }
    
    if (showIntroduceText) {
        self.ttIntroduceView.hidden = NO;
        self.ttIntroduceLabel.hidden = NO;
        if (projectType() == ProjectType_LookingLove) {
            NSString * str = @"[房间公告]";
            NSString *introText = [NSString stringWithFormat:@"[房间公告] \n%@", self.roomInfo.introduction];
            NSMutableAttributedString * attribut = [[NSMutableAttributedString alloc] initWithString:introText attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]}];
            NSRange range = [introText rangeOfString:str];
            [attribut addAttribute:NSForegroundColorAttributeName value:[XCTheme getTTMainColor] range:range];
            CGSize introduceSize = [NSString sizeThatFitsWithText:introText maxSize:CGSizeMake(labelW, CGFLOAT_MAX) font:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]];
            self.ttIntroduceView.frame = CGRectMake(0, self.ttBlueTextView.frame.size.height + vertMargin, introduceSize.width+2*margin, introduceSize.height+2*vertMargin);
            self.ttIntroduceLabel.frame = CGRectMake(margin, vertMargin, introduceSize.width, introduceSize.height);
            self.ttIntroduceLabel.attributedText = attribut;
        }else {
            NSString *introText = [NSString stringWithFormat:@"[房间公告] \n%@", self.roomInfo.introduction];
            CGSize introduceSize = [NSString sizeThatFitsWithText:introText maxSize:CGSizeMake(labelW, CGFLOAT_MAX) font:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize]];
            self.ttIntroduceView.frame = CGRectMake(0, self.ttBlueTextView.frame.size.height + vertMargin, introduceSize.width+2*margin, introduceSize.height+2*vertMargin);
            self.ttIntroduceLabel.frame = CGRectMake(margin, vertMargin, introduceSize.width, introduceSize.height);
            self.ttIntroduceLabel.text = introText;
        }
    } else {
        self.ttIntroduceView.hidden = YES;
        self.ttIntroduceLabel.hidden = YES;
    }
    
    // 点击查看介绍
    if (!isRoomOwner) {
        self.ttTipView.hidden = NO;
        self.ttTipLabel.hidden = NO;
        NSString *tipTitle = @"点击房间话题查看本房间公告";
        CGSize tipTitleSzie = [self sizeWithText:tipTitle font:[UIFont systemFontOfSize:TTMessageViewDefaultFontSize] maxSize:CGSizeMake(labelW, CGFLOAT_MAX)];
        
        CGFloat ttTipLabelY = showIntroduceText ? (CGRectGetMaxY(self.ttIntroduceView.frame) + margin) : (CGRectGetMaxY(self.ttBlueTextView.frame) + vertMargin);
        self.ttTipView.frame = CGRectMake(0, ttTipLabelY, tipTitleSzie.width+2*margin, tipTitleSzie.height+2*vertMargin);
        self.ttTipLabel.frame = CGRectMake(margin, vertMargin, tipTitleSzie.width, tipTitleSzie.height);
        self.ttTipLabel.text = tipTitle;
    } else {
        self.ttTipView.hidden = YES;
        self.ttTipLabel.hidden = YES;
    }
    
    CGFloat height = isRoomOwner ? floorf(CGRectGetMaxY(self.ttBlueTextView.frame) + vertMargin) : floorf(CGRectGetMaxY(self.ttTipView.frame) + vertMargin);
    self.frame = CGRectMake(0, 0, labelW+2*margin, height);
    
    UserEnterRoomInfo *newInfo = [UserEnterRoomInfo new];
    newInfo.enterRoomUid = [NSString stringWithFormat:@"%zd", self.roomInfo.roomId];
    newInfo.enterTime = [self getCurrentTimestamp];
    [GetCore(UserCore) saveOrUpadateEnterRoomInfo:newInfo];
}

/**
 *  获取当前时间戳
 */
- (NSString *)getCurrentTimestamp {
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - Getter
- (void)setRoomInfo:(RoomInfo *)roomInfo {
    _roomInfo = roomInfo;
    
    [self updateRoomInfo];
}

- (UIView *)ttBlueTextView {
    if (!_ttBlueTextView) {
        _ttBlueTextView = [[UIView alloc] init];
        _ttBlueTextView.backgroundColor = UIColorRGBAlpha(0x000000, 0.16);
        _ttBlueTextView.layer.cornerRadius = TTMessageViewCellBubbleCornerRadius;
    }
    return _ttBlueTextView;
}

- (UILabel *)ttBlueLabel {
    if (!_ttBlueLabel) {
        _ttBlueLabel = [[UILabel alloc] init];
        _ttBlueLabel.font = [UIFont systemFontOfSize:TTMessageViewDefaultFontSize];
        if (projectType() == ProjectType_LookingLove) {
            _ttBlueLabel.textColor = [XCTheme getTTMainColor];
        }else {
            _ttBlueLabel.textColor = UIColorFromRGB(0xFFFFFF);
        }
        _ttBlueLabel.numberOfLines = 0;
    }
    return _ttBlueLabel;
}

- (UIView *)ttIntroduceView {
    if (!_ttIntroduceView) {
        _ttIntroduceView = [[UIView alloc] init];
        _ttIntroduceView.backgroundColor = UIColorRGBAlpha(0x000000, 0.16);
        _ttIntroduceView.layer.cornerRadius = TTMessageViewCellBubbleCornerRadius;
    }
    return _ttIntroduceView;
}

- (UILabel *)ttIntroduceLabel {
    if (!_ttIntroduceLabel) {
        _ttIntroduceLabel = [[UILabel alloc] init];
        _ttIntroduceLabel.font = [UIFont systemFontOfSize:TTMessageViewDefaultFontSize];
        _ttIntroduceLabel.textColor = [UIColor whiteColor];
        _ttIntroduceLabel.numberOfLines = 0;
    }
    return _ttIntroduceLabel;
}

- (UIView *)ttTipView {
    if (!_ttTipView) {
        _ttTipView = [[UIView alloc] init];
        _ttTipView.backgroundColor = UIColorRGBAlpha(0x000000, 0.16);
        _ttTipView.layer.cornerRadius = 13;
        _ttTipView.userInteractionEnabled = YES;
        [_ttTipView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapttTipView:)]];
    }
    return _ttTipView;
}

- (UILabel *)ttTipLabel {
    if (!_ttTipLabel) {
        _ttTipLabel = [[UILabel alloc] init];
        _ttTipLabel.font = [UIFont systemFontOfSize:TTMessageViewDefaultFontSize];
        _ttTipLabel.textColor = UIColor.whiteColor;
        _ttTipLabel.numberOfLines = 0;
    }
    return _ttTipLabel;
}

@end
