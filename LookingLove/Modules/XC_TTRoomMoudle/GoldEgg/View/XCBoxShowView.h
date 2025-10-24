//
//  XCShowHandlerView.h
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XCBoxShowTypeRecode,
    XCBoxShowTypeHelp,
    XCBoxShowTypeJackpot,
} XCBoxShowType;

@interface XCBoxShowView : UIView

@property (nonatomic, copy) void(^BoxShowViewBlock)(XCBoxShowType showType);

@end
