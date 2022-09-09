//
//  GMLRuntimeDefines.h
//  GML-OC
//
//  Created by GML on 2022/8/26.
//

#ifndef GMLRuntimeDefines_h
#define GMLRuntimeDefines_h

typedef NS_OPTIONS(NSInteger, GMLPropertyAttribute) {
    GMLPropertyAttributeReadonly = 1 << 0,
    GMLPropertyAttributeCopy = 1 << 1,
    GMLPropertyAttributeRetain = 1 << 2,
    GMLPropertyAttributeNonatomic = 1 << 3,
    GMLPropertyAttributeDynamic = 1 << 4,
    GMLPropertyAttributeWeak = 1 << 5,
};

typedef NS_ENUM(NSInteger, GMLEncodingType) {
    GMLEncodingTypeChar = 1, ///< c
    GMLEncodingTypeInt, ///<  i
    GMLEncodingTypeShort, ///< s
    GMLEncodingTypeLong, /// < l
    GMLEncodingTypeLongLong, /// < q
    GMLEncodingTypeUnsignedChar, ///< C
    GMLEncodingTypeUnsignedInt, ///< I
    GMLEncodingTypeUnsignedShort, ///< S
    GMLEncodingTypeUnsignedLong, ///< L
    GMLEncodingTypeUnsignedLongLong, ///< Q
    GMLEncodingTypeFloat, ///< f
    GMLEncodingTypeDouble, ///< d
    GMLEncodingTypeBool, ///< B
    GMLEncodingTypeVoid, ///< v
    
    GMLEncodingTypeObject, ///< @
    GMLEncodingTypeClass, ///< #
    GMLEncodingTypeSelector,
    
    GMLEncodingTypeCString, ///< *
    GMLEncodingTypeCArray, ///< [array type]
    GMLEncodingTypeStruct, ///< {name=type}
    GMLEncodingTypeUnion, ///< (name=type)
//    GMLEncodingType
    GMLEncodingTypePointer, ///< ^type
    GMLEncodingTypeUnknown, ///< ?
        
};

@protocol GMLObjectProtocol <NSObject>

@optional
//- (NSDictionary *)custom

@end

@protocol GMLEqualProtocol <NSObject>

@required
- (BOOL)isEqualToGMLObject:(id)object;

@end




#endif /* GMLRuntimeDefines_h */
