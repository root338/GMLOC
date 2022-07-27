//
//  UIAlertController+GMLAdd.h
//  GML-OC
//
//  Created by GML on 2022/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (GMLAdd)

+ (void)showAlertTo:(UIViewController *)toVC
                      title:(nullable NSString *)title
                    message:(nullable NSString *)message
                     finish:(nullable NSString *)finish
                     cancel:(nullable NSString *)cancel
                 completion:(void(^_Nullable)(BOOL isCancel))completion;
//+ (instancetype)showTo:(UIViewController *)toVC configuration:()

@end

NS_ASSUME_NONNULL_END
