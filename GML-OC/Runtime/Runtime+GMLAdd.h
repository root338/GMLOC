//
//  Runtime+GMLAdd.h
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, GMLClassIgnoreRule) {
    GMLClassIgnoreRuleSystem,
    GMLClassIgnoreRuleAllSuperclass,
};
typedef void (^GMLEnumeratePropertyBlock)(objc_property_t property_t, BOOL *stop);

__attribute__((unused)) static void enumerateProperyAttributeList(objc_property_t property_t, void (^block) (objc_property_attribute_t attribute, BOOL *stop)) {
    if (block == nil) return;
    unsigned int outCount = 0;
    objc_property_attribute_t *attributes = property_copyAttributeList(property_t, &outCount);
    if (attributes == NULL) return;
    if (outCount == 0) {
        free(attributes);
        return;
    }
    BOOL stop = false;
    for (int i = 0; i < outCount; i++) {
        block(attributes[i], &stop);
        if (stop) break;
    }
    free(attributes);
}


@interface NSObject (GMLRuntimeAdd)

+ (void)swizzledClassMethodAtSelector:(SEL)selector1 withClassMethodAtSelector:(SEL)selector2;
+ (void)swizzledInstanceMethodAtSelector:(SEL)selector1 withInstanceMethodAtSelector:(SEL)selector2;

/// 遍历属性列表，且忽略系统类
+ (void)enumerateProperysUsingBlock:(GMLEnumeratePropertyBlock)block;
/// 遍历属性列表
+ (void)enumerateProperysWithIgnoreRule:(GMLClassIgnoreRule)ignoreRule usingBlock:(GMLEnumeratePropertyBlock)block;
/// 遍历属性列表
+ (void)enumerateProperysUsingBlock:(GMLEnumeratePropertyBlock)block shouldStartNextClass:(BOOL (^_Nullable) (Class mClass))shouldStartNextClass;



//- (BOOL)isEqual_gml:(id)object;

@end

NS_ASSUME_NONNULL_END
