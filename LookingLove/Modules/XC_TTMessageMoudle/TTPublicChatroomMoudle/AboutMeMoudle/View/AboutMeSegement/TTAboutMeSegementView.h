//
//  TTAboutMeSegementView.h
//  TuTu
//
//  Created by 卫明 on 2018/11/4.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTAboutMeSegementChildView.h"

NS_ASSUME_NONNULL_BEGIN

@class TTAboutMeSegementView;

@protocol TTAboutMeSegementViewDelegate <NSObject>
@optional
/**
 被点击

 @param segement segement
 @param segementType 点击事件
 */
- (void)onTTAboutMeSegementView:(TTAboutMeSegementView *)segement
          childSegementWasClick:(TTAboutMeSegementViewClickType)segementType;

@end

@interface TTAboutMeSegementView : UIView

@property (nonatomic,weak) id<TTAboutMeSegementViewDelegate> delegate;

@property (nonatomic,assign) TTAboutMeSegementViewClickType currentType;

@end

NS_ASSUME_NONNULL_END
