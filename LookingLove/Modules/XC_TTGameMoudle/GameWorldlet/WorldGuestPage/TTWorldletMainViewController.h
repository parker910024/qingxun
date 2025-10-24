//
//  TTWorldletMainViewController.h
//  AFNetworking
//
//  Created by apple on 2019/7/1.
//

#import "BaseTableViewController.h"
#import "LittleWorldListModel.h"
#import <JXPagingView/JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface TTWorldletMainViewController : BaseTableViewController<JXPagerViewListViewDelegate>

@property (nonatomic, strong) LittleWorldListItem *model;
/** 是不是房间进去的*/
@property (nonatomic,assign) BOOL isFromRoom;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@end

NS_ASSUME_NONNULL_END
