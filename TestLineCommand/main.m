//
//  main.m
//  TestLineCommand
//
//  Created by GML on 2022/5/24.
//

#import <Foundation/Foundation.h>
#import "GMLTimerAdapter.h"

@interface A: NSObject
+ (void)testClass;
- (void)testInstance;
@end
@implementation A
+  (void)testClass {
    
}
- (BOOL)respondsToSelector:(SEL)aSelector {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return [super respondsToSelector:aSelector];
}
+ (BOOL)resolveClassMethod:(SEL)sel {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return [super resolveClassMethod:sel];
}
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)instancesRespondToSelector:(SEL)aSelector {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return [super instancesRespondToSelector:aSelector];
}

- (void)testInstance {
    
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        A *a = [A new];
        NSLog(@"a respondsToSelector:@selector(testClass)");
        NSLog(@"%i", [a respondsToSelector:@selector(testClass)]);
        NSLog(@"A respondsToSelector:@selector(testInstance)");
        NSLog(@"%i", [A respondsToSelector:@selector(testInstance)]);
        
        for (NSInteger index = 48; index < 58; index++) {
            NSString *str = [NSString stringWithUTF8String:(char *)&index];
            uint32_t result1 = 0;
            uint32_t result2 = 0;
            sscanf(str.UTF8String, "%X", &result1);
            sscanf([[str stringByAppendingString:str] UTF8String], "%X", &result2);
            NSLog(@"%@: 单: %f, 双: %f", str, result1 / 15.0, result2 / 255.0);
        }
        
    }
    return 0;
}
