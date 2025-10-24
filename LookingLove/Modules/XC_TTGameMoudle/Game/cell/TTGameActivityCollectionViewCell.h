//
//  TTGameActivityCollectionViewCell.h
//  AFNetworking
//
//  Created by User on 2019/5/6.
//

#import <UIKit/UIKit.h>
@class ActivityInfo;
NS_ASSUME_NONNULL_BEGIN

@interface TTGameActivityCollectionViewCell : UICollectionViewCell

- (void)configWithUrlStr:(ActivityInfo *)info;
    
@end

NS_ASSUME_NONNULL_END
