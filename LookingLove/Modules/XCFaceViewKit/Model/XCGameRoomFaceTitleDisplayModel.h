//
//  XCGameRoomFaceTitleDisplayModel.h
//  XCRoomMoudle
//
//  Created by 卫明何 on 2018/8/23.
//  Copyright © 2018年 卫明何. All rights reserved.
//

#import "BaseObject.h"

//facemodel
#import "FaceInfo.h"
//core
#import "FaceCore.h"

@interface XCGameRoomFaceTitleDisplayModel : BaseObject

/**
 该标题下的表情类型
 */
@property (nonatomic,assign) RoomFaceType type;

/**
 标题内容
 */
@property (nonatomic,copy) NSString *title;

/**
 是否被选择
 */
@property (nonatomic,assign) BOOL isSelected;

@end
