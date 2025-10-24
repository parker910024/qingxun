//
//  CTInputAudioRecordIndicatorView.h
//  CTKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "CTInputView.h"

@interface CTInputAudioRecordIndicatorView : UIView

@property (nonatomic, assign) CTAudioRecordPhase phase;

@property (nonatomic, assign) NSTimeInterval recordTime;

@end
