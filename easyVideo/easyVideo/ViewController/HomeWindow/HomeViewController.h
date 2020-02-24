//
//  HomeViewController.h
//  easyVideo
//
//  Created by quanhao huang on 2018/8/17.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HomeViewController : NSViewController

/** Left Menu View */
@property (weak) IBOutlet NSView *leftMenuView;
@property (weak) IBOutlet NSButton *userImageBtn;
@property (weak) IBOutlet NSTextField *userName;
@property (weak) IBOutlet NSImageView *registerImage;
@property (weak) IBOutlet NSTextField *registerTitle;
//Meeting View
@property (weak) IBOutlet NSView *meetingView;
@property (weak) IBOutlet NSView *meetingline;
@property (weak) IBOutlet NSImageView *meetingViewImage;
@property (weak) IBOutlet NSTextField *meetingViewTitle;
@property (weak) IBOutlet NSButton *meetingBtn;
//Chat View
@property (weak) IBOutlet NSView *ChatView;
@property (weak) IBOutlet NSView *Chatline;
@property (weak) IBOutlet NSImageView *chatViewImage;
@property (weak) IBOutlet NSTextField *chatViewTitle;
@property (weak) IBOutlet NSButton *chatBtn;
@property (weak) IBOutlet NSLayoutConstraint *chatConstraint;
//AddressBookView
@property (weak) IBOutlet NSView *contactsView;
@property (weak) IBOutlet NSView *contactsline;
@property (weak) IBOutlet NSImageView *contactsImage;
@property (weak) IBOutlet NSTextField *contactsTitle;
@property (weak) IBOutlet NSButton *contactsBtn;
@property (weak) IBOutlet NSLayoutConstraint *contactsConstraint;
//Set View
@property (weak) IBOutlet NSView *setView;
@property (weak) IBOutlet NSView *setline;
@property (weak) IBOutlet NSImageView *setViewImage;
@property (weak) IBOutlet NSTextField *setViewTitle;
@property (weak) IBOutlet NSButton *setBtn;
@property (weak) IBOutlet NSLayoutConstraint *setConstraint;
/** Top Menu View */
@property (weak) IBOutlet NSView *topMenuView;
@property (weak) IBOutlet NSTextField *topMenuViewTitle;
@property (weak) IBOutlet NSButton *closeBtn;
@property (weak) IBOutlet NSButton *miniBtn;
@property (weak) IBOutlet NSButton *fullBtn;

/** Meeting Custom View */
@property (weak) IBOutlet NSView *webContainerView;
/** Chat Custom View*/
@property (weak) IBOutlet NSView *chatContainerView;
/**Contacts Custom View*/
@property (weak) IBOutlet NSView *contactsContainerView;
/** Setting Custom View */
@property (weak) IBOutlet NSView *setContainerView;

@end
