//
//  HomebaseModel.h
//  BberryCore
//
//  Created by Apple on 2018/4/27.
//  Copyright © 2018年 chenran. All rights reserved.
//

#import "MonsterGameModel.h"
#import "PanelInfor.h"
#import "BannerInfo.h"
#import "UserInfo.h"

typedef NS_ENUM(NSInteger, HeadLineTipType){
    HeadLineTipTypeAtme = 1,//最新
    HeadLineTipTypeNews = 2,//@wo
    HeadLineTipTypeMonst = 3,//打怪
    
};



@interface HomebaseModel : MonsterGameModel


//banner
@property (nonatomic, strong)NSString *bannerId;
@property (nonatomic, strong)NSString *bannerName;
@property (nonatomic, strong)NSString *bannerPic;
@property (nonatomic, strong)NSString *skipUri;
@property (nonatomic, assign)NSInteger skipType;// 1跳app页面，2跳聊天室，3跳h5页面
@property (nonatomic, assign)NSInteger seqNo;//排序

@property (nonatomic, strong) NSArray<BannerInfo *> * topBannerList;//bannner
@property (nonatomic, strong) NSArray<PanelInfor *> * panelList;//快捷入口

//tag
@property (nonatomic, assign) int id;  //quary use
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pict;
@property (nonatomic, assign) int seq;
@property (nonatomic, assign) int type;

@property (nonatomic, assign) HeadLineTipType tipType;//1 是@我   2 是最新  3是打怪
@property (nonatomic, assign) int paramType;
@property (nonatomic, strong) NSString * time;//发布的时间
@property (nonatomic, strong) NSString * img;//头条的图片
@property (nonatomic, strong) NSString * param;

@property(nonatomic, copy) NSString *roomPwd;
@property (nonatomic, copy)NSString *avatar;
@property(nonatomic, copy) NSString *backPic;
@property (nonatomic, copy) NSString *badge;
@property(nonatomic, assign) UserGender gender;
@property (nonatomic, assign) BOOL isRecom;
@property(nonatomic, copy) NSString *nick;
@property(nonatomic, assign) NSInteger onlineNum;
@property(nonatomic, assign) NSInteger operatorStatus;
@property(nonatomic, copy) NSString *roomDesc;
@property(nonatomic, assign) NSInteger roomId;
@property(nonatomic, copy) NSString *roomTag;
@property(nonatomic, assign) int tagId;
@property(nonatomic, copy) NSString *tagPict;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) UserID uid;

@end
