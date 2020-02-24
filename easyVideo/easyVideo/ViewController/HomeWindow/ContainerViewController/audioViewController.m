//
//  audioViewController.m
//  easyVideo
//
//  Created by quanhao huang on 2018/8/24.
//  Copyright © 2018年 easyVideo. All rights reserved.
//

#import "audioViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface audioViewController ()<AVAudioPlayerDelegate>
{
    AppDelegate *appDelegate;
    NSTimer *levelTimer;
    AVAudioPlayer *musicPlayer;
    AVAudioRecorder *recorder;
}
@end

@implementation audioViewController

@synthesize microphoneboBox, microphoneTitle, speakerboBox, speakerTitle, playBtn, playTitle, audioImageBg;

- (void)viewWillDisappear
{
    [super viewWillDisappear];
    
    [appDelegate.evengine enableMicMeter:NO];
    
    [levelTimer invalidate];
    levelTimer = nil;
    
    [musicPlayer stop];
    musicPlayer = nil;
    musicPlayer.delegate = nil;
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    playBtn.enabled = YES;
    [playBtn setBackgroundColor:COLORF1F1F1];
    playBtn.layer.cornerRadius = 4;
    speakerboBox.enabled = YES;
    
    [self testMicrophone];
    
    [self getAllEVDeviceAudioCapture];
    
    [self getAllEVDeviceAudioPlayback];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self setRootViewAttribute];
    
    [self languageLocalization];
}

- (void)setRootViewAttribute
{
    microphoneboBox.editable = NO;
    speakerboBox.editable    = NO;
    
    appDelegate = APPDELEGATE;
}

- (void)getAllEVDeviceAudioCapture
{
    NSArray *devices = [appDelegate.evengine getDevices:EVDeviceAudioCapture];
    if (devices.count != 0) {
        //cameraboBox select the first by default
        EVDevice *device = [appDelegate.evengine getDevice:EVDeviceAudioCapture];
        microphoneboBox.stringValue = device.name;
        [microphoneboBox removeAllItems];
        [appDelegate.evengine setDevice:EVDeviceVideoCapture withId:device.id];
        for (EVDevice *device in devices) {
            [microphoneboBox addItemWithObjectValue:device.name];
        }
    }
}

- (void)getAllEVDeviceAudioPlayback
{
    NSArray *devices = [appDelegate.evengine getDevices:EVDeviceAudioPlayback];
    if (devices.count != 0) {
        //cameraboBox select the first by default
        EVDevice *device = [appDelegate.evengine getDevice:EVDeviceAudioPlayback];
        speakerboBox.stringValue = device.name;
        [speakerboBox removeAllItems];
        [appDelegate.evengine setDevice:EVDeviceAudioPlayback withId:device.id];
        for (EVDevice *device in devices) {
            [speakerboBox addItemWithObjectValue:device.name];
        }
    }
}

- (void)testMicrophone
{
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
                              nil];
    
    NSError *error;
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (recorder)
    {
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
        levelTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    }
    else
    {
        NSLog(@"%@", [error description]);
    }
}

- (void)levelTimerCallback:(NSTimer *)timer {
    [recorder updateMeters];
    
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels    = [recorder averagePowerForChannel:0];
    
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    
    /* level 范围[0 ~ 1], 转为[0 ~ 20] 之间 */
    dispatch_async(dispatch_get_main_queue(), ^{
        int value = [[NSString stringWithFormat:@"%f", level*20] intValue];
        self->audioImageBg.image = [NSImage imageNamed:[NSString stringWithFormat:@"audio_%d", value]];
    });
}

/**
 Language localization
 */
- (void)languageLocalization
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:CHANGELANGUAGE object:nil];
    
    [LanguageTool initUserLanguage];
    
    microphoneTitle.stringValue = localizationBundle(@"home.set.audio.microphone");
    speakerTitle.stringValue = localizationBundle(@"home.set.audio.speaker");
    [playBtn changeCenterButtonattribute:localizationBundle(@"home.set.audio.play") color:CONTENTCOLOR];
    playTitle.stringValue = localizationBundle(@"home.set.audio.playtitle");
    
}

- (IBAction)microphoneboBoxAction:(id)sender
{
    NSArray *devices = [appDelegate.evengine getDevices:EVDeviceAudioCapture];
    for (EVDevice *device in devices) {
        if ([device.name isEqualToString:microphoneboBox.stringValue]) {
            
            [appDelegate.evengine setDevice:EVDeviceAudioCapture withId:device.id];
        }
    }
}

- (IBAction)speakerboBoxAction:(id)sender
{
    NSArray *devices = [appDelegate.evengine getDevices:EVDeviceAudioPlayback];
    for (EVDevice *device in devices) {
        if ([device.name isEqualToString:speakerboBox.stringValue]) {
            
            [appDelegate.evengine setDevice:EVDeviceAudioPlayback withId:device.id];
        }
    }
}

#pragma mark - ButtonMethod
- (IBAction)playAction:(id)sender
{
    playBtn.enabled = NO;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"speaker" ofType:@"wav"];
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    musicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:nil];
    musicPlayer.delegate = self;
    
    if (![musicPlayer isPlaying]){
        [musicPlayer prepareToPlay];
        [musicPlayer play];
        speakerboBox.enabled = NO;
    }
}

#pragma mark - AVAudioPlayerDelegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    speakerboBox.enabled = YES;
    playBtn.enabled = YES;
    [musicPlayer stop];
    musicPlayer = nil;
    musicPlayer.delegate = nil;
}

#pragma mark - Notification
/**
 Toggle language
 
 @param sender Notification
 */
- (void)changeLanguage:(NSNotification *)sender
{
    microphoneTitle.stringValue = localizationBundle(@"home.set.audio.microphone");
    speakerTitle.stringValue = localizationBundle(@"home.set.audio.speaker");
    [playBtn changeCenterButtonattribute:localizationBundle(@"home.set.audio.play") color:CONTENTCOLOR];
    playTitle.stringValue = localizationBundle(@"home.set.audio.playtitle");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGELANGUAGE object:nil];
}

@end
