//
//  GMLPropertyInfo.h
//  TestLineCommand
//
//  Created by GML on 2022/8/30.
//

#import <Foundation/Foundation.h>
#import "GMLRuntimeDefines.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMLPropertyInfo : NSObject

@property (nonatomic, readonly) objc_property_t property;
@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, assign, readonly) GMLPropertyAttribute attributes;
@property (nonatomic, assign, readonly) GMLEncodingType type;
@property (nonatomic, copy, readonly) NSString *typeEncoding;

@property (nullable, nonatomic, readonly) SEL getter;
@property (nullable, nonatomic, readonly) SEL setter;

@property (nullable, nonatomic, readonly) Class mClass;
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *protocols;

@property (nullable, nonatomic, copy, readonly) NSString *ivarName;

+ (instancetype)newWithProperty:(objc_property_t)property;

@end

NS_ASSUME_NONNULL_END
