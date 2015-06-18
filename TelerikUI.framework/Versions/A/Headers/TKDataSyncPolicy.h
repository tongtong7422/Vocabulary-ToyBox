//
//  TKDataSyncPolicy.h
//  DataSyncDemo
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <Foundation/Foundation.h>

//Error codes enumeration
typedef enum TKDataSyncErrorCodes
{
    //Error because of missing connection
    TKDataSyncErrorCode_NoConnection,
    //Error because of reached timeout period
    TKDataSyncErrorCode_TimeoutReached,
    //Error occured in synchronization engine
    TKDataSyncErrorCode_InternalError,
    //Error becasue of failed communication with cloud data provider
    TKDataSyncErrorCode_CloudError,
    //Error occured in ORM engine
    TKDataSyncErrorCode_LocalDBError
} TKDataSyncErrorCodes;

//The type of synchronization procedure
typedef enum TKDataSyncType{
    //the engine is used only for local persistence
    TKDataSyncNever,
    //synchronization on user request
    TKDataSyncOnDemand,
    //continuios synchronization on time interval
    TKDataSyncOnTimeInterval
} TKDataSyncType;


//Options that specify the conditions required for synchronization to be triggered
typedef enum TKDataSyncReachabilityOptions{
    //Synchronize in case of available WIFI network connectivity
    TKSyncInWIFINetwork = 1 << 0,
    //Synchronize in case of available 3G network connectivity
    TKSyncIn3GNetwork   = 1 << 1,
    //Synchronize in case of available LTI network connectivity
    TKSyncInLTENetwork  = 1 << 2,
    //Use custom checking for available network
    TKSyncInManualyCheckedNetwork = 1 << 3
} TKDataSyncReachabilityOptions;

//Defines the modes for data resolution
typedef enum TKDataSyncResolutionType{
    //the cloud instnace of data will be prefered in case of conflicted changes
    TKPreferCloudInstance,
    //the local instnace of data will be prefered in case of conflicted changes
    TKPreferLocalInstance,
    //custom resolution via delegate call
    TKCustomResolution
} TKDataSyncResolutionType;


/*! The policy that defines the behavior of synchronization engine
 */
@interface TKDataSyncPolicy : NSObject

@property(nonatomic) TKDataSyncType syncType;

@property(nonatomic) NSUInteger reachabilityOptions;

@property(nonatomic, setter = setSyncTimeInterval:) NSUInteger syncTimeInterval;

@property(nonatomic) TKDataSyncResolutionType conflictResolutionType;

@property(nonatomic) NSTimeInterval syncTimeout;

- (instancetype)initForNeverSyncWithCloud;

- (instancetype)initForSyncOnDemandWithReachabilityOptions:(TKDataSyncReachabilityOptions) options
                                    conflictResolutionType:(TKDataSyncResolutionType) resolution
                                               syncTimeout:(NSTimeInterval) timeout;

- (instancetype)initForSyncOnTimeInterval:(NSTimeInterval) interval
                  withReachabilityOptions:(TKDataSyncReachabilityOptions) options
                   conflictResolutionType:(TKDataSyncResolutionType) resolution
                              syncTimeout:(NSTimeInterval) timeout;
@end
