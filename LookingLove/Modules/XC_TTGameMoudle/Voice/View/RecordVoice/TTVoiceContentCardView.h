//
//  TTVoiceContentCardView.h
//  XC_TTGameMoudle
//
//  Created by fengshuo on 2019/6/4.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceBottlePiaModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TTVoiceContentCardViewDelegate <NSObject>

- (void)reloadDataChangeNext;

@end


@interface TTVoiceContentCardView : UIView

/**
 *
 */
@property (nonatomic,assign) BOOL isShowReload;;

/**
 *
 */
@property (nonatomic,assign) id<TTVoiceContentCardViewDelegate> delegate;

/** 剧本*/
@property (nonatomic,strong) VoiceBottlePiaModel *picModel;

/** 清楚数据*/
- (void)clearData;

@end

NS_ASSUME_NONNULL_END
