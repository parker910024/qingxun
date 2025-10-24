//
//  TTCarrotHeadView.h
//  TTPlay
//
//  Created by lee on 2019/3/15.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CarrotWallet;
NS_ASSUME_NONNULL_BEGIN

typedef void(^TTCarrotHeadSelectHandler)(NSInteger index);

@interface TTCarrotHeadView : UIView
@property (nonatomic, strong) CarrotWallet *carrotWalletInfo;
@property (nonatomic, copy) TTCarrotHeadSelectHandler selectHandler;
@end

NS_ASSUME_NONNULL_END
