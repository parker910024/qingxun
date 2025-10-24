//
//  NSString+Auth.h
//  Pods
//
//  Created by Jarvis Zeng on 2019/4/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Auth)
/**
 * 密码是否为数字和字母混合
 */
- (BOOL)isPasswordStrong;

/**
 * 是否在范围内
 */
- (BOOL)isLengthInRange:(NSInteger)min max:(NSInteger)max;
@end

NS_ASSUME_NONNULL_END
