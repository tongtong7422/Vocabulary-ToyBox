//
//  TKPlatformFeedbackRepository.h
//  TelerikUI
//
//  Copyright (c) 2014 Telerik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKFeedbackDataSource.h"

/**
 The feedback data source implementation for the Telerik Platform AppFeedback service.
 */
@interface TKPlatformFeedbackSource : NSObject<TKFeedbackDataSource>

- (id)initWithKey:(NSString *)apiKey;
- (id)initWithKey:(NSString *)apiKey uid:(NSString *)uid;

/**
 The API key created in the Telerik AppFeedback service for your application.
 */
@property (nonatomic, copy) NSString *apiKey;

/**
 The user ID used to send feedback.
 */
@property (nonatomic, copy) NSString *UID;

@end
