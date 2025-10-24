//
//  TTPersonEditImageCell.h
//  TuTu
//
//  Created by Macx on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserPhoto;
@interface TTPersonEditImageCell : UITableViewCell
@property (nonatomic, strong) UILabel  *titleLabel;//
@property (nonatomic, strong) NSArray<UserPhoto *>  *photos;//
@end
