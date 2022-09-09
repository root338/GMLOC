//
//  GMLClassInfo.m
//  TestLineCommand
//
//  Created by GML on 2022/8/29.
//

#import "GMLClassInfo.h"
#import "GMLIvarInfo.h"
#import "GMLMethodInfo.h"
#import "GMLPropertyInfo.h"


@interface GMLClassInfo ()
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, readwrite) Class mClass;
@property (nonatomic, readwrite) BOOL isMeta;
@property (nullable, nonatomic, readwrite) Class metaClass;
@property (nullable, nonatomic, readwrite) Class mSuperclass;
@property (nullable, nonatomic, weak, readwrite) GMLClassInfo *superClassInfo;

@property (nonatomic, strong, readwrite) NSMutableDictionary<NSString *, GMLIvarInfo *> *ivarInfos;
@property (nonatomic, strong, readwrite) NSMutableDictionary<NSString *, GMLPropertyInfo *> *propertyInfos;
@property (nonatomic, strong, readwrite) NSMutableDictionary<NSString *, GMLMethodInfo *> *methodInfos;
@end

@implementation GMLClassInfo

+ (instancetype)infoWithClass:(Class)mClass {
    if (mClass == nil) return nil;
    static dispatch_once_t onceToken;
    static NSCache *classCache = nil;
    dispatch_once(&onceToken, ^{
        classCache = [NSCache new];
    });
    NSString *key = NSStringFromClass(mClass);
    if (class_isMetaClass(mClass)) {
        key = [@"Meta@" stringByAppendingString:key];
    }
    id obj = [classCache objectForKey:key];
    if (obj) return obj;
    
    obj = [[GMLClassInfo alloc] initWithClass:mClass];
    [classCache setObject:obj forKey:key];
    return obj;
}

- (instancetype)initWithClass:(Class)class {
    self = [super init];
    if (self == nil) return nil;
    
    _name = NSStringFromClass(class);
    _mClass = class;
    _isMeta = class_isMetaClass(class);
    if (!_isMeta) {
        _metaClass = objc_getMetaClass(object_getClassName(class));
    }
    _mSuperclass = class_getSuperclass(class);
    
    [self _reloadData];
    
    return self;
}

- (void)_reloadData {
    unsigned int outCount;
    
    Ivar *ivarList = class_copyIvarList(_mClass, &outCount);
    _ivarInfos = [NSMutableDictionary dictionaryWithCapacity:outCount];
    if (ivarList != NULL) {
        for (NSInteger i = 0; i < outCount; i++) {
            GMLIvarInfo *info = [[GMLIvarInfo alloc] initWithIvar:ivarList[i]];
            if (info.name) _ivarInfos[info.name] = info;
        }
        free(ivarList);
    }
    objc_property_t *propertyList = class_copyPropertyList(_mClass, &outCount);
    _propertyInfos = [NSMutableDictionary dictionaryWithCapacity:outCount];
    if (propertyList != NULL) {
        for (NSInteger i = 0; i < outCount; i++) {
            GMLPropertyInfo *info = [GMLPropertyInfo newWithProperty:propertyList[i]];
            if (info.name) _propertyInfos[info.name] = info;
        }
        free(propertyList);
    }
    
    Method *methodList = class_copyMethodList(_mClass, &outCount);
    _methodInfos = [NSMutableDictionary dictionaryWithCapacity:outCount];
    if (methodList != NULL) {
        for (NSInteger i = 0; i < outCount; i++) {
            GMLMethodInfo *info = [[GMLMethodInfo alloc] initWithMethod:methodList[i]];
            if (info.name) _methodInfos[info.name] = info;
        }
        free(methodList);
    }
}

- (GMLClassInfo *)superClassInfo {
    return _mSuperclass != nil ? [GMLClassInfo infoWithClass:_mSuperclass] : nil;
}

@end
