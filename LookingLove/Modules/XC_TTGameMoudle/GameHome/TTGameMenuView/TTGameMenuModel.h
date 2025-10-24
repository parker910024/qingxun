//
//  TTGameMenuModel.h
//  AFNetworking
//
//  Created by lee on 2019/6/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTGameMenuModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;

+ (TTGameMenuModel *)normalModelWtiTitle:(NSString *)title
                              titleColor:(UIColor *)titleColor;

@end

NS_ASSUME_NONNULL_END
