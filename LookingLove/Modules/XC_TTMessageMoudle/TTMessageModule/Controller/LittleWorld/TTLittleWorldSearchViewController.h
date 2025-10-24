//
//  TTLittleWorldSearchViewController.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/5.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "BaseUIViewController.h"
#import "LittleWolrdMember.h"
NS_ASSUME_NONNULL_BEGIN
@class TTLittleWorldSearchViewController;
@protocol TTLittleWorldSearchViewControllerDelegate <NSObject>

@optional
- (void)onsearchVC:(TTLittleWorldSearchViewController *)vc littleWorldSerachMember:(LittleWolrdMember *)meber isDelete:(BOOL)isDelete;

@end


@interface TTLittleWorldSearchViewController : BaseUIViewController

/** 代理*/
@property (nonatomic,assign) id<TTLittleWorldSearchViewControllerDelegate> delegate;

/** 搜索的那个世界的id*/
@property (nonatomic,assign) UserID worldId;

/** 身份*/
@property (nonatomic,assign) TTWorldLetType type;
@end

NS_ASSUME_NONNULL_END
