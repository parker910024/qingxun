//
//  CTEmoticonParser.m
//  CTKit
//
//  Created by chris.
//  Copyright (c) 2015 Netease. All rights reserved.
// CT

#import "CTInputEmoticonParser.h"
#import "CTInputEmoticonManager.h"

@implementation CTInputTextToken
@end

@interface CTInputEmoticonParser ()
@property (nonatomic,strong)    NSCache *tokens;
@end


@implementation CTInputEmoticonParser
+ (instancetype)currentParser
{
    static CTInputEmoticonParser *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CTInputEmoticonParser alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _tokens = [[NSCache alloc] init];
    }
    return self;
}

- (NSArray *)tokens:(NSString *)text
{
    NSArray *tokens = nil;
    if ([text length])
    {
        tokens = [_tokens objectForKey:text];
        if (tokens == nil)
        {
            tokens = [self parseToken:text];
            [_tokens setObject:tokens
                        forKey:text];
        }
    }
    return tokens;
}

- (NSArray *)parseToken:(NSString *)text
{
    NSMutableArray *tokens = [NSMutableArray array];
    static NSRegularExpression *exp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        exp = [NSRegularExpression regularExpressionWithPattern:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
                                                        options:NSRegularExpressionCaseInsensitive
                                                          error:nil];
    });
    __block NSInteger index = 0;
    [exp enumerateMatchesInString:text
                          options:0
                            range:NSMakeRange(0, [text length])
                       usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                           NSString *rangeText = [text substringWithRange:result.range];
                           if ([[CTInputEmoticonManager sharedManager] emoticonByTag:rangeText])
                           {
                               if (result.range.location > index)
                               {
                                   NSString *rawText = [text substringWithRange:NSMakeRange(index, result.range.location - index)];
                                   CTInputTextToken *token = [[CTInputTextToken alloc] init];
                                   token.type = CTInputTokenTypeText;
                                   token.text = rawText;
                                   [tokens addObject:token];
                               }
                               CTInputTextToken *token = [[CTInputTextToken alloc] init];
                               token.type = CTInputTokenTypeEmoticon;
                               token.text = rangeText;
                               [tokens addObject:token];

                               index = result.range.location + result.range.length;
                           }
                       }];
    
    if (index < [text length])
    {
        NSString *rawText = [text substringWithRange:NSMakeRange(index, [text length] - index)];
        CTInputTextToken *token = [[CTInputTextToken alloc] init];
        token.type = CTInputTokenTypeText;
        token.text = rawText;
        [tokens addObject:token];
    }
    return tokens;
}
@end
