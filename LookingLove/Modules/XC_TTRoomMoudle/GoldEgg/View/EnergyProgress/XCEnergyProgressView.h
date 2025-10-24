//
//  XCEnergyProgressView.h
//  XCRoomMoudle
//
//  Created by JarvisZeng on 2019/5/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XCEnergyProgressViewDelegate <NSObject>
- (void)onEnergyProgressViewLuckyValueQuestionCliked;
@end

@interface XCEnergyProgressView : UIView
@property (nonatomic, weak) id<XCEnergyProgressViewDelegate> delegate;
@property (nonatomic, assign) CGFloat progressValue; // progress value

- (void)updateProgressWithRanges:(NSArray <NSNumber *> *)ranges;
- (void)removeBoxView;
@end

NS_ASSUME_NONNULL_END
