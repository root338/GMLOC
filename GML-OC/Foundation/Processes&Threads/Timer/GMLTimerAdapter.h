//
//  GMLTimerAdapter.h
//  GML-OC
//
//  Created by GML on 2022/7/15.
//

#import <Foundation/Foundation.h>
#import <GML_OC/GMLTimeConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^GMLConfigurationTimeBlock)(id<GMLTimeConfiguration> configuration);
@interface GMLTimerAdapter : NSObject

@property (nullable, nonatomic, copy) void (^block) (GMLTimerAdapter *timer);

@property (nonatomic, assign, readonly) NSTimeInterval interval;

@property (nonatomic, assign, readonly) BOOL isValid;

/// 仅配置计时器，需要手动调用 resume 开启计时器
+ (instancetype)timerWithConfiguration:(GMLConfigurationTimeBlock)block;
/// 当 autoAddToRunLoop == true 时(默认为 true )，自动执行 resume 开启计时器
+ (instancetype)scheduledTimerWithConfiguration:(GMLConfigurationTimeBlock)block;

/// 更新计时器，如果计时器还没有开启，那么该方法也不会开启
- (void)configurationTime:(GMLConfigurationTimeBlock)block;

- (BOOL)addToRunLoop;

- (void)stop;
- (void)suspend;
- (void)resume;
/// 恢复计时器
/// @param fireDate 是否立即执行
- (void)resumeAtFireDate:(nullable NSDate *)fireDate;

@end

NS_ASSUME_NONNULL_END
