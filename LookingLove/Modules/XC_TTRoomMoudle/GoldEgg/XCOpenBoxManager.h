//
//  XCOpenBoxManager.h
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCOpenBoxManager : NSObject


+ (instancetype)shareManager;

- (void)showBox;

- (void)stopAutoOpenBox;

- (void)stopAutoOpenDiamondBox;
@end
