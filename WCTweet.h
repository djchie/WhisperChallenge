//
//  WCTweet.h
//  WhisperChallenge
//
//  Created by Derrick J Chie on 8/1/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "WCUser.h"

@interface WCTweet : NSManagedObject <NSCopying>

@property (copy, nonatomic) NSString* createdAtString;
@property (nonatomic) NSInteger favoriteCount;
@property (copy, nonatomic) NSString* idString;
@property (copy, nonatomic) NSString* inReplyToScreenNameString;
@property (copy, nonatomic) NSString* inReplyToStatusIdString;
@property (copy, nonatomic) NSString* inReplyToUserIdString;
@property (copy, nonatomic) NSString* languageString;
@property (copy, nonatomic) NSString* placeString;
@property (nonatomic) NSInteger retweetCount;
@property (copy, nonatomic) NSString* sourceString;
@property (copy, nonatomic) NSString* textString;
@property (strong, nonatomic) WCUser *user;

@property (nonatomic) BOOL selectedToBeSaved;
@property (nonatomic) BOOL selectedToBeUnSaved;
@property (nonatomic) BOOL isSaved;

- (void)updateWithDictionary:(NSDictionary *)dictionary withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)updateWithTweetManagedObject:(NSManagedObject *)tweetManagedObject withUserManagedObject:(NSManagedObject *)userManagedObject withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
