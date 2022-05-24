//
//  GMLViewControllerViewStateDefine.h
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#ifndef GMLViewControllerViewStateDefine_h
#define GMLViewControllerViewStateDefine_h

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, GMLViewControllerViewState) {
    GMLViewControllerViewStateWillAppear = 1 << 0,
    GMLViewControllerViewStateDidAppear = 1 << 1,
    GMLViewControllerViewStateWillDisappear = 1 << 2,
    GMLViewControllerViewStateDidDisappear = 1 << 3,
    
    GMLViewControllerViewStateAppear = GMLViewControllerViewStateWillAppear | GMLViewControllerViewStateDidAppear,
    GMLViewControllerViewStateDisappear = GMLViewControllerViewStateWillDisappear | GMLViewControllerViewStateDidDisappear,
    
    GMLViewControllerViewStateAll = GMLViewControllerViewStateWillAppear | GMLViewControllerViewStateDidAppear | GMLViewControllerViewStateWillDisappear | GMLViewControllerViewStateDidDisappear,
};

@protocol GMLViewControllerViewStateToken <NSObject>
@end

typedef void (^GMLViewControllerViewStateCallback)(GMLViewControllerViewState state, BOOL animated);

#endif /* GMLViewControllerViewStateDefine_h */
