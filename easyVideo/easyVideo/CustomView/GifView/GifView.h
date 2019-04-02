//
//  GifView.h
//  easyVideo
//
//  Created by quanhao huang on 2018/9/6.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GifView : NSView

- (void)setImage:(NSImage*)image;
- (void)setImageURL:(NSString*)url;

@end
