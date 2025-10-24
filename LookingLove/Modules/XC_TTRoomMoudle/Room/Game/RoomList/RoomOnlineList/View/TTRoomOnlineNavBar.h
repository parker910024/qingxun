//
//  TTRoomOnlineNavBar.h
//  TuTu
//
//  Created by lvjunhang on 2018/11/9.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTRoomOnlineNavBarDelegate <NSObject>
@required
- (void)navBarDidNavBack;
@end

@interface TTRoomOnlineNavBar : UIView
@property (nonatomic, weak) id<TTRoomOnlineNavBarDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
