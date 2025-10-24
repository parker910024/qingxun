//
//  XCBoxTypeSelectView.h
//  XCRoomMoudle
//
//  Created by JarvisZeng on 2019/5/5.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxStatus.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    XCBoxSelectType_Normal, // 黄金宝箱
    XCBoxSelectType_Diamond, // 钻石宝箱
} XCBoxSelectType;

@protocol XCBoxTypeSelectViewDelegate
@required
- (void)onBoxTypeSelected:(XCBoxSelectType)boxType;
@end

@interface XCBoxTypeSelectView : UIView
@property (nonatomic, weak) id<XCBoxTypeSelectViewDelegate> delegate;
- (void)updateBoxStatus:(BoxStatus *)status;
@end

NS_ASSUME_NONNULL_END
