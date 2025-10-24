//
//  XCOpenLiveAlertMessageContentView.m
//  XChat
//
//  Created by 何卫明 on 2017/10/15.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCOpenLiveAlertMessageContentView.h"
#import "UIView+NTES.h"
#import "XCOpenLiveAlertMessageView.h"
#import "XCOpenLiveAttachment.h"
#import "UIImageView+QiNiu.h"
#import "XCTheme.h"
#import "XCMediator+TTRoomMoudleBridge.h"

@interface XCOpenLiveAlertMessageContentView()
@property (strong, nonatomic) XCOpenLiveAlertMessageView *contentView;
@end

@implementation XCOpenLiveAlertMessageContentView

- (instancetype)initSessionMessageContentView {
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        self.contentView  = [[XCOpenLiveAlertMessageView alloc] init];
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data {
    [super refresh:data];
    NIMCustomObject *object = (NIMCustomObject *)data.message.messageObject;
    XCOpenLiveAttachment *customObject = (XCOpenLiveAttachment*)object.attachment;
    if (customObject.nick && customObject.nick.length > 0) {
        [self.contentView.avatar qn_setImageImageWithUrl:customObject.avatar placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
        [self.contentView.subTitle setText:[NSString stringWithFormat:@"%@上线啦",customObject.nick]];
    }else {
        __block NIMUser *user = [[NIMUser alloc]init];
        NSArray *uids = @[[NSString stringWithFormat:@"%lld",customObject.uid]];

        [[NIMSDK sharedSDK].userManager fetchUserInfos:uids completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
            if (error == nil) {
                user = users[0];
                [self.contentView.avatar qn_setImageImageWithUrl:user.userInfo.avatarUrl placeholderImage:[[XCTheme defaultTheme] default_avatar] type:ImageTypeUserIcon];
                [self.contentView.subTitle setText:[NSString stringWithFormat:@"%@上线啦",user.userInfo.nickName]];
            }
        }];
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGFloat tableViewWidth = self.superview.width;
    CGSize contentSize = [self.model contentSize:tableViewWidth];
    CGRect imageViewFrame = CGRectMake(contentInsets.left - 10, contentInsets.top, contentSize.width, contentSize.height);
    self.contentView.frame  = imageViewFrame;
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = 13.0;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = self.contentView.bounds;
    self.contentView.layer.mask = maskLayer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NIMCustomObject *object = (NIMCustomObject *)self.model.message.messageObject;
    XCOpenLiveAttachment *customObject = (XCOpenLiveAttachment*)object.attachment;
    [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:customObject.uid];
}

@end
