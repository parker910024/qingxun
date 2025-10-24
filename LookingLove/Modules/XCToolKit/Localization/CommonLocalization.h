//
//  CommonLocalization.h
//  Commons
//
//  Created by daixiang on 13-10-9.
//  Copyright (c) 2013年 YY Inc. All rights reserved.
//

#ifndef Commons_CommonLocalization_h
#define Commons_CommonLocalization_h

#import <UIKit/UIKit.h>

extern NSString *getLocalizedString(NSString *key);
extern NSString *getLocalizedStringFromTable(NSString *key, NSString *table, __unused NSString *comment);
extern NSString *getLocalizedStringFromTableWithFallback(NSString *key, NSString *table, NSString *fallback, __unused NSString *comment);

#endif
