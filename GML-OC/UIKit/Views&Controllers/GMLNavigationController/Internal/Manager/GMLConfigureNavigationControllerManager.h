//
//  GMLConfigureNavigationControllerManager.h
//  GML-OC
//
//  Created by GML on 2022/5/24.
//

#import <Foundation/Foundation.h>
#import "GMLConfigureNavigationControllerDefines.h"
#import <UIKit/UINavigationController.h>

NS_ASSUME_NONNULL_BEGIN
@class UINavigationController, UIViewController;
@protocol GMLNavigationBarAppearanceProtocol;
@interface GMLConfigureNavigationControllerManager : NSObject<UINavigationControllerDelegate>

@property (nonatomic, assign, readonly) BOOL isNeedUpdate;
@property (nullable, nonatomic, weak) UINavigationController *navigationController;
@property (nullable, nonatomic, copy) id<GMLNavigationBarAppearanceProtocol> defaultNavigationBarAppearance;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

- (void)handlePushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)handlePopViewControllerAnimated:(BOOL)animated;
- (void)handlePopToRootViewControllerAnimated:(BOOL)animated;
- (void)handlePopToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)handleSetViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated;

- (void)handleControllerForOperation:(GMLNavigationControllerOperation)operation
                  fromViewController:(UIViewController *)fromVC
                    toViewController:(UIViewController *)toVC
                            animated:(BOOL)animated;

- (void)updateNavigationControllerConfigure;

@end

NS_ASSUME_NONNULL_END
