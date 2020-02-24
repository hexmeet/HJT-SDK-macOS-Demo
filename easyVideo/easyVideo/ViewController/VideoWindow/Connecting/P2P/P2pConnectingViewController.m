//
//  P2pConnectingViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2019/11/13.
//  Copyright © 2019 easyVideo. All rights reserved.
//

#import "P2pConnectingViewController.h"

@interface P2pConnectingViewController ()
{
    AppDelegate *appDelegate;
    RippleAnimationView *animationView;
}
@end

@implementation P2pConnectingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = APPDELEGATE;
    
    [EVUtils playSound];
    
    _headImage.wantsLayer = YES;
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.cornerRadius = 70;
    
    [_localVideoView setBackgroundColor:BLACKCOLOR];
    
//    [appDelegate.evengine enablePreview:YES];
    [appDelegate.evengine setLocalVideoWindow:(__bridge void *)(_localVideoView)];
    
    if (!animationView) {
        animationView = [[RippleAnimationView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) animationType:AnimationTypeWithBackground];
        animationView.layer.masksToBounds = NO;
        animationView.frame = _headImage.frame;
    }
    [self.view addSubview:animationView positioned:NSWindowBelow relativeTo:_headImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:CLOSEP2PCONNECTINGWINDOW object:nil];
    
    _callTitle.stringValue = localizationBundle(@"home.p2pcall");
    _hangUpTitle.stringValue = localizationBundle(@"video.callend");
}

- (void)viewDidLayout
{
    [super viewDidLayout];

    animationView.frame = _headImage.frame;
    
}

- (IBAction)hangUpAction:(id)sender {
    
    [EVUtils stopSound];
    
    [appDelegate.evengine hangUp];
    
    [self.view.window close];
}

- (void)closeWindow
{
    [EVUtils stopSound];
    
    [self.view.window close];
}

@end
