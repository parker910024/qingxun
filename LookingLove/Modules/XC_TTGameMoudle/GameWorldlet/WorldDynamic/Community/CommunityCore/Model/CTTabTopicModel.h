//
//  CTTopicModel.h
//  UKiss
//
//  Created by apple on 2018/12/4.
//  Copyright © 2018 yizhuan. All rights reserved.
// 话题和tab模型

#import <Foundation/Foundation.h>
#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTTabTopicModel : BaseObject
/*****************话题数据*****************/
///话题名字
@property (nonatomic, copy) NSString *topicName;
///话题id
@property (nonatomic, assign) long topicId;
///如果url有值  就代表是活动  跳转到web
@property (nonatomic, copy) NSString *url;
///是否是 全部话题
@property (nonatomic, assign) BOOL isTotalTopic;



/*****************tab数据*****************/
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) long ID;
//tab类型
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
