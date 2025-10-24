//
//  TTRoomeMessageNavView.h
//  TTPlay
//
//  Created by Jenkins on 2019/3/8.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTRoomeMessageNavViewDelegate <NSObject>

- (void)backButtonClick:(UIButton *)sender;

@end

@interface TTRoomeMessageNavView : UIView
/** 显示名字*/
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, assign) id<TTRoomeMessageNavViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
