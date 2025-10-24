//
//  TTNotFriendWarnView.h
//  TTPlay
//
//  Created by 卫明 on 2019/2/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTNotFriendWarnView : UIView

@property (strong, nonatomic) NSString *friendID;

@property (nonatomic,weak) UITableView *tableView;

/**
 初始化方法

 @param userId 必传
 @param frame frame
 @return self
 */
- (instancetype)initWithUserId:(NSString *)userId frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
