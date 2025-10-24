//
//  RoomInfo.m
//  BberryCore
//
//  Created by chenran on 2017/5/27.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "RoomInfo.h"

#import "DESEncrypt.h"
#import "XCMacros.h"

@implementation RoomInfo

#pragma mark - Getter Setter
- (void)setRoomPwd:(NSString *)roomPwd {
    if (projectType() == ProjectType_Haha) {
        _roomPwd = [DESEncrypt decryptUseDES:roomPwd key:keyWithType(KeyType_PwdEncode, NO)];
    }else if (projectType() == ProjectType_Pudding ||
              projectType() == ProjectType_LookingLove ||
              projectType() == ProjectType_TuTu ||
              projectType() == ProjectType_Planet) {
        _roomPwd = [DESEncrypt decryptUseDES:roomPwd key:keyWithType(KeyType_PwdEncode, NO)];
        if (_roomPwd.length <=0 && roomPwd.length > 0) { //有密码 但是解码失败
            _roomPwd = @" ";
        }
    }else {
        _roomPwd = roomPwd;
    }
}

@end
