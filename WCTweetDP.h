//
//  SavedTweets.h
//  WhisperChallenge
//
//  Created by Derrick J Chie on 8/3/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "WCTweet.h"
#import "AppDelegate.h"
#import "Constants.h"

@protocol WCAuthDelegate <NSObject>

@optional
- (void)didFinishAuthenticatingBearerToken;
- (void)didFailAuthenticatingBearerToken;
- (void)didFinishFetchRequestWithPopularTweets:(NSMutableArray *)popularTweetsMutableArray;
- (void)didFinishFetchRequestWithRecentTweets:(NSMutableArray *)recentTweetsMutableArray;
- (void)didFailFetchRequest;

@end

@interface WCTweetDP : NSObject <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//@property (strong, nonatomic) ACAccountStore* accountStore;

@property (strong, nonatomic) NSMutableArray* savedTweetsMutableArray;
@property (strong, nonatomic) NSMutableArray* tweetsCoreDataMutableArray;
@property (strong, nonatomic) NSMutableArray* usersCoreDataMutableArray;
@property (strong, nonatomic) NSMutableArray* allTweetsMutableArray;

@property (strong, nonatomic) NSString* accessTokenString;
@property (readonly, nonatomic) NSString* bearerTokenString;
@property (strong, nonatomic) NSString* tokenTypeString;

@property (strong, nonatomic) NSURLConnection* authentificationConnection;
@property (strong, nonatomic) NSURLConnection* popularTweetsConnection;
@property (strong, nonatomic) NSURLConnection* recentTweetsConnection;

@property (strong, nonatomic) NSMutableData* popularTweetsResponseData;
@property (strong, nonatomic) NSMutableData* recentTweetsResponseData;

- (void)requestAuthenticationFromTwitter;

@property (nonatomic, weak) id<WCAuthDelegate> delegate;

+ (WCTweetDP *)sharedInstance;

- (NSMutableArray *)getSavedTweets;
- (void)saveTweet:(WCTweet *)tweet;
- (void)saveTweets:(NSMutableArray *)tweets;
- (void)unSaveTweet:(WCTweet *)tweet;
- (void)clearAllTweetsMutableArray;

- (void)fetchCoreDataObjects;
- (void)cleanCoreDataObjects;
- (void)saveContext;

- (void)fetchPopularTweetsWithString:(NSString *)searchString;
- (void)fetchRecentTweetsWithString:(NSString *)searchString;

// Testing Core Data Methods
- (void)fetchCountOfTweetCoreDataObjects;
- (void)fetchCountOfUserCoreDataObjects;
- (void)printCounts;

@end
