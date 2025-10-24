//
//  WithDrawalList.h
//  BberryCore
//
//  Created by gzlx on 2017/7/12.
//  Copyright © 2017年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface WithDrawalInfo : BaseObject

@property (copy, nonatomic)NSString *cashProdId;
@property (copy, nonatomic)NSString *cashProdName;
@property (copy, nonatomic)NSString *diamondNum;
@property (copy, nonatomic)NSString *cashNum;
@property (copy, nonatomic)NSString *seqNo;

/**记录是否被选中*/
@property(nonatomic, assign) bool isSelect;
@end
