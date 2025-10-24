//
//  TTUserCardBottomFunctionContentView.h
//  TuTu
//
//  Created by 卫明 on 2018/11/17.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserCore.h"
#import "UserInfo.h"

#import "TTUserCardFunctionItem.h"


NS_ASSUME_NONNULL_BEGIN

@interface TTUserCardBottomFunctionContentView : UIView
/** 当前的用户信息*/
@property (nonatomic, strong) UserInfo * currentInfor;

- (instancetype)initWithFrame:(CGRect)frame actionUid:(UserID)actionUid;

@property (strong, nonatomic) NSMutableArray<TTUserCardFunctionItem *> *opeButtonArray;

@end

NS_ASSUME_NONNULL_END
