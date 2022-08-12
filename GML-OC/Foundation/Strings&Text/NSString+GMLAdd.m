//
//  NSString+GMLAdd.m
//  GML-OC
//
//  Created by GML on 2022/8/11.
//

#import "NSString+GMLAdd.h"

@implementation NSString (GMLAdd)

- (NSString *)trimSpace {
    return [self stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
}

@end
