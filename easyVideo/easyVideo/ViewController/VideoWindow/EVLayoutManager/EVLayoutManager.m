//
//  EVLayoutManager.m
//  easyVideo
//
//  Created by quanhao huang on 2018/9/13.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "EVLayoutManager.h"

static EVLayoutManager *sharedEVLayoutManager = nil;
@implementation EVLayoutManager

SVCLayoutDetail gSvcLayoutDetail[SVC_LAYOUT_MODE_NUMBER] = {0};

+ (EVLayoutManager *)getInstance
{
    if (sharedEVLayoutManager == nil)
    {
        @synchronized(self)
        {
            if (sharedEVLayoutManager == nil)
            {
                sharedEVLayoutManager = [[EVLayoutManager alloc] init];
            }
        }
    }
    
    return sharedEVLayoutManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        prepareSVCLayoutDetail(localWidth, localHeight);
    }
    return self;
}

void prepareSVCLayoutDetail(float screenWidth, float screenHeight)
{
    for (SVCLayoutModeType mode = SVC_LAYOUT_MODE_1X1; mode < SVC_LAYOUT_MODE_NUMBER ; mode++)
    {
        switch (mode) {
            case SVC_LAYOUT_MODE_1X1:
                gSvcLayoutDetail[mode] = (SVCLayoutDetail){1,
                    {0, 0, 1.0, 1.0}};
                break;
                
            case SVC_LAYOUT_MODE_1X2:
                gSvcLayoutDetail[mode] = (SVCLayoutDetail){2,
                        {{0, 0.25, 0.5, 0.5},
                        {0.5, 0.25, 0.5, 0.5}}};
                break;
                
            case SVC_LAYOUT_MODE_2X2:
                gSvcLayoutDetail[mode] = (SVCLayoutDetail){2,
                        {{0, 0.5, 0.5, 0.5},
                        {0.5, 0.5, 0.5, 0.5},
                        {0, 0, 0.5, 0.5},
                        {0.5, 0, 0.5, 0.5}}};
                break;
                
            case SVC_LAYOUT_MODE_2X3:
                gSvcLayoutDetail[mode] = (SVCLayoutDetail){6,
                        {{0, 0.3, 0.3, 0.3},
                        {0.33333, 0.3, 0.3, 0.3},
                        {0.66666, 0.3, 0.3, 0.3},
                        {0, 0.6, 0.3, 0.3},
                        {0.33333, 0.6, 0.3, 0.3},
                        {0.66666, 0.6, 0.3, 0.3}}};
                break;
                
            case SVC_LAYOUT_MODE_3X3:
                gSvcLayoutDetail[mode] = (SVCLayoutDetail){9,
                        {{0, 0.666666, 0.333333, 0.333333},
                        {0.333333, 0.666666, 0.333333, 0.333333},
                        {0.666666, 0.666666, 0.333333, 0.333333},
                        {0, 0.333333, 0.333333, 0.333333},
                        {0.333333, 0.333333, 0.333333, 0.333333},
                        {0.666666, 0.333333, 0.333333, 0.333333},
                        {0, 0, 0.333333, 0.333333},
                        {0.333333, 0, 0.333333, 0.333333},
                        {0.666666, 0, 0.333333, 0.333333}}};
                break;
                
            case SVC_LAYOUT_MODE_NUMBER:
            default:
                break;
        }
    }
}

@end
