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

@property (strong, nonatomic) NSString* descriptionString;
@property (nonatomic) NSInteger favouritesCount;
@property (nonatomic) NSInteger followersCount;
@property (nonatomic) NSInteger friendsCount;
@property (strong, nonatomic) NSString* idString;
@property (strong, nonatomic) NSString* locationString;
@property (strong, nonatomic) NSString* nameString;
@property (strong, nonatomic) NSString* profileBackgroundImageURLString;
@property (strong, nonatomic) NSString* profileImageURLString;
@property (strong, nonatomic) NSString* screenNameString;
@property (nonatomic) NSInteger statusesCount;

- (void)updateWithDictionary:(NSDictionary *)dictionary;

@end
