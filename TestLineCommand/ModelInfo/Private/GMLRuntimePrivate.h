//
//  GMLRuntimePrivate.h
//  GML-OC
//
//  Created by GML on 2022/8/30.
//

#ifndef GMLRuntimePrivate_h
#define GMLRuntimePrivate_h

#import "GMLRuntimeDefines.h"


static GMLEncodingType GMLGetEncodingType(const char *value) {
    switch (value[0]) {
        case 'c': return GMLEncodingTypeChar;
        case 'i': return GMLEncodingTypeInt;
        case 's': return GMLEncodingTypeShort;
        case 'l': return GMLEncodingTypeLong;
        case 'q': return GMLEncodingTypeLongLong;
        case 'C': return GMLEncodingTypeUnsignedChar;
        case 'I': return GMLEncodingTypeUnsignedInt;
        case 'S': return GMLEncodingTypeUnsignedShort;
        case 'L': return GMLEncodingTypeUnsignedLong;
        case 'Q': return GMLEncodingTypeLongLong;
        case 'f': return GMLEncodingTypeFloat;
        case 'd': return GMLEncodingTypeDouble;
        case 'b': return GMLEncodingTypeBool;
        case 'v': return GMLEncodingTypeVoid;
        case '*': return GMLEncodingTypeCString;
        case '@': return GMLEncodingTypeObject;
        case '#': return GMLEncodingTypeClass;
        case ':': return GMLEncodingTypeSelector;
        case '[': return GMLEncodingTypeCArray;
        case '{': return GMLEncodingTypeStruct;
        case '(': return GMLEncodingTypeUnion;
//        case 'b': return ;
        case '^': return GMLEncodingTypePointer;
        case '?': return GMLEncodingTypeUnknown;
        default: return 0;
    }
}

#endif /* GMLRuntimePrivate_h */
