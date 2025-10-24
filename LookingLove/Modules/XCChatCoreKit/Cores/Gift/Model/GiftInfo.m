//
//  GiftInfo.m
//  BberryCore
//
//  Created by chenran on 2017/7/13.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import "GiftInfo.h"
#import "NSString+JsonToDic.h"
@implementation GiftTips

@end

@implementation GiftAvatar

@end

@implementation GiftInfo

- (void)setMp4Key:(NSString *)mp4Key {
    _mp4Key = mp4Key;
    if (mp4Key.length > 0) {
        NSDictionary *dict = [NSString dictionaryWithJsonString:mp4Key];
        self.giftMp4Key = [GiftAvatar modelDictionary:dict];
    }
}

@end
