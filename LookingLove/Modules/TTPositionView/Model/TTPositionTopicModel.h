//
//  TTPositionTopicModel.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/22.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTPositionTopicModel : BaseObject
/** 房间话题*/
@property (nonatomic, assign) NSString *roomTag;
/** 房间话题的图片*/
@property (nonatomic, assign) NSString *tagPict;
/** 房间话题内容*/
@property (nonatomic, assign) NSString *topicString;
/** 是不是可以编辑*/
@property (nonatomic, assign) BOOL isEdit;
@end

NS_ASSUME_NONNULL_END
