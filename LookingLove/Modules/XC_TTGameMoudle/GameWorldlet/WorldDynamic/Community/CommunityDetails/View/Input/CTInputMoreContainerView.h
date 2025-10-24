//
//  NTESInputMoreContainerView.h
//  CTDemo
//
//  Created by chris.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMSessionConfig.h"
#import "NIMInputProtocol.h"


@interface CTInputMoreContainerView : UIView

@property (nonatomic,weak)  id<NIMSessionConfig> config;
@property (nonatomic,weak)  id<NIMInputActionDelegate> actionDelegate;

@end
