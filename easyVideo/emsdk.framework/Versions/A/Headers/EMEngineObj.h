#import <Foundation/Foundation.h>
#import "IEMEngineObj.h"

//////////////////////////////
//  EMEngine
//////////////////////////////

@interface EMEngineObj : NSObject<IEMEngineObj> {
@private
	NSTimer* mIterateTimer;
}
//Common
//Log
- (void) setLog:(EMLogLevel)level path:(NSString *_Nonnull)log_path file:(NSString *_Nullable)log_file_name size:(unsigned int)max_file_size;
- (void) enableLog:(BOOL)enable;

//init
- (int) initialize:(NSString *_Nullable)config_path filename:(NSString *_Nullable)config_file_name;
- (int) close;

- (int) setRootCA:(NSString *_Nullable)root_ca_path;

//Login
- (int) enableSecure:(BOOL)enable;

//CallBack
- (void) setDelegate:(id<EMEngineDelegate>_Nonnull)aDelegate;

//Login
- (int) login:(NSString *_Nonnull)host port:(unsigned int)port sechme:(NSString *_Nonnull)sechme username:(NSString *_Nonnull)username secret:(NSString *_Nonnull)secret;
- (int) anonymousLogin:(NSString *_Nonnull)host port:(unsigned int)port displayname:(NSString *_Nonnull)displayname external_info:(NSString *_Nonnull)external_info;
- (void) logout;

//IM
- (EMGroupInfo *_Nullable) getGroupSpecificationWithId:(NSString *_Nonnull)groupId;
- (EMUserInfo *_Nullable) getUserInfo;
- (NSString * _Nonnull) sendMessage:(NSString *_Nonnull)topicName content:(NSString *_Nonnull)content;
- (NSString * _Nonnull) getGroupMemberName:(NSString *_Nonnull)userId group:(NSString *_Nonnull)groupId;
- (void) joinNewGroup:(NSString *_Nonnull)groupId;
- (NSMutableArray *_Nullable) getAllGroupSpecification;

//Private
- (void) iterate;

@end
