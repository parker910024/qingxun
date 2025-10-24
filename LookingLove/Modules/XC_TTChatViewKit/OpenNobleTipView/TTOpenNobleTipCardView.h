//
//  TTOpenNobleTipCardView.h
//  TuTu
//
//  Created by KevinWang on 2018/11/19.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTOpenNobleTipCardView;
@protocol TTOpenNobleTipCardViewDelegate<NSObject>

@optional
- (void)openNobleTipCardViewDidClose:(TTOpenNobleTipCardView *)cardView;
- (void)openNobleTipCardViewDidGotoOpenNoble:(TTOpenNobleTipCardView *)cardView;

@end

@interface TTOpenNobleTipCardView : UIView

@property (nonatomic, weak) id<TTOpenNobleTipCardViewDelegate> delegate;

- (instancetype)initWithCurrentLevel:(NSString *)currentLevel  doAction:(NSString *)action needLevel:(NSString *)needLevel;

@end
