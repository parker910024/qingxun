//
//  XCBlackListTwiceEnsureView.h
//  XChat
//
//  Created by Macx on 2018/4/19.
//  Copyright © 2018年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ensureBlock)(void);
typedef void(^cancelBlock)(void);

@interface TTBlackListTwiceEnsureView : UIView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message ensureBlock:(ensureBlock)block cancel:(cancelBlock)cancelBlock;

@end
