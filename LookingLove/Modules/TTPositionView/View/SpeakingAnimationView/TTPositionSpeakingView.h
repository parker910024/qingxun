//
//  TTPositionSpeakingView.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/20.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTPositionSpeakingView : UIView
@property(nonatomic,strong)UIColor *circleColor;
@property(nonatomic,strong)UIColor *borderColor;
@property(assign,nonatomic)NSInteger pulsingCount;
@property(assign,nonatomic)NSInteger repeatCount;
@property(assign,nonatomic)double animationDuration;
@property(assign, nonatomic) BOOL removeAfterFinish;

@property (assign, nonatomic) BOOL isAnimate;


-(instancetype)initWithFrame:(CGRect)frame;
- (void)start:(int)tag;
- (void)remove:(int)tag;
@end

NS_ASSUME_NONNULL_END
