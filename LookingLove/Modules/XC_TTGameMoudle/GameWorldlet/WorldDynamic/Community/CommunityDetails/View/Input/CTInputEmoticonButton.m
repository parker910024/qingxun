//
//  CTInputEmoticonButton.m
//  CTKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CTInputEmoticonButton.h"
#import "UIImage+NIMKit.h"
#import "CTInputEmoticonManager.h"

@implementation CTInputEmoticonButton

+ (CTInputEmoticonButton*)iconButtonWithData:(CTInputEmoticon*)data catalogID:(NSString*)catalogID delegate:( id<CTEmoticonButtonTouchDelegate>)delegate{
    CTInputEmoticonButton* icon = [[CTInputEmoticonButton alloc] init];
    [icon addTarget:icon action:@selector(onIconSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage nim_fetchEmoticon:data.filename];

    icon.emoticonData    = data;
    icon.catalogID              = catalogID;
    icon.userInteractionEnabled = YES;
    icon.exclusiveTouch         = YES;
    icon.contentMode            = UIViewContentModeScaleToFill;
    icon.delegate               = delegate;
    [icon setImage:image forState:UIControlStateNormal];
    [icon setImage:image forState:UIControlStateHighlighted];
    return icon;
}



- (void)onIconSelected:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(selectedEmoticon:catalogID:)])
    {
        [self.delegate selectedEmoticon:self.emoticonData catalogID:self.catalogID];
    }
}

@end
