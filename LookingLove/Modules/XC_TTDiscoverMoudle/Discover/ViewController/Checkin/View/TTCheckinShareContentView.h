//
//  TTCheckinShareContentView.h
//  TTPlay
//
//  Created by lvjunhang on 2019/3/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  分享内容视图，用于截图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTCheckinShareContent : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *shareContent;
@end

@interface TTCheckinShareContentView : UIView
@property (nonatomic, strong) TTCheckinShareContent *model;

- (void)captureImageWithModel:(TTCheckinShareContent *)model completion:(void(^)(UIImage *image))completion;

@end

NS_ASSUME_NONNULL_END
