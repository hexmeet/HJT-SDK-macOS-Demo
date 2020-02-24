#import <Foundation/Foundation.h>

//! Project version number for evsdk.
FOUNDATION_EXPORT double evsdkVersionNumber;

//! Project version string for evsdk.
FOUNDATION_EXPORT const unsigned char evsdkVersionString[];

//////////////////////////////
//  Common
//////////////////////////////

typedef enum EMEncryptType {
    EMEncryptSHA1 = 0,
    EMEncryptAES = 1
} EMEncryptType;


//////////////////////////////
//  Log
//////////////////////////////

typedef NS_ENUM (NSUInteger, EMLogLevel) {
    EMLogLevelDebug = 0,
    EMLogLevelMessage = 1,
    EMLogLevelWARNING = 2,
    EMLogLevelError = 3,
    EMLogLevelFatal = 4
};

//////////////////////////////
//  Error
//////////////////////////////
typedef NS_ENUM (NSUInteger, EMErrorType) {
    EM_ERROR_TYPE_UNKNOWN = 0,
    EM_ERROR_TYPE_SDK = 1,
    EM_ERROR_TYPE_SERVER = 2,
    EM_ERROR_TYPE_LOCATE = 3,
    EM_ERROR_TYPE_LOGIN = 4,
    EM_ERROR_TYPE_HELLO = 5,
    EM_ERROR_TYPE_SUBSCRIBE = 6,
    EM_ERROR_TYPE_PUBLISH = 7,
    EM_ERROR_TYPE_CONN_DISCONNECT = 8
};

typedef NS_ENUM (NSUInteger, EMGroupType) {
    P2PTYPE = 3,
    GROUPTYPE = 4
};

__attribute__((visibility("default"))) @interface EMError : NSObject
@property (assign, nonatomic) EMErrorType type;
@property (assign, nonatomic) int code;
@property (copy, nonatomic) NSString *_Nonnull action;
@property (copy, nonatomic) NSString *_Nonnull msg;
@property (copy, nonatomic) NSString *_Nonnull reason;
@property (copy, nonatomic) NSString *_Nonnull msgId;
@property (copy, nonatomic) NSArray<NSString *> * _Nullable args;
@end

typedef NS_ENUM (NSUInteger, EMSdkError) {
    EMOK = 0,
    EMNG = 1,
    EMUninitialized = 2,
    EMBadFormat = 3,
    EMNotInConf = 4,
    EMBadParam = 5,
    EMRegisterFailed = 6,
    EMInternalError = 7,
    EMServerUnreachable = 8,
    EMServerInvalid = 9,
    EMCallDeclined = 10,
    EMCallBusy = 11,
    EMCallIOError = 12
 };

//////////////////////////////
//  Event
//////////////////////////////

__attribute__((visibility("default"))) @interface EMUserInfo : NSObject
@property (copy, nonatomic) NSString *_Nonnull userId;
@property (copy, nonatomic) NSString *_Nonnull userName;
@property (assign, nonatomic) BOOL on_line;
@end

__attribute__((visibility("default"))) @interface EMGroupInfo : NSObject
@property (copy, nonatomic) NSString *_Nonnull groupName;
@property (copy, nonatomic) NSString *_Nonnull groupId;
@property (assign, nonatomic) EMGroupType groupType;
@property (assign, nonatomic) BOOL on_line;
@end

__attribute__((visibility("default"))) @interface MessageBody : NSObject
@property (copy, nonatomic) NSString *_Nonnull groupId;
@property (assign, nonatomic) uint64_t seq;
@property (copy, nonatomic) NSString *_Nonnull content;
@property (copy, nonatomic) NSString *_Nonnull from;
@property (copy, nonatomic) NSString *_Nonnull time;
@end

__attribute__((visibility("default"))) @interface MessageReceived : NSObject
@property (copy, nonatomic) NSString *_Nonnull topicName;
@property (assign, nonatomic) uint64_t count;
@property (assign, nonatomic) uint64_t seq;
@end

__attribute__((visibility("default"))) @interface MessageState : NSObject
@property (copy, nonatomic) NSString *_Nonnull msgId;
@property (assign, nonatomic) uint64_t seq;
@end

__attribute__((visibility("default"))) @interface EMGroupMemberInfo : NSObject
@property (copy, nonatomic) NSString *_Nonnull groupId;
@property (copy, nonatomic) NSString *_Nonnull name;
@property (copy, nonatomic) NSString *_Nonnull emuserId;
@property (copy, nonatomic) NSString *_Nonnull evuserId;
@property (copy, nonatomic) NSString *_Nonnull imageUrl;
@end

@protocol EMCommonDelegate <NSObject>
@optional
//Login
- (void)onEMError:(EMError *_Nonnull)err;
- (void)onLoginSucceed;
//IM
- (void)onMessageReciveData:(MessageBody *_Nonnull)message;
- (void)onAllMessagesReceived:(MessageReceived *_Nonnull)message;
- (void)onMessageSendSucceed:(MessageState *_Nonnull)messageState;
- (void)onGroupMemberInfo:(EMGroupMemberInfo *_Nonnull)groupMemberInfo;

@end

//////////////////////////////
//  EMCommon
//////////////////////////////

@protocol IEMCommonObj <NSObject>
@required
//Log
- (void) setLog:(EMLogLevel)level path:(NSString *_Nonnull)log_path file:(NSString *_Nullable)log_file_name size:(unsigned int)max_file_size;
- (void) enableLog:(BOOL)enable;

//init
- (int) initialize:(NSString *_Nullable)config_path filename:(NSString *_Nullable)config_file_name;
- (int) close;

//Login
- (int) enableSecure:(BOOL)enable;
- (NSString * _Nonnull) encryptPassword:(NSString * _Nonnull)password;
- (NSString * _Nonnull) encryptPassword:(EMEncryptType)type password:(NSString * _Nonnull)password;

@end
