//
//  TTFamilyMemberTableViewCell.h
//  TuTu
//
//  Created by gzlx on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCFamilyModel.h"
#import "GroupMemberModel.h"
#import "FamilyCore.h"
#import "UserInfo.h"
#import "SearchResultInfo.h"
NS_ASSUME_NONNULL_BEGIN

@protocol TTFamilyMemberTableViewCellDelegate <NSObject>

- (void)handleFamilyMemberTableViewWith:(XCFamilyModel *)familyModel groupModel:(GroupMemberModel *)groupModel listType:(FamilyMemberListType)listType typeButton:(UIButton *)sender;

@end

@interface TTFamilyMemberTableViewCell : UITableViewCell
/** 家族成员列表的赋值*/
- (void)configFamilyMemberWith:(XCFamilyModel *)familyModel;
/** 群成员的赋值*/
- (void)configGroupMemberWith:(GroupMemberModel*)groupMember;
/** 分享的时候 给cell 赋值*/
- (void)configShareCellWith:(UserInfo *)infor;
/** 搜索的时候*/
- (void)configSearchShareCellWith:(SearchResultInfo *)infor;

#pragma mark - 搜索的时候赋值
/** 家族广场搜索的赋值*/
- (void)configSearchFamilyWith:(XCFamily *)family;

@property (nonatomic, assign) FamilyMemberListType listType;
/** 创建群的时候 选择了成员 再次进去的时候*/
@property (nonatomic, strong) NSMutableDictionary * selectMemberDic;

@property (nonatomic, assign) id<TTFamilyMemberTableViewCellDelegate>delegate;

/*状态按钮，用于邀请好友时，多选的状态 */
@property (nonatomic, strong) UIButton *inviteButton;

@end

NS_ASSUME_NONNULL_END
