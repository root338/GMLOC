//
//  GMLProtocolFlagManager.h
//  GML-OC
//
//  Created by GML on 2022/5/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMLProtocolFlagManager : NSObject

- (NSDictionary<NSString *, NSNumber *> *)flagInfoWithObject:(id)object protocols:(Protocol *)protocols;

@end

NS_ASSUME_NONNULL_END
