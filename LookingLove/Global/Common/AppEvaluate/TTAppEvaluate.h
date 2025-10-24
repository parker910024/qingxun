//
//  TTAppEvaluate.h
//  TuTu
//
//  Created by gzlx on 2018/12/14.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTAppEvaluate : NSObject
+ (instancetype)mainCenter;
- (void)ttaddAppReview:(NSString *)account;
@end

NS_ASSUME_NONNULL_END
