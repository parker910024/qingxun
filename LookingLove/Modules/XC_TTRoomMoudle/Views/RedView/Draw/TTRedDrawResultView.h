//
//  TTRedDrawResultView.h
//  AFNetworking
//
//  Created by ShenJun_Mac on 2020/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    TTRedDrawResultViewTypeSuccess = 0,//抢到了
    TTRedDrawResultViewTypeSnow = 1,//手慢了
    TTRedDrawResultViewTypeOver = 2,//结束了
} TTRedDrawResultViewType;

typedef NS_ENUM(NSInteger, TTRedDrawResultViewAction) {//红包列表操作类型
    TTRedDrawResultViewActionSend,//发红包
    TTRedDrawResultViewActionRecord,//红包记录
};



@interface TTRedDrawResultView : UIView
@property (nonatomic, strong) UIImageView *bgView;

- (instancetype)initWithType:(TTRedDrawResultViewType)type data:(NSString * _Nullable) data;

@property (nonatomic, copy) void (^resultViewBlock)(TTRedDrawResultViewAction action);//领取对应奖励


/// 金额增加动画
- (void)countAnimation;

@end

NS_ASSUME_NONNULL_END
