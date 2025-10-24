//
//  XCDiamondBoxBuyLabel.h
//  XCRoomMoudle
//
//  Created by JarvisZeng on 2019/5/10.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XCDiamondBoxBuyLabelDelegate <NSObject>
- (void)onDiamondBoxBuyButtonCliked;
@end

@interface XCDiamondBoxBuyLabel : UIView
@property (nonatomic, weak) id<XCDiamondBoxBuyLabelDelegate> delegate;
- (void)updateKeyNumber:(int)keyNumber;
@end

NS_ASSUME_NONNULL_END
