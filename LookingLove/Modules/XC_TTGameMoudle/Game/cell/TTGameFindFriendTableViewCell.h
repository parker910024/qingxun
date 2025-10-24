//
//  TTGameFindFriendTableViewCell.h
//  AFNetworking
//
//  Created by new on 2019/4/16.
//

#import <UIKit/UIKit.h>

@protocol TTGameFindFriendTableViewCellDelegate <NSObject>

- (void)jumpFindFriendPage;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTGameFindFriendTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TTGameFindFriendTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
