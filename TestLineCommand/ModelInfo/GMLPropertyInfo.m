//
//  GMLPropertyInfo.m
//  TestLineCommand
//
//  Created by GML on 2022/8/30.
//

#import "GMLPropertyInfo.h"
#import "GMLRuntimePrivate.h"

@interface GMLPropertyInfo ()

@property (nonatomic, readwrite) objc_property_t property;
@property (nonatomic, copy, readwrite) NSString *name;

@property (nonatomic, readwrite) SEL getter;
@property (nonatomic, readwrite) SEL setter;

@property (nonatomic, assign, readwrite) GMLPropertyAttribute attributes;
@property (nonatomic, assign, readwrite) GMLEncodingType type;
@property (nonatomic, copy, readwrite) NSString *typeEncoding;

@property (nonatomic, readwrite) Class mClass;
@property (nonatomic, strong, readwrite) NSArray<NSString *> *protocols;

@property (nonatomic, copy, readwrite) NSString *ivarName;
@end

@implementation GMLPropertyInfo

+ (instancetype)newWithProperty:(objc_property_t)property {
    
    NSString *name = [NSString stringWithUTF8String:property_getName(property)];
    unsigned int outCount;
    objc_property_attribute_t * attributes = property_copyAttributeList(property, &outCount);
    if (attributes == NULL) return nil;
    
    GMLPropertyAttribute attribute = 0;
    GMLEncodingType type = 0;
    NSString *ivarName = nil;
    NSString *getterName = nil;
    NSString *setterName = nil;
    NSString *typeEncoding = nil;
    Class targetClass = nil;
    NSArray *protocols = nil;
    for (unsigned int i = 0; i < outCount; i++) {
        switch (attributes[i].name[0]) {
            case 'T': {
                const char *value = attributes[i].value;
                type = GMLGetEncodingType(value);
                typeEncoding = [NSString stringWithUTF8String:value];
                if (type & GMLEncodingTypeObject && typeEncoding.length) {
                    NSScanner *scanner = [NSScanner scannerWithString:typeEncoding];
                    NSString *result = nil;
                    if (![scanner scanString:@"@\"" intoString:NULL]) continue;
                    if ([scanner scanUpToString:@"<" intoString:&result]) {
                        targetClass = NSClassFromString(result);
                    }
                    NSMutableArray *mProtocols = NSMutableArray.array;
                    while ([scanner scanString:@"<" intoString:NULL]) {
                        if ([scanner scanUpToString:@">" intoString:&result]) [mProtocols addObject:result];
                        scanner.scanLocation += 1;
                    }
                    protocols = mProtocols.count ? mProtocols : nil;
                }
            }   break;
            case 'R':
                attribute |= GMLPropertyAttributeReadonly; break;
            case 'C':
                attribute |= GMLPropertyAttributeCopy; break;
            case 'V':
                ivarName = [NSString stringWithUTF8String:attributes[i].value];
                break;
            case '&':
                attribute |= GMLPropertyAttributeRetain; break;
            case 'N':
                attribute |= GMLPropertyAttributeNonatomic; break;
            case 'G':
                getterName = [NSString stringWithUTF8String:attributes[i].value];
                break;
            case 'S':
                setterName = [NSString stringWithUTF8String:attributes[i].value];
                break;
            case 'D':
                attribute |= GMLPropertyAttributeDynamic;
                break;
            case 'W':
                attribute |= GMLPropertyAttributeWeak;
                break;
            case 'P':
                break;
        }
    }
    free(attributes);
    
    if (setterName == nil && (attribute & GMLPropertyAttributeReadonly) == 0 && name.length > 0) {
        setterName = [NSString stringWithFormat:@"set%@%@", [name substringToIndex:1].uppercaseString, name.length == 1 ? @"" : [name substringFromIndex:1]];
    }
    
    GMLPropertyInfo *info = [GMLPropertyInfo new];
    info.property = property;
    info.name = name;
    info.getter = NSSelectorFromString(getterName ?: name);
    info.setter = NSSelectorFromString(setterName);
    info.attributes = attribute;
    info.type = type;
    info.typeEncoding = typeEncoding;
    info.ivarName = ivarName;
    info.mClass = targetClass;
    info.protocols = protocols;
    return info;
}

@end
