//
//  TuTuGameRoomListHeaderView.h
//  XChat
//
//  Created by Mac on 2018/1/16.
//  Copyright © 2018年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserID.h"

@protocol XCGameRoomListHeaderViewDelegate<NSObject>
@optional
- (void)gameRoomListHeaderViewShowNobleUserCard:(UserID)uid;
- (void)gameRoomListHeaderViewShowOpenNobleTipCard;

@end

@interface TTRoomOnlineNobleHeaderView : UIView

@property (nonatomic, weak) id<XCGameRoomListHeaderViewDelegate> delegate;

- (void)configGameRoomListHeaderView:(NSArray *)nubleLists;
 
@end
