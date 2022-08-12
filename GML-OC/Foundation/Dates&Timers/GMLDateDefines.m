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

CGFormatterStyle const GMLFormatStyleYear = @"GMLFormatterStyleYear";
CGFormatterStyle const GMLFormatStyleTime = @"GMLFormatterStyleTime";
CGFormatterStyle const GMLFormatStyleAll = @"GMLFormatterStyleAll";
