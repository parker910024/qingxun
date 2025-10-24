//
//  ActivityInfo.h
//  BberryCore
//
//  Created by 卫明何 on 2017/10/19.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

//入口位置，1-右下角，2-左上角
typedef NS_ENUM(NSUInteger, EntrancePositionType) {
    // 入口位置未定义
    EntrancePositionTypeUndefined = 0,
    //入口位置，右下角
    EntrancePositionTypeBottomRight = 1,
    //入口位置，左上角
    EntrancePositionTypeTopLeft = 2,
};

@interface ActivityInfo : BaseObject

@property (assign, nonatomic) NSInteger actId;
@property (copy, nonatomic) NSString *actName;
@property (assign, nonatomic) BOOL alertWin;
@property (copy, nonatomic) NSString *alertWinPic;
@property (assign, nonatomic) NSInteger alertWinLoc;
@property (assign, nonatomic) NSInteger skipType;
@property (copy, nonatomic) NSString *skipUrl;
@property (assign, nonatomic) NSInteger actAlertVersion;
@property (nonatomic, strong) NSString *imageType;

//入口位置，1-右下角，2-左上角
@property (nonatomic, assign) EntrancePositionType entrancePosition;
/// 显示类型，1-全屏，2-半屏，默认值是1
@property (nonatomic, assign) NSInteger showType;

@end
