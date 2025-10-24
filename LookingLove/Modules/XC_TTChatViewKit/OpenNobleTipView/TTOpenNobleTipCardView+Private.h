//
//  TTOpenNobleTipCardView+Private.h
//  XC_TTChatViewKit
//
//  Created by KevinWang on 2019/4/9.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTOpenNobleTipCardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTOpenNobleTipCardView (Private)

- (NSMutableAttributedString *)creatOpenNobleTipCardNeedLevelString:(NSString *)needLevel;
- (NSMutableAttributedString *)creatOpenNobleTipCardCurrentLevelString:(NSString *)currentLevel;

@end

NS_ASSUME_NONNULL_END
