//
//  RouterSkipCenter.h
//  LookingLove
//
//  Created by apple on 2020/12/11.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "P2PInteractiveAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface RouterSkipCenter : NSObject
+ (instancetype)shareInstance;

- (void)handleRouterType:(P2PInteractive_SkipType)routerType value:(id)routerValue;

@end

NS_ASSUME_NONNULL_END
