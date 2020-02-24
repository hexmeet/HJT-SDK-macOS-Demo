//
//  EMMessageManager.m
//  HexMeet
//
//  Created by quanhao huang on 2019/12/5.
//  Copyright © 2019 fo. All rights reserved.
//

#import "EMMessageManager.h"

//获取CoreData的.xcdatamodel文件的名称
static NSString * const coreDataModelName = @"easyVideo";
//获取CodeData
static NSString * const coreDataEntityName = @"MessageTab";
//数据库
static NSString * const sqliteName = @"MessageTab.sqlite";
@implementation EMMessageManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static EMMessageManager *coreDataManager = nil;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreDataManager = [[EMMessageManager alloc] init];
    });
    return coreDataManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (coreDataManager == nil) {
            coreDataManager = [super allocWithZone:zone];
        }
    });
    return coreDataManager;
}

- (void)insertNewEntity:(MessageBody *)model success:(void (^)(void))success fail:(void (^)(NSError *))fail {
    NSDictionary *dict = [EVUtils getObjectData:model];
    if (!dict||dict.allKeys.count == 0) return;
    // 通过传入上下文和实体名称，创建一个名称对应的实体对象（相当于数据库一组数据，其中含有多个字段）
    NSManagedObject * entity = [NSEntityDescription insertNewObjectForEntityForName:coreDataEntityName inManagedObjectContext:self.managedObjectContext];
    // 实体对象存储属性值（相当于数据库中将一个值存入对应字段)
    for (NSString *key in [dict allKeys]) {
        [entity setValue:[dict objectForKey:key] forKey:key];
    }
    // 保存信息，同步数据
    NSError *error = nil;
    BOOL result = [self.managedObjectContext save:&error];
    if (!result) {
        NSLog(@"添加数据失败：%@",error);
        if (fail) {
            fail(error);
        }
    } else {
        NSLog(@"添加数据成功");
        if (success) {
            success();
        }
    }
}

- (void)deleteEntity:(NSManagedObject *)model success:(void (^__nullable)(void))success fail:(void (^__nullable)(NSError *))fail {
    // 传入需要删除的实体对象
    [self.managedObjectContext deleteObject:model];
    // 同步到数据库
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"删除失败：%@",error);
        if (fail) {
            fail(error);
        }
    } else {
        NSLog(@"删除成功");
        if (success) {
            success();
        }
    }
}

- (void)selectEntity:(NSArray *__nullable)selectKays ascending:(BOOL)isAscending filterString:(NSString *__nullable)filterString success:(void (^__nullable)(NSArray *))success fail:(void (^__nullable)(NSError *))fail {
    // 1.初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 2.设置要查询的实体
    NSEntityDescription *desc = [NSEntityDescription entityForName:coreDataEntityName inManagedObjectContext:self.managedObjectContext];
    request.entity = desc;
    // 3.设置查询结果排序
    if (selectKays&&selectKays.count>0) { // 如果进行了设置排序
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *key in selectKays) {
            /**
             *  设置查询结果排序
             *  sequenceKey:根据某个属性（相当于数据库某个字段）来排序
             *  isAscending:是否升序
             */
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:key ascending:isAscending];
            [array addObject:sort];
        }
        if (array.count>0) {
            request.sortDescriptors = array;// 可以添加多个排序描述器，然后按顺序放进数组即可
        }
    }
    // 4.设置条件过滤
    if (filterString) { // 如果设置了过滤语句
        NSPredicate *predicate = [NSPredicate predicateWithFormat:filterString];
        request.predicate = predicate;
    }
    // 5.执行请求
    NSError *error = nil;
    NSArray *objs = [self.managedObjectContext executeFetchRequest:request error:&error]; // 获得查询数据数据集合
    if (error) {
        NSLog(@"失败");
        if (fail) {
            fail(error);
        }
    } else{
        NSLog(@"成功");
        if (success) {
            success(objs);
        }
    }
}

- (void)updateEntity:(void (^)(void))success fail:(void (^)(NSError *))fail {
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"删除失败：%@",error);
        if (fail) {
            fail(error);
        }
    } else {
        if (success) {
            success();
        }
    }
}

#pragma 懒加载
-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) return _managedObjectModel;
    NSURL * modelURL = [[NSBundle mainBundle] URLForResource:coreDataModelName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) return _persistentStoreCoordinator;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL * storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:sqliteName];
    NSError * error = nil;
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        if (error) {
            NSLog(@"添加数据库失败:%@",error);
        } else {
            NSLog(@"添加数据库成功");
        }
        NSLog(@"错误信息: %@, %@", error, [error userInfo]);
    }
    return _persistentStoreCoordinator;
}

-(NSURL *)applicationDocumentsDirectory
{
    //获取沙盒路径下documents文件夹的路径 NSURL   (类似于search)
    NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject].absoluteString);
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//容器类 存放OC的对象
-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)  return _managedObjectContext;
    NSPersistentStoreCoordinator * coordinator = [self persistentStoreCoordinator];
    if (!coordinator)
    {
        return nil;
    }
    //创建context对象
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    //让context和coordinator关联   context可以对数据进行增删改查功能   // 设置上下文所要关联的持久化存储库
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

@end
