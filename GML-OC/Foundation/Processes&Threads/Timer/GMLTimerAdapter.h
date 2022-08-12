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
/// 其中默认值 repeats = true,
/// addToMainRunLoop = true，
/// autoAddToRunLoop = true,
/// mode = NSDefaultRunLoopMode,
+ (instancetype)timerWithConfiguration:(GMLConfigurationTimeBlock)block;
/// 当 autoAddToRunLoop == true 时(默认为 true )，自动执行 resume 开启计时器(autoAddToRunLoop 默认为 true)
/// 其中默认值 repeats = true,
/// addToMainRunLoop = true，
/// autoAddToRunLoop = true,
/// mode = NSDefaultRunLoopMode,
+ (instancetype)scheduledTimerWithConfiguration:(GMLConfigurationTimeBlock)block;

/// 更新计时器，如果计时器还没有开启，那么该方法也不会开启
- (void)configurationTime:(GMLConfigurationTimeBlock)block;
/// 添加到配置好的runloop中，返回是否添加成功
- (BOOL)addToRunLoop;
/// 停止计时器
- (void)stop;
/// 中断计时器，注意：如果频繁的中断恢复可以考虑使用 stop/resume 组合，具体可以参考 NSTimer fireDate 属性的说明
- (void)suspend;
/// 恢复计时器，并在NSDate.date+interval 时执行
- (void)resume;
/// 恢复计时器
/// @param fireDate 立即执行的时间
- (void)resumeAtFireDate:(nullable NSDate *)fireDate;

@end

NS_ASSUME_NONNULL_END
