#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#endif
#import "EVCommonObj.h"

#define EV_LAYOUT_SIZE 16

#if TARGET_OS_IPHONE
#define EVView UIView
#elif TARGET_OS_MAC
#define EVView NSView
#endif

typedef NS_ENUM (NSUInteger, EVServerError) {
    EVServerApiVersionNotSupported = 1000,
    EVServerInvalidToken = 1001,
    EVServerInvalidParameter = 1002,
    EVServerInvalidDevicesn = 1003,
    EVServerInvalidMediaType = 1004,
    EVServerPermissionDenied = 1005,
    EVServerWrongFieldName = 1006,
    EVServerInternalSystemError = 1007,
    EVServerOperationFailed = 1008,
    EVServerGetFailed = 1009,
    EVServerNotSupported = 1010,
    EVServerRedisLockTimeout = 1011,
    EVServerLocalZoneStopped = 1019,
    EVServerInvalidUserNamePassword = 1100,
    EVServerLoginFailedMoreThan5Times = 1101,
    EVServerAccountTemporarilyLocked = 1102,
    EVServerAccountDisabled = 1103,
    EVServerNoUsername = 1104,
    EVServerEmailMismatch = 1105,
    EVServerCompanyAdministratorNotInAnyCompany = 1106,
    EVServerFileUploadFailed = 1200,
    EVServerInvalidLicense = 1201,
    EVServerInvalidImportUserFile = 1202,
    EVServerInvalidTimeServiceAddress = 1300,
    EVServerFailedUpdateSystemProperties = 1301,
    EVServerConfNotExists = 1400,
    EVServerNumericidConflicts = 1401,
    EVServerConfUpdatingInProgress = 1402,
    EVServerConfDeletingInProgress = 1403,
    EVServerConfTerminatingInProgress = 1404,
    EVServerConfLaunchingInProgress = 1405,
    EVServerConfNotInApprovedStatus = 1406,
    EVServerConfNumericidOngoing = 1407,
    EVServerConfNotApprovedOrOngoing = 1409,
    EVServerParticipantNotExistsInConf = 1410,
    EVServerNumericidAlreadyInUse = 1412,
    EVServerInvalidConfTime = 1415,
    EVServerInvalidConfId = 1418,
    EVServerNotFoundSuitableMru = 1421,
    EVServerNotFoundSuitableGateway = 1422,
    EVServerFailedToConnectMru = 1424,
    EVServerNotAllowDuplicatedName = 1427,
    EVServerNotFoundConfInRedis = 1430,
    EVServerNotInLecturerMode = 1431,
    EVServerFailedToMuteAllParticipants = 1433,
    EVServerFailedToConnectParticipant = 1436,
    EVServerFailedToDisconnectParticipant = 1439,
    EVServerFailedToChangeLayout = 1442,
    EVServerFailedToSetSubtitle = 1445,
    EVServerFailedToMuteParticipantAudio = 1448,
    EVServerFailedToDeleteParticipant = 1451,
    EVServerFailedToInviteAvcEndpoint = 1454,
    EVServerFailedToInviteSvcEndpoints = 1455,
    EVServerConfRoomCompletelyFull = 1456,
    EVServerTimeoutToGenerateNumericid = 1457,
    EVServerNotFoundProfileNamedSvc = 1460,
    EVServerFailedToProlongConf = 1463,
    EVServerInvalidMeetingControlRequest = 1500,
    EVServerNameInUse = 1600,
    EVServerEmptyEndpointName = 1601,
    EVServerEmptyEndpointCallMode = 1602,
    EVServerEmptyEndpointSipUsername = 1603,
    EVServerEmptyEndpointSipPassword = 1604,
    EVServerEmptyEndpointAddress = 1605,
    EVServerInvalidSipUsername = 1606,
    EVServerInvalidIpAddress = 1607,
    EVServerEndpointNotExist = 1608,
    EVServerE164InUse = 1609,
    EVServerEndpointDeviceSnExist = 1610,
    EVServerSipUsernameRegistered = 1611,
    EVServerEndpointE164Invalid = 1612,
    EVServerNotFoundEndpointDeviceSn = 1613,
    EVServerNotFoundEndpointProvisionTemplate = 1614,
    EVServerDeviceSnExists = 1615,
    EVServerCanNotDeleteUserInReservedMeeting = 1700,
    EVServerEmptyUserPassword = 1701,
    EVServerEmptyUsername = 1702,
    EVServerEmptyUserDisplayName = 1703,
    EVServerInvalidUserEmail = 1704,
    EVServerInvalidCellphoneNumber = 1705,
    EVServerOriginalPasswordWrong = 1706,
    EVServerDuplicateEmailName = 1707,
    EVServerDuplicateCellphoneNumber = 1708,
    EVServerDuplicateUsername = 1709,
    EVServerInvalidConfRoomMaxCapacity = 1710,
    EVServerShouldAssignDepartmentToDepartmentAdministrator = 1711,
    EVServerEmptyUserEmail = 1712,
    EVServerEmptyUserCellphoneNumber = 1713,
    EVServerNotOrganizationAdministrator = 1714,
    EVServerCompanyNotExist = 1800,
    EVServerShortNameOfCompanyUsed = 1801,
    EVServerFullNameOfCompanyUsed = 1802,
    EVServerCompanyNotEmpty = 1803,
    EVServerEmptyCompanyShortName = 1804,
    EVServerAgentInUse = 1900,
    EVServerShortNameInUse = 1901,
    EVServerFullNameInUse = 1902,
    EVServerAgentNotExist = 1903,
    EVServerAgentNotEmpty = 1904,
    EVServerConfRoomExpired = 2000,
    EVServerNotActived = 2001,
    EVServerNotFoundSuitableRoom = 2003,
    EVServerNotFoundTemplateOrRoom = 2005,
    EVServerConfRoomInUse = 2006,
    EVServerConfRoomNumberInUse = 2009,
    EVServerConfRoomCapacityExceedsLimit = 2012,
    EVServerInvalidConfRoomCapacity = 2015,//PasswordRequired
    EVServerInvalidConfRoomNumber = 2018,
    EVServerRoomNotExists = 2021,
    EvServerRoomNotAllowAnonymousCall = 2031,
    EvServerRoomOnlyAllowOwnerActive = 2033,
    EvServerTrialPeriodExpired = 2035,
    EVServerCanNotDeleteDepartmentWithSubordinateDepartment = 2100,
    EVServerCanNotDeleteDepartmentWithUsersOrEndpoints = 2101,
    EVServerInvalidAcsConfiguration = 2200
};

//Error code from locate server
typedef NS_ENUM (NSUInteger, EVLocateError) {
    EVLocateFailedToReadBody = 10000,
    EVLocateFailedToParseBody = 10001,
    EVLocateLocationTimeout = 10002,
    EVLocateErrorInfoGeneral = 10003,
    EVLocateErrorInfoBadFormat = 10004,
    EVLocateUnexpected = 10005,
    EVLocateFailedToLocateClient = 10006,
    EVLocateFailedToLocateZone = 10007,
    EVLocateNoLocationDomain = 10008,
    EVLocateErrorLocationRequest = 10009
};


typedef NS_ENUM (NSUInteger, EVCallError) {
    EVCallInvalidNumericid = 1001,
    EVCallInvalidUsername = 1003,
    EVCallInvalidUserid = 1005,
    EVCallInvalidDeviceid = 1007,
    EVCallInvalidEndpoint = 1009,

    EVCallServerUnlicensed = 2001,
    EVCallNotFoundSuitableMru = 2003,
    EVCallNeitherTemplateNorOngoingNorBindedRoom = 2005,
    EVCallLockTimeout = 2007,
    EVCallTemplateConfWithoutConfroom = 2009,
    EVCallRoomExpired = 2011,
    EVCallInvalidPassword = 2015,
    EVCallNoTimeSpaceToActivateRoom = 2017,
    EVCallConfPortCountUsedUp = 2023,
    EVCallOrgPortCountUsedUp = 2024,
    EVCallHaishenPortCountUsedUp = 2025,
    EVCallHaishenGatewayAudioPortCountUsedUp = 2027,
    EVCallHaishenGatewayVideoPortCountUsedUp = 2029,
    EVCallOnlyRoomOwnerCanActivateRoom = 2031,
    EVCallNotAllowAnonymousParty = 2033,
    EVCallTrialOrgExpired = 2035,
    EVCallLocalZoneNotStarted = 2043,
    EVCallLocalZoneStopped = 2045
};

//////////////////////////////
//  Layout
//////////////////////////////

#define EV_LAYOUT_SIZE 16

typedef NS_ENUM (NSUInteger, EVLayoutMode) {
    EVLayoutAutoMode =  0,
    EVLayoutGalleryMode =  1, 
    EVLayoutSpeakerMode =  2,
    EVLayoutSpecifiedMode =  3
};

typedef NS_ENUM (int, EVLayoutType) {
    EVLayoutType_AUTO       = -1, 
    EVLayoutType_1          = 101,
    EVLayoutType_2H         = 201,
    EVLayoutType_2V         = 202,
    EVLayoutType_2H_2       = 203,
    EVLayoutType_2V_2       = 204,
    EVLayoutType_2_1IN1     = 205,
    EVLayoutType_2_1L_1RS   = 207,
    EVLayoutType_3_1T_2B    = 301,
    EVLayoutType_3_2T_1B    = 302,
    EVLayoutType_3_1L_2R    = 303,
    EVLayoutType_3_2IN1     = 304,
    EVLayoutType_1P2W       = 305,
    EVLayoutType_4          = 401,
    EVLayoutType_4_3T_1B    = 402,
    EVLayoutType_4_1L_3R    = 403,
    EVLayoutType_4_1T_3B    = 404,
    EVLayoutType_4_3IN1     = 405,
    EVLayoutType_5_1L_4R    = 501,
    EVLayoutType_5_4T_1B    = 502,
    EVLayoutType_5_1T_4B    = 503,
    EVLayoutType_6          = 601,
    EVLayoutType_6W         = 602,
    EVLayoutType_2P4W       = 603,
    EVLayoutType_6CP        = 604,
    EVLayoutType_8          = 801,
    EVLayoutType_9          = 901,
    EVLayoutType_9_1IN_8OUT = 902,
    EVLayoutType_9_8T_1B    = 903,
    EVLayoutType_9_1T_8B    = 904,
    EVLayoutType_10         = 1001,
    EVLayoutType_2TP8B      = 1002,
    EVLayoutType_2CP4L4R    = 1003,
    EVLayoutType_12W        = 1201,
    EVLayoutType_13         = 1301,
    EVLayoutType_1LTP12     = 1302,
    EVLayoutType_16         = 1601,
    EVLayoutType_1TLP16     = 1701,
    EVLayoutType_1CP16      = 1702,
    EVLayoutType_20         = 2001,
    EVLayoutType_20_SQUARE  = 2002,
    EVLayoutType_1TLP20     = 2101,
    EVLayoutType_1CP20      = 2102,
    EVLayoutType_25         = 2501,
    EVLayoutType_30         = 3001,
    EVLayoutType_30_SQUARE  = 3002,
    EVLayoutType_36         = 3601
};

typedef NS_ENUM (NSUInteger, EVLayoutPage) {
	EVLayoutCurrentPage = 0,
	EVLayoutPrevPage = 1,
    EVLayoutNextPage = 2
}; 

__attribute__((visibility("default"))) @interface EVLayoutRequest : NSObject
@property (assign, nonatomic) EVLayoutMode mode;
@property (assign, nonatomic) EVLayoutType max_type;
@property (assign, nonatomic) EVLayoutPage page;
@property (assign, nonatomic) EVVideoSize max_resolution;
@property (copy, nonatomic) NSArray<EVView *> * _Nullable windows;
@end

__attribute__((visibility("default"))) @interface EVSite : NSObject
@property (assign, nonatomic) void * _Nonnull window;
@property (assign, nonatomic) BOOL is_local;
@property (copy, nonatomic) NSString *_Nonnull name;
@property (assign, nonatomic) uint64_t device_id;
@property (assign, nonatomic) BOOL mic_muted;
@property (assign, nonatomic) BOOL remote_muted;
@end

__attribute__((visibility("default"))) @interface EVLayoutIndication : NSObject
@property (assign, nonatomic) EVLayoutMode mode;
@property (assign, nonatomic) EVLayoutMode setting_mode;
@property (assign, nonatomic) EVLayoutType type;
@property (assign, nonatomic) BOOL mode_settable;
@property (copy, nonatomic) NSString *_Nonnull speaker_name;
@property (assign, nonatomic) int speaker_index;
@property (assign, nonatomic) unsigned int sites_size;
@property (copy, nonatomic) NSArray<EVSite *> *_Nonnull sites;
@end

__attribute__((visibility("default"))) @interface EVLayoutSpeakerIndication : NSObject
@property (copy, nonatomic) NSString *_Nonnull speaker_name;
@property (assign, nonatomic) int speaker_index;
@end

__attribute__((visibility("default"))) @interface EVMessageOverlay : NSObject
@property (assign, nonatomic) BOOL enable;
@property (copy, nonatomic) NSString *_Nonnull content;
@property (assign, nonatomic) int displayRepetitions;
@property (assign, nonatomic) int displaySpeed;
@property (assign, nonatomic) int verticalBorder;
@property (assign, nonatomic) int transparency;
@property (assign, nonatomic) int fontSize;
@property (copy, nonatomic) NSString *_Nonnull foregroundColor;
@property (copy, nonatomic) NSString *_Nonnull backgroundColor;
@end

__attribute__((visibility("default"))) @interface EVWhiteBoardInfo : NSObject
@property (assign, nonatomic) EVWhiteBoardType type;
@property (copy, nonatomic) NSString *_Nonnull authServer;
@property (copy, nonatomic) NSString *_Nonnull server;
@end

typedef NS_ENUM (NSUInteger, EVRecordingState) {
    EVRecordingStateNone = 0,
    EVRecordingStateOn = 1,
    EVRecordingStatePause = 2
};

__attribute__((visibility("default"))) @interface EVRecordingInfo : NSObject
@property (assign, nonatomic) EVRecordingState state;
@property (assign, nonatomic) BOOL live;
@end

__attribute__((visibility("default"))) @interface EVContactInfo : NSObject
@property (assign, nonatomic) int evstatus;
@property (assign, nonatomic) uint64_t userId;
@property (copy, nonatomic) NSString *_Nonnull displayName;
@property (copy, nonatomic) NSString *_Nonnull imageUrl;
@end

@protocol EVEngineDelegate <EVCommonDelegate>
@optional
- (void)onRegister:(BOOL)registered;
- (void)onLayoutSiteIndication:(EVSite *_Nonnull)site;
- (void)onLayoutIndication:(EVLayoutIndication *_Nonnull)layout;
- (void)onLayoutSpeakerIndication:(EVLayoutSpeakerIndication *_Nonnull)speaker;
- (void)onJoinConferenceIndication:(EVCallInfo *_Nonnull)info;
- (void)onConferenceEndIndication:(int)seconds;
- (void)onRecordingIndication:(EVRecordingInfo *_Nonnull)info;
- (void)onMessageOverlay:(EVMessageOverlay *_Nonnull)msg;
- (void)onWhiteBoardIndication:(EVWhiteBoardInfo * _Nonnull)msg;
- (void)onParticipant:(int)number;
- (void)onPeerImageUrl:(NSString *_Nonnull)imageUrl;
@end

//////////////////////////////
//  EVEngine
//////////////////////////////

@protocol IEVEngineObj  <IEVCommonObj>
@required
//CallBack
- (void) setDelegate:(id<EVEngineDelegate>_Nonnull)aDelegate;

//Login
- (int) login:(NSString *_Nonnull)server port:(unsigned int)port name:(NSString *_Nonnull)username password:(NSString *_Nonnull)password __deprecated;
- (int) loginWithLocation:(NSString *_Nonnull)location_server port:(unsigned int)port name:(NSString *_Nonnull)username password:(NSString *_Nonnull)password;
- (int) logout;
- (int) changePassword:(NSString *_Nonnull)oldpassword newpassword:(NSString *_Nonnull)newpassword;
- (int) changeDisplayName:(NSString *_Nonnull)display_name;
- (EVUserInfo *_Nullable) getUserInfo;

//Set Windows
- (int) setRemoteVideoWindow:(void *_Nullable[_Nonnull])id andSize:(unsigned int)size;

//Conference & Layout
- (int) setMaxRecvVideo:(unsigned int)num;
- (int) setLayoutCapacity:(EVLayoutMode)mode types:(EVLayoutType[_Nonnull])types size:(unsigned int)size;
- (int) joinConference:(NSString *_Nonnull)conference_number display_name:(NSString *_Nonnull)display_name password:(NSString *_Nonnull)password;
- (int) joinConference:(NSString *_Nonnull)conference_number display_name:(NSString *_Nonnull)display_name password:(NSString *_Nonnull)password svcCallType:(EVSvcCallType)type;
- (int) joinConference:(NSString *_Nonnull)server port:(unsigned int)port conference_number:(NSString *_Nonnull)conference_number display_name:(NSString *_Nonnull)display_name password:(NSString *_Nonnull)password __deprecated;
- (int) joinConferenceWithLocation:(NSString *_Nonnull)location_server port:(unsigned int)port conference_number:(NSString *_Nonnull)conference_number display_name:(NSString *_Nonnull)display_name password:(NSString *_Nonnull)password;
- (int) leaveConference;
- (int) declineIncommingCall:(NSString *_Nonnull)conference_number;
- (int) setLayout:(EVLayoutRequest *_Nonnull)layout;
- (int) setVideoActive:(int)active;
- (int) videoActive;
- (int) setInConfDisplayName:(NSString *_Nonnull)display_name;

//IM
- (NSString * _Nonnull) getIMAddress;
- (NSString * _Nonnull) getIMGroupID;
- (EVContactInfo *_Nonnull)getContactInfo:(const char *_Nonnull)usrid timeout:(int)timeout_sec;
- (void) setIMUserID:(const char *_Nonnull)im_usrid;
@end
