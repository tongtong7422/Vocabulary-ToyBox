//
//  TKCloudClient.h
//  DataSyncDemo
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 TKCloudClientProtocol defines the methods that every cloud client should implement in order to be used for data synchronization by DataSync engine.
 */
@protocol TKCloudClientProtocol <NSObject>

//the name of cloud service
@property (nonatomic, retain) NSString* name;

@required

/*!
 Prepares fetch request to cloud backend
 @param  objectType The type of items that will be retrieved
 @param  predicate The condition for item selection
 @param  descriptors Sort descriptors
 @param  subsetOfFields The subset of fields to be fetched
 @param  fetchLimit The number of items to be fetched
 @param  fetchOffset The offset of items bundle from first record in db
 @param  fieldsInclusionMode YES in case of inclusion of given subset of fields
 @result A GET request ready for execution
 */
- (NSURLRequest*)getFetchRequestForObjectsOfType: (Class) objectType
                                          filter: (NSPredicate*) predicate
                                 sortDescriptors: (NSArray*) descriptors
                                          subset: (NSArray*) subsetOfFields
                                           limit: (NSInteger) fetchLimit
                                          offset: (NSInteger) fetchOffset
                                   inclusionMode: (BOOL) fieldsInclusionMode;
/*!
 Prepares insert request to cloud backend
 @param  payload The actual data that should be inserted
 @param  objectType The type of items that will be retrieved 
 @result A POST request prepared for execution
 */
- (NSURLRequest*)getInsertDataRequestWithJSONPayload:(NSData*) payload
                                              ofType:(Class) objectType;

/*!
 Prepares delete request for items on backend service that pass the filter
 @param  filter A predicate used to filter the items that should be deleted
 @param  objectType The type of items that will be deleted
 @result A DELETE request ready for execution
 */
- (NSURLRequest*)getDeleteDataRequestWithPredicate:(NSPredicate*) filter
                                            ofType:(Class) objectType;


/*!
 Prepares update request for items on backend service that pass the filter
 @param  filter A predicate used to filter the items that should be updated
 @param  payload The new data that will be used for update purposes
 @param  objectType The type of items that will be deleted
 @result A PUT request ready for execution
 */
- (NSURLRequest*)getUpdateDataRequestWithPredicate:(NSPredicate*) filter
                                       JSONPayload:(NSData*) payload
                                            ofType:(Class) objectType;

/*!
 Prepares count request for items on backed service that are of given type
 @param  objectType The type of items that will be deleted
 @result A GET request ready for execution
 */
- (NSURLRequest*)getCountRequestForObjectsOfType:(Class) objectType;

/*!
 Gets the Class of entity class that wraps the system fields
 */
- (Class)getCloudSysEntityClass;

/*!
 Checks if the client is properly initialized 
 */
- (BOOL)verifyCloudClient;

//todo: It is a good idea to have some specific JSON parser methods for results
@end

