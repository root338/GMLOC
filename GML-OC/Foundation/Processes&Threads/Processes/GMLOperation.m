//
//  GMLOperation.m
//  GML-OC
//
//  Created by GML on 2022/8/16.
//

#import "GMLOperation.h"

@interface GMLOperation ()
@property (nonatomic, strong) NSRecursiveLock *lock;

@property (readwrite, getter=isExecuting) BOOL executing;
@property (nonatomic, readwrite, getter=isReady) BOOL ready;
@property (readwrite, getter=isCancelled) BOOL cancelled;
@property (readwrite, getter=isFinished) BOOL finished;
@property (readwrite, getter=isAsynchronous) BOOL asynchronous;

@end

@implementation GMLOperation
@synthesize executing = _executing;
@synthesize ready = _ready;
@synthesize cancelled = _cancelled;
@synthesize finished = _finished;
@synthesize asynchronous = _asynchronous;

- (instancetype)init {
    self = [super init];
    if (self) {
        _lock = NSRecursiveLock.new;
    }
    return self;
}

- (void)main {
    
}

- (void)start {
    
}

- (void)cancel {
    
}

#pragma mark - Getter & Setter
- (void)setExecuting:(BOOL)executing {
    [_lock lock];
    if (_executing != executing) {
        [self willChangeValueForKey:@"isExecuting"];
        _executing = executing;
        [self didChangeValueForKey:@"isExecuting"];
    }
    [_lock unlock];
}
- (BOOL)isExecuting {
    [_lock lock];
    BOOL isExecuting = _executing;
    [_lock unlock];
    return isExecuting;
}

- (void)setCancelled:(BOOL)cancelled {
    [_lock lock];
    if (_cancelled != cancelled) {
        [self willChangeValueForKey:@"isCancelled"];
        _cancelled = cancelled;
        [self didChangeValueForKey:@"isCancelled"];
    }
    [_lock unlock];
}
- (BOOL)isCancelled {
    [_lock lock];
    BOOL isCancelled = _cancelled;
    [_lock unlock];
    return isCancelled;
}
- (void)setFinished:(BOOL)finished {
    [_lock lock];
    if (_finished != finished) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self didChangeValueForKey:@"isFinished"];
    }
    [_lock unlock];
}
- (BOOL)isFinished {
    [_lock lock];
    BOOL isFinished = _finished;
    [_lock unlock];
    return isFinished;
}
- (void)setAsynchronous:(BOOL)asynchronous {
    [_lock lock];
    if (_asynchronous != asynchronous) {
        [self willChangeValueForKey:@"isAsynchronous"];
        _asynchronous = asynchronous;
        [self didChangeValueForKey:@"isAsynchronous"];
    }
    [_lock unlock];
}
- (BOOL)isAsynchronous {
    [_lock lock];
    BOOL isAsynchronous = _asynchronous;
    [_lock unlock];
    return isAsynchronous;
}
- (void)setReady:(BOOL)ready {
    [_lock lock];
    if (_ready != ready) {
        [self willChangeValueForKey:@"isReady"];
        _ready = ready;
        [self didChangeValueForKey:@"isReady"];
    }
    [_lock unlock];
}
- (BOOL)isReady {
    [_lock lock];
    BOOL isReady = [super isReady] || _ready;
    [_lock unlock];
    return isReady;
}

@end
