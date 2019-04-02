//
//  EVLayoutManager.h
//  easyVideo
//
//  Created by quanhao huang on 2018/9/13.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _SVCLayoutModeType
{
    SVC_LAYOUT_MODE_1X1,
    SVC_LAYOUT_MODE_1X2,
    SVC_LAYOUT_MODE_2X2,
    SVC_LAYOUT_MODE_2X3,
    SVC_LAYOUT_MODE_3X3,
    SVC_LAYOUT_MODE_NUMBER,
}SVCLayoutModeType;

typedef struct _SVCLayoutDetail
{
    int videoViewNum;
    float videoViewDescription[9][4];
}SVCLayoutDetail;

@interface EVLayoutManager : NSObject
{
    int localWidth;
    int localHeight;
}

+ (EVLayoutManager *)getInstance;

@end
