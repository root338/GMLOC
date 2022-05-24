//
//  Runtime+GMLAdd.m
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#import "Runtime+GMLAdd.h"
#import <objc/runtime.h>

@implementation NSObject (GMLRuntimeAdd)

+ (void)swizzledClassMethodAtSelector:(SEL)selector1 withClassMethodAtSelector:(SEL)selector2 {
    Class mClass = [self class];
    [self swizzledMethod1:class_getClassMethod(mClass, selector1)
              AtSelector1:selector1
               withMethod:class_getClassMethod(mClass, selector2) AtSelector2:selector2
    ];
}
+ (void)swizzledInstanceMethodAtSelector:(SEL)selector1 withInstanceMethodAtSelector:(SEL)selector2 {
    Class mClass = [self class];
    [self swizzledMethod1:class_getInstanceMethod(mClass, selector1)
              AtSelector1:selector1
               withMethod:class_getInstanceMethod(mClass, selector2)
              AtSelector2:selector2
    ];
}
+ (void)swizzledMethod1:(Method)method1 AtSelector1:(SEL)selector1 withMethod:(Method)method2 AtSelector2:(SEL)selector2 {
    Class mClass = [self class];
    BOOL didAddMethod = class_addMethod(mClass, selector1, method_getImplementation(method2), method_getTypeEncoding(method2));
    if (didAddMethod) {
        class_addMethod(mClass, selector2, method_getImplementation(method1), method_getTypeEncoding(method1));
    }else {
        method_exchangeImplementations(method1, method2);
    }
}

@end

