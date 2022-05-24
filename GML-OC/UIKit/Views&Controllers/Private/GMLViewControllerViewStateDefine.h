//
//  GMLViewControllerViewStateDefine.h
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#ifndef GMLViewControllerViewStateDefine_h
#define GMLViewControllerViewStateDefine_h

#import <Foundation/Foundation.h>

@protocol GMLViewControllerViewStateToken <NSObject>
- (void)cancel;
@end

typedef void (^GMLViewShowStateBlock)(id<GMLViewControllerViewStateToken> token, BOOL animated);

typedef NS_ENUM(NSInteger, GMLViewControllerViewState) {
    GMLViewControllerViewStateWillAppear,
    GMLViewControllerViewStateDidAppear,
    GMLViewControllerViewStateWillDisappear,
    GMLViewControllerViewStateDidDisappear,
};

#endif /* GMLViewControllerViewStateDefine_h */
