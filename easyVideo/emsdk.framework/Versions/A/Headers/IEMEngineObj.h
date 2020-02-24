#import <Foundation/Foundation.h>
#import "IEMCommonObj.h"

typedef NS_ENUM (NSUInteger, EMServerError) {
    EMServerApiVersionNotSupported = 1000,
    EMServerInvalidToken = 1001,
    EMServerInvalidParameter = 1002,
    EMServerInvalidDevicesn = 1003,
    EMServerInvalidMediaType = 1004,
    EMServerPermissionDenied = 1005,
    EMServerWrongFieldName = 1006,
    EMServerInternalSystemError = 1007,
    EMServerOperationFailed = 1008,
    EMServerGetFailed = 1009,
    EMServerNotSupported = 1010,
    EMServerRedisLockTimeout = 1011,
    EMServerLocalZoneStopped = 1019,
    EMServerInvalidUserNamePassword = 1100,
    EMServerLoginFailedMoreThan5Times = 1101,
    EMServerAccountTemporarilyLocked = 1102,
    EMServerAccountDisabled = 1103,
    EMServerNoUsername = 1104,
    EMServerEmailMismatch = 1105,
    EMServerCompanyAdministratorNotInAnyCompany = 1106,
    EMServerFileUploadFailed = 1200,
    EMServerInvalidLicense = 1201,
    EMServerInvalidImportUserFile = 1202,
    EMServerInvalidTimeServiceAddress = 1300,
    EMServerFailedUpdateSystemProperties = 1301,
    EMServerConfNotExists = 1400,
    EMServerNumericidConflicts = 1401,
    EMServerConfUpdatingInProgress = 1402,
    EMServerConfDeletingInProgress = 1403,
    EMServerConfTerminatingInProgress = 1404,
    EMServerConfLaunchingInProgress = 1405,
    EMServerConfNotInApprovedStatus = 1406,
    EMServerConfNumericidOngoing = 1407,
    EMServerConfNotApprovedOrOngoing = 1409,
    EMServerParticipantNotExistsInConf = 1410,
    EMServerNumericidAlreadyInUse = 1412,
    EMServerInvalidConfTime = 1415,
    EMServerInvalidConfId = 1418,
    EMServerNotFoundSuitableMru = 1421,
    EMServerNotFoundSuitableGateway = 1422,
    EMServerFailedToConnectMru = 1424,
    EMServerNotAllowDuplicatedName = 1427,
    EMServerNotFoundConfInRedis = 1430,
    EMServerNotInLecturerMode = 1431,
    EMServerFailedToMuteAllParticipants = 1433,
    EMServerFailedToConnectParticipant = 1436,
    EMServerFailedToDisconnectParticipant = 1439,
    EMServerFailedToChangeLayout = 1442,
    EMServerFailedToSetSubtitle = 1445,
    EMServerFailedToMuteParticipantAudio = 1448,
    EMServerFailedToDeleteParticipant = 1451,
    EMServerFailedToInviteAvcEndpoint = 1454,
    EMServerFailedToInviteSvcEndpoints = 1455,
    EMServerConfRoomCompletelyFull = 1456,
    EMServerTimeoutToGenerateNumericid = 1457,
    EMServerNotFoundProfileNamedSvc = 1460,
    EMServerFailedToProlongConf = 1463,
    EMServerInvalidMeetingControlRequest = 1500,
    EMServerNameInUse = 1600,
    EMServerEmptyEndpointName = 1601,
    EMServerEmptyEndpointCallMode = 1602,
    EMServerEmptyEndpointSipUsername = 1603,
    EMServerEmptyEndpointSipPassword = 1604,
    EMServerEmptyEndpointAddress = 1605,
    EMServerInvalidSipUsername = 1606,
    EMServerInvalidIpAddress = 1607,
    EMServerEndpointNotExist = 1608,
    EMServerE164InUse = 1609,
    EMServerEndpointDeviceSnExist = 1610,
    EMServerSipUsernameRegistered = 1611,
    EMServerEndpointE164Invalid = 1612,
    EMServerNotFoundEndpointDeviceSn = 1613,
    EMServerNotFoundEndpointProvisionTemplate = 1614,
    EMServerDeviceSnExists = 1615,
    EMServerCanNotDeleteUserInReservedMeeting = 1700,
    EMServerEmptyUserPassword = 1701,
    EMServerEmptyUsername = 1702,
    EMServerEmptyUserDisplayName = 1703,
    EMServerInvalidUserEmail = 1704,
    EMServerInvalidCellphoneNumber = 1705,
    EMServerOriginalPasswordWrong = 1706,
    EMServerDuplicateEmailName = 1707,
    EMServerDuplicateCellphoneNumber = 1708,
    EMServerDuplicateUsername = 1709,
    EMServerInvalidConfRoomMaxCapacity = 1710,
    EMServerShouldAssignDepartmentToDepartmentAdministrator = 1711,
    EMServerEmptyUserEmail = 1712,
    EMServerEmptyUserCellphoneNumber = 1713,
    EMServerNotOrganizationAdministrator = 1714,
    EMServerCompanyNotExist = 1800,
    EMServerShortNameOfCompanyUsed = 1801,
    EMServerFullNameOfCompanyUsed = 1802,
    EMServerCompanyNotEmpty = 1803,
    EMServerEmptyCompanyShortName = 1804,
    EMServerAgentInUse = 1900,
    EMServerShortNameInUse = 1901,
    EMServerFullNameInUse = 1902,
    EMServerAgentNotExist = 1903,
    EMServerAgentNotEmpty = 1904,
    EMServerConfRoomExpired = 2000,
    EMServerNotActived = 2001,
    EMServerNotFoundSuitableRoom = 2003,
    EMServerNotFoundTemplateOrRoom = 2005,
    EMServerConfRoomInUse = 2006,
    EMServerConfRoomNumberInUse = 2009,
    EMServerConfRoomCapacityExceedsLimit = 2012,
    EMServerInvalidConfRoomCapacity = 2015,//PasswordRequired
    EMServerInvalidConfRoomNumber = 2018,
    EMServerRoomNotExists = 2021,
    EMServerRoomNotAllowAnonymousCall = 2031,
    EMServerRoomOnlyAllowOwnerActive = 2033,
    EMServerTrialPeriodExpired = 2035,
    EMServerCanNotDeleteDepartmentWithSubordinateDepartment = 2100,
    EMServerCanNotDeleteDepartmentWithUsersOrEndpoints = 2101,
    EMServerInvalidAcsConfiguration = 2200
};

@protocol EMEngineDelegate <EMCommonDelegate>
@optional
@end

//////////////////////////////
//  EMEngine
//////////////////////////////

@protocol IEMEngineObj  <IEMCommonObj>
@required

@end
