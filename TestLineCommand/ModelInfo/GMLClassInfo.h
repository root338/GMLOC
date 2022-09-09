//
//  GMLClassInfo.h
//  TestLineCommand
//
//  Created by GML on 2022/8/29.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

@class GMLPropertyInfo, GMLIvarInfo, GMLMethodInfo;
@interface GMLClassInfo : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) Class mClass;
@property (nonatomic, readonly) BOOL isMeta;
@property (nullable, nonatomic, readonly) Class metaClass;
@property (nullable, nonatomic, readonly) Class mSuperclass;
@property (nullable, nonatomic, weak, readonly) GMLClassInfo *superClassInfo;

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, GMLIvarInfo *> *ivarInfos;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, GMLPropertyInfo *> *propertyInfos;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, GMLMethodInfo *> *methodInfos;
//@property (nonatomic, strong) <#class#> *protocolList;

+ (instancetype)infoWithClass:(Class)mClass;


@end

NS_ASSUME_NONNULL_END
