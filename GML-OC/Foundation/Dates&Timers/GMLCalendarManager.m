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


@interface GMLCalendarManager ()

@property (nonatomic, strong, readwrite) NSCalendar *calendar;

@end

@implementation GMLCalendarManager

+ (GMLCalendarManager *)defaultManager {
    
    static GMLCalendarManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (NSInteger)dayWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSCalendarUnit unit = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *fromDateComponents = [self components:unit date:fromDate];
    if (fromDateComponents == nil) return 0;
    NSDateComponents *toDateComponents = [self components:unit date:toDate];
    if (toDateComponents == nil) return 0;
    NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitDay fromDateComponents:fromDateComponents toDateComponents:toDateComponents options:NSCalendarMatchStrictly];
    return dateComponents.day;
}

- (NSDateComponents *)components:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    if (fromDate == nil || toDate == nil) {
        return nil;
    }
    if (![fromDate isKindOfClass:[NSDate class]] || ![toDate isKindOfClass:[NSDate class]]) {
        return nil;
    }
    NSDateComponents *dateComponents = [self.calendar components:unit fromDate:fromDate toDate:toDate options:NSCalendarMatchStrictly];
    return dateComponents;
}

- (NSDateComponents *)components:(NSCalendarUnit)unit date:(NSDate *)date
{
    if (date == nil) { return nil; }
    if (![date isKindOfClass:[NSDate class]]) { return nil; }
    NSDateComponents *dateComponents = [self.calendar components:unit fromDate:date];
    return dateComponents;
}

- (NSString *)date:(NSDate *)date formatterStyle:(CGFormatterStyle)formatterStyle {
    if ([formatterStyle isEqualToString:GMLFormatStyleYear]) {
        NSDateComponents *dateComponents = [self components:GMLCalendarUnitYear date:date];
        return [NSString stringWithFormat:@"%04li-%02li-%02li", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day];
    }else if ([formatterStyle isEqualToString:GMLFormatStyleTime]) {
        NSDateComponents *dateComponents = [self components:GMLCalendarUnitTime date:date];
        return [NSString stringWithFormat:@"%02li-%02li-%02li", (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second];
    }else if ([formatterStyle isEqualToString:GMLFormatStyleAll]) {
        NSDateComponents *dateComponents = [self components:GMLCalendarUnitTime date:date];
        return [NSString stringWithFormat:@"%04li-%02li-%02li %02li-%02li-%02li", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second];
    }
    else {
        return nil;
    }
}

- (NSDate *)formatterString:(NSString *)formatterString style:(CGFormatterStyle)style {
    return nil;
}

#pragma mark - 私有方法
- (NSCalendarIdentifier)calendarIdentifier
{
    NSCalendarIdentifier identifier = nil;
    switch (self.calendarType) {
        
        case GMLCalendarGregorian:
            identifier  = NSCalendarIdentifierGregorian;
            break;
    }
    
    return identifier ? identifier : NSCalendarIdentifierGregorian;
}

#pragma mark - 设置属性

- (void)setCalendarType:(GMLCalendar)calendarType
{
    if (_calendarType != calendarType) {
        _calendarType   = calendarType;
        _calendar       = nil;
    }
}

- (NSCalendar *)calendar
{
    if (_calendar) {
        return _calendar;
    }
    
    _calendar = [NSCalendar calendarWithIdentifier:[self calendarIdentifier]];;
    
    return _calendar;
}

@end
