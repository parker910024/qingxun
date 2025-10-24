//
//  TTPositionHelper.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/20.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XCConst.h"

#import "TTPositionViewUIProtocol.h"

#import "TTPositionTopicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTPositionHelper : NSObject

+ (instancetype)shareHelper;

/** 给用户的头饰赋值*/
+ (void)handlerImageView:(UIImageView *)imageView  soure:(id)source imageType:(ImageType)imageType;

/**
 设置房间话题

 @param model 房间话题的molde
 @return 返回一个拼接好的富文本
 */
- (NSMutableAttributedString *)createTuTuTopicAtttibutedStringWith:(TTPositionTopicModel *)model;

/** 是不是显示土豪位*/
- (BOOL)showTTPositionVipViewWith:(TTRoomPositionViewLayoutStyle)style;

/** 根据布局的形式得到是什么房间的类型*/
- (TTRoomPositionViewType)configTTRoomPositionViewType:(TTRoomPositionViewLayoutStyle)style;

@end

NS_ASSUME_NONNULL_END
