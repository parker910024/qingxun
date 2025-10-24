//
//  KEReportController.h
//  Kelo
//
//  Created by apple on 2019/5/20.
//  Copyright © 2019 wujie. All rights reserved.
//  匿名举报、帮助与建议

#import "BaseUIViewController.h"
#import "KEReportPictureCollectionView.h"
#import <SZTextView/SZTextView.h>
#import "LTReportTypeSelectView.h"

typedef NS_ENUM(NSInteger, KEReportClassType) {
    KEReportClassTypeReport,          // 举报
    KEReportClassTypeAdvice         // 帮助、建议
};

//0.用户举报 1.动态举报 2.评论举报 3.弹幕举报
typedef NS_ENUM(NSInteger, KEReportTypeValue) {
    KEReportTypeValueUser,            // 举报用户
    KEReportTypeValueDynamic,         // 举报动态
    KEReportTypeValueComment,         // 举报评论
    KEReportTypeValueBarrage          // 举报弹幕
};


@interface KEReportController : BaseUIViewController

@property (nonatomic, strong) UIScrollView *bgScrollView;
///举报、帮助
@property (nonatomic, assign) KEReportClassType type;
///输入框的背景view
@property (nonatomic, strong) UIView *textBgView;
@property (nonatomic, strong) SZTextView *textView;
@property (nonatomic, strong) UILabel *limitLab;
@property (nonatomic, strong) KEReportPictureCollectionView *pictureCollectionView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *commitBtn;
///举报类型选择
@property (nonatomic, strong) LTReportTypeSelectView *reportSelectView;
///被举报者的uid
@property (nonatomic, assign) long long toUid;
///举报类型 0.用户举报 1.动态举报 2.评论举报 3.弹幕举报
@property (nonatomic, assign) KEReportTypeValue reportType;
///被举报的评论id
@property (nonatomic, assign) long long toCommentId;
///被举报的动态id
@property (nonatomic, assign) long long dynamicId;
///被举报的弹幕id
@property (nonatomic, copy) NSString *barrageId;

@end
