//
//  TTMessageView+SuperAdmin.m
//  XC_TTRoomMoudle
//
//  Created by jiangfuyuan on 2019/8/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMessageView+SuperAdmin.h"

@implementation TTMessageView (SuperAdmin)

- (void)handleSuperAdminCell:(TTMessageTextCell *)cell model:(TTMessageDisplayModel *)model {
    cell.messageLabel.attributedText = model.content;
    cell.labelContentView.hidden = NO;
    cell.chatBubleImageView.hidden = YES;
}

@end
