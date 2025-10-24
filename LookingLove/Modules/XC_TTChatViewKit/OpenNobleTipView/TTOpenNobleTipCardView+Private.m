//
//  TTOpenNobleTipCardView+Private.m
//  XC_TTChatViewKit
//
//  Created by KevinWang on 2019/4/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTOpenNobleTipCardView+Private.h"
#import <YYText.h>
#import "XCTheme.h"

@implementation TTOpenNobleTipCardView (Private)

//开通贵族提示卡片
- (NSMutableAttributedString *)creatOpenNobleTipCardNeedLevelString:(NSString *)needLevel{
    
    NSMutableAttributedString *needAttributedString = [[NSMutableAttributedString alloc] init];
    NSString *needString = [NSString stringWithFormat:@"- 需开通%@ - \n",needLevel];
    
    NSMutableAttributedString *needLevelString = [self creatStrAttrByStr:needString attributed:
                                                  @{NSFontAttributeName:[UIFont boldSystemFontOfSize:23],
                                                    NSForegroundColorAttributeName:UIColorFromRGB(0xE0B980)}];
    
    NSMutableAttributedString *needTipString = [self creatStrAttrByStr:@"才可使用该礼物" attributed:
                                                @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                                  NSForegroundColorAttributeName:UIColorFromRGB(0xE0B980)}];
    
    [needAttributedString appendAttributedString:needLevelString];
    [needAttributedString appendAttributedString:needTipString];
    needAttributedString.yy_alignment = NSTextAlignmentCenter;
    
    return needAttributedString;
}

- (NSMutableAttributedString *)creatOpenNobleTipCardCurrentLevelString:(NSString *)currentLevel{
    
    NSMutableAttributedString *currentAttributedString = [[NSMutableAttributedString alloc] init];
    NSString *currentString = [NSString stringWithFormat:@"·当前为%@·",currentLevel];
    
    NSMutableAttributedString *currentLevelString = [self creatStrAttrByStr:currentString attributed:
                                                     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                                       NSForegroundColorAttributeName:UIColorFromRGB(0xE0B980)}];
    
    [currentAttributedString appendAttributedString:currentLevelString];
    currentAttributedString.yy_alignment = NSTextAlignmentCenter;
    return currentAttributedString;
}


-(NSMutableAttributedString *)creatStrAttrByStr:(NSString *)str attributed:(NSDictionary *)attribute{
    if (str.length == 0 || !str) {
        str = @" ";
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str attributes:attribute];
    return attr;
}


@end
