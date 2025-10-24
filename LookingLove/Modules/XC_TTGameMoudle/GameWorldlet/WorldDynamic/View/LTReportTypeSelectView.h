//
//  LTReportTypeSelectView.h
//  LTChat
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019 wujie. All rights reserved.
//  获取举报类型view

#import <UIKit/UIKit.h>
@class LTReportModel;

@interface LTReportTypeSelectView : UIView
///举报的模型数据
@property (nonatomic, weak) LTReportModel *reportModel;

@end
