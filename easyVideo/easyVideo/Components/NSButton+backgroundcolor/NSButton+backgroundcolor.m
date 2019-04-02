//
//  NSButton+backgroundcolor.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/22.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "NSButton+backgroundcolor.h"

@implementation NSButton (backgroundcolor)

- (void)changeLeftButtonattribute:(NSString *)text color:(NSColor *)color
{
    NSMutableParagraphStyle *pghStyle = [[NSMutableParagraphStyle alloc] init];
    
    pghStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *dicAtt = @{NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: pghStyle};
    self.title = @" ";
    
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedTitle];
    
    [attTitle replaceCharactersInRange:NSMakeRange(0, 1) withString:text];
    [attTitle addAttributes:dicAtt range:NSMakeRange(0, text.length)];
    
    self.attributedTitle = attTitle;
}

- (void)changeCenterButtonattribute:(NSString *)text color:(NSColor *)color
{
    NSMutableParagraphStyle *pghStyle = [[NSMutableParagraphStyle alloc] init];
    
    pghStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *dicAtt = @{NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: pghStyle};
    self.title = @" ";
    
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedTitle];
    [attTitle replaceCharactersInRange:NSMakeRange(0, 1) withString:text];
    [attTitle addAttributes:dicAtt range:NSMakeRange(0, text.length)];
    
    self.attributedTitle = attTitle;
}

- (void)changeRightButtonattribute:(NSString *)text color:(NSColor *)color
{
    NSMutableParagraphStyle *pghStyle = [[NSMutableParagraphStyle alloc] init];
    
    pghStyle.alignment = NSTextAlignmentRight;
    
    NSDictionary *dicAtt = @{NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: pghStyle};
    self.title = @" ";
    
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedTitle];
    [attTitle replaceCharactersInRange:NSMakeRange(0, 1) withString:text];
    [attTitle addAttributes:dicAtt range:NSMakeRange(0, text.length)];
    
    self.attributedTitle = attTitle;
}
@end
