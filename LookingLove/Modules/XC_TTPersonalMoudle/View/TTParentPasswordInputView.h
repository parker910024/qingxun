//
//  TTParentPasswordInputView.h
//  AFNetworking
//
//  Created by User on 2019/5/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTParentPasswordInputView : UIView

@property (nonatomic, strong) NSMutableArray *lbArray;

@property (nonatomic, strong) void (^returnBlock)(NSString *pwStr);

- (instancetype)initWithFrame:(CGRect)frame withNum:(NSInteger)num;

- (void)clearPassword;
    
@end

NS_ASSUME_NONNULL_END
