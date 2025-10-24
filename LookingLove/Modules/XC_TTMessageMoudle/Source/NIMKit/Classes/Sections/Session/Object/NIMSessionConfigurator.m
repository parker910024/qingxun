//
//  NIMSessionConfigurator.m
//  NIMKit
//
//  Created by chris on 2016/11/7.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "NIMSessionConfigurator.h"
#import "NIMSessionMsgDatasource.h"
#import "NIMSessionInteractorImpl.h"
#import "NIMCustomLeftBarView.h"
#import "UIView+NIM.h"
#import "NIMMessageModel.h"
#import "NIMGlobalMacro.h"
#import "NIMSessionInteractorImpl.h"
#import "NIMSessionDataSourceImpl.h"
#import "NIMSessionLayoutImpl.h"
#import "NIMSessionTableAdapter.h"

/*
                                            NIMSessionViewController 类关系图
 
 
             .........................................................................
             .                                                                       .
             .                                                                       .
             .                                                                       .                  | ---> [NIMSessionDatasource]
             .                                                                       .
             .                                                       | ---> [NIMSessionInteractor] -->  |
             .
             .                                                                                          | ---> [NIMSessionLayout]
             .
             ↓
  [NIMSessionViewController]-------> [NIMSessionConfigurator] -----> |
             |
             |
             |
             |
             ↓                                                       | ---> [NIMSessionTableAdapter]
       [UITableView]                                                              .
            ↑                                                                     .
            .                                                                     .
            .                                                                     .
            .......................................................................
 */

@interface NIMSessionConfigurator()

@property (nonatomic,strong) NIMSessionInteractorImpl   *interactor;

@property (nonatomic,strong) NIMSessionTableAdapter     *tableAdapter;

@end

@implementation NIMSessionConfigurator

- (void)setup:(NIMSessionViewController *)vc
{
    NIMSession *session    = vc.session;
    id<NIMSessionConfig> sessionConfig = vc.sessionConfig;
    UITableView *tableView  = vc.tableView;
    NIMInputView *inputView = vc.sessionInputView;
    
    NIMSessionDataSourceImpl *datasource = [[NIMSessionDataSourceImpl alloc] initWithSession:session config:sessionConfig];
    NIMSessionLayoutImpl *layout         = [[NIMSessionLayoutImpl alloc] initWithSession:session config:sessionConfig];
    layout.tableView = tableView;
    layout.inputView = inputView;
    
    
    _interactor                          = [[NIMSessionInteractorImpl alloc] initWithSession:session config:sessionConfig];
    _interactor.delegate                 = vc;
    _interactor.dataSource               = datasource;
    _interactor.layout                   = layout;
    
    [layout setDelegate:_interactor];
    
    _tableAdapter = [[NIMSessionTableAdapter alloc] init];
    _tableAdapter.interactor = _interactor;
    _tableAdapter.delegate   = vc;
    vc.tableView.delegate = _tableAdapter;
    vc.tableView.dataSource = _tableAdapter;
    
    
    [vc setInteractor:_interactor];
}

- (void)setup:(NIMSessionViewController *)vc isPublic:(BOOL)isPublic {
    TTPublicNIMChatroomController *newVC = (TTPublicNIMChatroomController *)vc;
    NIMSession *session    = newVC.session;
    id<NIMSessionConfig> sessionConfig = newVC.sessionConfig;
    UITableView *tableView  = newVC.tableView;
    UIView *inputView = newVC.publicChatInputView;
    
    NIMSessionDataSourceImpl *datasource = [[NIMSessionDataSourceImpl alloc] initWithSession:session config:sessionConfig];
    NIMSessionLayoutImpl *layout         = [[NIMSessionLayoutImpl alloc] initWithSession:session config:sessionConfig];
    layout.tableView = tableView;
    layout.inputView = inputView;
    
    
    _interactor                          = [[NIMSessionInteractorImpl alloc] initWithSession:session config:sessionConfig];
    _interactor.delegate                 = newVC;
    _interactor.dataSource               = datasource;
    _interactor.layout                   = layout;
    
    [layout setDelegate:_interactor];
    
    _tableAdapter = [[NIMSessionTableAdapter alloc] init];
    _tableAdapter.interactor = _interactor;
    _tableAdapter.delegate   = newVC;
    vc.tableView.delegate = _tableAdapter;
    vc.tableView.dataSource = _tableAdapter;
    
    
    [newVC setInteractor:_interactor];
}


- (void)setupLittleWorld:(TTLittleWorldSessionViewController *)vc {
    TTLittleWorldSessionViewController *newVC = (TTLittleWorldSessionViewController *)vc;
    NIMSession *session    = newVC.session;
    id<NIMSessionConfig> sessionConfig = newVC.sessionConfig;
    UITableView *tableView  = newVC.tableView;
    UIView *inputView = newVC.publicChatInputView;
    
    NIMSessionDataSourceImpl *datasource = [[NIMSessionDataSourceImpl alloc] initWithSession:session config:sessionConfig];
    NIMSessionLayoutImpl *layout         = [[NIMSessionLayoutImpl alloc] initWithSession:session config:sessionConfig];
    layout.tableView = tableView;
    layout.inputView = inputView;
    
    
    _interactor                          = [[NIMSessionInteractorImpl alloc] initWithSession:session config:sessionConfig];
    _interactor.delegate                 = newVC;
    _interactor.dataSource               = datasource;
    _interactor.layout                   = layout;
    
    [layout setDelegate:_interactor];
    
    _tableAdapter = [[NIMSessionTableAdapter alloc] init];
    _tableAdapter.interactor = _interactor;
    _tableAdapter.delegate   = newVC;
    vc.tableView.delegate = _tableAdapter;
    vc.tableView.dataSource = _tableAdapter;
    
    
    [newVC setInteractor:_interactor];

}

@end
