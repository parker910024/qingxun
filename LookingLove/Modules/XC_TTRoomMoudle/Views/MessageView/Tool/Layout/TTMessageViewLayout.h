//
//  TTMessageViewLayout.h
//  TTPlay
//
//  Created by 卫明 on 2019/3/11.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTMessageViewLayout : NSObject

+ (instancetype)shareLayout;

- (CGFloat)getAttributedHeightWith:(NSMutableAttributedString *)attr;

@end

NS_ASSUME_NONNULL_END
