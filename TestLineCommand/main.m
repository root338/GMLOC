//
//  main.m
//  TestLineCommand
//
//  Created by GML on 2022/5/24.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray *mArr = [NSMutableArray arrayWithObjects:
                                @1, @3, @4, @11, @00, @77, nil];
//        [mArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [mArr removeObject:obj];
//            NSLog(@"%@", obj);
//        }];
        NSHashTable *mList = [NSHashTable weakObjectsHashTable];
        for (NSNumber *obj in mArr) {
            NSLog(@"%@", obj);
            [mList addObject:obj];
        }
        NSLog(@"%@", mList.allObjects);
        for (NSNumber *obj in mList) {
            [mArr removeObject:obj];
            NSLog(@"%@", obj);
        }
//        for (NSNumber *obj in mArr) {
//            [mArr removeObject:obj];
//            NSLog(@"%@", obj);
//        }
    }
    return 0;
}
