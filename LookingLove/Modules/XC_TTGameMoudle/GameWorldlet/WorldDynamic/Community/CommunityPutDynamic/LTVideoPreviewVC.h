//
//  LTVideoPreviewVC.h
//  LTChat
//
//  Created by apple on 2019/7/26.
//  Copyright © 2019 wujie. All rights reserved.
//

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTVideoPreviewVC : BaseUIViewController

@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) UIImage *coverImage;

@property (nonatomic, copy) void (^deleteVideo)();

@end

NS_ASSUME_NONNULL_END
