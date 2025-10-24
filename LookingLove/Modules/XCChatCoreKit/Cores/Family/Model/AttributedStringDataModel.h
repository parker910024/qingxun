//
//  AttributedStringDataModel.h
//  BberryCore
//
//  Created by 卫明何 on 2018/5/28.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttributedStringDataModel : NSObject
@property (strong, nonatomic) NSMutableAttributedString *attributedString;
@property (assign, nonatomic) BOOL isComplete;
@end
