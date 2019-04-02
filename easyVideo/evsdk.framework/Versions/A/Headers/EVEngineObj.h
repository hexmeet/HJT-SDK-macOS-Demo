#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "IAVEngineObj.h"
#import "IEVEngineObj.h"

//////////////////////////////
//  EVEngine
//////////////////////////////

@interface EVEngineObj : NSObject<IAVEngineObj, IEVEngineObj> {
}
//Common
//Log
- (void) setLog:(EVLogLevel)level path:(NSString *_Nonnull)log_path file:(NSString *_Nullable)log_file_name size:(unsigned int)max_file_size;
- (void) enableLog:(BOOL)enable;

//init
- (int) initialize:(NSString *_Nullable)config_path filename:(NSString *_Nullable)config_file_name;
- (int) setRootCA:(NSString *_Nonnull)root_ca_path;
- (int) setUserImage:(NSString *_Nonnull)background_file_path filename:(NSString *_Nullable)user_image_path;
- (int) enableWhiteBoard:(BOOL)enable;
- (int) setUserAgent:(NSString *_Nonnull)company version:(NSString *_Nonnull)version;
- (int) close;

//Login
- (int) enableSecure:(BOOL)enable;
- (NSString * _Nonnull) encryptPassword:(NSString * _Nonnull)password;
- (NSString * _Nonnull) getSerialNumber;
- (int) setProvision:(NSString * _Nonnull)server port:(unsigned int)port;
- (int) clearProvision;

//Device
- (NSArray<EVDevice *> * _Nonnull) getDevices:(EVDeviceType)type;
- (EVDevice * _Nonnull) getDevice:(EVDeviceType)type;
- (void) setDevice:(EVDeviceType)type withId:(unsigned int)id;
- (int) enableMicMeter:(BOOL)enable;
- (float) getMicVolume;

//Set Windows
- (int) setLocalVideoWindow:(void *_Nullable)id;
- (int) setRemoteVideoWindow:(void *_Nullable)id;
- (int) setRemoteContentWindow:(void *_Nullable)id;
- (int) setLocalContentWindow:(void *_Nullable)id mode:(EVContentMode)mode;

//Conference
- (int) enablePreview:(BOOL)enable;
- (int) setBandwidth:(unsigned int)kbps;
- (int) enableCamera:(BOOL)enable;
- (int) enableMic:(BOOL)enable;
- (BOOL) remoteMuted;
- (int) requestRemoteUnmute:(BOOL)val;
- (int) enableHighFPS:(BOOL)enable;
- (NSArray<EVStreamStats *> * _Nonnull) getStats;
- (BOOL) cameraEnabled;
- (BOOL) micEnabled;
- (BOOL) highFPSEnabled;
- (float) getNetworkQuality;

//Send Content
- (int) sendContent;
- (int) sendWhiteBoard;
- (int) stopContent;

//AVC
//CallBack
- (void) setAVDelegate:(id<AVEngineDelegate>_Nonnull)aDelegate;

//Login
- (int) avlogin:(NSString *_Nonnull)server port:(unsigned int)port name:(NSString *_Nonnull)username password:(NSString *_Nonnull)password;
- (int) avlogout;

//SIP
- (void) dialOut:(NSString *_Nonnull)number;
- (void) hangUp;
- (void) acceptCall;

//SVC
//CallBack
- (void) setDelegate:(id<EVEngineDelegate>_Nonnull)aDelegate;

//Login
- (int) login:(NSString *_Nonnull)server port:(unsigned int)port name:(NSString *_Nonnull)username password:(NSString *_Nonnull)password;
- (int) loginWithLocation:(NSString *_Nonnull)location_server port:(unsigned int)port name:(NSString *_Nonnull)username password:(NSString *_Nonnull)password;
- (int) logout;
- (int) downloadUserImage:(NSString *_Nonnull)path;
- (int) uploadUserImage:(NSString *_Nonnull)path;
- (int) changePassword:(NSString *_Nonnull)oldpassword newpassword:(NSString *_Nonnull)newpassword;
- (int) changeDisplayName:(NSString *_Nonnull)display_name;
- (EVUserInfo *_Nullable) getUserInfo;

//Set Windows
- (int) setRemoteVideoWindow:(void *_Nullable[_Nonnull])id andSize:(unsigned int)size;

//Conference & Layout
- (int) setMaxRecvVideo:(unsigned int)num;
- (int) joinConference:(NSString *_Nonnull)conference_number display_name:(NSString *_Nonnull)display_name password:(NSString *_Nonnull)password;
- (int) joinConference:(NSString *_Nonnull)server port:(unsigned int)port conference_number:(NSString *_Nonnull)conference_number display_name:(NSString *_Nonnull)display_name password:(NSString *_Nonnull)password;
- (int) joinConferenceWithLocation:(NSString *_Nonnull)location_server port:(unsigned int)port conference_number:(NSString *_Nonnull)conference_number display_name:(NSString *_Nonnull)display_name password:(NSString *_Nonnull)password;
- (int) leaveConference;
- (int) setLayout:(EVLayoutRequest *_Nonnull)layout;

@end
