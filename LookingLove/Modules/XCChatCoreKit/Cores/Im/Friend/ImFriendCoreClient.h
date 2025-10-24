//
//  ImFriendCoreClient.h
//  BberryCore
//
//  Created by chenran on 2017/5/14.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImFriendCoreClient <NSObject>
@optional
- (void)onRequestFriendSuccess;
- (void)onRequestFriendFailth;
- (void)onDeleteFriendSuccess;
- (void)onDeleteFirendFailth;
- (void)onAddToBlackListSuccess;
- (void)onAddToBlackListFailth;
- (void)onRemoveFromBlackListSuccess;
- (void)onRemoveFromBlackListFailth;

- (void)onFriendChanged;
- (void)onBlackListChanged;
- (void)onMuteListChanged;
- (void)onRecieveFriendAddNoti:(NSString *)uid;

- (void)onFriendAdded;

@end
