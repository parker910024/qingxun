//
//  TTSendRedBagView.h
//  AFNetworking
//
//  Created by ShenJun_Mac on 2020/5/11.
//

#import <UIKit/UIKit.h>
#import "RoomRedConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTSendRedBagView : UIView
@property (nonatomic, strong) RoomRedConfig *config;
@property (nonatomic, copy) void (^sendRedBagSuccessBlock)(void);//发红包成功
@end

NS_ASSUME_NONNULL_END
