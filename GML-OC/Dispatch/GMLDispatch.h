//
//  GMLDispatch.h
//  GML-OC
//
//  Created by GML on 2022/7/20.
//

#ifndef GMLDispatch_h
#define GMLDispatch_h

#import <dispatch/queue.h>
#import <pthread/pthread.h>

typedef void (^GMLDispatchEmptyBlock) (void);
static inline void dispatch_async_on_main_queue(GMLDispatchEmptyBlock block) {
    dispatch_async(dispatch_get_main_queue(), block);
};

static inline void dispatch_sync_on_main_queue(GMLDispatchEmptyBlock block) {
    if (pthread_main_np()) {
        if (block) block();
    }else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
};

static inline void dispatch_async_queue(GMLDispatchEmptyBlock block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
};


#endif /* GMLDispatch_h */
