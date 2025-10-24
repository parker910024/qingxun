//
//  TTWorldListEmptyDataView.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/7/5.
//  我加入的世界列表无数据占位图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTWorldListEmptyDataView : UIView
@property (nonatomic, copy) void (^actionBlock)(void);
@end

NS_ASSUME_NONNULL_END
