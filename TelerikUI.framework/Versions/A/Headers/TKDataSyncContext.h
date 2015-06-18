//
//  TKDataSyncContext.h
//  DataSyncDemo
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKCloudClientProtocol.h"
#import "TKPersistencePublicProtocol.h"
#import "TKDataSyncDelegate.h"


//note: currently we support only sqlite database for local persistence
NS_ENUM(int, TKLocalStoreType)
{
    TKSQLite = 1
};

@class TKDataSyncPolicy;

/**
 TKDataSyncContext class is the façade for SQLite database manipulation with ORM features.
 It orchestrates the CRUD operations and the synchronization process of tables in this database. 
 The context instance keeps the internal state of data schema and data sets that should be persisted.
 */
@interface TKDataSyncContext : NSObject<TKPersistencePublicProtocol>

//The delegate that conforms to TKDataSyncDelegate protocol
@property (nonatomic, weak) id<TKDataSyncDelegate> delegate;

-(instancetype) initWithLocalStoreName:(NSString*) storeName
                          cloudService:(id<TKCloudClientProtocol>) cloudClient
                            syncPolicy:(TKDataSyncPolicy*) policy;

#pragma mark Local context methods

/*!
 Creates an index with given name on listed columns
 @param indexName  The name of index
 @param entityClass The entity class that the index is associated to
 @param columns  Array of names of columns that are indexed
 @param orders  Array with sort orders of columns
 @param unique  The uniqueness of index tuples
 */
- (void)registerIndex:(NSString*) indexName
             forClass:(Class) entityClass
            onColumns:(NSArray*) columns
           withOrders:(NSArray*) orders
             asUnique:(BOOL) unique;

/*!
 Registers a given field as primary key for entity class
 @param entityClass  The entity class that the primary key is defined of
 @param fieldName The field name that will be a primary key
 @param autoincrement  If the primary key is auto incremental
 */
- (void)registerClass:(Class)entityClass
  withPrimaryKeyField:(NSString*)fieldName
    asAutoincremental:(BOOL) autoincrement;


#pragma mark Sync methods
/*!
 Initiates synchronous data synchronization procedure.
 @param  error The error returned during synchronization
 */
- (BOOL)syncChanges:(NSError**) error;

/*!
 Initiates asynchronous data synchronization procedure.
 @param queue execution queue for given completion handler
 @param handler The error returned during synchronization
 */
-(void)syncChangesAsync:(dispatch_queue_t)queue
      completionHandler:(syncHandler)handler;

@end
