//
//  main.m
//  TestLineCommand
//
//  Created by GML on 2022/5/24.
//

#import <Foundation/Foundation.h>

#import "GMLClassInfo.h"
#import "GMLPropertyInfo.h"
#import "GMLObjectCompareConfiguration.h"

typedef NS_ENUM(NSInteger, FooManChu) {
    FooManChuNone
};
struct YorkshireTeaStruct {
    int a;
};

union MoneyUnion {
    int b;
};

@protocol GMLProtocol1 <NSObject>
@end
@protocol GMLProtocol2 <NSObject>
@end
@protocol GMLProtocol3 <GMLProtocol1>
@end

@interface TestA : NSObject
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger a;
@property (nonatomic, assign) float b;
@property (nonatomic, strong) NSString *str;


@property (nonatomic, copy) NSNumber *number;
@property (nonatomic, strong, readonly) NSArray *array;
@property (nonatomic) SEL selector;
@property char charDefault;
@property double doubleDefault;
@property enum FooManChu enumDefault;
@property float floatDefault;
@property int intDefault;
@property long longDefault;
@property short shortDefault;
@property signed signedDefault;
@property struct YorkshireTeaStruct structDefault;
@property unsigned unsignedDefault;
@property int (*functionPointerDefault)(char *);
@property (nullable, nonatomic, copy) NSString * (^block) (NSArray *array, int d);
@property id idDefault;
@property union MoneyUnion unionDefault;
@property int *intPointer;
@property void *voidPointerDefault;
@property int intSynthEquals;
@property(getter=intGetFoo, setter=intSetFoo:) int intSetterGetter;
@property(readonly) int intReadonly;
@property(getter=isIntReadOnlyGetter, readonly) int intReadonlyGetter;
@property(readwrite) int intReadwrite;
@property(assign) int intAssign;
@property(retain) id idRetain;
@property(copy) id idCopy;
@property(nonatomic) int intNonatomic;
@property(nonatomic, readonly, copy) id idReadonlyCopyNonatomic;
@property(nonatomic, readonly, retain) id idReadonlyRetainNonatomic;

@property (nonatomic, unsafe_unretained) NSMutableDictionary* __strong *dictPointer;
@property (nonatomic, strong) NSString<GMLProtocol1, GMLProtocol2, GMLProtocol3> *protocolObject;
@property (class, nonatomic, strong) NSString *classObject;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *mDict;
@end
@implementation TestA
@dynamic classObject;
@end

@interface NSObject (_GMLTest)

@end

typedef NS_ENUM(NSInteger, GMLEncodingNSType) {
    GMLEncodingNSUnknown = 0,
    GMLEncodingNSString,
    GMLEncodingNSNumber,
    GMLEncodingNSValue,
    GMLEncodingNSData,
    GMLEncodingNSDate,
    GMLEncodingNSURL,
    GMLEncodingNSArray,
    GMLEncodingNSDictionary,
    GMLEncodingNSSet,
    GMLEncodingNSOrderedSet,
    GMLEncodingNSHashTable,
    GMLEncodingNSMapTable
};
@implementation NSObject (_GMLTest)

- (BOOL)isValueEqual:(id)object configuration:(GMLObjectCompareConfiguration *)configuration {
    if (object == nil) return false;
    if (object == self) return true;
    if ([self isMemberOfClass:NSObject.class] && [object isMemberOfClass:NSObject.class]) return [self isEqual:object];
    
    if (configuration.compareClass) {
        if (!configuration.compareClass([self class], [object class])) return false;
    }else {
        GMLEncodingNSType typeA = [self _toNSType];
        GMLEncodingNSType typeB = [object _toNSType];
        if (typeA != typeB) return false;
        switch (typeA) {
            case GMLEncodingNSUnknown: break;
            case GMLEncodingNSString:
            case GMLEncodingNSNumber:
            case GMLEncodingNSValue:
            case GMLEncodingNSData:
            case GMLEncodingNSDate:
            case GMLEncodingNSURL:
                return [self isEqual:object];
            case GMLEncodingNSArray:
            case GMLEncodingNSOrderedSet:
            case GMLEncodingNSHashTable:// 有序数组下
                return [self _compareSequentialCollection:object configuration:configuration];
            case GMLEncodingNSSet: // 无序数组下
                return configuration.compareSet ? configuration.compareSet((id)self, object) : [(NSSet *)self isEqualToSet:object];
            case GMLEncodingNSDictionary:
                return configuration.compareDictionary ? configuration.compareDictionary((id)self, object) : [self _compareMap:object configuration:configuration];
            case GMLEncodingNSMapTable: // 字典下
                return [self _compareMap:object configuration:configuration];
        }
        
        id targetObj = nil;
        GMLClassInfo *infoA = [GMLClassInfo infoWithClass:[self class]];
        GMLClassInfo *infoB = [GMLClassInfo infoWithClass:[object class]];
        
        if ([self isKindOfClass:infoB.mClass]) {
            targetObj = self;
        }else if ([object isKindOfClass:infoA.mClass]) {
            targetObj = object;
        }else {
            return false; // 没有继承关系时直接返回 false
        }
        GMLClassInfo *currentClassInfo = targetObj == self ? infoA : infoB;
        id compareObject = targetObj == self ? object : self;
        while (currentClassInfo && currentClassInfo.mSuperclass) { // 忽略 NSObject/NSProxy
            BOOL isMemberCompare = currentClassInfo.mClass == [compareObject class];
            switch (configuration.type) {
                case GMLObjectCompareTypeProperty: {
                    for (GMLPropertyInfo *property in currentClassInfo.propertyInfos.allValues) {
//                        if ([targetObj respondsToSelector:property.getter]) {
//                            <#statements#>
//                        }
//                        if (!isMemberCompare) {
//                            property.getter
//                        }
                    }
                }
                case GMLObjectCompareTypeIvar: {
                }
            }
            currentClassInfo = currentClassInfo.superClassInfo;
        }
    }
    return false;
}

- (GMLEncodingNSType)_toNSType {
    
    if ([self isKindOfClass:NSString.class]) return GMLEncodingNSString;
    if ([self isKindOfClass:NSNumber.class]) return GMLEncodingNSNumber;
    if ([self isKindOfClass:NSArray.class]) return GMLEncodingNSArray;
    if ([self isKindOfClass:NSDictionary.class]) return GMLEncodingNSDictionary;
    
    if ([self isKindOfClass:NSValue.class]) return GMLEncodingNSValue;
    if ([self isKindOfClass:NSData.class]) return GMLEncodingNSData;
    if ([self isKindOfClass:NSDate.class]) return GMLEncodingNSDate;
    if ([self isKindOfClass:NSURL.class]) return GMLEncodingNSURL;
    if ([self isKindOfClass:NSSet.class]) return GMLEncodingNSSet;
    if ([self isKindOfClass:NSOrderedSet.class]) return GMLEncodingNSOrderedSet;
    if ([self isKindOfClass:NSHashTable.class]) return GMLEncodingNSHashTable;
    if ([self isKindOfClass:NSMapTable.class]) return GMLEncodingNSMapTable;
    return GMLEncodingNSUnknown;
}

/// 验证并遍历 value 对象的集合，如： NSArray, NSDictionary
- (BOOL)_compareSequentialCollection:(id)object configuration:(GMLObjectCompareConfiguration *)configuration {
    if ([(id)self count] != [(id)object count]) return false;
    NSEnumerator *enumeratorA = [(id)self objectEnumerator];
    NSEnumerator *enumeratorB = [(id)object objectEnumerator];
    if (![enumeratorA isKindOfClass:[NSEnumerator class]] || ![enumeratorB isKindOfClass:[NSEnumerator class]]) return false;
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
    BOOL result = true;
    id obj = nil;
    while ((obj = enumeratorA.nextObject)) {
        result = [obj isValueEqual:enumeratorB.nextObject configuration:configuration];
        if (!result) return false;
    }
    return result;
}
- (BOOL)_compareMap:(id)map configuration:(GMLObjectCompareConfiguration *)configuration {
    if ([(id)self count] != [(id)map count]) return false;
    NSEnumerator *keyEnumerator = [(id)self keyEnumerator];
    if (![keyEnumerator isKindOfClass:[NSEnumerator class]]) return false;
    BOOL result = true;
    id key = nil;
    while ((key = keyEnumerator.nextObject)) {
        result = [[(id)self objectForKey:key] isValueEqual:[map objectForKey:key] configuration:configuration];
        if (!result) return false;
    }
    return result;
}

@end

typedef NS_OPTIONS(NSUInteger, YJMessageType) {
    
    YJMessageTypeLayerMask = 0xF,
    YJMessageTypeMarkerLayer = 1,
    YJMessageTypeLineLayer = 2,
    YJMessageTypeRegionLayer = 3,
    
    YJMessageTypeWidgetMask = 0xF0,
    YJMessageTypeMarkers = 1 << 4,
    YJMessageTypeLines = 1 << 5,
    YJMessageTypeRegions = 1 << 6,
    
    YJMessageTypeOperateMask = 0xF00,
    YJMessageTypeOperateCreate = 1 << 8,
    YJMessageTypeOperateUpdate = 1 << 9,
    YJMessageTypeOperateDelete = 1 << 10,
    
    YJMessageTypeUpdateMask = 0xF000,
    YJMessageTypeUpdateBase = 1 << 13,
    YJMessageTypeUpdateStyle = 1 << 14,
    YJMessageTypeUpdateAttribute = 1 << 15,
    YJMessageTypeUpdateDisplay = 1 << 16,
};

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        testCalendarManager();
//        testRuntime();
//        NSNumber *num1  = [NSNumber numberWithInt:1];
//        NSNumber *num2 = [NSNumber numberWithFloat:1];
//        NSLog(@"isEqual: %i", [num1 isEqual:num2]);
//        NSLog(@"isEqualToNumber: %i", [num1 isEqualToNumber:num2]);
//
//        NSString *str1 = NSString.string;
//        NSObject *obj2 = NSObject.new;
//        GMLClassInfo *info = [GMLClassInfo infoWithClass:[GMLClassInfo infoWithClass:TestA.class].metaClass];
//        NSLog(@"%@, %@, %i", NSStringFromClass(str1.superclass), NSStringFromClass(obj2.class), [str1.superclass isMemberOfClass:obj2.class]);
//        NSLog(@"%i", [TestA.new isValueEqual:TestA.new configuration:nil]);
        
        YJMessageType type = YJMessageTypeRegionLayer + YJMessageTypeOperateUpdate + YJMessageTypeUpdateStyle;
        type ^= YJMessageTypeUpdateStyle;
        
        NSLog(@"%i, %i, %i", type & YJMessageTypeLayerMask, type & YJMessageTypeOperateMask, type & YJMessageTypeUpdateMask);
    }
    return 0;
}

//void testCalendarManager() {
//    GMLCalendarManager *manager = GMLCalendarManager.defaultManager;
//    NSLog(@"1. %@", [manager string:@"2022-01-01" format:GMLYearFormat]);
//    NSLog(@"2. %@", [manager date:NSDate.date format:GMLFullDateFormat]);
//    NSLog(@"2. %@", [manager string:[manager date:NSDate.date format:GMLFullDateFormat] format:GMLFullDateFormat]);
//    NSString *dateStr = @"2022-08-15 23:00:00";
//    NSDate *fromDate = [manager string:dateStr format:GMLFullDateFormat];
//    NSDate *toDate = NSDate.date;
//    NSInteger offsetDay = [manager dayWithFromDate:fromDate toDate:toDate];
//    NSLog(@"from: %@, to: %@, offsetDay: %li", fromDate, toDate, (long)offsetDay);
//}




