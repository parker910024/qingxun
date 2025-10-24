//
//  CTUnreadModel.h
//  LTChat
//
//  Created by apple on 2019/8/5.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTUnreadModel : BaseObject
///头像
@property (nonatomic, copy) NSString *avatar;
///点赞数
@property (nonatomic, assign) long likeCount;
///评论数
@property (nonatomic, assign) long commentCount;

@property (nonatomic, assign) long allCount;

@end

NS_ASSUME_NONNULL_END
