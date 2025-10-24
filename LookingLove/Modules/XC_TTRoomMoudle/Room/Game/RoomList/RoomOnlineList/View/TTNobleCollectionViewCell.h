//
//  TuTuNobleCollectionViewCell.h
//  XChat
//
//  Created by Mac on 2018/1/16.
//  Copyright © 2018年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnLineNobleInfo.h"

@interface TTNobleCollectionViewCell : UICollectionViewCell

- (void)configCellWithUserModel:(OnLineNobleInfo *)userInfo;
 
@end
