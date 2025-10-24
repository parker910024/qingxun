//
//  TTMessageCell.h
//  TuTu
//
//  Created by KevinWang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SingleNobleInfo;

@interface TTMessageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)configCellWithAttributedString:(NSMutableAttributedString *)attributedString nobleInfo:(SingleNobleInfo *)nobleInfo;

@end
