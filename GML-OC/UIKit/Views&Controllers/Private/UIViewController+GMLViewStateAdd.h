//
//  UIViewController+GMLViewStateAdd.h
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#import <UIKit/UIKit.h>
#import "GMLViewControllerViewStateDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (GMLViewStateAdd)

- (id<GMLViewControllerViewStateToken>)gml_addViewState:(GMLViewControllerViewState)state callback:(GMLViewControllerViewStateCallback)callback;
- (void)gml_removeViewStateToken:(id<GMLViewControllerViewStateToken>)token;
@end

NS_ASSUME_NONNULL_END
