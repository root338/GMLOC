//
//  GMLViewControllerViewStateItem.h
//  GML-OC
//
//  Created by GML on 2022/5/23.
//

#import <Foundation/Foundation.h>
#import "GMLViewControllerViewStateDefine.h"

NS_ASSUME_NONNULL_BEGIN
@class UIViewController;

typedef void (^GMLViewControllerViewStateCancelBlock)(id<GMLViewControllerViewStateToken> token);
@interface GMLViewControllerViewStateItem : NSObject<GMLViewControllerViewStateToken>

@property (nonatomic, copy, readonly) GMLViewShowStateBlock block;

- (instancetype)initWithBlock:(GMLViewShowStateBlock)block;
@end

NS_ASSUME_NONNULL_END
