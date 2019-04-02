//
//  ExceptionModel.h
//  easyVideo
//
//  Created by quanhao huang on 2018/11/22.
//  Copyright © 2018 easyVideo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const UncaughtExceptionHandlerSignalExceptionName;
extern NSString * const UncaughtExceptionHandlerSignalKey;
extern NSString * const UncaughtExceptionHandlerAddressesKey;

extern const volatile int32_t UncaughtExceptionCount;
extern const int32_t UncaughtExceptionMaximum;

extern const NSInteger UncaughtExceptionHandlerSkipAddressCount;
extern const NSInteger UncaughtExceptionHandlerReportAddressCount;

@interface ExceptionModel : NSObject

@end

NS_ASSUME_NONNULL_END
