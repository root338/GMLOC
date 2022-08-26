//
//  main.m
//  TestLineCommand
//
//  Created by GML on 2022/5/24.
//

#import <Foundation/Foundation.h>
#import "GMLCalendarManager.h"
#import "Runtime+GMLAdd.h"

@interface TestA : NSString
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString *name;
@end
@implementation TestA
@end

void testRuntime() {
    NSLog(@"--------------------- %@", NSStringFromClass([TestA class]));
    [TestA enumerateProperysUsingBlock:^(objc_property_t property_t, BOOL *stop){
        NSLog(@"%@", [NSString stringWithUTF8String:property_getName(property_t)]);
    } shouldStartNextClass:^(Class mClass) {
        NSLog(@"--------------------- %@", NSStringFromClass(mClass));
        BOOL result = true;
        return result;
    }];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        testCalendarManager();
        testRuntime();
    }
    return 0;
}

void testCalendarManager() {
    GMLCalendarManager *manager = GMLCalendarManager.defaultManager;
    NSLog(@"1. %@", [manager string:@"2022-01-01" format:GMLYearFormat]);
    NSLog(@"2. %@", [manager date:NSDate.date format:GMLFullDateFormat]);
    NSLog(@"2. %@", [manager string:[manager date:NSDate.date format:GMLFullDateFormat] format:GMLFullDateFormat]);
    NSString *dateStr = @"2022-08-15 23:00:00";
    NSDate *fromDate = [manager string:dateStr format:GMLFullDateFormat];
    NSDate *toDate = NSDate.date;
    NSInteger offsetDay = [manager dayWithFromDate:fromDate toDate:toDate];
    NSLog(@"from: %@, to: %@, offsetDay: %li", fromDate, toDate, (long)offsetDay);
}




