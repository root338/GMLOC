//
//  GMLPropertyMacro.h
//  GML-OC
//
//  Created by GML on 2022/8/4.
//

#ifndef GMLPropertyMacro_h
#define GMLPropertyMacro_h

#import <GML_OC/GMLDataCompareMacro.h>


#define GMLWriteClassProperty(a) \
if (GMLClassIsEqual(_##a, a)) return;\
_##a = a;

#define GMLWriteClassCopyProperty(a) \
if (GMLClassIsEqual(_##a, a)) return;\
_##a = [a copy];

#define GMLWriteValueProperty(a) \
if (_##a == a) return; \
_##a = a;

#define GMLWriteFloatProperty(a) \
if (GMLFloatIsEqual(_##a, a)) return;\
_##a = a;

#endif /* GMLPropertyMacro_h */
