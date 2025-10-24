//
//  PeeragesInfo.m
//  BberryCore
//
//  Created by 卫明何 on 2018/1/8.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "NobleInfo.h"

@implementation NobleInfo

//+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
//    return @{
//             @"privilegeInfo"       : PrivilegeInfo.class,
//             @"badge"               : NobleSourceInfo.class,
//             @"headerwear"          : NobleSourceInfo.class,
//             @"cardbg"              : NobleSourceInfo.class,
//             @"zonebg"              : NobleSourceInfo.class,
//             @"open_effect"         : NobleSourceInfo.class,
//             @"banner"              : NobleSourceInfo.class,
//             @"bubble"              : NobleSourceInfo.class,
//             @"halo"                : NobleSourceInfo.class
//             
//             };
//}

- (NobleSourceInfo *)badge {
    if (_badge == nil) {
        _badge = [[NobleSourceInfo alloc]init];
    }
    return _badge;
}

- (NobleSourceInfo *)headerwear {
    if (_headerwear == nil) {
        _headerwear = [[NobleSourceInfo alloc]init];
    }
    return _headerwear;
}

- (NobleSourceInfo *)cardbg {
    if (_cardbg == nil) {
        _cardbg = [[NobleSourceInfo alloc]init];
    }
    return _cardbg;
}

- (NobleSourceInfo *)zonebg {
    if (_zonebg == nil) {
        _zonebg = [[NobleSourceInfo alloc]init];
    }
    return _zonebg;
}

- (NobleSourceInfo *)open_effect {
    if (_open_effect == nil) {
        _open_effect = [[NobleSourceInfo alloc]init];
    }
    return _open_effect;
}

- (NobleSourceInfo *)banner {
    if (_banner == nil) {
        _banner = [[NobleSourceInfo alloc]init];
    }
    return _banner;
}

- (NobleSourceInfo *)bubble {
    if (_bubble == nil) {
        _bubble = [[NobleSourceInfo alloc]init];
    }
    return _bubble;
}

- (NobleSourceInfo *)halo {
    if (_halo == nil) {
        _halo = [[NobleSourceInfo alloc]init];
    }
    return _halo;
}
- (NobleSourceInfo *)recommend{
    if (_recommend == nil) {
        _recommend = [[NobleSourceInfo alloc]init];
    }
    return _recommend;
}
@end
