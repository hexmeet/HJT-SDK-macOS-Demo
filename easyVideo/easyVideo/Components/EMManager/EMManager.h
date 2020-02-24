//
//  EMManager.h
//  HexMeet
//
//  Created by quanhao huang on 2019/12/3.
//  Copyright © 2019 fo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDMulticastDelegate.h"
#import "EMDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMManager : NSObject

+ (EMManager *)sharedInstance;

@property (nonatomic, strong) GCDMulticastDelegate<EMDelegate> *delegates;

-(void)addEMDelegate:(id<EMDelegate>)delegate;
-(void)removeEMDelegate:(id<EMDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
