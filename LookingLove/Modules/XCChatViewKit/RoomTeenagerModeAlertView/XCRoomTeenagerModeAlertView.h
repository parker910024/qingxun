//
//  XCRoomTeenagerModeAlertView.h
//  XCChatViewKit
//
//  Created by lee on 2019/8/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XCRoomTeenagerModeAlertViewBlock)(void);

@interface XCRoomTeenagerModeAlertView : UIView

@property (nonatomic, copy) XCRoomTeenagerModeAlertViewBlock roomTeenagerModeAlertBlock;

- (instancetype)initWithFrame:(CGRect)frame resMessage:(NSString *)resMsg;
@end

NS_ASSUME_NONNULL_END
