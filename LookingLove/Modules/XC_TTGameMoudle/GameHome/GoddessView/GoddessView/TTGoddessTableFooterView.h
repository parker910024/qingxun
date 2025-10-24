//
//  TTGoddessTableFooterView.h
//  AFNetworking
//
//  Created by lvjunhang on 2019/6/3.
//  合拍女神的头部 - 没喜欢的？点击查看更多

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTGoddessViewDelegate;

@interface TTGoddessTableFooterView : UITableViewHeaderFooterView
@property (nonatomic, assign) id<TTGoddessViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
