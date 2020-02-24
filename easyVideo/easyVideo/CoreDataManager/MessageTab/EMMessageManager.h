//
//  EMMessageManager.h
//  HexMeet
//
//  Created by quanhao huang on 2019/12/5.
//  Copyright © 2019 fo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMMessageManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel * managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator * persistentStoreCoordinator;

/**
 单例
 @return CoreDataManager
 */
+ (instancetype)sharedInstance;
/**
 插入数据
 @param model 的键值对必须要与实体中的每个名字一一对应
 @param success 成功回调
 @param fail 失败回调
 */
- (void)insertNewEntity:(MessageBody *)model success:(void(^)(void))success fail:(void(^)(NSError *error))fail;


/**
 查询数据
 @param selectKays 数组高级排序（数组里存放实体中的key，顺序按自己需要的先后存放即可），实体key来排序
 @param isAscending 升序降序
 @param filterString 查询条件
 @param success 成功回调
 @param fail 失败回调
 */
- (void)selectEntity:(NSArray *__nullable)selectKays ascending:(BOOL)isAscending filterString:(NSString *__nullable)filterString success:(void(^__nullable)(NSArray *results))success fail:(void(^__nullable)(NSError *error))fail;

/**
 删除数据
 @param model NSManagedObject
 @param success 成功回调
 @param fail 失败回调
 */
- (void)deleteEntity:(NSManagedObject *)model success:(void(^__nullable)(void))success fail:(void(^__nullable)(NSError *error))fail;

/**
 更新数据
 @param success 成功回调
 @param fail 失败回调
 */
- (void)updateEntity:(void(^__nullable)(void))success fail:(void(^__nullable)(NSError *error))fail;

@end

NS_ASSUME_NONNULL_END
