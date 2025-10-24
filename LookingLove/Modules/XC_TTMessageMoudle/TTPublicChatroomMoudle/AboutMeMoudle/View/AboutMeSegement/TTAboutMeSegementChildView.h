//
//  TTAboutMeSegementChildView.h
//  TuTu
//
//  Created by 卫明 on 2018/11/4.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTAboutMeSegementChildView;

typedef enum : NSUInteger {
    TTAboutMeSegementViewClickType_AtMe = 1,        //@我的
    TTAboutMeSegementViewClickType_SendFromMe = 2,  //我发出的
} TTAboutMeSegementViewClickType;

@protocol TTAboutMeSegementChildViewDelegate <NSObject>

- (void)onAboutMeSegementChildView:(TTAboutMeSegementChildView *)childView wasClickWthType:(TTAboutMeSegementViewClickType)type;

@end

@interface TTAboutMeSegementChildView : UIView

@property (nonatomic,copy) NSString *title;

@property (nonatomic,assign) TTAboutMeSegementViewClickType type;

@property (strong, nonatomic) UIColor *titleColor;

@property (nonatomic,weak) id<TTAboutMeSegementChildViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
