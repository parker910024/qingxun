//
//  TTPublicSearchController.h
//  TuTu
//
//  Created by 卫明 on 2018/11/7.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class TTPublicSearchController;

@protocol TTPublicSearchControllerDelegate <NSObject>

/**
 点击用户信息

 @param vc self
 @param info 用户信息
 */
- (void)onSearchVC:(TTPublicSearchController *)vc didSelectedUserInfo:(UserInfo *)info;

@end

@interface TTPublicSearchController : UIViewController

@property (nonatomic,weak) id<TTPublicSearchControllerDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
