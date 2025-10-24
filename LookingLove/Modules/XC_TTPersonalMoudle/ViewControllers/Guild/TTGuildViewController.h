//
//  TTGuildViewController.h
//  TuTu
//
//  Created by lee on 2018/12/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "BaseUIViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TTGuildNameRefreshHandler)(NSString *guildName);

@interface TTGuildViewController : BaseUIViewController
@property (nonatomic, copy) TTGuildNameRefreshHandler guildNameRefreshHandler;
@end

NS_ASSUME_NONNULL_END
