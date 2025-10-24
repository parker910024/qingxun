//
//  TTMissionGuideAlertView.h
//  AFNetworking
//
//  Created by lee on 2019/4/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TTGuideViewDismissHandler)(void);

@interface TTMissionGuideAlertView : UIView

@property (nonatomic, copy) TTGuideViewDismissHandler dismissHandler;

 /**
 使用此初始化方法

 @param frame frame
 @param stepPic 图片地址 urlString
 */
- (instancetype)initWithFrame:(CGRect)frame withStepPic:(NSString *)stepPic;

@end

NS_ASSUME_NONNULL_END
