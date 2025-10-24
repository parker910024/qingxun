//
//  TTSendGiftSegmentItem.h
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTSendGiftSegmentItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isSelected;

+ (instancetype)itemWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
