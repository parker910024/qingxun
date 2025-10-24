//
//  TTMessageHeaderView.h
//  TuTu
//
//  Created by KevinWang on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTMessageHeaderView;
@class RoomInfo;

@protocol TTMessageHeaderViewDelegate<NSObject>
@optional
// 点击了 "点击房间话题查看本房间玩法"
- (void)ttMessageHeaderView:(TTMessageHeaderView *)headerView didClickTipView:(UILabel *)tipLabel;
@end

@interface TTMessageHeaderView : UIView
/** delegate */
@property (nonatomic, weak) id<TTMessageHeaderViewDelegate> delegate;

/** roomInfo */
@property (nonatomic, strong) RoomInfo *roomInfo;
@end
