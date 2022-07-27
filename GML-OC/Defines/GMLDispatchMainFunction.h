//
//  GMLDispatchMainFunction.h
//  GML-OC
//
//  Created by GML on 2022/7/20.
//

#ifndef GMLDispatchMainFunction_h
#define GMLDispatchMainFunction_h

#import <dispatch/queue.h>
#import <pthread/pthread.h>

#define dispatch_async_on_main_queue(block) dispatch_async(dispatch_get_main_queue(), (block));
#define dispatch_sync_on_main_queue(block) \
    if (pthread_main_np()) { \
        if (block) block(); \
    }else { \
        dispatch_sync(dispatch_get_main_queue(), block); \
    } \

#define dispatch_async_queue(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), (block));


#endif /* GMLDispatchMainFunction_h */
