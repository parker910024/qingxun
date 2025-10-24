//
//  NIMSessionTableDelegate.m
//  NIMKit
//
//  Created by chris on 2016/11/7.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "NIMSessionTableAdapter.h"
#import "NIMMessageModel.h"
#import "NIMMessageCellFactory.h"
#import "TTPublicMessageCell.h"
#import "UIView+NIM.h"
#import "Attachment.h"
//custom
#import <YYText/YYText.h>
#import "TTGameStaticTypeCore.h"
#import "NSArray+Safe.h"
@interface NIMSessionTableAdapter()

@property (nonatomic,strong) NIMMessageCellFactory *cellFactory;

@end

@implementation NIMSessionTableAdapter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cellFactory = [[NIMMessageCellFactory alloc] init];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTablckeView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.interactor items].count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    id model = [[self.interactor items] safeObjectAtIndex:indexPath.row];
    if ([model isKindOfClass:[NIMMessageModel class]]) {
        NIMMessageModel *md = (NIMMessageModel *)model;
        if (md.message.session.sessionType == NIMSessionTypeChatroom) {
            cell = [self.cellFactory publicCellInTable:tableView forMessageMode:md];
            [(TTPublicMessageCell *)cell setDelegate:self.delegate];
            [(TTPublicMessageCell *)cell setMessageModel:model];
            
        }else {
            cell = [self.cellFactory cellInTable:tableView
                                  forMessageMode:model];
            [(NIMMessageCell *)cell setDelegate:self.delegate];
            [(NIMMessageCell *)cell refreshData:model];
        }
        
    }
    else if ([model isKindOfClass:[NIMTimestampModel class]])
    {
        cell = [self.cellFactory cellInTable:tableView
                                     forTimeModel:model];
    }
    else
    {
        NSAssert(0, @"not support model");
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
    {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0;
    id modelInArray = [[self.interactor items] objectAtIndex:indexPath.row];
    if ([modelInArray isKindOfClass:[NIMMessageModel class]])
    {
        NIMMessageModel *model = (NIMMessageModel *)modelInArray;
        if (model.message.session.sessionType == NIMSessionTypeChatroom) {
            YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake([UIScreen mainScreen].bounds.size.width * 0.67, CGFLOAT_MAX) text:model.messageAttributedString];
            cellHeight = layout.textBoundingSize.height + 64;
            NIMCustomObject *object = (NIMCustomObject *)model.message.messageObject;
            if (object) {
                if ([object.attachment isKindOfClass:Attachment.class]) {
                    Attachment *attachment = (Attachment *)object.attachment;
                    if (attachment.first == Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification) {
                        if (attachment.second == Custom_Noti_Sub_CPGAME_PrivateChat_SysNoti_GameOver) {
                            cellHeight = layout.textBoundingSize.height + 20;
                        }
                    }else if (attachment.first == Custom_Noti_Header_CPGAME_PublicChat_Respond){
                        if (attachment.second == Custom_Noti_Sub_CPGAME_PublicChat_Respond_Cancel) {
                            cellHeight = 0;
                        }
                        
                    }else if (attachment.first == Custom_Noti_Header_Red) {
                        if (attachment.second == Custom_Noti_Sub_Red_Room_Other) {
                            
                            layout = [YYTextLayout layoutWithContainerSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - (50+12)*2, CGFLOAT_MAX) text:model.messageAttributedString];
                            CGFloat outerMargin = 10 * 2;//外部垂直约束
                            CGFloat innerMargin = 10 * 2;//内部垂直约束
                            cellHeight = layout.textBoundingSize.height + outerMargin + innerMargin;
                        }
                    }
                }
                if (!object.attachment) {
                    cellHeight = 0;
                }
            }
            
        }else {
            CGSize size = [model contentSize:tableView.nim_width];
            
            UIEdgeInsets contentViewInsets = model.contentViewInsets;
            UIEdgeInsets bubbleViewInsets  = model.bubbleViewInsets;
            cellHeight = size.height + contentViewInsets.top + contentViewInsets.bottom + bubbleViewInsets.top + bubbleViewInsets.bottom;
        }
        
    }
    else if ([modelInArray isKindOfClass:[NIMTimestampModel class]])
    {
        cellHeight = [(NIMTimestampModel *)modelInArray height];
    }
    else
    {
        NSAssert(0, @"not support model");
    }
    return cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
    if (bottomOffset <= height + 10) {
        //在最底部
        self.currentIsInBottom = YES;
    }
    else {
        self.currentIsInBottom = NO;
    }
    
    if ([self.interactor respondsToSelector:@selector(tableViewIsInBottom:)]) {
        [self.interactor tableViewIsInBottom:self.currentIsInBottom];
    }
}



@end
