//
//  TTGroupManagerViewController.h
//  TuTu
//
//  Created by gzlx on 2018/11/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, GroupManagerModifyType){
    GroupManagerModifyType_Name = 1,
    GroupManagerModifyType_Avatar = 2,
    GroupManagerModifyType_Verify= 3,
};


@interface TTGroupManagerViewController : BaseTableViewController
@property (nonatomic,assign) NSInteger teamId;
@end

NS_ASSUME_NONNULL_END
