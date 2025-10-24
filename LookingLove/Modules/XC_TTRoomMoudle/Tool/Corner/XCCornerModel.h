//
//  XCCornerModel.h
//  XCChatViewKit
//
//  Created by KevinWang on 2019/6/19.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.


#import <UIKit/UIKit.h>

struct XCRadius {
    CGFloat upLeft; //The radius of upLeft. 左上半径
    CGFloat upRight;    //The radius of upRight.    右上半径
    CGFloat downLeft;   //The radius of downLeft.   左下半径
    CGFloat downRight;  //The radius of downRight.  右下半径
};
typedef struct XCRadius XCRadius;

static XCRadius const XCRadiusZero = (XCRadius){0, 0, 0, 0};

NS_INLINE bool XCRadiusIsEqual(XCRadius radius1, XCRadius radius2) {
    return radius1.upLeft == radius2.upLeft && radius1.upRight == radius2.upRight && radius1.downLeft == radius2.downLeft && radius1.downRight == radius2.downRight;
}

NS_INLINE XCRadius XCRadiusMake(CGFloat upLeft, CGFloat upRight, CGFloat downLeft, CGFloat downRight) {
    XCRadius radius;
    radius.upLeft = upLeft;
    radius.upRight = upRight;
    radius.downLeft = downLeft;
    radius.downRight = downRight;
    return radius;
}

NS_INLINE XCRadius XCRadiusMakeSame(CGFloat radius) {
    XCRadius result;
    result.upLeft = radius;
    result.upRight = radius;
    result.downLeft = radius;
    result.downRight = radius;
    return result;
}


typedef NS_ENUM(NSUInteger, XCGradualChangeType) {
    XCGradualChangeTypeUpLeftToDownRight = 0,
    XCGradualChangeTypeUpToDown,
    XCGradualChangeTypeLeftToRight,
    XCGradualChangeTypeUpRightToDownLeft
};


@interface XCGradualChangingColor : NSObject

@property (nonatomic, strong) UIColor *fromColor;
@property (nonatomic, strong) UIColor *toColor;
@property (nonatomic, assign) XCGradualChangeType type;

@end


@interface XCCorner : NSObject

/**The radiuses of 4 corners.   4个圆角的半径*/
@property (nonatomic, assign) XCRadius radius;
/**The color that will fill the layer/view. 将要填充layer/view的颜色*/
@property (nonatomic, strong) UIColor *fillColor;
/**The color of the border. 边框颜色*/
@property (nonatomic, strong) UIColor *borderColor;
/**The lineWidth of the border. 边框宽度*/
@property (nonatomic, assign) CGFloat borderWidth;

@end
