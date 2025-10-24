//
//  XCShowHandlerView.h
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XCDiamondBoxShowTypeRecode,
    XCDiamondBoxShowTypeHelp,
    XCDiamondBoxShowTypeJackpot,
} XCDiamondBoxShowType;

@interface XCDiamondBoxShowView : UIView

@property (nonatomic, copy) void(^DiamondBoxShowViewBlock)(XCDiamondBoxShowType showType);

@end
