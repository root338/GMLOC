//
//  GMLUIKitMacro.h
//  GML-OC
//
//  Created by GML on 2022/8/4.
//

#ifndef GMLUIKitMacro_h
#define GMLUIKitMacro_h

#define GMLViewIsInvisible(view) ( \
    (view) == nil \
    || (view).isHidden \
    || (view).frame.size.width < 0.001 \
    || (view).frame.size.height < 0.001 \
)

#define GMLViewIsInvisibleOfWindow(view) ( \
    GMLViewIsInvisible(view) \
    || (view).window == nil \
)

#endif /* GMLUIKitMacro_h */
