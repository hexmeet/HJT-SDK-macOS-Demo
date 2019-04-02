//
//  UncaughtExceptionHandler.h
//  easyVideo
//
//  Created by quanhao huang on 2018/11/22.
//  Copyright © 2018 easyVideo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UncaughtExceptionHandler : NSObject

@end

void InstallUncaughtExceptionHandler(void);

NS_ASSUME_NONNULL_END
