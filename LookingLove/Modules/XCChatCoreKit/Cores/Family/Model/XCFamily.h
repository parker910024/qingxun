//
//  XCFamily.h
//  BberryCore
//
//  Created by 卫明何 on 2018/5/24.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "BaseObject.h"
#import "XCFamilyModel.h"
#import "XCFamilyMoneyModel.h"
#import "BannerInfo.h"


typedef NS_ENUM(NSInteger, FamilyMemberPosition) {
    FamilyMemberPositionOwen = 10,//族长
    FamilyMemberPositionMember = 0, //成员
};

typedef NS_ENUM(NSInteger, UserInFamily){
    UserInFamilyYES = 1,
    UserInFamilyNO = 0,
};

typedef enum : NSUInteger {
    FamilyNotificationType_CreatSuccess     = 1, //创建家族成功
    FamilyNotificationType_Inter            = 2, //加入家族成功
    FamilyNotificationType_Outer            = 3, //退出家族成功
    FamilyNotificationType_BeKicked         = 4, //被踢出家族
    FamilyNotificationType_Dismiss          = 5, //解散家族成功
    FamilyNotificationType_Enter_Group      = 6, //加入群成功
    FamilyNotificationType_Quit_Group       = 7, //退出群成功
    FamilyNotificationType_Enter_Family_Group = 8, //加入家族并且加入群
    FamilyNotificationType_System_Award = 9, //系统奖励家族币
    FamilyNotificationType_System_Discount = 10, //系统扣除家族币
    FamilyNotificationType_Trade_Money = 11, //交易家族币
    FamilyNotificationType_Donate_Money = 12, //贡献家族币
} FamilyNotificationType;

@interface XCFamily : BaseObject
@property (strong, nonatomic) NSString *familyName;//家族名称
@property (strong, nonatomic) NSString *familyId;//家族id
@property (strong, nonatomic) NSString *familyIcon;//家族头像
@property (strong, nonatomic) NSString *memberCount;//家族成员数
@property (nonatomic, strong) NSString * background;//最强王者的背景图
//@property (strong, nonatomic) NSString *coinName;
@property (assign, nonatomic) FamilyMemberPosition position;//职位 10 是族长 0是成员
@property (nonatomic,assign) float redPacketRate;//xcRedColor费率
@property (nonatomic,assign) float gameRate;//游戏费率

@property (nonatomic, assign) double familyMoney;//家族币
@property (nonatomic, assign) UserInFamily enterStatus;//是否在该家族 1是 0不是
@property (nonatomic, strong) NSString * moneyName;//家族代币的名称
@property (nonatomic, strong) NSMutableArray<XCFamilyModel *> * games;//游戏列表
@property (nonatomic, strong) NSMutableArray<XCFamilyModel *> * members;//成员信息 在该家族才有数据
@property (nonatomic, strong) NSMutableArray<XCFamilyModel *> * groups;//群组列表
@property (nonatomic, strong) XCFamilyModel *  leader;//族长信息 不在该家族没有该数据
@property (nonatomic, strong) NSString * verifyType;//是否需要校验
@property (nonatomic, assign) BOOL openMoney;//是不是开启了家族币
@property (nonatomic, assign) BOOL openGame;//是不是开启了游戏

@property (nonatomic, assign) double  income;//总的收入
@property (nonatomic, assign) double  cost;//总的消耗
@property (nonatomic, assign) double totalAmount;//家族币的总的金额
@property (nonatomic, strong) NSString * count;//家族币变化记录总数
@property (nonatomic, strong) NSMutableArray<XCFamilyMoneyModel *> *recordMonVos;//
@property (nonatomic, strong) XCFamilyMoneyModel * incomeAndCost;

//群聊交易记录
@property (nonatomic, assign) double  weekAmount;//本周流水
@property (nonatomic, strong) NSMutableArray<XCFamilyModel *> *weekRecords;//

//家族魅力值
@property (nonatomic, strong) NSMutableArray<XCFamilyModel *>* familys;//美丽家族

//萌声的
@property (nonatomic, strong) NSMutableArray<BannerInfo *>* panelList;
@property (nonatomic, strong) NSMutableArray<BannerInfo *>* advList;


@end

