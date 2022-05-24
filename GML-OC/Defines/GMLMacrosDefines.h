//
//  GMLMacrosDefines.h
//  GML-OC
//
//  Created by GML on 2022/5/24.
//

#ifndef GMLMacrosDefines_h
#define GMLMacrosDefines_h

#define GMLEqualObjectAndContainNil(lObj, rObj) ( \
    ((lObj) == nil && (rObj) == nil) \
    || [(lObj) isEqual:(rObj)] \
)

#define GMLEqualDictionaryAndContainNil(lObj, rObj) ( \
    ((lObj) == nil && (rObj) == nil) \
    || [(lObj) isEqualToDictionary:(rObj)] \
)

#define GMLEqualObjectAndContainNil(lObj, rObj) ( \
    ((lObj) == nil && (rObj) == nil) \
    || [(lObj) isEqual:(rObj)] \
)

#define GMLEqualArrayAndContainNil(lObj, rObj) ( \
    ((lObj) == nil && (rObj) == nil) \
    || [(lObj) isEqualToArray:(rObj)] \
)

#endif /* GMLMacrosDefines_h */
