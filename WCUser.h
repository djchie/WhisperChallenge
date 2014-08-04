//
//  WCUser.h
//  WhisperChallenge
//
//  Created by Derrick J Chie on 8/1/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface WCUser : NSManagedObject <NSCopying>

@property (copy, nonatomic) NSString* descriptionString;
@property (nonatomic) NSInteger favouritesCount;
@property (nonatomic) NSInteger followersCount;
@property (nonatomic) NSInteger friendsCount;
@property (copy, nonatomic) NSString* idString;
@property (copy, nonatomic) NSString* locationString;
@property (copy, nonatomic) NSString* nameString;
@property (copy, nonatomic) NSString* profileBackgroundImageURLString;
@property (copy, nonatomic) NSString* profileImageURLString;
@property (copy, nonatomic) NSString* screenNameString;
@property (nonatomic) NSInteger statusesCount;

- (void)updateWithDictionary:(NSDictionary *)dictionary;
- (void)updateWithUserManagedObject:(NSManagedObject *)userManagedObject;

@end
