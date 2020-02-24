//
//  ChatPageViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2019/12/18.
//  Copyright © 2019 easyVideo. All rights reserved.
//

#import "ChatPageViewController.h"

@interface ChatPageViewController ()<EMDelegate, NSTextViewDelegate>
{
    AppDelegate *appDelegate;
    EmojiPopover *emojiVc;
    NSPopover *popover;
    NSRange range;
}
/**
 消息数组
 */
@property (nonatomic, strong) NSMutableArray *messages;

@end

@implementation ChatPageViewController

#pragma mark - LAZY
- (NSMutableArray *)messages
{
    if (_messages == nil) {

        [[EMMessageManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray *results)            {
            NSMutableArray *models = [NSMutableArray arrayWithCapacity:results.count];
            MessageModel *previousModel = nil;
            for (MessageBody *user in results) {
                if ([[self->appDelegate.evengine getIMGroupID] isEqualToString:user.groupId]) {

                    self->_groupStr = user.groupId;
           
                    NSDictionary * dict = @{@"groupId":user.groupId,
                                            @"seq":[NSString stringWithFormat:@"%llu", user.seq],
                                            @"content":user.content,
                                            @"from":user.from,
                                            @"time":user.time,
                                            @"type":@(MessageModelTypeMe)};
                    
                    MessageModel *message = [MessageModel messageModelWithDict:dict];
                    message.name = @"";
                    message.imagUrl = @"";
                    [[EVUserIdManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray * _Nonnull results) {
                            for (EMGroupMemberInfo *user in results) {
             
                                if ([user.emuserId isEqualToString:message.from]) {
                                    message.imagUrl = user.imageUrl;
                                    message.name = user.name;
                                    if ([self->_userId isEqualToString:user.evuserId]) {
                                        message.type = MessageModelTypeMe;
                                    }else {
                                        message.type = MessageModelTypeOther;
                                    }
                                }
                            }
                    } fail:nil];
                    
                    //判断是否显示时间
//                    message.hiddenTime =  [message.time isEqualToString:previousModel.time];
                    
                    [models addObject:message];
                    
                    previousModel = message;
                }
            }
            self.messages = [models mutableCopy];
        } fail:^(NSError *error) {

        }];
        
    }
    return _messages;
}

- (void)viewWillAppear
{
    [super viewWillAppear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    appDelegate = APPDELEGATE;
    
    [[EMManager sharedInstance] addEMDelegate:self];
    
    self.userId = [NSString stringWithFormat:@"%llu", [appDelegate.evengine getUserInfo].userId];
    
    emojiVc = [[EmojiPopover alloc] init];
    
    popover = [[NSPopover alloc] init];
    [popover setContentViewController:emojiVc];
    [popover setContentSize:emojiVc.view.bounds.size];
    [popover setAnimates:NO];
    popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    
    emojiVc = [[EmojiPopover alloc] init];
    
    popover = [[NSPopover alloc] init];
    [popover setContentViewController:emojiVc];
    [popover setContentSize:emojiVc.view.bounds.size];
    [popover setAnimates:NO];
    popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    
    [self performSelector:@selector(test) withObject:nil afterDelay:10];
}

#pragma mark - NSTableViewDataSource and NSTableViewDelegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.messages.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    MessageModel *model = self.messages[row];
    return 85+[self getStringHeightWithText:model.content font:[NSFont systemFontOfSize:12] viewWidth:self.view.bounds.size.width/2];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    MessageModel *model = self.messages[row];
    if (model.type == MessageModelTypeMe) {
        MessageRightCell *cellView = [tableView makeViewWithIdentifier:@"MessageRightCell" owner:self];
        cellView.content.stringValue = model.content;
        cellView.name.stringValue = model.name;
        [cellView.headImage sd_setImageWithURL:[NSURL URLWithString:model.imagUrl]];
        cellView.time.stringValue = model.time;
        return cellView;
    }else {
        MessageLeftCell *cellView = [tableView makeViewWithIdentifier:@"MessageLeftCell" owner:self];
        cellView.content.stringValue = model.content;
        cellView.name.stringValue = model.name;
        [cellView.headImage sd_setImageWithURL:[NSURL URLWithString:model.imagUrl]];
        cellView.time.stringValue = model.time;
        return cellView;
    }
}

- (void)tableView:(NSTableView *)tableView didClickedRow:(NSInteger)row
{
    
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    return NO;
}

#pragma mark - EMDelegate
- (void)onMessageReciveData:(MessageBody *)message
{
    NSDictionary * dict = @{@"groupId":message.groupId,
                            @"seq":[NSString stringWithFormat:@"%llu", message.seq],
                            @"content":message.content,
                            @"from":message.from,
                            @"time":message.time,
                            @"type":@(MessageModelTypeOther)};
    
    MessageModel *messageModel = [MessageModel messageModelWithDict:dict];
    messageModel.imagUrl = @"";
    messageModel.name = @"";
    //判断是否显示时间
    messageModel.hiddenTime =  NO;
    
    [[EVUserIdManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray * _Nonnull results) {
        for (EMGroupMemberInfo *user in results) {
            if ([user.emuserId isEqualToString:message.from]) {
                
                messageModel.imagUrl = user.imageUrl;
                messageModel.name = user.name;
                
                if ([self->_userId isEqualToString:user.evuserId]) {
                    messageModel.type = MessageModelTypeMe;
                }else {
                    messageModel.type = MessageModelTypeOther;
                }
            }
            
        }
    } fail:nil];
    
    messageModel.time = [EVUtils userVisibleDateTimeStringForRFC3339DateTimeString:message.time];
    
    if ([messageModel.groupId isEqualToString:_groupStr]) {
        [self.messages addObject:messageModel];
        //刷新表格
        [self.mainTab reloadData];
    }
    
    [self.mainTab scrollRowToVisible:_messages.count-1];
}

- (void)onGroupMemberInfo:(EMGroupMemberInfo *)groupMemberInfo
{
    for (MessageModel *message in self.messages) {
        if (message.name.length == 0 || message.imagUrl.length == 0) {
            //重新刷新消息
            [[EVUserIdManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray * _Nonnull results) {
                for (EMGroupMemberInfo *user in results) {
                    if ([user.emuserId isEqualToString:message.from]) {
                        
                        message.imagUrl = user.imageUrl;
                        message.name = user.name;
                        
                    }
                    
                }
            } fail:nil];
        }
    }
    [self->_mainTab reloadData];
}

- (void)onEMError:(EMError *)err {
    DDLogInfo(@"IM on error:%@", err.reason);
}

- (void)onMessageSendSucceed:(MessageState *_Nonnull)messageState
{
    [self.mainTab scrollRowToVisible:_messages.count-1];
}

#pragma mark - TextViewDelegate
- (void)textDidChange:(NSNotification *)notification {

}

- (BOOL)textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    //insertTab:   -键入tab
    //insertNewline:   -键入回车
    //deleteBackward
    
    if ([NSStringFromSelector(commandSelector) isEqualToString:@"insertNewline:"]) {
        
        NSEventModifierFlags flags = [NSApplication sharedApplication].currentEvent.modifierFlags;
        
        if ((flags & NSEventModifierFlagShift) != 0) {
            [textView insertNewlineIgnoringFieldEditor:self];
            return YES;
        }else {
            if (textView.string.length != 0) {
                [self addMessage:textView.string type:MessageModelTypeMe];
            }
            return YES;
        }
    }
    return NO;
}

#pragma mark - ButtonMethod
- (IBAction)buttonMethodAciton:(id)sender
{
    if (sender == self.hiddenBtn) {
        [self.view.window orderOut:nil];
    }else if (sender == self.emojiBtn) {
        NSButton *btn = sender;
        NSRect cellRect = [btn bounds];
        
        if (popover.shown) {
            [popover close];
            self.inputView.selectedRange = self.inputView.selectedRange;
        }else {
            [popover showRelativeToRect:cellRect ofView:btn preferredEdge:NSRectEdgeMinY];
            self.inputView.selectedRange = self.inputView.selectedRange;
        }
    }
}

#pragma mark - Other
- (void)onCallEnd
{
    [[EMManager sharedInstance] removeEMDelegate:self];
    [self.view.window close];
}

- (CGFloat)getStringHeightWithText:(NSString *)text font:(NSFont *)font viewWidth:(CGFloat)width {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    
    // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.height);
}

- (void)emojiStr:(NSString *)emoji
{
    NSUInteger location  = self.inputView.selectedRange.location;
    NSString * textStr = self.inputView.string;
    NSString *resultStr = [NSString stringWithFormat:@"%@%@%@",[textStr substringToIndex:location], emoji,[textStr substringFromIndex:location]];
    self.inputView.string = resultStr;
    range = NSMakeRange(location+2, 0);
    self.inputView.selectedRange = range;
    [popover close];
}

- (void)addMessage:(NSString *)content type:(MessageModelType) type
{
    if ([appDelegate.emengine sendMessage:_groupStr content:content].length != 0 || [appDelegate.emengine sendMessage:@""content:content] != nil) {
        
        NSDate * date = [NSDate date];
        long long timeSp = [date timeIntervalSince1970]*1000;
        NSString *strDate = [EVUtils getDateDisplayString:timeSp];
        
        MessageModel * message = [[MessageModel alloc] init];
        message.type = type;
        message.content = content;
        message.time = strDate;
        message.from = [appDelegate.emengine getUserInfo].userId;
        message.name = [appDelegate.evengine getDisplayName];
        [[EVUserIdManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray * _Nonnull results) {
               for (EMGroupMemberInfo *user in results) {
                   if ([user.emuserId isEqualToString:message.from]) {
                       message.imagUrl = user.imageUrl;
                       message.name = user.name;
                   }
               }
       } fail:nil];
//        message.hiddenTime = [message.time isEqualToString:compareM.time];
  
        [self.messages addObject:message];
        [self.mainTab reloadData];
        
        self.inputView.string = @"";
    }
}

@end
