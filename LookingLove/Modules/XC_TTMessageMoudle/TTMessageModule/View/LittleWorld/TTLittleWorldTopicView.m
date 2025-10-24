//
//  TTLittleWorldTopicView.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/6/28.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTLittleWorldTopicView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

@interface TTLittleWorldTopicView ()<TTLittleWorldPartyPersonViewDelegate>

@end


@implementation TTLittleWorldTopicView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}
#pragma mark - pubulic method
/** 给话题的view赋值*/
- (void)updateTTLittleWorldTopicViewFrameWithType:(TTLittleWorldTopicViewType)type teamPartyModel:(LittleWorldTeamModel *)partyModel isCreateEr:(BOOL)isCreate {
    self.partyView.hidden = YES;
    self.editTopicView.hidden = YES;
    if (type == TTLittleWorldTopicViewType_OnLineAndTopic) {
        self.partyView.hidden = NO;
        self.editTopicView.hidden = NO;
        [self.partyView updateLittleWorldPartyNumberPersonWithPerson:partyModel.count];
        self.editTopicView.titleLabel.text = partyModel.topic;
        [self.partyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
        }];
    
    }else if (type == TTLittleWorldTopicViewType_Topic) {
        self.editTopicView.hidden = NO;
        self.editTopicView.titleLabel.text = partyModel.topic;
        
        [self.partyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }]; 
    }
    self.editTopicView.editButton.hidden = !isCreate;
}

#pragma mark - response
- (void)editButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ttLittleWorldTopicView:managerEditTopicAction:)]) {
        [self.delegate ttLittleWorldTopicView:self managerEditTopicAction:sender];
    }
}

- (void)closeButtonAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ttLittleWorldTopicView:closeNumberPerson:)]) {
        [self.delegate ttLittleWorldTopicView:self closeNumberPerson:sender];
    }
}

#pragma mark - TTLittleWorldPartyPersonViewDelegate
- (void)ttLittleWorldPartyPersonViewCheckPartyInTeam:(TTLittleWorldPartyPersonView *)view {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ttLittleWorldTopicViewCheckNumberPerson:)]) {
        [self.delegate ttLittleWorldTopicViewCheckNumberPerson:self];
    }
}

#pragma mark - private method
- (void)initView {
    self.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self addSubview:self.editTopicView];
    [self addSubview:self.partyView];
    
    [self.editTopicView.editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.partyView.closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initContrations {
    [self.editTopicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.partyView.mas_bottom).offset(14);
        make.height.mas_equalTo(76);
    }];
    
    [self.partyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - setters and getters
- (TTLittleWorldPartyPersonView *)partyView {
    if (!_partyView) {
        _partyView = [[TTLittleWorldPartyPersonView alloc] init];
        _partyView.delegate = self;
    }
    return _partyView;
}

- (TTLittleWorldEditTopicView *)editTopicView {
    if (!_editTopicView) {
        _editTopicView = [[TTLittleWorldEditTopicView alloc] init];
    }
    return _editTopicView;
}

@end
