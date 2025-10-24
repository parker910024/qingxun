//
//  TTSendRedBagTextField.h
//  AFNetworking
//
//  Created by ShenJun_Mac on 2020/5/11.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, TTSendRedBagTextFieldType) {
    TTSendRedBagTextFieldTypeCount,//红包个数
    TTSendRedBagTextFieldTypeCoin,//金币总数
    TTSendRedBagTextFieldTypeCondition,//发红包条件
    TTSendRedBagTextFieldTypeMessage,//红包留言
};

NS_ASSUME_NONNULL_BEGIN

@interface TTSendRedBagTextField : UIView

@property(nonatomic, strong) UITextField *textField;

@property(nonatomic, strong) UILabel *unitLabel;

@property(nonatomic, strong) UIImageView *rightImageView;

- (instancetype)initWithType:(TTSendRedBagTextFieldType)type;
@end

NS_ASSUME_NONNULL_END
