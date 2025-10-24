//
//  TTUserCarPreviewView.h
//  TuTu
//
//  Created by Macx on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserCar;
@protocol TTUserCarPreviewViewDelegate<NSObject>
- (void)carOrderViewDidDismiss;
@end

@interface TTUserCarPreviewView : UIView
@property (nonatomic, strong) UserCar *car;
@property (nonatomic, weak) id<TTUserCarPreviewViewDelegate> delegate;
@end
