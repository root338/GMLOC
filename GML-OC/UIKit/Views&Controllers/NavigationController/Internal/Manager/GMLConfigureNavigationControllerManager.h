//
//  GMLConfigureNavigationControllerManager.h
//  GML-OC
//
//  Created by GML on 2022/5/24.
//

#import <Foundation/Foundation.h>
#import "GMLConfigureNavigationControllerDefines.h"

NS_ASSUME_NONNULL_BEGIN
@class UINavigationController, UIViewController;
@protocol GMLNavigationBarAppearanceProtocol;
@interface GMLConfigureNavigationControllerManager : NSObject

@property (nullable, nonatomic, weak) UINavigationController *navigationController;
@property (nullable, nonatomic, copy) id<GMLNavigationBarAppearanceProtocol> defaultAppearance;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

- (void)handlePushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)handlePopViewControllerAnimated:(BOOL)animated;
- (void)handlePopToRootViewControllerAnimated:(BOOL)animated;
- (void)handleSetViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated;

- (void)handleControllerForOperation:(GMLNavigationControllerOperation)operation
                  fromViewController:(UIViewController *)fromVC
                    toViewController:(UIViewController *)toVC
                            animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
