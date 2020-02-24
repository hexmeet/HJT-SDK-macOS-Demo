//
//  MessageModel.h
//  easyVideo
//
//  Created by quanhao huang on 2019/12/18.
//  Copyright © 2019 easyVideo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    MessageModelTypeMe = 0,
    MessageModelTypeOther
} MessageModelType;

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) MessageModelType type;
@property (nonatomic, copy) NSString *seq;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imagUrl;
@property (nonatomic, assign) BOOL hiddenTime;

HQInitH(messageModel)

@end

NS_ASSUME_NONNULL_END
