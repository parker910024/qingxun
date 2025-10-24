//
//  SingleAudioCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/5/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PhoneCallCoreClient <NSObject>
@optional
- (void)onStartPhoneCallSuccess:(UserID)callUid;
- (void)onStartPhoneCallFailth;

- (void)onCallEstablished;
- (void)onCallDisconnected;

- (void)onRecievePhoneCall:(NSString *)from;
- (void)onRecievePhoneCall:(NSString *)from uid:(NSString *)uid extend:(NSString *)extend;
- (void)onResponsePhoneCall:(NSString *)from accept:(BOOL)accept;

- (void)onHangup:(NSString *)from;
//- (void)onNetStatus:(NIMNetCallNetStatus)status user:(NSString *)user;
- (void)onBusyLine:(NSString *)from;
@end
