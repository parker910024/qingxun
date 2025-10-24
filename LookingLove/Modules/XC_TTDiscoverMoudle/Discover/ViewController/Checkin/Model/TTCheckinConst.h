//
//  TTCheckinConst.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  签到页面相关常量配置

#import <UIKit/UIKit.h>
#import "XCTheme.h"
#import "XCMacros.h"

#ifndef TTCheckinConst_h
#define TTCheckinConst_h

static inline UIColor *TTCheckinMainColor() {
    if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
        return UIColorFromRGB(0x593BED);
    } else {
        return UIColorFromRGB(0x8D47F8);
    }
}

#endif /* TTCheckinConst_h */
