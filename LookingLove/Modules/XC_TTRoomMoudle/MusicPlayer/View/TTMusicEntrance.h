//
//  TTMusicEntrance.h
//  TuTu
//
//  Created by Mac on 2018/10/31.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//
//房间播放器入口

#import <UIKit/UIKit.h>


@class TTMusicEntrance;

@protocol TTMusicEntranceDelegate <NSObject>


- (void)onDidTapToShowMusicPlayerMusicEntrance:(TTMusicEntrance *)entrance;

@end

@interface TTMusicEntrance : UIView

@property (nonatomic,weak) id<TTMusicEntranceDelegate> delegate;

@end
