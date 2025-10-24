//
//  TTMinePhotoCell.h
//  TuTu
//
//  Created by lee on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class UserPhoto;


@protocol TTMinePhotoCellDelegate<NSObject>

- (void)showPhotosEditController;
@end

@interface TTMinePhotoCell : UITableViewCell

@property (nonatomic, weak) id<TTMinePhotoCellDelegate> delegate;//
@property (nonatomic, assign) long long userID;//
@property (nonatomic, strong) NSArray<UserPhoto *> *privatePhoto;
@end

NS_ASSUME_NONNULL_END
