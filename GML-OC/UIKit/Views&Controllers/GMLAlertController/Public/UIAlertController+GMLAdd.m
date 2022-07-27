//
//  UIAlertController+GMLAdd.m
//  GML-OC
//
//  Created by GML on 2022/7/8.
//

#import "UIAlertController+GMLAdd.h"

@implementation UIAlertController (GMLAdd)

+ (void)showAlertTo:(UIViewController *)toVC title:(NSString *)title message:(NSString *)message finish:(NSString *)finish cancel:(NSString *)cancel completion:(void (^)(BOOL))completion {
    if (toVC == nil) return;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (finish != nil) {
        [alertController addAction:[UIAlertAction actionWithTitle:finish style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            !completion?: completion(false);
        }]];
    }
    if (cancel != nil) {
        [alertController addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            !completion?: completion(true);
        }]];
    }
    [toVC presentViewController:alertController animated:true completion:nil];
}

@end
