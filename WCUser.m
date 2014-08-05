//
//  WCUser.m
//  WhisperChallenge
//
//  Created by Derrick J Chie on 8/1/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "WCUser.h"

@implementation WCUser

@synthesize descriptionString, favouritesCount, followersCount, friendsCount, idString, locationString, nameString, profileBackgroundImageURLString, profileImageURLString, screenNameString, statusesCount;

- (id)copyWithZone:(NSZone *)zone
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext* managedObjectContext = appDelegate.managedObjectContext;
    NSEntityDescription *userEntityDescription = [NSEntityDescription entityForName:@"WhisperChallengeUser" inManagedObjectContext:managedObjectContext];

    WCUser* copiedUser = [[[self class] alloc] initWithEntity:userEntityDescription insertIntoManagedObjectContext:managedObjectContext];

    [managedObjectContext deleteObject:copiedUser];

    if (copiedUser)
    {
        copiedUser.descriptionString = [self.descriptionString copyWithZone:zone];
        copiedUser.favouritesCount = self.favouritesCount;
        copiedUser.followersCount = self.followersCount;
        copiedUser.friendsCount = self.friendsCount;
        copiedUser.idString = [self.idString copyWithZone:zone];
        copiedUser.locationString = [self.locationString copyWithZone:zone];
        copiedUser.nameString = [self.nameString copyWithZone:zone];
        copiedUser.profileBackgroundImageURLString = [self.profileBackgroundImageURLString copyWithZone:zone];
        copiedUser.profileImageURLString = [self.profileImageURLString copyWithZone:zone];
        copiedUser.screenNameString = [self.screenNameString copyWithZone:zone];
        copiedUser.statusesCount = self.statusesCount;
    }

    return copiedUser;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    if ([dictionary objectForKey:@"description"] != [NSNull null])
    {
        descriptionString = [dictionary objectForKey:@"description"];
    }

    favouritesCount = [[dictionary objectForKey:@"favourites_count"] intValue];
    followersCount = [[dictionary objectForKey:@"followers_count"] intValue];
    friendsCount = [[dictionary objectForKey:@"friends_count"] intValue];

    if ([dictionary objectForKey:@"id_str"] != [NSNull null])
    {
        idString = [dictionary objectForKey:@"id_str"];
    }
    if ([dictionary objectForKey:@"location"] != [NSNull null])
    {
        locationString = [dictionary objectForKey:@"location"];
    }
    if ([dictionary objectForKey:@"name"])
    {
        nameString = [dictionary objectForKey:@"name"];
    }
    if ([dictionary objectForKey:@"profile_background_image_url"])
    {
        profileBackgroundImageURLString = [dictionary objectForKey:@"profile_background_image_url"];
    }
    if ([dictionary objectForKey:@"profile_image_url"])
    {
        profileImageURLString = [dictionary objectForKey:@"profile_image_url"];
    }
    if ([dictionary objectForKey:@"screen_name"])
    {
        screenNameString = [dictionary objectForKey:@"screen_name"];
    }

    statusesCount = [[dictionary objectForKey:@"statuses_count"] intValue];
}

- (NSManagedObjectID*) permanentObjectID
{
    NSManagedObjectID *theID = [self objectID];

    if ([theID isTemporaryID])
    {
        return nil;
    }

    return theID;
}

- (void) makeObjectIDPermanent
{
    if ([[self objectID] isTemporaryID])
    {
        NSError *err;
        NSManagedObjectContext *moc = [self managedObjectContext];

        BOOL success = [moc obtainPermanentIDsForObjects:@[self] error:&err];
        if ( !success )
        {
            // Deal with error
        }
    }
}

@end
