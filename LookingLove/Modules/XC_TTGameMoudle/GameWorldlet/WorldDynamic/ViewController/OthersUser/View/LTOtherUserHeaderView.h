//
//  LTOtherUserHeaderView.h
//  LTChat
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019 wujie. All rights reserved.
//  他人的头部view

#import <UIKit/UIKit.h>


@interface LTOtherUserHeaderView : UIView

///播放视频控制器
//@property (nonatomic, strong) KEShortVideoPlayViewControler *videoPlayVc;

/**
 创建他人头部view

 @param uid uid
 @return 返回头部视图
 */
- (instancetype)initWithOtherUid:(NSString *)uid;


@end
