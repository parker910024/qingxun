//
//  TTMessageView+RoomTip.h
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView.h"

@interface TTMessageView (RoomTip)

- (void)handleRoomTipCell:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model;

@end

