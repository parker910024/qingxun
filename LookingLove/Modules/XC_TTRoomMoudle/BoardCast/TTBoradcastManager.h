//
//  TTBoradcastManager.h
//  TuTu
//
//  Created by KevinWang on 2018/11/21.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTBoradcastManager : NSObject

+(instancetype)shareManager;
- (void)showBoradCast:(NSMutableAttributedString *)content;
- (void)showBoradCast:(NSMutableAttributedString *)content width:(CGFloat)width;
- (void)showNamePlate:(NSArray *)array;//铭牌全服通知
@end




typedef void(^completeBlock)(BOOL finished);

@interface BoradCastView : UIView

@property (nonatomic,assign,getter=isFinished) BOOL finished;
@property (nonatomic, copy) completeBlock block;

- (void)animateWithCompleteBlock:(completeBlock)completed;
- (void)boradCastContent:(NSMutableAttributedString *)content;

@end





@interface AnimOperation : NSOperation

@property (nonatomic,strong) BoradCastView *boradCastView;

+ (instancetype)animOperationWithBoradCastView:(BoradCastView *)boradCastView finishedBlock:(void(^)(BOOL result))finishedBlock;

@end
