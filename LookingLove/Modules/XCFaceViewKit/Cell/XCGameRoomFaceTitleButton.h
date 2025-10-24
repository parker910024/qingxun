//
//  XCGameRoomFaceTitleButton.h
//  AFNetworking
//
//  Created by lvjunhang on 2018/11/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCGameRoomFaceTitleButton : UIButton
/**
 标题
 */
@property (nonatomic, copy) NSString *title;
/**
 默认标题颜色，默认：[UIColor colorWithWhite:1 alpha:0.4]
 */
@property (nonatomic, strong) UIColor *normalTitleColor;
/**
 选中标题颜色，默认：[UIColor colorWithWhite:1 alpha:1]
 */
@property (nonatomic, strong) UIColor *selectTitleColor;
/**
 下划线颜色，默认：[UIColor colorWithWhite:1 alpha:0.4]
 */
@property (nonatomic, strong) UIColor *underlineColor;

/**
 是否显示下划线，默认：NO
 */
@property (nonatomic, assign) BOOL isShowUnderline;

@end

NS_ASSUME_NONNULL_END
