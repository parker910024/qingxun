//
//  TTRoomIntroduceAlertView.h
//  TuTu
//
//  Created by Macx on 2019/1/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RoomInfo;
@class TTRoomIntroduceAlertView;

@protocol TTRoomIntroduceAlertViewDelegate <NSObject>
@optional
/**
 点击了关闭按钮
 
 @param button 关闭按钮
 */
- (void)ttRoomIntroduceAlertView:(TTRoomIntroduceAlertView *)view didClickCloseButton:(UIButton *)button;
@end

@interface TTRoomIntroduceAlertView : UIView
/** roomInfo */
@property (nonatomic, strong) RoomInfo *roomInfo;
/** delegate */
@property (nonatomic, weak) id<TTRoomIntroduceAlertViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
