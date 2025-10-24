//
//  TTRedBagGuideView.h
//  AFNetworking
//
//  Created by ShenJun_Mac on 2020/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTRedBagGuideView : UIView
/**
 引导完成回调
 */
@property (nonatomic, copy) void (^didFinishGuide)(void);
@end

NS_ASSUME_NONNULL_END
