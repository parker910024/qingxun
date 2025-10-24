//
//  TTGameMatchTableViewCell.h
//  AFNetworking
//
//  Created by new on 2019/4/16.
//

#import <UIKit/UIKit.h>

@protocol TTGameMatchTableViewCellDelegate <NSObject>

- (void)oppositeSexBtnMatchClick;

- (void)hiChatBtnMatchClick;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTGameMatchTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TTGameMatchTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
