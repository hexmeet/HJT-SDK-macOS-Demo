#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#endif

//! Project version number for evsdk.
FOUNDATION_EXPORT double evsdkVersionNumber;

//! Project version string for evsdk.
FOUNDATION_EXPORT const unsigned char evsdkVersionString[];

//////////////////////////////
//  Common
//////////////////////////////
#define EV_STREAM_SIZE 20

typedef NS_ENUM (NSUInteger, EVCallType) {
	EVCallUnknown = 0,
	EVCallSIP = 1,
	EVCallH323 = 2,
	EVCallSVC = 3
};

typedef NS_ENUM (NSUInteger, EVSvcCallType) {
	EVSvcCallConf = 0,
	EVSvcCallP2P = 1
};

typedef NS_ENUM (NSUInteger, EVSvcCallAction) {
    EVSvcNoAction = 0,
    EVSvcIncomingCallRing = 1,
    EVSvcIncomingCallCancel = 2
};

typedef NS_ENUM (NSUInteger, EVCallDir) {
	EVCallOutgoing = 0,
	EVCallIncoming = 1
};

typedef NS_ENUM (NSUInteger, EVCallStatus) {
	EVCallStatusSuccess = 0,
	EVCallStatusAborted = 1,
	EVCallStatusMissed = 2,
	EVCallStatusDeclined = 3
};

typedef NS_ENUM (NSUInteger, EVStreamType) {
	EVStreamAudio = 0,
	EVStreamVideo = 1,
	EVStreamContent = 2,
	EVStreamWhiteBoard = 3
};

typedef NS_ENUM (NSUInteger, EVContentMode) {
    EVContentFullMode = 0,
    EVContentApplicationMode = 1
};

typedef NS_ENUM (NSUInteger, EVContentStatus) {
    EVContentUnknown = 0,
	EVContentGranted = 1,
	EVContentReleased = 2,
	EVContentDenied = 3,
	EVContentRevoked = 4
};

typedef NS_ENUM (NSUInteger, EVStreamDir) {
	EVStreamUpload = 0,
	EVStreamDownload = 1
};

typedef NS_ENUM (NSUInteger, EVWhiteBoardType) {
	EVACSWhiteBoard = 0,
	EVBelugaWhiteBoard = 1
};

typedef struct _EVVideoSize {
    int width;
    int height;
} EVVideoSize;

typedef enum EVEncryptType {
    EVEncryptSHA1 = 0,
    EVEncryptAES = 1
} EVEncryptType;


//////////////////////////////
//  Log
//////////////////////////////

typedef NS_ENUM (NSUInteger, EVLogLevel) {
    EVLogLevelDebug = 0,
    EVLogLevelMessage = 1,
    EVLogLevelWARNING = 2,
    EVLogLevelError = 3,
    EVLogLevelFatal = 4
};

//////////////////////////////
//  Error
//////////////////////////////

typedef NS_ENUM (NSUInteger, EVErrorType) {
    EVErrorTypeSdk = 0,
    EVErrorTypeServer = 1,
    EVErrorTypeLocate = 2,
    EVErrorTypeCall = 3,
    EVErrorTypeAVServer = 4,
    EVErrorTypeUnknown = 5
};

__attribute__((visibility("default"))) @interface EVError : NSObject
@property (assign, nonatomic) EVErrorType type;
@property (assign, nonatomic) int code;
@property (copy, nonatomic) NSString *_Nonnull msg;
@property (copy, nonatomic) NSArray<NSString *> * _Nullable args;
@end

typedef NS_ENUM (NSUInteger, EVSdkError) {
    EVOK = 0,
    EVNG = 1,
    EVUninitialized = 2,
    EVBadFormat = 3,
    EVNotInConf = 4,
    EVBadParam = 5,
    EVRegisterFailed = 6,
    EVInternalError = 7,
    EVServerUnreachable = 8,
    EVServerInvalid = 9,
    EVCallDeclined = 10,
    EVCallBusy = 11,
    EVCallIOError = 12,
    EVNotLogin = 13,
    EVCallTimeout = 14
 };

typedef NS_ENUM (NSUInteger, EVWarnCode) {
    EVWarnNetworkPoor = 0,
    EVWarnNetworkVeryPoor = 1,
    EVWarnBandwidthInsufficient = 2,
    EVWarnBandwidthVeryInsufficient = 3,
    EVWarnNoAudioCaptureCard = 4,
    EVWarnUnmuteAudioNotAllowed = 5,
    EVWarnUnmuteAudioIndication = 6
};

__attribute__((visibility("default"))) @interface EVWarn : NSObject
@property (assign, nonatomic) EVWarnCode code;
@property (copy, nonatomic) NSString *_Nonnull msg;
@end

//////////////////////////////
//  Device
//////////////////////////////

typedef NS_ENUM (NSUInteger, EVDeviceType) {
    EVDeviceAudioCapture = 0,
    EVDeviceAudioPlayback = 1,
    EVDeviceVideoCapture = 2
};

__attribute__((visibility("default"))) @interface EVDevice : NSObject
@property (assign, nonatomic) unsigned int id;
@property (assign, nonatomic) EVDeviceType type;
@property (copy, nonatomic) NSString *_Nonnull name;
@end

//////////////////////////////
//  Statistic
////////////////////////////// 

__attribute__((visibility("default"))) @interface EVStreamStats : NSObject
@property (assign, nonatomic) EVStreamType type;
@property (assign, nonatomic) EVStreamDir dir;
@property (copy, nonatomic) NSString *_Nonnull payload_type;
@property (assign, nonatomic) float nego_bandwidth; //kbps
@property (assign, nonatomic) float real_bandwidth; //kbps
@property (assign, nonatomic) uint64_t cum_packet;
@property (assign, nonatomic) float fps;  //Video only
@property (assign, nonatomic) EVVideoSize resolution; //Video only
@property (assign, nonatomic) uint64_t cum_packet_loss;
@property (assign, nonatomic) float packet_loss_rate;
@property (assign, nonatomic) bool is_encrypted;
@property (copy, nonatomic) NSString *_Nonnull name;
@property (assign, nonatomic) unsigned int ssrc;
@end

//////////////////////////////
//  Call Log
////////////////////////////// 

__attribute__((visibility("default"))) @interface EVCallLog : NSObject
@property (copy, nonatomic) NSString *_Nonnull id;
@property (assign, nonatomic) EVCallType type;
@property (assign, nonatomic) EVCallDir dir;
@property (assign, nonatomic) EVCallStatus status;
@property (copy, nonatomic) NSString *_Nonnull displayName;
@property (copy, nonatomic) NSString *_Nonnull peer;
@property (assign, nonatomic) uint64_t startTime;
@property (assign, nonatomic) uint64_t duration;
@property (assign, nonatomic) bool isAudioOnly;
@end

//////////////////////////////
//  Event
//////////////////////////////
__attribute__((visibility("default"))) @interface EVFeatureSupport : NSObject 
@property (assign, nonatomic) bool contactWebPage;
@property (assign, nonatomic) bool p2pCall;
@property (assign, nonatomic) bool chatInConference;
@property (assign, nonatomic) bool switchingToAudioConference;
@property (assign, nonatomic) bool sitenameIsChangeable;
@end

__attribute__((visibility("default"))) @interface EVUserInfo : NSObject
@property (assign, nonatomic) uint64_t userId;
@property (copy, nonatomic) NSString *_Nonnull username;
@property (copy, nonatomic) NSString *_Nonnull displayName;
@property (copy, nonatomic) NSString *_Nonnull org;
@property (copy, nonatomic) NSString *_Nonnull orgPortAllocMode;
@property (assign, nonatomic) uint64_t orgPortCount;
@property (copy, nonatomic) NSString *_Nonnull email;
@property (copy, nonatomic) NSString *_Nonnull cellphone;
@property (copy, nonatomic) NSString *_Nonnull telephone;
@property (assign, nonatomic) uint64_t deviceId;
@property (assign, nonatomic) BOOL everChangedPasswd;
@property (copy, nonatomic) NSString *_Nonnull dept;
@property (copy, nonatomic) NSString *_Nonnull customizedH5UrlPrefix;
@property (copy, nonatomic) NSString *_Nonnull token;
@property (copy, nonatomic) NSString *_Nonnull doradoVersion;
@property (copy, nonatomic) NSString *_Nonnull callNumber;
@property (copy, nonatomic) NSString *_Nonnull appServerType;
@property (copy, nonatomic) NSString *_Nonnull urlSuffixForMobile;
@property (copy, nonatomic) NSString *_Nonnull urlSuffixForPC;
@property (strong, nonatomic) EVFeatureSupport *_Nonnull featureSupport;

@end

__attribute__((visibility("default"))) @interface EVCallInfo : NSObject
@property (assign, nonatomic) BOOL isAudioOnly;
@property (assign, nonatomic) BOOL contentEnabled;
@property (copy, nonatomic) NSString *_Nonnull peer;
@property (copy, nonatomic) NSString *_Nonnull conference_number;
@property (copy, nonatomic) NSString *_Nonnull password;
@property (strong, nonatomic) EVError *_Nonnull err;
@property (assign, nonatomic) BOOL isBigConference;
@property (assign, nonatomic) BOOL isRemoteMuted;
@property (assign, nonatomic) EVSvcCallType svcCallType;
@property (assign, nonatomic) EVSvcCallAction svcCallAction;
@end

__attribute__((visibility("default"))) @interface EVContentInfo : NSObject
@property (assign, nonatomic) BOOL enabled;
@property (assign, nonatomic) EVStreamDir dir;
@property (assign, nonatomic) EVStreamType type;
@property (assign, nonatomic) EVContentStatus status;
@property (assign, nonatomic) BOOL isBigConference;
@property (assign, nonatomic) BOOL isRemoteMuted;
@end

@protocol EVCommonDelegate <NSObject>
@optional
- (void)onError:(EVError *_Nonnull)err;
- (void)onWarn:(EVWarn *_Nonnull)warn;
- (void)onLoginSucceed:(EVUserInfo *_Nonnull)user;
- (void)onDownloadUserImageComplete:(NSString *_Nonnull)path;
- (void)onUploadUserImageComplete:(NSString *_Nonnull)path;
- (void)onNetworkState:(bool)reachable;
- (void)onNetworkQuality:(float)quality_rating;
- (void)onProvision:(bool)applied;
- (void)onCallConnected:(EVCallInfo * _Nonnull)info;
- (void)onCallPeerConnected:(EVCallInfo * _Nonnull)info;
- (void)onCallIncoming:(EVCallInfo * _Nonnull)info;
- (void)onCallEnd:(EVCallInfo * _Nonnull)info;
- (void)onContent:(EVContentInfo * _Nonnull)info;
- (void)onMuteSpeakingDetected;
- (void)onCallLogUpdated:(EVCallLog * _Nonnull)call_log;
- (void)onMicMutedShow:(int)mic_muted;
- (void)onAudioData:(int)sample_rate data:(void *)data len:(int)len;
@end

//////////////////////////////
//  EVCommon
//////////////////////////////

@protocol IEVCommonObj <NSObject>
@required
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
- (NSString * _Nonnull) encryptPassword:(EVEncryptType)type password:(NSString * _Nonnull)password;
- (int) downloadUserImage:(NSString *_Nonnull)path;
- (int) uploadUserImage:(NSString *_Nonnull)path;

//Provision
- (NSString * _Nonnull) getSerialNumber;
- (int) setProvision:(NSString * _Nonnull)server port:(unsigned int)port;
- (int) clearProvision;

//Device
- (int) switchCamera;
- (NSArray<EVDevice *> * _Nonnull) getDevices:(EVDeviceType)type;
- (EVDevice * _Nonnull) getDevice:(EVDeviceType)type;
- (void) setDevice:(EVDeviceType)type withId:(unsigned int)id;
- (int) enableMicMeter:(BOOL)enable;
- (float) getMicVolume;
- (int) setDeviceRotation:(int)rotation;
- (int) audioInterruption:(int)type;

//Set Windows
- (int) setLocalVideoWindow:(void *_Nullable)id;
- (int) setRemoteVideoWindow:(void *_Nullable[_Nonnull])id;
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
- (NSString * _Nonnull) getDisplayName;
- (int) enableHD:(BOOL)enable;
- (BOOL) HDEnabled;
- (int) setVideoActive:(int)active;
//Send Content
- (int) sendContent;
- (int) sendWhiteBoard;
- (int) stopContent;

//Call Log
- (int) setCallLogMaxSize:(unsigned int) num;
- (NSArray<EVCallLog *> * _Nonnull) getCallLog;
- (int) removeCallLog:(NSString * _Nonnull)id;

//Relay stream
- (int) enableRelayStreamDataCb:(EVStreamType)type enable:(BOOL)enable;

@end
