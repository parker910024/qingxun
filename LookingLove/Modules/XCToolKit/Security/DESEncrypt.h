//
//  DESEncrypt.h
//  XChatFramework
//
//  Created by chenran on 2017/5/4.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESEncrypt : NSObject
//加密方法
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;
//解密方法
+(NSString *) decryptUseDES:(NSString *)cipherText key:(NSString *)key;
@end
