//
//  TTMessageView+SuperAdmin.h
//  XC_TTRoomMoudle
//
//  Created by jiangfuyuan on 2019/8/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMessageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTMessageView (SuperAdmin)

- (void)handleSuperAdminCell:(TTMessageTextCell *)cell model:(TTMessageDisplayModel *)model;

@end

NS_ASSUME_NONNULL_END
