//
//  TTPublicAtSearchCancelBar.h
//  TuTu
//
//  Created by 卫明 on 2018/11/7.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TTPublicAtSearchCancelBar;
@protocol TTPublicAtSearchCancelBarDelegate <NSObject>
@optional

/**
 搜索按钮被点击
 
 @param searchBar self
 @param key 关键字
 */
- (void)onSearchCancelBar:(TTPublicAtSearchCancelBar *)searchBar searhWithKey:(NSString *)key;

/**
 取消按钮被点击

 @param searchBar self
 */
- (void)onSearchCancelDidClickBar:(TTPublicAtSearchCancelBar *)searchBar;

@end

@interface TTPublicAtSearchCancelBar : UIView

@property (nonatomic,weak) id<TTPublicAtSearchCancelBarDelegate> delegate;


/**
 搜索框输入框
 */
@property (strong, nonatomic) UITextField *searchField;

@end

NS_ASSUME_NONNULL_END
