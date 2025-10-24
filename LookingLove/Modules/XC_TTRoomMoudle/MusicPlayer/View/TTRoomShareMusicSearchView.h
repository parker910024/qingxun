//
//  TTRoomShareMusicSearchView.h
//  TTPlay
//
//  Created by Macx on 2019/3/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TTRoomShareMusicSearchView;

@protocol TTRoomShareMusicSearchViewDelegate<NSObject>

@required
/**
 点击取消按钮
 
 @param searchView self
 @param cancleButton button
 */
- (void)roomShareMusicSearchView:(TTRoomShareMusicSearchView *)searchView didClickCancleButton:(UIButton *)cancleButton;

/**
 点击搜索区域, 变为搜索状态
 
 @param searchView self
 @param contentView contentView
 */
- (void)roomShareMusicSearchView:(TTRoomShareMusicSearchView *)searchView didClickSearchContent:(UIView *)contentView;
@end

@interface TTRoomShareMusicSearchView : UIView
/** delegate */
@property (weak,nonatomic) id<TTRoomShareMusicSearchViewDelegate> delegate;
/** 搜索框 */
@property (nonatomic, strong, readonly) UITextField *textField;
@end

NS_ASSUME_NONNULL_END
