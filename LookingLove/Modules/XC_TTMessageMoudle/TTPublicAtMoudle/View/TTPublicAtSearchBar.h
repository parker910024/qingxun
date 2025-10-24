//
//  TTPublicAtSearchBar.h
//  TuTu
//
//  Created by 卫明 on 2018/11/7.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTPublicAtSearchBar;

@protocol TTPublicAtSearchBarDelegate <NSObject>
@optional
/**
 搜索按钮被点击

 @param searchBar self
 @param key 关键字
 */
- (void)onSearchBar:(TTPublicAtSearchBar *)searchBar searhWithKey:(NSString *)key;

/**
 搜索框被点击

 @param searchBarDidClick self
 */
- (void)onSearchBarClick:(TTPublicAtSearchBar *)searchBarDidClick;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTPublicAtSearchBar : UIView

@property (nonatomic,weak) id<TTPublicAtSearchBarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
