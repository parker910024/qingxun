//
//  LLPublicHeadView.h
//  XC_TTDiscoverMoudle
//
//  Created by fengshuo on 2019/7/25.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickActionHandle)(void);
@interface LLPublicHeadView : UIView
@property (nonatomic, copy) ClickActionHandle clickHandle;
@end

NS_ASSUME_NONNULL_END
