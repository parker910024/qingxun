//
//  TTPickMicContentView.h
//  WanBan
//
//  Created by lvjunhang on 2020/10/13.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTPickMicContentView : UIView
- (instancetype)initWithRoomType:(RoomType)roomType uid:(UserID)uid;
@end

NS_ASSUME_NONNULL_END
