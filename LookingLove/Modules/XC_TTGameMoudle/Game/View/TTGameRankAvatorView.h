//
//  TTGameRankAvatorView.h
//  TTPlay
//
//  Created by new on 2019/3/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTGameRankAvatorView : UIView

- (void)configWithGameName:(NSString *)gameName ImageArray:(NSArray *)avatorArray Success:(void (^)(BOOL success))success;


@end

NS_ASSUME_NONNULL_END
