//
//  TTPersonEditRecordCell.h
//  TuTu
//
//  Created by Macx on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPersonEditRecordCell : UITableViewCell
@property (nonatomic, strong) UIButton  *recordBtn;//
@property (nonatomic, strong) UILabel  *recordTimeLabel;//
@property (nonatomic, strong) UILabel  *titleLabel;//
@property (nonatomic, strong) void (^tapRecordBlock)(void);//
@end
