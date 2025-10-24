//
//  GuildHallMenu.h
//  XCChatCoreKit
//
//  Created by lee on 2019/1/23.
//  Copyright © 2019 KevinWang. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuildHallMenu : BaseObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *minImage;
@property (nonatomic, copy) NSString *maxImage;

@end

NS_ASSUME_NONNULL_END
