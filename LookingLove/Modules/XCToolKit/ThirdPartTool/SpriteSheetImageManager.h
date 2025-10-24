//
//  SpriteSheetImageManager.h
//  XChat
//
//  Created by Macx on 2018/5/11.
//  Copyright © 2018年 XC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYImage/YYSpriteSheetImage.h>

@interface SpriteSheetImageManager : NSObject
- (void)loadSpriteSheetImageWithURL:(NSURL *_Nullable)url
        completionBlock:(void ( ^ _Nonnull )(YYSpriteSheetImage * _Nullable sprit))completionBlock
           failureBlock:(void ( ^ _Nullable)(NSError * _Nullable error))failureBlock;


/**
 * 这里与UI 协定 一张横向长图 每个帧 都是通过高度 来获取 正方形
 **/

+ (YYSpriteSheetImage *_Nullable)createSpriteSheet:(UIImage *_Nullable)image;

/**** --------------------- 帧长  ----------------------- ****/

- (void)loadSpriteSheetImageWithURL:(NSURL *_Nullable)url
                     frameDurations:(CGFloat)frameDurations
                    completionBlock:(void ( ^ _Nonnull )(YYSpriteSheetImage * _Nullable sprit))completionBlock
                       failureBlock:(void ( ^ _Nullable)(NSError * _Nullable error))failureBlock;


/**
 * 这里与UI 协定 一张横向长图 每个帧 都是通过高度 来获取 正方形
 * frameDurations 帧长
 **/

+ (YYSpriteSheetImage *_Nullable)createSpriteSheet:(UIImage *_Nullable)image frameDurations:(CGFloat)frameDurations;

+ (YYSpriteSheetImage *_Nullable)createSpriteSheet:(UIImage *_Nullable)image frameDurations:(CGFloat)frameDurations recetWidth:(CGFloat)width recetHeight:(CGFloat)height spriteCount:(NSInteger)spriteCount ;
@end
