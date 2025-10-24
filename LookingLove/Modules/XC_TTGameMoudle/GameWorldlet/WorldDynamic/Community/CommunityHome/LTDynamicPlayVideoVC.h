//
//  LTDynamicPlayVideoVC.h
//  LTChat
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019 wujie. All rights reserved.
// 动态播放视频

#import "BaseUIViewController.h"
#import "CTDynamicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTDynamicPlayVideoVC : BaseUIViewController

@property (nonatomic, strong) NSString *videoUrl;

@property (nonatomic, strong) UIImage * coverImage;

@property (nonatomic, strong) CTDynamicModel *dynamicModel;


@end

NS_ASSUME_NONNULL_END
