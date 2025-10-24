//
//  SingleNobleInfo.m
//  BberryCore
//
//  Created by 卫明何 on 2018/1/10.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "SingleNobleInfo.h"
#import "UIColor+hex.h"
#import "NobleSourceTool.h"
#import "NobleCore.h"

@implementation SingleNobleInfo

- (void)setLevel:(NSInteger)level {
    _level = level;
    NobleInfo *nobleInfo = [GetCore(NobleCore).privilegeDict objectForKey:[NSString stringWithFormat:@"%ld",(long)level]];
    self.banner = nobleInfo.banner.values.firstObject;
    self.open_effect = nobleInfo.open_effect.values.firstObject;
    self.wingBadge = nobleInfo.badge.values.firstObject;
}

- (id)badge {
    return [NobleSourceTool sortStringWithid:_badge];
}

- (id)headwear {
    return [NobleSourceTool sortStringWithid:_headwear];
}

- (id)cardbg {
    return [NobleSourceTool sortStringWithid:_cardbg];
}

- (id)roombg {
    return [NobleSourceTool sortStringWithid:_roombg];
}

- (id)zonebg {
    return [NobleSourceTool sortStringWithid:_zonebg];
}

- (id)open_effect {
    return [NobleSourceTool sortStringWithid:_open_effect];
}

- (id)banner {
    return [NobleSourceTool sortStringWithid:_banner];
}

- (id)bubble {
    return [NobleSourceTool sortStringWithid:_bubble];
}

- (id)halo {
    return [NobleSourceTool sortStringWithid:_halo];
}

- (id)wingBadge {
    return [NobleSourceTool sortStringWithid:_wingBadge];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"badge" : @"badge",
             @"headwear" : @[@"micDecorate",@"headwear"],
             @"halo" : @[@"micHalo",@"halo"],
             @"roombg" : @[@"roomBackground",@"roombg"],
             @"bubble":@[@"chatBubble",@"bubble"],
             @"level":@[@"nobleId",@"level"]
             };
}

- (NSDictionary *)encodeAttachemt {
    if (_encodeAttachemt == nil) {
        _encodeAttachemt = [NobleSourceTool sortStringWithNobleInfo:self];
    }
    return _encodeAttachemt;
}

@end
