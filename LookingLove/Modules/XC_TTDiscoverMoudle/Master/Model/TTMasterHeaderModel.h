//
//  TTMasterHeaderModel.h
//  TTPlay
//
//  Created by Macx on 2019/1/23.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMasterHeaderModel : BaseObject
/** title */
@property (nonatomic, strong) NSString *title;
/** content */
@property (nonatomic, strong) NSString *content;
/** tips */
@property (nonatomic, strong) NSString *tips;
/** 能否去收徒,true 能，false不能 */
@property (nonatomic, assign) BOOL can;
@end

NS_ASSUME_NONNULL_END
