//
//  GMLDataCompareMacro.h
//  GML-OC
//
//  Created by GML on 2022/8/4.
//

#ifndef GMLDataCompareMacro_h
#define GMLDataCompareMacro_h

#define GMLFloatIsEqual(a, b) (fabs((a) - (b)) < 0.00001)

#define GMLClassIsEqual(a, b) ((a) == (b) || ((a) != nil && (b) != nil && [(a) isEqual:(b)]))

#define GMLEqualObjectAndContainNil(lObj, rObj) ( \
    ((lObj) == nil && (rObj) == nil) \
    || ((rObj) != nil && [(lObj) isEqual:(rObj)]) \
)

#define GMLEqualDictionaryAndContainNil(lObj, rObj) ( \
    ((lObj) == nil && (rObj) == nil) \
    || ((rObj) != nil && [(lObj) isEqualToDictionary:(rObj)]) \
)

#define GMLEqualStringAndContainNil(lObj, rObj) ( \
    ((lObj) == nil && (rObj) == nil) \
    || ((rObj) != nil && [(lObj) isEqualToString:(rObj)]) \
)

#define GMLEqualArrayAndContainNil(lObj, rObj) ( \
    ((lObj) == nil && (rObj) == nil) \
    || ((rObj) != nil && [(lObj) isEqualToArray:(rObj)]) \
)

#endif /* GMLDataCompareMacro_h */
