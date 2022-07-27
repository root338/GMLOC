//
//  GMLTimeConfiguration.h
//  GML-OC
//
//  Created by GML on 2022/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GMLTimerAdapter;
@protocol GMLTimeConfiguration <NSObject>

@property (nonatomic, assign) BOOL repeats;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, copy) NSDate *fireDate;
/// 是否自动添加到 runloop
@property (nonatomic, assign) BOOL autoAddToRunLoop;
/// 添加到 main runloop
@property (nonatomic, assign) BOOL addToMainRunLoop;
@property (nonatomic, copy) NSRunLoopMode mode;

@property (nullable, nonatomic, copy) void (^block) (GMLTimerAdapter *timer);
@end

NS_ASSUME_NONNULL_END
