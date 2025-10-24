//
//  TTSessionGuideView.h
//  AFNetworking
//
//  Created by apple on 2019/6/6.
//

#import <UIKit/UIKit.h>

typedef void(^returnChatterbox)(void);

NS_ASSUME_NONNULL_BEGIN

@interface TTSessionGuideView : UIView

@property (nonatomic, copy) returnChatterbox chatterbox;

@end

NS_ASSUME_NONNULL_END
