//
//  DataUtils.h
//  YYFaceAuth
//
//  Created by chenran on 16/10/18.
//  Copyright © 2016年 zhangji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountInfo.h"
@interface AccountInfoStorage : NSObject

+ (AccountInfo *)getCurrentAccountInfo;
+ (void) saveAccountInfo:(AccountInfo *)accountInfo;
@end
