//
//  TTEmptyMusicListView.h
//  TuTu
//
//  Created by Macx on 2018/11/22.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTEmptyMusicListView;

@protocol TTEmptyMusicListViewDelegate <NSObject>

@optional

/**
 音乐空列表的电脑传输歌曲按钮被点击
 
 @param emptyMusicView 音乐空列表View self
 @param addMusicClick 被点击的按钮
 */
- (void)emptyMusicListView:(TTEmptyMusicListView *)emptyMusicView addMusicButtonClick:(UIButton *)addMusicClick;

/**
 音乐空列表的添加共享音乐按钮被点击
 
 @param emptyMusicView 音乐空列表View self
 @param addShareMusicButton 被点击的按钮
 */
- (void)emptyMusicListView:(TTEmptyMusicListView *)emptyMusicView addShareMusicButtonClick:(UIButton *)addShareMusicButton;

@end

@interface TTEmptyMusicListView : UIView

/**
 delegate:TTEmptyMusicListViewDelegate
 */
@property (nonatomic,weak) id<TTEmptyMusicListViewDelegate> delegate;
@end
