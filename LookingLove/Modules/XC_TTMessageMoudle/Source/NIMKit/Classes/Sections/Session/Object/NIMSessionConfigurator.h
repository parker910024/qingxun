//
//  NIMSessionViewConfigurator.h
//  NIMKit
//
//  Created by chris on 2016/11/7.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "NIMSessionViewController.h"
#import "NIMSessionConfigurateProtocol.h"
#import "TTPublicNIMChatroomController.h"
#import "TTLittleWorldSessionViewController.h"
@class NIMSessionViewController;

@interface NIMSessionConfigurator : NSObject

- (void)setup:(NIMSessionViewController *)vc;

- (void)setup:(TTPublicNIMChatroomController *)vc isPublic:(BOOL)isPublic;

- (void)setupLittleWorld:(TTLittleWorldSessionViewController *)vc;

@end
