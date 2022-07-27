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
        
    }
    return 0;
}
