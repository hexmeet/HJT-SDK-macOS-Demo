//
//  TextViewWithPlaceHolder.m
//  easyVideo
//
//  Created by quanhao huang on 2019/12/19.
//  Copyright © 2019 easyVideo. All rights reserved.
//

#import "TextViewWithPlaceHolder.h"

static NSAttributedString *placeHolderString;
@implementation TextViewWithPlaceHolder

+ (void)initialize
{
  static BOOL initialized = NO;
    if (!initialized) {
        NSColor *txtColor = [NSColor grayColor];
        NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:txtColor, NSForegroundColorAttributeName, nil];
        placeHolderString = [[NSAttributedString alloc] initWithString:@"      发送消息..." attributes:txtDict];
    }
}

- (BOOL)becomeFirstResponder
{
    [self setNeedsDisplay:YES];
    return [super becomeFirstResponder];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    if ([[self string] isEqualToString:@""] && self != [[self window] firstResponder])
         [placeHolderString drawAtPoint:NSMakePoint(0,0)];
}

- (BOOL)resignFirstResponder
{
    [self setNeedsDisplay:YES];
    return [super resignFirstResponder];
}

@end
