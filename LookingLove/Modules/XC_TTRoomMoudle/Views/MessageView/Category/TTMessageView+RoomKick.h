//
//  TTMessageView+RoomKick.h
//  TuTu
//
//  Created by KevinWang on 2018/11/8.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageView.h"

@interface TTMessageView (RoomKick)

- (void)handleKickCell:(TTMessageTextCell *)newCell model:(TTMessageDisplayModel *)model;

@end
