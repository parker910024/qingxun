//
//  TTQYServiceView.h
//  TTPlay
//
//  Created by fengshuo on 2019/3/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <XCThirdPartyFrameworks/QYSDK.h>
#import "NIMBadgeView.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTQYServiceTableViewCell : UITableViewCell

@property (nonatomic,strong) NIMBadgeView *badgeView;

/** 更新view*/
- (void)refresh;


//- (void)onReceiveQYMessageUpdateUI:(QYMessageInfo *)message;
@end

NS_ASSUME_NONNULL_END
