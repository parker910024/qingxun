//
//  CPOnline.m
//  AFNetworking
//
//  Created by apple on 2018/11/15.
//

#import "CPOnline.h"

@implementation CPOnline

- (void)setCountDown:(int)countDown {
    _countDown = countDown;
    self.secondDown = _countDown * 60;
}

- (id)copyWithZone:(NSZone *)zone {
    CPOnline *cpLine = [[[self class] allocWithZone:zone]init];
    cpLine.countDown = _countDown;
    cpLine.startTime = _startTime;
    cpLine.accompanyValue = _accompanyValue;
    cpLine.secondDown = _secondDown;
    cpLine.difference = _difference;
    return cpLine;
}

@end
