//
//  TTGameRoomViewController+FunctionMenu.h
//  TuTu
//
//  Created by KevinWang on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTGameRoomViewController.h"
#import "XCFaceViewKitProtocol.h"

@interface TTGameRoomViewController (FunctionMenu)<XCFaceViewKitDelegate>

//更新toolBar状态
- (void)updateFunctionMenu;

@end
