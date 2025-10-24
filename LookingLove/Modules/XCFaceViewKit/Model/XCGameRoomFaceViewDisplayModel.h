//
//  XCGameRoomFaceViewDisplayModel.h
//  XCRoomMoudle
//
//  Created by 卫明何 on 2018/8/23.
//  Copyright © 2018年 卫明何. All rights reserved.
//

#import "BaseObject.h"

//submodel
#import "XCGameRoomFaceTitleDisplayModel.h"

typedef enum : NSUInteger {
    XCGameRoomFaceViewDisplayType_normal        = 1,        //普通视图，没有圆角
    XCGameRoomFaceViewDisplayType_Noble         = 2,        //有贵族表情的视图，需要titles不为空
    XCGameRoomFaceViewDisplayType_normal_corner = 3         //普通视图，顶部有两个圆角
} XCGameRoomFaceViewDisplayType;

@interface XCGameRoomFaceViewDisplayModel : BaseObject

/**
 标题模型数组
 */
@property (strong, nonatomic) NSMutableArray<XCGameRoomFaceTitleDisplayModel *> *titles;

/**
 显示布局类型
 */
@property (nonatomic,assign) XCGameRoomFaceViewDisplayType displayType;

@end
