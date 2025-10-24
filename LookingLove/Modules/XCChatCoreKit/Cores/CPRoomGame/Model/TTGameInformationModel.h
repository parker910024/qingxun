//
//  TTGameInformationModel.h
//  TuTu
//
//  Created by new on 2019/1/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGameInformationModel : BaseObject
// 游戏结束之后，收到的消息实体。 message.body
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *nonstr;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSDictionary *result;

@property (nonatomic, assign) UserID uidLeft;
@property (nonatomic, assign) UserID uidRight;
@end

NS_ASSUME_NONNULL_END
