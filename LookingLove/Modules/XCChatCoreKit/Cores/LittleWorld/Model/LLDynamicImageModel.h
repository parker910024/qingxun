//
//  LLDynamicImageModel.h
//  XC_TTGameMoudle
//
//  Created by Lee on 2019/11/23.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLDynamicImageModel : BaseObject
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *resUrl;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@end

NS_ASSUME_NONNULL_END
