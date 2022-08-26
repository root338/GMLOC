//
//  GMLCalendarManager.m
//  QuickAskCommunity
//
//  Created by apple on 2018/1/25.
//  Copyright © 2018年 ym. All rights reserved.
//

/**
 
 参考链接： http://nshipster.cn/nscalendar-additions/
 */

#import "GMLCalendarManager.h"
#import "GMLPropertyMacro.h"

@interface GMLCalendarManager ()

@property (nonatomic, strong, readwrite) NSCalendar *calendar;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation GMLCalendarManager
@synthesize calendarIdentifier = _calendarIdentifier;
+ (GMLCalendarManager *)defaultManager {
    
    static GMLCalendarManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (NSInteger)dayWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendarUnit unit = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *fromDateComponents = [self components:unit date:fromDate];
    if (fromDateComponents == nil) return 0;
    NSDateComponents *toDateComponents = [self components:unit date:toDate];
    if (toDateComponents == nil) return 0;
    NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitDay fromDateComponents:fromDateComponents toDateComponents:toDateComponents options:NSCalendarMatchStrictly];
    return dateComponents.day;
}

- (NSDateComponents *)components:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    if (fromDate == nil || toDate == nil) {
        return nil;
    }
    if (![fromDate isKindOfClass:[NSDate class]] || ![toDate isKindOfClass:[NSDate class]]) {
        return nil;
    }
    NSDateComponents *dateComponents = [self.calendar components:unit fromDate:fromDate toDate:toDate options:NSCalendarMatchStrictly];
    return dateComponents;
}

- (NSDateComponents *)components:(NSCalendarUnit)unit date:(NSDate *)date {
    if (date == nil) { return nil; }
    if (![date isKindOfClass:[NSDate class]]) { return nil; }
    NSDateComponents *dateComponents = [self.calendar components:unit fromDate:date];
    return dateComponents;
}

- (NSString *)date:(NSDate *)date format:(nonnull NSString *)format {
    if (![self.dateFormatter.dateFormat isEqualToString:format]) {
        [self.dateFormatter setDateFormat:format];
    }
    return [self.dateFormatter stringFromDate:date];
}

- (NSDate *)string:(NSString *)string format:(NSString *)format {
    if (![self.dateFormatter.dateFormat isEqualToString:format]) {
        [self.dateFormatter setDateFormat:format];
    }
    return [self.dateFormatter dateFromString:string];
}

#pragma mark - 设置属性
- (NSCalendarIdentifier)calendarIdentifier {
    if (_calendarIdentifier == nil) return NSCalendarIdentifierGregorian;
    return _calendarIdentifier;
}
- (void)setCalendarIdentifier:(NSCalendarIdentifier)calendarIdentifier {
    GMLWriteClassCopyProperty(calendarIdentifier)
    _calendar = nil;
}

- (NSCalendar *)calendar {
    if (_calendar == nil) {
        _calendar = [NSCalendar calendarWithIdentifier:self.calendarIdentifier];
    }
    return _calendar;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [NSDateFormatter new];
    }
    return _dateFormatter;
}

@end
