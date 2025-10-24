//
//  NIMMessageCellMaker.m
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMMessageCellFactory.h"
#import "NIMMessageModel.h"
#import "NIMTimestampModel.h"
#import "NIMSessionAudioContentView.h"
#import "NIMKit.h"
#import "NIMKitAudioCenter.h"
#import "UIView+NIM.h"
#import "TTPublicMessageCell.h"

@interface NIMMessageCellFactory()

@end

@implementation NIMMessageCellFactory

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    
}

- (TTPublicMessageCell *)publicCellInTable:(UITableView *)tableView
                            forMessageMode:(NIMMessageModel *)model {
    if (!model.isMe) {
        id<NIMCellLayoutConfig> layoutConfig = [[NIMKit sharedKit] layoutConfig];
        NSString *identity = @"TTPublicMessageCellLeft";
        TTPublicMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
        if (!cell) {
            NSString *clz = @"TTPublicMessageCell";
            [tableView registerClass:NSClassFromString(clz) forCellReuseIdentifier:@"TTPublicMessageCellLeft"];
            cell = [tableView dequeueReusableCellWithIdentifier:identity];
        }
        return (TTPublicMessageCell *)cell;
    }else {
        id<NIMCellLayoutConfig> layoutConfig = [[NIMKit sharedKit] layoutConfig];
        NSString *identity = @"TTPublicMessageCellRight";
        TTPublicMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
        if (!cell) {
            NSString *clz = @"TTPublicMessageCell";
            [tableView registerClass:NSClassFromString(clz) forCellReuseIdentifier:@"TTPublicMessageCellRight"];
            cell = [tableView dequeueReusableCellWithIdentifier:identity];
        }
        return (TTPublicMessageCell *)cell;
    }
    
}

- (NIMMessageCell *)cellInTable:(UITableView*)tableView
                 forMessageMode:(NIMMessageModel *)model
{
    id<NIMCellLayoutConfig> layoutConfig = [[NIMKit sharedKit] layoutConfig];
    NSString *identity = [layoutConfig cellContent:model];
    NIMMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        NSString *clz = @"NIMMessageCell";
        [tableView registerClass:NSClassFromString(clz) forCellReuseIdentifier:identity];
        cell = [tableView dequeueReusableCellWithIdentifier:identity];
    }
    return (NIMMessageCell *)cell;
}

- (NIMSessionTimestampCell *)cellInTable:(UITableView *)tableView
                            forTimeModel:(NIMTimestampModel *)model
{
    NSString *identity = @"time";
    NIMSessionTimestampCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        NSString *clz = @"NIMSessionTimestampCell";
        [tableView registerClass:NSClassFromString(clz) forCellReuseIdentifier:identity];
        cell = [tableView dequeueReusableCellWithIdentifier:identity];
    }
    [cell refreshData:model];
    return (NIMSessionTimestampCell *)cell;
}

@end
