#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "EVCommonObj.h"

@protocol AVEngineDelegate <EVCommonDelegate>
@optional
- (void)onLoginSucceed:(EVUserInfo *_Nonnull)user;
- (void)onSIPRegister:(BOOL)registered;
@end

//////////////////////////////
//  AVEngine
//////////////////////////////

@protocol IAVEngineObj <IEVCommonObj>
@required

//CallBack
- (void) setAVDelegate:(id<AVEngineDelegate>_Nonnull)aDelegate;

//Login
- (int) avlogin:(NSString *_Nonnull)server port:(unsigned int)port name:(NSString *_Nonnull)username password:(NSString *_Nonnull)password;
- (int) avlogout;

//SIP
- (void) dialOut:(NSString *_Nonnull)number video:(BOOL)enable_video;
- (void) hangUp;
- (void) acceptCall:(BOOL)enable_video;

@end
