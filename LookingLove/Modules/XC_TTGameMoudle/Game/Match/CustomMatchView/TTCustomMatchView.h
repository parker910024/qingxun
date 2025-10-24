//
//  TTCustomMatchView.h
//  TTPlay
//
//  Created by new on 2019/4/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserID.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTCustomMatchView : UIView

@property (nonatomic, strong) NSString *imageUrlString;

@property (nonatomic, assign) UserID userID;

- (void)startAnimation;

@end

NS_ASSUME_NONNULL_END
