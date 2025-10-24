//
//  TTMusicListTableViewCell.h
//  TuTu
//
//  Created by Macx on 2018/11/22.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

//model
#import "MusicInfo.h"

@class TTMusicListTableViewCell;

@protocol TTMusicListTableViewCellDelegate<NSObject>

@required
/**
 点击歌曲删除按钮
 
 @param cell TTMusicListTableViewCell self
 @param indexPath 点击是indexPath
 */
- (void)onTTMusicListTableViewCell:(TTMusicListTableViewCell *)cell deleteSongAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TTMusicListTableViewCell : UITableViewCell
/**
 cell的indexPath
 */
@property (strong, nonatomic) NSIndexPath * indexPath;

/**
 delegate:XCMusicListTableViewCellDelegate
 */
@property (weak,nonatomic) id<TTMusicListTableViewCellDelegate> delegate;
@property (assign, nonatomic) BOOL isOnline;

/**
 复制音乐信息
 
 @param musicInfo 音乐实体
 */
- (void)ttUpdateMusicInfo:(MusicInfo *)musicInfo;
@end
