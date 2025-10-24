//
//  TTFamilySearchView.h
//  TuTu
//
//  Created by gzlx on 2018/11/9.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTFamilySearchViewDelegate <NSObject>

- (void)touchCancleDismissSearch;

- (void)searchViewTextFileTextChange:(UITextField *)textfiled;

@end

@interface TTFamilySearchView : UIView

@property (nonatomic, assign) id<TTFamilySearchViewDelegate> delegate;
/** 搜索输入框*/
@property (nonatomic, strong) UITextField * textFiled;
@end

NS_ASSUME_NONNULL_END
