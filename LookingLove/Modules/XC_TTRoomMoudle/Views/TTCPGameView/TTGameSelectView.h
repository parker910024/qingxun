//
//  TTGameSelectView.h
//  AFNetworking
//
//  Created by User on 2019/4/26.
//

#import <UIKit/UIKit.h>

#import "TTCPGameCustomModel.h"
#import "CPGameListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTGameSelectView : UIView

@property (nonatomic, strong) CPGameListModel *gameModel;
@property (nonatomic, strong) TTCPGameCustomModel *model;

@end

NS_ASSUME_NONNULL_END
