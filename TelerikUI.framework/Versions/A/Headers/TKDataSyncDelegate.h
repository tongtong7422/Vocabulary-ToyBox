//
//  TKDataSyncDelegate.h
//  DataSyncDemo
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^syncHandler)(BOOL result, NSError* error);

/**
 TKDataSyncDelegate declared methods called by TKDataSyncContext class during synchronization procedure. 
 This delegate can be used for implementation of custom merge of entities that are changed on the cloud and in local database simultaneously.
 */
@protocol TKDataSyncDelegate <NSObject>

/*!
 Custom verification of current app conditions. Called before synchronization process to begin.
 @result YES in case that all user requirements for sync process are OK
 */
- (BOOL)dataSyncContextIsReadyForSyncExecution;

/*!
 Invoked when the synchronization for the table with given name is failed.
 @param  name The name of the table
 @param  error The error information about failure reason
 @result YES if this table should be synchronized later again
         NO - if we shouldn't try to synchronize it again during current session.
 */
- (BOOL)dataSyncFailedForTableWithName:(NSString*) name
                             withError:(NSError**) error;

/*!
 Use to resolves conflict between given remote * local instance of the same record.
 @param  type The type of the entities that should be merged
 @param  remote The remote instance of object. If nil, then the item is deleted on remote storage
 @param  local The local instance of object. If nil, then the item is deleted from local storage
 @result The merged/resolved instance of given type
 */
- (id) resolveConflictOfObjectsWithType:(Class) type
                           remoteObject:(id) remote
                             localOject:(id) local;

/*!
 Invoked before start of synchronization process for table with given name.
 @param  tableName The name of table
 @result YES in case of succesfull pre-sync processing, else NO.
 In case of NO the table will not be synchronized.
 */
- (BOOL)beforeSynchOfTableWithName:(NSString*) tableName;

/*!
 Invoked after finished synchronization process for table with given name.
 @param  tableName The name of table
 @param  error The error info about finished synchronization
 @result YES in case of succesfull post-sync processing, else NO.
 */
- (BOOL)afterSynchOfTableWithName:(NSString*) tableName
                    doneWithError:(NSError**) error;


@end
