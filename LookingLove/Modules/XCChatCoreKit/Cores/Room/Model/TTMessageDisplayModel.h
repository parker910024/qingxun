//
//  TTMessageDisplayModel.h
//  TTPlay
//
//  Created by 卫明 on 2019/3/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import <UIKit/UIKit.h>
#import "UserID.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMessageDisplayModel : NSObject

/**
 消息实体
 */
@property (strong, nonatomic) NIMMessage *message;

/**
 内容高度
 */
@property (nonatomic,assign) CGFloat contentHeight;

/**
 富文本
 */
@property (strong, nonatomic) NSMutableAttributedString *content;

/**
 哪个uid被点击
 */
@property (nonatomic, copy) void (^textDidClick)(UserID uid);

@end

NS_ASSUME_NONNULL_END
