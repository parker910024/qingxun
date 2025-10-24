//
//  PhoneCallCore.h
//  BberryCore
//
//  Created by chenran on 2017/5/29.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "BaseCore.h"

@interface PhoneCallCore : BaseCore

- (BOOL) isBusyLine;
- (UInt64)currentCallID;
- (void) startPhoneCall:(UserID)uid extendMsg:(NSString *)extendMsg;
- (void) responsePhoneCall:(BOOL)accept;
- (void) hangup;
- (BOOL) setMute:(BOOL)mute;
- (BOOL) setSpeaker:(BOOL)speaker;
@end
