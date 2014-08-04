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
    NSManagedObjectContext* privateManagedObjectContext = appDelegate.privateManagedObjectContext;
    NSEntityDescription *tweetEntityDescription = [NSEntityDescription entityForName:@"WhisperChallengeTweet" inManagedObjectContext:privateManagedObjectContext];

    WCTweet* copiedTweet = [[[self class] alloc] initWithEntity:tweetEntityDescription insertIntoManagedObjectContext:privateManagedObjectContext];
    
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
    createdAtString = [dictionary objectForKey:@"created_at"];
    createdAtString = [createdAtString substringToIndex:19];
    favoriteCount = [[dictionary objectForKey:@"favorite_count"] intValue];
    idString = [dictionary objectForKey:@"id_str"];

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

    languageString = [dictionary objectForKey:@"lang"];

    if ([dictionary objectForKey:@"place"] != (id)[NSNull null])
    {
        placeString = [dictionary objectForKey:@"place"];
    }

    retweetCount = [[dictionary objectForKey:@"retweet_count"] intValue];
    sourceString = [dictionary objectForKey:@"source"];
    textString = [dictionary objectForKey:@"text"];


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

- (void)updateWithTweetManagedObject:(NSManagedObject *)tweetManagedObject withUserManagedObject:(NSManagedObject *)userManagedObject withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    createdAtString = [tweetManagedObject valueForKey:@"createdAtString"];
    favoriteCount = [[tweetManagedObject valueForKey:@"favoriteCount"] intValue];
    idString = [tweetManagedObject valueForKey:@"idString"];
    inReplyToScreenNameString = [tweetManagedObject valueForKey:@"inReplyToScreenNameString"];
    inReplyToStatusIdString = [tweetManagedObject valueForKey:@"inReplyToStatusIdString"];
    inReplyToUserIdString = [tweetManagedObject valueForKey:@"inReplyToUserIdString"];
    languageString = [tweetManagedObject valueForKey:@"languageString"];
    placeString = [tweetManagedObject valueForKey:@"placeString"];
    retweetCount = [[tweetManagedObject valueForKey:@"retweetCount"] intValue];
    sourceString = [tweetManagedObject valueForKey:@"sourceString"];
    textString = [tweetManagedObject valueForKey:@"textString"];

    if (!user)
    {
        NSEntityDescription *userEntityDescription = [NSEntityDescription entityForName:@"WhisperChallengeUser" inManagedObjectContext:managedObjectContext];
        user = [[WCUser alloc] initWithEntity:userEntityDescription insertIntoManagedObjectContext:managedObjectContext];
    }

    [user updateWithUserManagedObject:userManagedObject];

    selectedToBeSaved = NO;
    selectedToBeUnSaved = NO;
    isSaved = YES;
}

@end
