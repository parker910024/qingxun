//
//  CTInputEmoticonParser.h
//  CTKit
//
//  Created by chris.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger
{
    CTInputTokenTypeText,
    CTInputTokenTypeEmoticon,
    
} CTInputTokenType;

@interface CTInputTextToken : NSObject
@property (nonatomic,copy)      NSString    *text;
@property (nonatomic,assign)    CTInputTokenType   type;
@end


@interface CTInputEmoticonParser : NSObject
+ (instancetype)currentParser;
- (NSArray *)tokens:(NSString *)text;
@end
