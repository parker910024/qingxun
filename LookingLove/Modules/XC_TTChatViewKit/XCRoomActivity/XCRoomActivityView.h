//
//  XCRoomActivityView.h
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/27.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XCRoomActivityView,ActivityInfo;
@protocol XCRoomActivityViewDelegate <NSObject>
@optional
- (void)roomActivityView:(XCRoomActivityView *)activityView jumbByActivityInfo:(ActivityInfo *)activityInfo;

@end

@interface XCRoomActivityView : UIImageView

@property (nonatomic, weak) id<XCRoomActivityViewDelegate> delegate;

@end
