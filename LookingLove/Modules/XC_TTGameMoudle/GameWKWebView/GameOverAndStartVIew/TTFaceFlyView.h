//
//  TTFaceFlyView.h
//  AFNetworking
//
//  Created by new on 2019/4/19.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTFaceFlyView : UIView

@property (nonatomic, strong) NSString *imageString;

- (void)animateInView:(UIView *)view withDirection:(BOOL )directionType;

@end

NS_ASSUME_NONNULL_END
