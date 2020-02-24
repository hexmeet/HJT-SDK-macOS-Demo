//
//  EMManager.m
//  HexMeet
//
//  Created by quanhao huang on 2019/12/3.
//  Copyright © 2019 fo. All rights reserved.
//

#import "EMManager.h"

@implementation EMManager

static EMManager *_sharedInstance = nil;

+ (EMManager *)sharedInstance {
    if (_sharedInstance == nil) {
        @synchronized(self) {
            _sharedInstance = [[EMManager alloc] init];
        }
    }
    
    return _sharedInstance;
}

- (id)init {
    if(self=[super init]) {
        _delegates = (GCDMulticastDelegate<EMDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    
    return self;
}

- (void)addEMDelegate:(id<EMDelegate>)delegate {
    @synchronized(_delegates) {
        [_delegates addDelegate:delegate
                  delegateQueue:dispatch_get_main_queue()];
    }
}

- (void)removeEMDelegate:(id<EMDelegate>)delegate {
    @synchronized(_delegates) {
        [_delegates removeDelegate:delegate];
    }
}

@end
