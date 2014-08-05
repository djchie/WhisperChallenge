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

@property (strong, nonatomic) NSString* createdAtString;
@property (nonatomic) NSInteger favoriteCount;
@property (strong, nonatomic) NSString* idString;
@property (strong, nonatomic) NSString* inReplyToScreenNameString;
@property (strong, nonatomic) NSString* inReplyToStatusIdString;
@property (strong, nonatomic) NSString* inReplyToUserIdString;
@property (strong, nonatomic) NSString* languageString;
@property (strong, nonatomic) NSString* placeString;
@property (nonatomic) NSInteger retweetCount;
@property (strong, nonatomic) NSString* sourceString;
@property (strong, nonatomic) NSString* textString;
@property (strong, nonatomic) WCUser *user;

@property (nonatomic) BOOL selectedToBeSaved;
@property (nonatomic) BOOL selectedToBeUnSaved;
@property (nonatomic) BOOL isSaved;

- (void)updateWithDictionary:(NSDictionary *)dictionary withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
