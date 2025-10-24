//
//  TTFamilyCreateGroupTableViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/11/3.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FamilyCreateGroupCellType){
    FamilyCreateGroupCellType_GroupImage,
    FamilyCreateGroupCellType_GroupName,
    FamilyCreateGroupCellType_GroupVer,
    FamilyCreateGroupCellType_GroupMem
};

@protocol TTFamilyCreateGroupTableViewCellDelegate <NSObject>
@optional
/** 按钮状态改变*/
- (void)switchValueChange:(UISwitch *)verSwitch;
/** 文字变化的时候*/
- (void)textFiledChangeWithString:(NSString *)text;

@end
NS_ASSUME_NONNULL_BEGIN

@interface TTFamilyCreateGroupTableViewCell : UITableViewCell
/**输入框*/
@property (nonatomic, strong) UITextField * textFiled;
/** 显示图片*/
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, assign) id<TTFamilyCreateGroupTableViewCellDelegate>delegate;
@property (nonatomic, assign) FamilyCreateGroupCellType groupType;
@property (nonatomic, strong) NSMutableDictionary * members;
/** 是不是需要验证*/
@property (nonatomic, strong) UISwitch * verSwitch;
/** 选择的人数*/
@property (nonatomic, strong) UILabel * numberPersonLabel;
/**标题*/
@property (nonatomic, strong) UILabel * titleLabel;

- (void)configFamilyInforWith:(NSString *)familyImageUrl;
@end

NS_ASSUME_NONNULL_END
