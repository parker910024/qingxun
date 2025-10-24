//
//  TTMessageView+Red.m
//  XC_TTRoomMoudle
//
//  Created by lvjunhang on 2020/5/18.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTMessageView+Red.h"
#import "XCMediator+TTRoomMoudleBridge.h"
#import "TTStatisticsService.h"

@implementation TTMessageView (Red)

- (void)handleRedCell:(TTMessageTextCell *)cell model:(TTMessageDisplayModel *)model {
    
    [model setTextDidClick:^(UserID uid) {
        //其他房间的红包跳转其他房间
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:uid];
        
        [TTStatisticsService trackEvent:@"room_enter_red_paper_room" eventDescribe:@"房间公屏"];
    }];
    
    cell.messageLabel.attributedText = model.content;
    cell.labelContentView.hidden = NO;
    cell.chatBubleImageView.hidden = NO;
}

@end
