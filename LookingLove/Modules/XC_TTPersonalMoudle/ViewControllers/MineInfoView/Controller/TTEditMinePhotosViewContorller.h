//
//  TTEditMinePhotosViewContorller.h
//  TuTu
//
//  Created by lee on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class UserInfo;
@protocol TTEditMinePhotosViewContorllerDelegate <NSObject>

- (void)photoDataReload:(UserInfo *)userInfo;

@end


@interface TTEditMinePhotosViewContorller : BaseUIViewController

@property (nonatomic, assign) long long uid;
@property (nonatomic, weak) id<TTEditMinePhotosViewContorllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
