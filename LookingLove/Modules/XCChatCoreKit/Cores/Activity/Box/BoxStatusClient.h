//
//  BoxStatusClient.h
//  XCChatCoreKit
//
//  Created by JarvisZeng on 2019/5/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//


#import "BoxStatus.h"

@protocol BoxStatusClient <NSObject>

@optional
// 获取钻石宝箱活动状态
- (void)onGetDiamondBoxActivityStatusSuccess:(BoxStatus *)status;
- (void)onGetDiamondBoxActivityStatusFailth:(NSString *)message;
@end;
