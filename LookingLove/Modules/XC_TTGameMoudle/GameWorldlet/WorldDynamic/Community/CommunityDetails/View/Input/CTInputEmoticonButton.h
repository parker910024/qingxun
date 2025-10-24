//
//  CTInputEmoticonButton.h
//  CTKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTInputEmoticon;

@protocol CTEmoticonButtonTouchDelegate <NSObject>

- (void)selectedEmoticon:(CTInputEmoticon*)emoticon catalogID:(NSString*)catalogID;

@end



@interface CTInputEmoticonButton : UIButton

@property (nonatomic, strong) CTInputEmoticon *emoticonData;

@property (nonatomic, copy)   NSString         *catalogID;

@property (nonatomic, weak)   id<CTEmoticonButtonTouchDelegate> delegate;

+ (CTInputEmoticonButton*)iconButtonWithData:(CTInputEmoticon*)data catalogID:(NSString*)catalogID delegate:( id<CTEmoticonButtonTouchDelegate>)delegate;

- (void)onIconSelected:(id)sender;

@end
