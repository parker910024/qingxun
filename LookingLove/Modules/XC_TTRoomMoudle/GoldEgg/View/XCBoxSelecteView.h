//
//  XCBoxSelecteView.h
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XCBoxSelectOpenCountTypeOne,
    XCBoxSelectOpenCountTypeTen,
    XCBoxSelectOpenCountTypeHundred,
    XCBoxSelectOpenCountTypeAuto
} XCBoxSelectOpenCountType;

@interface XCBoxSelecteView : UIView

@property (nonatomic, copy) void(^BoxSelecteViewBlock)(XCBoxSelectOpenCountType openCountType);

@property (nonatomic, assign) BOOL isDiamonBox; // 是否是至尊金蛋

@end
