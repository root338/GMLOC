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
              atSelector1:selector1
               withMethod:class_getClassMethod(mClass, selector2) atSelector2:selector2
    ];
}
+ (void)swizzledInstanceMethodAtSelector:(SEL)selector1 withInstanceMethodAtSelector:(SEL)selector2 {
    Class mClass = [self class];
    [self swizzledMethod1:class_getInstanceMethod(mClass, selector1)
              atSelector1:selector1
               withMethod:class_getInstanceMethod(mClass, selector2)
              atSelector2:selector2
    ];
}
+ (void)swizzledMethod1:(Method)method1 atSelector1:(SEL)selector1 withMethod:(Method)method2 atSelector2:(SEL)selector2 {
    Class mClass = [self class];
    BOOL didAddMethod = class_addMethod(mClass, selector1, method_getImplementation(method2), method_getTypeEncoding(method2));
    if (didAddMethod) {
        class_addMethod(mClass, selector2, method_getImplementation(method1), method_getTypeEncoding(method1));
    }else {
        method_exchangeImplementations(method1, method2);
    }
}

+ (void)enumerateProperysUsingBlock:(GMLEnumeratePropertyBlock)block {
    [self enumerateProperysWithIgnoreRule:GMLClassIgnoreRuleSystem usingBlock:block];
}
+ (void)enumerateProperysWithIgnoreRule:(GMLClassIgnoreRule)ignoreRule usingBlock:(GMLEnumeratePropertyBlock)block {
    if (ignoreRule == GMLClassIgnoreRuleSystem && [[NSBundle bundleForClass:[self class]].bundlePath hasPrefix:@"/System/"]) {
        return;
    }
    [self enumerateProperysUsingBlock:block shouldStartNextClass:^BOOL(Class mClass) {
        switch (ignoreRule) {
            case GMLClassIgnoreRuleSystem:
                return ![[NSBundle bundleForClass:mClass].bundlePath hasPrefix:@"/System/"];
            case GMLClassIgnoreRuleAllSuperclass:
                return false;
        }
    }];
}
+ (void)enumerateProperysUsingBlock:(GMLEnumeratePropertyBlock)block shouldStartNextClass:(BOOL (^)(Class  _Nonnull __unsafe_unretained))shouldStartNextClass {
    if (block == nil && shouldStartNextClass == nil) return;
    BOOL stop = false;
    __block Class targetClass = nil;
    __block Class nextClass = [self class];
    int (^conditionBlock) (void) = ^{
        if (targetClass != nil) { // 不是第一次执行时
            if (nextClass == nil || !(shouldStartNextClass && shouldStartNextClass(nextClass))) return false;
        }
        targetClass = nextClass;
        nextClass = class_getSuperclass(nextClass);
        return targetClass != nil;
    };
    while (conditionBlock()) {
        unsigned int outCount = 0;
        objc_property_t *propertyList = class_copyPropertyList(targetClass, &outCount);
        if (propertyList == NULL) continue;
        if (outCount == 0) {
            free(propertyList);
            continue;
        }
        for (int i = 0; i < outCount; i++) {
            objc_property_t property_t = propertyList[i];
            !block?: block(property_t, &stop);
            if (stop) return;
        }
        free(propertyList);
    }
}

- (BOOL)isEqual_gml:(id)object {
    if (object == nil) return false;
    if (object == self) return true;
    if (![self isMemberOfClass:[object class]]) return false;
    
    return false;
}

- (void)allPropertyKeys {
    
}
//- (id)parseToBaseObject {
//    
//    if ([self isKindOfClass:[NSArray class]]) {
//        NSArray *arr = (NSArray *)self;
//        if (arr.count == 0) return self;
//        NSMutableArray *mArr = NSMutableArray.array;
//        for (id element in arr) {
//            [mArr addObject:[element parseToBaseObject]];
//        }
//    }else if ([self isKindOfClass:[NSDictionary class]]) {
//        if
//    }
//}
//
//
//- (BOOL)_isBaseObject {
//    return [self isKindOfClass:NSString.class]
//    || [self isKindOfClass:NSNumber.class]
//    || [self isKindOfClass:NSData.class]
//    || [self isKindOfClass:NSError.class]
//    || [self isKindOfClass:NSNull.class]
//    || [self isKindOfClass:<#(__unsafe_unretained Class)#>];
//}
//
//- (void)validatorDictionaryWithEach:(void(^)(id key, id value))eachBlock {
//    if (<#condition#>) {
//        <#statements#>
//    }
//}
//- (id)validatorSingleElementCollectionsWithEach:(void(^)(id element))eachBlock {
//    if ([self respondsToSelector:@selector(objectEnumerator)]) {
//        NSEnumerator *enumerator = [(id)self objectEnumerator];
//        if ([enumerator isKindOfClass:[NSEnumerator class]]) {
//            // 判断对象是否存在 objectEnumerator 方法，且返回对象是否为 NSEnumerator 对象，如果存在则直接遍历对象中所有的元素集合
//            id element = nil;
//            while ((element = enumerator.nextObject)) {
//                eachBlock(element);
//            }
//        }
//    }
//    if ([self isKindOfClass:[NSArray class]]) {
//        NSArray *arr = (NSArray *)self;
//        if (arr.count == 0) return self;
//        NSMutableArray *mArr = NSMutableArray.array;
//        for (id element in arr) {
//            [mArr addObject:[element parseToBaseObject]];
//        }
//    }
//}

@end

