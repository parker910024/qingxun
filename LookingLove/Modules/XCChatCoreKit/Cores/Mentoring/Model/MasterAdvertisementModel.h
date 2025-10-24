//
//  MasterAdvertisementModel.h
//  XCChatCoreKit
//
//  Created by Macx on 2019/1/22.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface MasterAdvertisementModel : BaseObject
/** 师傅昵称 */
@property (nonatomic, strong) NSString *masterNick;
/** 徒弟昵称 */
@property (nonatomic, strong) NSString *apprenticeNick;
/** 成功收徒 */
@property (nonatomic, strong) NSString *notice;
@end

NS_ASSUME_NONNULL_END
