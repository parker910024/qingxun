//
//  LLDynamicLayoutModel.m
//  XCChatCoreKit
//
//  Created by lee on 2020/1/8.
//  Copyright © 2020 YiZhuan. All rights reserved.
//

#import "LLDynamicLayoutModel.h"
#import "UIView+NTES.h"
#import <YYText/YYText.h>
#import "XCMacros.h"
#import "LTDynamicPictureView.h"
#import "LLDynamicModel.h"

@implementation LLDynamicLayoutModel
 
+ (instancetype)layoutWithStatusModel:(LLDynamicModel *)dynamic {
    LLDynamicLayoutModel *layoutModel = [[LLDynamicLayoutModel alloc] init];
    layoutModel.dynamicModel = dynamic;
    layoutModel.isRecommendDynamic = dynamic.isRecommendDynamic;
    kCellWidth = KScreenWidth - 20 * 2;
    [layoutModel layout];
    return layoutModel;
}

+ (instancetype)layoutWithDynamicSquareModel:(LLDynamicModel *)dynamic {
    LLDynamicLayoutModel *layoutModel = [[LLDynamicLayoutModel alloc] init];
    layoutModel.dynamicModel = dynamic;
    kCellWidth = KCellContentWidth; // 动态广场的 cell宽度
    [layoutModel layout];
    return layoutModel;
}

#pragma mark -
#pragma mark layout
- (void)layout {
    [self layoutHead];
    [self layoutText];
    [self layoutPicView];
    [self layoutOrderBar];
    [self layoutToolBarView];
    [self layoutWorldTagView];
}

- (void)layoutHead {
    // 时间显示格式
    [self formatTimeStr];
    
    self.AvatarF = CGRectMake(25, 20, KHeadIconSize, KHeadIconSize);
    
    NSMutableAttributedString *nickText = [[NSMutableAttributedString alloc] initWithString:self.dynamicModel.nick];
    nickText.yy_font = [UIFont fontWithName:@"PingFangSC-Medium" size:KHeadNameFont];
    
    CGFloat nameX = CGRectGetMaxX(self.AvatarF) + KHeadImagePadding;
    CGFloat nameY = self.AvatarF.origin.y;
    CGFloat nameH = [self heightForAttributeText:nickText maxWidth:KNameMaxWidth];
    
    BOOL showTime = !self.isRecommendDynamic;//时间
    BOOL showAnchorBrand = self.dynamicModel.nameplate;//主播铭牌
    BOOL showDateSource = showTime || showAnchorBrand;//显示label
    BOOL showAnchorTag = self.dynamicModel.tagList.count > 0;//主播标签
    
    //没有铭牌和标签时，对头像居中
    if (!showDateSource && !showAnchorTag) {
        nameY = CGRectGetMaxY(self.AvatarF) - KHeadIconSize/2 - nameH/2;
    }
    
    self.nameF = CGRectMake(nameX, nameY, KNameMaxWidth, nameH);
    
    CGFloat dsX = self.nameF.origin.x;
    CGFloat dsY = CGRectGetMaxY(self.nameF) + KNameDatePadding;
    if (showDateSource) {
        dsY += KNameDatePadding;
    }
    CGFloat dsH = showDateSource ? 15 : 0;
    self.dateSourceF = CGRectMake(dsX, dsY, KNameMaxWidth, dsH);
    
    CGFloat tagY = CGRectGetMaxY(self.dateSourceF) + 6;
    CGFloat tagH = showAnchorTag ? 15 : 0;
    self.anchorTagF = CGRectMake(dsX, tagY, KNameMaxWidth, tagH);
    
    CGFloat proX = 0;
    CGFloat proY = 0;
    CGFloat proW = kCellWidth;
    CGFloat proH = CGRectGetMaxX(self.AvatarF) + KConnectPadding;
    
    if (showAnchorTag) {
        proH = CGRectGetMaxY(self.anchorTagF) + KConnectPadding;
    }
    
    proH = MAX(proH, 74);//最小值74
    
    self.profileF = CGRectMake(proX, proY, proW, proH);
}

- (void)layoutText {
    NSString *text = self.dynamicModel.content ? self.dynamicModel.content : @"";
    NSMutableAttributedString *richText = [[NSMutableAttributedString alloc] initWithString:text];
    richText.yy_font = [UIFont systemFontOfSize:15];
    richText.yy_lineSpacing = 5;
    
    CGFloat x = KContentPadding;
    CGFloat w = kCellSquareWidht;
    CGFloat h = [self heightForAttributeText:richText maxWidth:w];
    CGFloat y = CGRectGetMaxY(self.profileF);
    
    self.textF = CGRectMake(x, y, w, h);
    self.rowHeight = CGRectGetMaxY(self.textF);
    
    CGFloat openUpBtnY = CGRectGetMaxY(self.textF) + 7.5;
    self.openUpBtnF = self.numberOfText > 6 ? CGRectMake(x, openUpBtnY, 31, 15) : CGRectZero;
    
    if (self.numberOfText > 6) {
        self.rowHeight = CGRectGetMaxY(self.openUpBtnF);
    }
}

- (void)layoutPicView {
    if (self.dynamicModel.dynamicResList.count == 0) {
        self.sudokuPicsF = CGRectZero;
        return;
    }
    
    CGFloat y = self.rowHeight + 15;
    CGFloat x = CGRectGetMinX(self.textF);
    CGFloat w = kCellSquareWidht;
    CGFloat height = [LTDynamicPictureView getPictureViewHeightWithImageInfoList:self.dynamicModel.dynamicResList realWidth:w];
    self.sudokuPicsF = CGRectMake(x, y, w, height);
    self.rowHeight = CGRectGetMaxY(self.sudokuPicsF);
}

- (void)layoutToolBarView {
    CGFloat y = self.rowHeight+6;
    CGFloat h = 50.f;
    self.toolBarF = CGRectMake(25, y, kCellSquareWidht, h);
    self.rowHeight = CGRectGetMaxY(self.toolBarF);
}

- (void)layoutOrderBar {
    if (!self.dynamicModel.workOrder) {
        self.orderBarF = CGRectZero;
        return;
    }
    
    CGFloat x = CGRectGetMinX(self.textF);

    self.orderBarF = CGRectMake(x, self.rowHeight + 14, kCellSquareWidht+20, 16);
    self.rowHeight = CGRectGetMaxY(self.orderBarF) + 4;
}

- (void)layoutWorldTagView {
    if (self.dynamicModel.worldId.integerValue <= 0) {
        self.worldTagViewF = CGRectZero;
        self.squareRowHeight = self.rowHeight + 15;
        return;
    }
    
    CGFloat x = CGRectGetMinX(self.textF);
    self.worldTagViewF = CGRectMake(x, self.rowHeight+6, kCellSquareWidht, 45);
    self.rowHeight = CGRectGetMaxY(self.worldTagViewF);
    self.squareRowHeight = CGRectGetMaxY(self.worldTagViewF) + 15;
}
#pragma mark -
#pragma mark Public Method
- (void)reloadLayout {
    [self layout];
}

#pragma mark -
#pragma mark private Method
- (CGFloat)heightForAttributeText:(NSAttributedString *)attributeText maxWidth:(CGFloat)maxWidth {
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(maxWidth, CGFLOAT_MAX);
    
    container.maximumNumberOfRows = 0;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributeText];
    // 得到当前文本的行数
    self.numberOfText = layout.rowCount;
    
    if (layout.rowCount > 6) {
        NSInteger numberOfLines = self.dynamicModel.isOpenUp ? 0 : 6;
        container.maximumNumberOfRows = numberOfLines;
    }
    
    YYTextLayout *realLayout = [YYTextLayout layoutWithContainer:container text:attributeText];
    
    return realLayout.textBoundingSize.height;
}

/// 格式化显示时间
- (void)formatTimeStr {
    if (!self.dynamicModel.publishTime) {
        return;
    }
    NSString *timeStamp = self.dynamicModel.publishTime;
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
    
    BOOL isSameDay = [[NSCalendar currentCalendar] isDateInToday:date]; // 是否是同一天
    
    // A. 当天，且 timeInterval < 1分钟，显示“刚刚”；
    if (timeInterval < 60) {
        self.timeStr = [NSString stringWithFormat:@"刚刚"];
        
        // B. 当天，且1分钟≤ timeInterval <60分钟，显示“n分钟前”；
    } else if((temp = timeInterval/60) < 60){
        self.timeStr = [NSString stringWithFormat:@"%ld分钟前",temp];
        
        // C. 当天，且n≥60分钟，显示“xx:xx”；
    } else if((temp = temp/60) < 24 && isSameDay){
        self.timeStr = [timeFormatter stringFromDate:date];
        
        // C. 非当天，且n≥60分钟，显示“xx:xx”；
    } else if((temp = temp/60) < 24 && !isSameDay){
        self.timeStr = [dayFormatter stringFromDate:date];
        
        // D. 跨天，且未跨年，显示“mm-dd”；
    } else if((temp = temp/30) < 30){
        self.timeStr = [dayFormatter stringFromDate:date];
        
    } else {
        // E. 跨年，显示“yyyy-mm-dd”；
        self.timeStr = [yearFormatter stringFromDate:date];
    }
}
@end
