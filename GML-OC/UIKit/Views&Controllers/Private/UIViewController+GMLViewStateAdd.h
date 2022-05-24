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

- (id<GMLViewControllerViewStateToken>)gml_addViewWillAppearBlock:(GMLViewShowStateBlock)block;
- (id<GMLViewControllerViewStateToken>)gml_addViewDidAppearBlock:(GMLViewShowStateBlock)block;
- (id<GMLViewControllerViewStateToken>)gml_addViewWillDisappearBlock:(GMLViewShowStateBlock)block;
- (id<GMLViewControllerViewStateToken>)gml_addViewDidDisappearBlock:(GMLViewShowStateBlock)block;

@end

NS_ASSUME_NONNULL_END
