//
//  GiftReceiveInfo.m
//  BberryCore
//
//  Created by chenran on 2017/7/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "GiftReceiveInfo.h"
#import "GiftCore.h"

@implementation GiftReceiveInfo


- (void)setGiftId:(NSInteger)giftId {
    _giftId = giftId;
    self.giftInfo = [GetCore(GiftCore) findGiftInfoByGiftId:giftId];
}

- (GiftInfo *)gift {
    if (_gift) {
        return _gift;
    } else {
        return _giftInfo;
    }
}

- (GiftInfo *)giftInfo {
    if (_gift) {
        return _gift;
    } else {
        return _giftInfo;
    }
}

@end
