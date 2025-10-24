//
//  TTGameActivityCycleView.h
//  AFNetworking
//
//  Created by User on 2019/5/6.
//

#import <UIKit/UIKit.h>

@class TTGameActivityCycleView,ActivityInfo;
@protocol TTGameActivityCycleViewDelegate <NSObject>
    
@optional
- (void)roomActivityListView:(TTGameActivityCycleView *)activityView jumbByActivityInfo:(ActivityInfo *)activityInfo;
    
@end

NS_ASSUME_NONNULL_BEGIN

@interface TTGameActivityCycleView : UIView

@property (nonatomic, weak) id<TTGameActivityCycleViewDelegate> delegate;
    
@end

NS_ASSUME_NONNULL_END
