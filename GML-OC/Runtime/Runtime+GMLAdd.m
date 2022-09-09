//
//  Runtime+GMLAdd.m
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#import "Runtime+GMLAdd.h"
#import <objc/runtime.h>
#import "GMLRuntimeDefines.h"

@interface __GMLEmptyObject : NSObject
@end
@implementation __GMLEmptyObject
@end

static BOOL __isSystemClass(Class mClass) {
    static NSInteger local = 0;
    static NSString *appName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle bundleForClass:[__GMLEmptyObject class]] bundlePath];
        
        local = 0;
    });
    return [[[NSBundle bundleForClass:mClass] bundlePath] hasPrefix:@"/System/"];
}

@implementation NSObject (GMLRuntimeAdd)

+ (void)swizzledClassMethodAtSelector:(SEL)selector1 withClassMethodAtSelector:(SEL)selector2 {
    Class mClass = [self class];
    [self swizzledMethod1:class_getClassMethod(mClass, selector1)
              atSelector1:selector1
               withMethod:class_getClassMethod(mClass, selector2)
              atSelector2:selector2
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
    if (ignoreRule == GMLClassIgnoreRuleSystem && __isSystemClass([self class])) {
        return;
    }
    [self enumerateProperysUsingBlock:block shouldStartNextClass:^BOOL(Class mClass) {
        switch (ignoreRule) {
            case GMLClassIgnoreRuleSystem:
                return !__isSystemClass(mClass);
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

- (BOOL)isEqualGML:(id)object {
    if (object == nil) return false;
    if (object == self) return true;
    // 该方法只能判断是否是同一个类，当为类族时会出现错误的结果，比如 NSNumber/NSArray 等等的类
    // 此时仅对部分系统类做特殊处理
    if ([self conformsToProtocol:@protocol(GMLEqualProtocol)]) {
        return [(id<GMLEqualProtocol>)self isEqualToGMLObject:object];
    }
    if ([object conformsToProtocol:@protocol(GMLEqualProtocol)]) {
        return [(id<GMLEqualProtocol>)self isEqualToGMLObject:self];
    }
    if (__isSystemClass([self class]) || __isSystemClass([object class])) {
        return [self isEqualSystemObject:object];
    }
    if (![self isMemberOfClass:[object class]]) return false; // 当是自定义对象时，如果对象类型不同则不相同
    
    __block BOOL result = true;
    [[self class] enumerateProperysUsingBlock:^(objc_property_t  _Nonnull property_t, BOOL * _Nonnull stop) {
        NSString *key = [NSString stringWithUTF8String:property_getName(property_t)];
        id a = [self valueForKey:key];
        id b = [object valueForKey:key];
        result &= (a == b || (a != nil && [b isEqualGML:a]));
        if (!result) *stop = true;
    }];
    return result;
}

/// 对比系统对象
- (BOOL)isEqualSystemObject:(id)object {
    if (([self isKindOfClass:NSDictionary.class] && [object isKindOfClass:NSDictionary.class])
        || ([self isKindOfClass:NSMapTable.class] && [object isKindOfClass:NSMapTable.class])) {
        if ([(id)self count] != [(id)object count]) return false;
        // 字典容器
        __block BOOL result = true;
        [self validatorKeyValueCollectionsWithEach:^(id key, id value, BOOL *stop) {
            id otherValue = [object objectForKey:key];
            result &= (otherValue != nil && [value isEqualGML:otherValue]);
            if (!result) *stop = true;
        }];
        return result;
    }else if (([self isKindOfClass:NSArray.class] && [object isKindOfClass:NSArray.class])
          || ([self isKindOfClass:NSOrderedSet.class] && [object isKindOfClass:NSOrderedSet.class])) {
        // 有序数组
        NSInteger totalCount = [(id)self count];
        if (totalCount != [(id)object count]) return false;
        __block BOOL result = true;
        for (NSInteger index = 0; index < totalCount; index++) {
            result &= [[(id)self objectAtIndex:index] isEqualGML:[(id)object objectAtIndex:index]];
        }
        return result;
    }else if ([self isKindOfClass:NSSet.class] && [object isKindOfClass:NSSet.class]) {
        // 无许数组
        return [(NSSet *)self isEqualToSet:object];
    }else {
        return [self isEqual:object];
    }
}

- (BOOL)validatorIsCollections {
    return [self respondsToSelector:@selector(objectEnumerator)] && [[(id)self objectEnumerator] isKindOfClass:NSEnumerator.class];
}
/// 验证并遍历 key: value 对象，如: NSDictionary
- (BOOL)validatorKeyValueCollectionsWithEach:(void(^)(id key, id value, BOOL *stop))eachBlock {
    if (!([self respondsToSelector:@selector(keyEnumerator)] && [self respondsToSelector:@selector(objectForKey:)])) return false;
    NSEnumerator *enumerator = [(id)self keyEnumerator];
    if (![enumerator isKindOfClass:NSEnumerator.class]) return false;
    id key = nil;
    /**
     * 该判断会覆盖以下集合类
     * NSMapTable
     * NSDictionary|NSMutableDictionary
     */
    BOOL stop = false;
    while ((key = enumerator.nextObject)) {
        eachBlock(key, [(id)self objectForKey:key], &stop);
        if (stop) break;
    }
    return true;
}
/// 验证并遍历 value 对象的集合，如： NSArray, NSDictionary
- (BOOL)validatorValueCollectionsWithEach:(void(^)(id element, BOOL *stop))eachBlock {
    if (![self respondsToSelector:@selector(objectEnumerator)]) return false;
    NSEnumerator *enumerator = [(id)self objectEnumerator];
    if (![enumerator isKindOfClass:[NSEnumerator class]]) return false;
    // 判断对象是否存在 objectEnumerator 方法，且返回对象是否为 NSEnumerator 对象，如果存在则直接遍历对象中所有的元素集合
    /**
     * 该判断覆盖了以下集合类，基本覆盖常规使用
     *  NSArray|NSMutableArray
     *  NSSet|NSMutableSet
     *  NSHashTable
     *  NSOrderedSet|NSMutableOrderedSet
     *
     *  但需要注意的是，如果集合是 NSDictionary|NSMutableDictionary 也会执行该方法，但仅遍历 Value
     */
    id element = nil;
    BOOL stop = false;
    while ((element = enumerator.nextObject)) {
        eachBlock(element, &stop);
        if (stop) break;
    }
    return true;
}

@end

