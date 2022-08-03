//
//  GMLValueMacroDefine.h
//  GML-OC
//
//  Created by GML on 2022/8/3.
//

#ifndef GMLValueMacroDefine_h
#define GMLValueMacroDefine_h

#pragma mark - Equal Compare
#define YMFloatIsEqual(a, b) (fabs((a) - (b)) < 0.0001)

#define YMClassIsEqual(a, b) ((a) == (b) || ((a) != nil && (b) != nil && [(a) isEqual:(b)]))


#pragma mark - UIKit
#define YMViewItselfInvisible(view) ((view) == nil || (view).isHidden || (view).frame.size.width < 0.001 || (view).frame.size.height < 0.001)
#define YMViewInvisible(view) (YMViewItselfInvisible(view) || (view).window == nil)


#pragma mark - Method
#define YMWriteClassProperty(a) \
if (YMClassIsEqual(_##a, a)) return;\
_##a = a;

#define YMWriteClassCopyProperty(a) \
if (YMClassIsEqual(_##a, a)) return;\
_##a = [a copy];

#define YMWriteValueProperty(a) \
if (_##a == a) return; \
_##a = a;

#define YMWriteFloatProperty(a) \
if (YMFloatIsEqual(_##a, a)) return;\
_##a = a;

#endif /* GMLValueMacroDefine_h */
