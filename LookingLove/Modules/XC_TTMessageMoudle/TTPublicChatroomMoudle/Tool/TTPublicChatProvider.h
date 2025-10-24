//
//  TTPublicChatProvider.h
//  TuTu
//
//  Created by 卫明 on 2018/10/30.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

//NIM
#import <NIMSDK/NIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTPublicChatProvider : NSObject

+ (NIMUser *)fetchUserInfoByUser:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
