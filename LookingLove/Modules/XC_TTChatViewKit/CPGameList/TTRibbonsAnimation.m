//
//  TTRibbonsAnimation.m
//  GameMall
//
//  Created by zyc on 16/8/2.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "TTRibbonsAnimation.h"

#define EmitterColor_Red      [UIColor colorWithRed:254/255.0 green:56/255.0 blue:100/255.0 alpha:1.0]
#define EmitterColor_Yellow   [UIColor colorWithRed:255/255.0 green:219/255.0 blue:0/255.0 alpha:1.0]
#define EmitterColor_Purple   [UIColor colorWithRed:211/255.0 green:80/255.0 blue:255/255.0 alpha:1.0]
#define EmitterColor_Blue     [UIColor colorWithRed:115/255.0 green:234/255.0 blue:255/255.0 alpha:1.0]

#define EmitterColor_Green    [UIColor colorWithRed:100/255.0 green:255/255.0 blue:166/255.0 alpha:1.0]

@implementation TTRibbonsAnimation

+ (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    backgroundView.backgroundColor = UIColor.clearColor;
    backgroundView.userInteractionEnabled = NO;
    [window addSubview:backgroundView];
    
//    RewardSuccessWindow *centerImageView = [[RewardSuccessWindow alloc] initWithFrame:CGRectZero];
//    [backgroundView addSubview:centerImageView];
    //缩放
//    successWindow.transform=CGAffineTransformMakeScale(0.01f, 0.01f);
//    successWindow.alpha = 0;
//    [UIView animateWithDuration:0.4 animations:^{
//
//        successWindow.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//        successWindow.alpha = 1;
//    }];

    //3s 消失
    double delayInSeconds = 2.0;
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^(void){
        [backgroundView removeFromSuperview];
    });
    
    //开始粒子效果
    CAEmitterLayer *emitterLayer = addEmitterLayer(backgroundView);
    startAnimate(emitterLayer);
    
}

CAEmitterLayer *addEmitterLayer(UIView *backgroundView)
{

    //色块粒子
    CAEmitterCell *subCell1 = subCell(imageWithColor(EmitterColor_Red));
    subCell1.name = @"red";
    CAEmitterCell *subCell2 = subCell(imageWithColor(EmitterColor_Yellow));
    subCell2.name = @"yellow";
    CAEmitterCell *subCell3 = subCell(imageWithColor(EmitterColor_Purple));
    subCell3.name = @"purple";
    CAEmitterCell *subCell4 = subCell(imageWithColor(EmitterColor_Blue));
    subCell4.name = @"blue";
    CAEmitterCell *subCell5 = subCell(imageWithColor(EmitterColor_Green));
    subCell4.name = @"green";
    
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = CGPointMake(backgroundView.bounds.size.width * 0.5, 0);
    emitterLayer.emitterSize	= backgroundView.bounds.size;
    emitterLayer.emitterMode	= kCAEmitterLayerSurface;
    emitterLayer.emitterShape	= kCAEmitterLayerLine;
    emitterLayer.renderMode		= kCAEmitterLayerOldestFirst;
    
    emitterLayer.emitterCells = @[subCell1,subCell2,subCell3,subCell4,subCell5];
    [backgroundView.layer addSublayer:emitterLayer];
    
    return emitterLayer;
    
}

void startAnimate(CAEmitterLayer *emitterLayer)
{
    CABasicAnimation *redBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.red.birthRate"];
    redBurst.fromValue		= [NSNumber numberWithFloat:15];
    redBurst.toValue			= [NSNumber numberWithFloat:  0.0];
    redBurst.duration		= 0.5;
    redBurst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    CABasicAnimation *yellowBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.yellow.birthRate"];
    yellowBurst.fromValue		= [NSNumber numberWithFloat:15];
    yellowBurst.toValue			= [NSNumber numberWithFloat:  0.0];
    yellowBurst.duration		= 0.5;
    yellowBurst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    CABasicAnimation *blueBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.purple.birthRate"];
    blueBurst.fromValue		= [NSNumber numberWithFloat:15];
    blueBurst.toValue			= [NSNumber numberWithFloat:  0.0];
    blueBurst.duration		= 0.5;
    blueBurst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    CABasicAnimation *starBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.blue.birthRate"];
    starBurst.fromValue		= [NSNumber numberWithFloat:15];
    starBurst.toValue			= [NSNumber numberWithFloat:  0.0];
    starBurst.duration		= 0.5;
    starBurst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *greenBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.green.birthRate"];
    greenBurst.fromValue        = [NSNumber numberWithFloat:15];
    greenBurst.toValue            = [NSNumber numberWithFloat:  0.0];
    greenBurst.duration        = 0.5;
    greenBurst.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    CAAnimationGroup *group = [CAAnimationGroup animation];
     group.animations = @[redBurst,yellowBurst,blueBurst,starBurst,greenBurst];
    
    [emitterLayer addAnimation:group forKey:@"heartsBurst"];
}

CAEmitterCell *subCell(UIImage *image)
{
    CAEmitterCell * cell = [CAEmitterCell emitterCell];
    
    cell.name = @"heart";
    cell.contents = (__bridge id _Nullable)image.CGImage;
    
    // 缩放比例
    cell.scale      = 0.6;
    cell.scaleRange = 0.6;
    // 每秒产生的数量
    //    cell.birthRate  = 40;
    cell.lifetime   = 3;
    // 每秒变透明的速度
    //    snowCell.alphaSpeed = -0.7;
    //    snowCell.redSpeed = 0.1;
    // 秒速
    cell.velocity      = 200;
    cell.velocityRange = 200;
    cell.yAcceleration = 200;

//    cell.xAcceleration = 0;
    //掉落的角度范围
//    cell.emissionRange  = M_PI;
    cell.emissionLongitude = M_PI;
    cell.scaleSpeed		= -0.05;
    ////    cell.alphaSpeed		= -0.3;
    cell.spin			= 2 * M_PI;
    cell.spinRange		= 2 * M_PI;
    
    return cell;
}

UIImage *imageWithColor(UIColor *color)
{
    CGRect rect = CGRectMake(0, 0, 13, 17);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
