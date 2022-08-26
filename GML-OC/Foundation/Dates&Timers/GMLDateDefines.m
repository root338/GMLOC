//
//  GMLDateDefines.m
//  GML-OC
//
//  Created by GML on 2022/8/10.
//

#import "GMLDateDefines.h"

NSCalendarUnit const GMLCalendarUnitAll  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

NSCalendarUnit const GMLCalendarUnitYear = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;

NSCalendarUnit const GMLCalendarUnitTime = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

NSString * const GMLYearFormat = @"yyyy-MM-dd";
NSString * const GMLTimeFormat = @"HH:mm:ss";
NSString * const GMLFullDateFormat = @"yyyy-MM-dd HH:mm:ss";
