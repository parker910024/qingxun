//
//  M80AttributedLabel+NIMKit
//  NIM
//
//  Created by chris.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "M80AttributedLabel+NIMKit.h"
#import "NIMInputEmoticonParser.h"
#import "NIMInputEmoticonManager.h"
#import "UIImage+NIMKit.h"
#import "XCTheme.h"

@implementation M80AttributedLabel (NIMKit)
- (void)nim_setText:(NSString *)text
{
    [self setText:@""];
    NSArray *tokens = [[NIMInputEmoticonParser currentParser] tokens:text];
    for (NIMInputTextToken *token in tokens)
    {
        if (token.type == NIMInputTokenTypeEmoticon)
        {
            NIMInputEmoticon *emoticon = [[NIMInputEmoticonManager sharedManager] emoticonByTag:token.text];
            UIImage *image = [UIImage nim_emoticonInKit:emoticon.filename];
            if (image)
            {
                [self appendImage:image
                          maxSize:CGSizeMake(18, 18)];
            }
        }
        else
        {
            NSString *text = token.text;
            [self appendText:text];
        }
    }
}

/// 动态回复评论
/// @param text 回复的消息内容
/// @param replyNickName 被回复人昵称 @XXX用户的昵称
- (void)nim_setText:(NSString *)text replyNickName:(NSString *)replyNickName {
    [self setText:@""];
    
    NSAttributedString *attName = [[NSAttributedString alloc] initWithString:replyNickName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : UIColorFromRGB(0x34A7FF)}];
    [self appendAttributedText:attName];
    
    NSArray *tokens = [[NIMInputEmoticonParser currentParser] tokens:text];
    for (NIMInputTextToken *token in tokens)
    {
        if (token.type == NIMInputTokenTypeEmoticon)
        {
            NIMInputEmoticon *emoticon = [[NIMInputEmoticonManager sharedManager] emoticonByTag:token.text];
            UIImage *image = [UIImage nim_emoticonInKit:emoticon.filename];
            if (image)
            {
                [self appendImage:image
                          maxSize:CGSizeMake(18, 18)];
            }
        }
        else
        {
            NSString *text = token.text;
            [self appendText:text];
        }
    }
}

@end
