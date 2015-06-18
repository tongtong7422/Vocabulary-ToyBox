//
//  TKEverliveClient.h
//  DataSyncDemo
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import "TKCloudClientProtocol.h"

/**
 TKEverliveClient is a concrete cloud client that manages communication with Telerik Platform's backend services.
 */
@interface TKEverliveClient : NSObject<TKCloudClientProtocol>

/**
 A factory method for the Everlive client.
 @param  apiKey The application key obtained from Everlive.
 @param  accessToken The auth token per app user, obtained after user registration.
 @param  version The version of the used Everlive service (not taken into account yet).
 @result The initialized & shared Everlive client.
 */
+ (TKEverliveClient*) clientWithApiKey:(NSString*) apiKey
                           accessToken:(NSString*) accessToken
                        serviceVersion:(NSNumber*) version;

- (BOOL)verifyCloudClient;

//todo: It is a good idea to have some specific JSON parser methods for results
@end



