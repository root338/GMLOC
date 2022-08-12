//
//  GMLDateDefines.h
//  GML-OC
//
//  Created by GML on 2022/8/10.
//

#ifndef GMLDateDefines_h
#define GMLDateDefines_h

#import <Foundation/NSCalendar.h>

typedef NSString *CGFormatterStyle;

typedef NS_ENUM(NSInteger, GMLCalendar) {
    
    GMLCalendarGregorian,
};

/// CG 中默认的需要的日期的属性：公元|年|月|日|时|分|秒
FOUNDATION_EXPORT NSCalendarUnit const GMLCalendarUnitAll;
/// CG 中默认的需要的日期的属性：公元|年|月|日
FOUNDATION_EXPORT NSCalendarUnit const GMLCalendarUnitYear;
/// CG 中默认的需要的日期的属性：时|分|秒
FOUNDATION_EXPORT NSCalendarUnit const GMLCalendarUnitTime;

/// CG 中默认时间格式化：2018-01-01
FOUNDATION_EXPORT CGFormatterStyle const GMLFormatStyleYear;
/// CG 中默认时间格式化：时:分:秒
FOUNDATION_EXPORT CGFormatterStyle const GMLFormatStyleTime;
/// CG 中默认时间格式化：2018-01-01 时:分:秒
FOUNDATION_EXPORT CGFormatterStyle const GMLFormatStyleAll;

#endif /* GMLDateDefines_h */
