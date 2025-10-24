//
//  XCGoldHandlerView.h
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/22.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCBoxGoldView : UIView

@property (nonatomic, strong, readonly) UILabel *goldLabel;
@property (nonatomic, copy) void(^rechargeButtonClickBlock)(void);
@property (nonatomic, assign) BOOL isDiamondBox;
@end
