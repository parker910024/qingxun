//
//  TTFamilyShareChildViewController.h
//  TuTu
//
//  Created by gzlx on 2018/11/19.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ZJScrollPageView.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, TTFamilyShare_Type){
    TTFamilyShare_Type_FriendList = 1,
    TTFamilyShare_Type_Focus = 2,
    TTFamilyShare_Type_Fans = 3,
    TTFamilyShare_Type_Group = 4,
};

typedef void(^returnCustomTitleNumber)(NSInteger index);

@interface TTFamilyShareChildViewController : BaseTableViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, assign) TTFamilyShare_Type childShareType;

@property (nonatomic, copy) returnCustomTitleNumber customTitleBlock;
@end

NS_ASSUME_NONNULL_END
