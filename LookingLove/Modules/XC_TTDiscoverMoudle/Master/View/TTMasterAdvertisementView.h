//
//  TTMasterAdvertisementView.h
//  TTPlay
//
//  Created by Macx on 2019/1/16.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MasterAdvertisementModel;

@interface TTMasterAdvertisementView : UIView
/** models */
@property (nonatomic, strong) NSArray<MasterAdvertisementModel *> *models;

- (void)stopCountDown;
@end

NS_ASSUME_NONNULL_END
