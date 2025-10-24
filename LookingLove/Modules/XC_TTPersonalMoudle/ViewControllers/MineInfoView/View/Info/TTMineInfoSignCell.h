//
//  TTMineInfoSignCell.h
//  TuTu
//
//  Created by lee on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TTMineInfoSignCellDelegate<NSObject>
- (void)clickShowSignBtn;
@end
@interface TTMineInfoSignCell : UITableViewCell
@property (nonatomic, weak) id<TTMineInfoSignCellDelegate>  delegate;//
@property (nonatomic, strong) UILabel  *titleLabel;//
@property (nonatomic, strong) UILabel  *signLabel;//
@property (nonatomic, strong) UIButton  *showSignbtn;//
@end

NS_ASSUME_NONNULL_END
