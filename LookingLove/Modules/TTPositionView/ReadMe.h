//
//  ReadMe.h
//  TTPositionView
//
//  Created by fengshuo on 2019/5/27.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#ifndef ReadMe_h
#define ReadMe_h

/**
 codeReview
 
 基本的架构-PositionView持有了CoreManager和UIManager 这两个类一个处理core的逻辑 一个处理UI,所以以后关于麦位的东西 请不要在控制器里面去写东西 要完全和控制器解耦 控制器只负责添加和更新positionView
 
 文件夹里面的东西
 1.Manager: 存放了TTPositionCoreManager和TTPositionUIManager 两个都是单例  一个监听Core 处理core里面的方法  一个处理UI方面的东西  包含往PositionView是添加子view containView(不处理子View的布局)
 2.Object: 这个文件夹 存放了 TTPositionViewDatasourceImpl(处理来自Core的通知 一般是处理子view的赋值问题)  TTPositionViewDatasourceProtocol(处理子View赋值问题的协议)  TTPositionViewUIImpl(处理子ViewUI上的问题，包含子view的约束，是否隐藏什么东西，各个模式间的兼容问题)  TTPositionViewUIProtocol(处理UI问题的协议)
 3.Model:模型
 4.Config:TTRoomPositionConfig(坑位上面的配置信息)  TTPositionHelper(一个工具类)
 5.View:每个子View
 
 扩展性
 1.如果房间坑位有新的模式的话 请根据新的需求 监听Core然后再CoreManager里面处理逻辑 如果需要在坑位上添加新的子View 请根据判断是不是所有的坑位必须添加 如果不是所有的坑位 都必须添加的话 请根据需求正确配置(比如房间的土豪位只会出现在7麦 房主离开模式 只会出现大头位)
 2.监听到CoreManager里面的变化的时候 根据需求 调用UIManager做相应的处理
 3.赋值的时候 只需coreManager去调用TTPositionViewDatasourceProtocol然后TTPositionViewDatasourceImpl去实现相应的协议 同理对TTPositionViewUIProtocol同样使用
 
其他
  需要delloc或者layoutSubView的时候 只需position调用TTPositionViewUIProtocol 然后根据需求 在合适的地方实现 positionViwLayoutSubViews或者positionViewDelloc即可
 */





#endif /* ReadMe_h */
