//
//  LLDiscoverSquareTableViewCell.h
//  XC_TTDiscoverMoudle
//
//  Created by fengshuo on 2019/7/26.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLDiscoverSquareTableViewCell : UITableViewCell
/**家族广场*/
- (void)configDicoverSquareOrFamilyGuide:(NSDictionary *)modelDic;

- (void)updateCellContainerViewLayerWithTotal:(NSInteger)total row:(NSInteger)row;
@end

NS_ASSUME_NONNULL_END
