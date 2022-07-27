//
//  GMLTimerAdapter.m
//  GML-OC
//
//  Created by GML on 2022/7/15.
//

#import "GMLTimerAdapter.h"
#import "GMLTimeConfiguration.h"

@interface GMLTimerAdapter ()<GMLTimeConfiguration>
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL didAddToIsMainRunLoop;
@property (nonatomic, copy) NSRunLoopMode didAddToMode;

@property (nonatomic, assign, readwrite) NSTimeInterval interval;
@end

@implementation GMLTimerAdapter

@synthesize interval = _interval;
@synthesize repeats = _repeats;
@synthesize fireDate = _fireDate;
@synthesize addToMainRunLoop = _addToMainRunLoop;
@synthesize autoAddToRunLoop = _autoAddToRunLoop;
@synthesize mode = _mode;

- (void)dealloc {
    [self stop];
}

+ (instancetype)scheduledTimerWithConfiguration:(GMLConfigurationTimeBlock)block {
    GMLTimerAdapter *timerAdapter = [[[self class] alloc] init];
    timerAdapter.autoAddToRunLoop = true;
    !block?: block(timerAdapter);
    if (timerAdapter.autoAddToRunLoop) [timerAdapter resume];
    return timerAdapter;
}

+ (instancetype)timerWithConfiguration:(GMLConfigurationTimeBlock)block {
    GMLTimerAdapter *timerAdapter = [[[self class] alloc] init];
    !block?: block(timerAdapter);
    return timerAdapter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _repeats = true;
        _autoAddToRunLoop = true;
        _mode = NSDefaultRunLoopMode;
    }
    return self;
}

- (void)configurationTime:(GMLConfigurationTimeBlock)block {
    if (block == nil) return;
    block(self);
    if ([self isValid]) {
        [self resumeAtFireDate:nil];
    }
}
- (BOOL)addToRunLoop {
    if (![self isValid]) return false;
    if ([self isUpdateRunLoop]) [self _configRunLoop];
    return true;
}
- (void)stop {
    if ([self isValid]) [_timer invalidate];
    _timer = nil;
}
- (void)suspend {
    if (_timer.isValid) [_timer setFireDate:NSDate.distantFuture];
}
- (void)resume {
    [self resumeAtFireDate:[NSDate.date dateByAddingTimeInterval:self.interval]];
}
- (void)resumeAtFireDate:(NSDate *)fireDate {
    
    if ([self isUpdateTimer]) {
        if ([self isValid]) [self stop];
        _fireDate = fireDate;
        _timer = [self _newTimer];
        if (_autoAddToRunLoop) {
            [self addToRunLoop];
        }
    }else {
        _timer.fireDate = fireDate ?: [NSDate.date dateByAddingTimeInterval:self.interval];
    }
}

#pragma mark - Private
- (NSTimer *)_newTimer {
    __weak typeof(self) weakself = self;
    return [[NSTimer alloc] initWithFireDate:_fireDate?: NSDate.date interval:_interval repeats:_repeats block:^(NSTimer * _Nonnull timer) {
        typeof(weakself) strongself = weakself;
        if (strongself == nil) return;
        !strongself.block?: strongself.block(strongself);
        if (!strongself.repeats) [strongself stop];
    }];
}
- (BOOL)isUpdateTimer {
    if (![self isValid]) { return true; }
    return _timer.timeInterval != self.interval
    || (_didAddToMode != nil && [self isUpdateRunLoop]); // 先使用 _didAddToMode != nil 来判断 timer 已经添加过 runloop 中
}
- (BOOL)isUpdateRunLoop {
    return _didAddToMode == nil
    || (
        ![self.didAddToMode isEqualToString:self.mode]
        || _didAddToIsMainRunLoop != _addToMainRunLoop // 当 _didAddToMode != nil 为true 时，_didAddToIsMainRunLoop 肯定进行的一轮设置，所以可以直接进行值判断
        );
}

#pragma mark - Getter & Setter
- (BOOL)isValid { return _timer != nil && _timer.isValid; }

- (void)_configRunLoop {
    NSRunLoop *runLoop = _addToMainRunLoop ? NSRunLoop.currentRunLoop : NSRunLoop.mainRunLoop;
    [runLoop addTimer:_timer forMode:self.mode];
    self.didAddToMode = self.mode;
    self.didAddToIsMainRunLoop = _addToMainRunLoop;
}

- (NSRunLoopMode)mode {
    if (_mode == nil) {
        _mode = NSDefaultRunLoopMode;
    }
    return _mode;
}

@end
