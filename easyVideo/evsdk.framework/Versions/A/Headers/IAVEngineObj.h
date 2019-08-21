#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#endif
#import "EVCommonObj.h"

@protocol AVEngineDelegate <EVCommonDelegate>
@optional
- (void)onLoginSucceed:(EVUserInfo *_Nonnull)user;
- (void)onSIPRegister:(BOOL)registered;
- (void)onSIPForceClear;
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

//Anonymous call
- (int) registerSIPServer:(NSString * _Nullable)domain displayName:(NSString * _Nonnull)displayName username:(NSString * _Nonnull)username password:(NSString * _Nonnull)password protocol:(NSString * _Nonnull)protocol;
- (int) unregisterSIPServer;

//SIP
- (void) dialOut:(NSString *_Nonnull)number video:(BOOL)enable_video;
- (void) hangUp;
- (void) acceptCall:(BOOL)enable_video;

@end
