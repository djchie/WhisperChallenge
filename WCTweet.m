//
//  WCTweet.m
//  WhisperChallenge
//
//  Created by Derrick J Chie on 8/1/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "WCTweet.h"

@implementation WCTweet

@synthesize createdAtString, favoriteCount, idString, inReplyToScreenNameString, inReplyToStatusIdString, inReplyToUserIdString, languageString, placeString, retweetCount, sourceString, textString, user, selectedToBeSaved, selectedToBeUnSaved, isSaved;

- (id)copyWithZone:(NSZone *)zone
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext* managedObjectContext = appDelegate.managedObjectContext;
    NSEntityDescription *tweetEntityDescription = [NSEntityDescription entityForName:@"WhisperChallengeTweet" inManagedObjectContext:managedObjectContext];

    WCTweet* copiedTweet = [[[self class] alloc] initWithEntity:tweetEntityDescription insertIntoManagedObjectContext:managedObjectContext];

    [managedObjectContext deleteObject:copiedTweet];
    
    if (copiedTweet)
    {
        copiedTweet.createdAtString = [self.createdAtString copyWithZone:zone];
        copiedTweet.favoriteCount = self.favoriteCount;
        copiedTweet.idString = [self.idString copyWithZone:zone];
        copiedTweet.inReplyToScreenNameString = [self.inReplyToScreenNameString copyWithZone:zone];
        copiedTweet.inReplyToStatusIdString = [self.inReplyToStatusIdString copyWithZone:zone];
        copiedTweet.inReplyToUserIdString = [self.inReplyToUserIdString copyWithZone:zone];
        copiedTweet.languageString = [self.languageString copyWithZone:zone];
        copiedTweet.placeString = [self.placeString copyWithZone:zone];
        copiedTweet.retweetCount = self.retweetCount;
        copiedTweet.sourceString = [self.sourceString copyWithZone:zone];
        copiedTweet.textString = [self.textString copyWithZone:zone];

        copiedTweet.user = [self.user copy];
    }

    return copiedTweet;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if ([dictionary objectForKey:@"created_at"] != (id)[NSNull null])
    {
        createdAtString = [dictionary objectForKey:@"created_at"];
        createdAtString = [createdAtString substringToIndex:19];
    }

    favoriteCount = [[dictionary objectForKey:@"favorite_count"] intValue];

    if ([dictionary objectForKey:@"id_str"] != (id)[NSNull null])
    {
        idString = [dictionary objectForKey:@"id_str"];
    }
    if ([dictionary objectForKey:@"in_reply_to_screen_name"] != (id)[NSNull null])
    {
        inReplyToScreenNameString = [dictionary objectForKey:@"in_reply_to_screen_name"];
    }
    if ([dictionary objectForKey:@"in_reply_to_status_id_str"] != (id)[NSNull null])
    {
        inReplyToStatusIdString = [dictionary objectForKey:@"in_reply_to_status_id_str"];
    }
    if ([dictionary objectForKey:@"in_reply_to_status_id_str"] != (id)[NSNull null])
    {
        inReplyToUserIdString = [dictionary objectForKey:@"in_reply_to_user_id_str"];
    }
    if ([dictionary objectForKey:@"lang"] != (id)[NSNull null])
    {
        languageString = [dictionary objectForKey:@"lang"];
    }
    if ([dictionary objectForKey:@"place"] != (id)[NSNull null])
    {
        placeString = [dictionary objectForKey:@"place"];
    }

    retweetCount = [[dictionary objectForKey:@"retweet_count"] intValue];

    if ([dictionary objectForKey:@"source"] != [NSNull null])
    {
        sourceString = [dictionary objectForKey:@"source"];
    }
    if ([dictionary objectForKey:@"text"] != [NSNull null])
    {
        textString = [dictionary objectForKey:@"text"];
    }

    if (!user)
    {
        NSEntityDescription *userEntityDescription = [NSEntityDescription entityForName:@"WhisperChallengeUser" inManagedObjectContext:managedObjectContext];
        user = [[WCUser alloc] initWithEntity:userEntityDescription insertIntoManagedObjectContext:managedObjectContext];
    }

    [user updateWithDictionary:[dictionary objectForKey:@"user"]];

    selectedToBeSaved = NO;
    selectedToBeUnSaved = NO;
    isSaved = NO;
}

@end
