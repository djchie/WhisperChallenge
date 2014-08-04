//
//  SavedTweets.m
//  WhisperChallenge
//
//  Created by Derrick J Chie on 8/3/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "WCTweetDP.h"

@implementation WCTweetDP

@synthesize savedTweetsMutableArray, tweetsCoreDataMutableArray, usersCoreDataMutableArray;
@synthesize managedObjectContext, privateManagedObjectContext;
@synthesize bearerTokenString, accessTokenString, tokenTypeString;
@synthesize authentificationConnection, popularTweetsConnection, recentTweetsConnection;
@synthesize popularTweetsResponseData, recentTweetsResponseData;

static WCTweetDP *sharedInstance = nil;

#pragma mark - Initial Setup Methods

+ (WCTweetDP *)sharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }

    return sharedInstance;
}

+ (id)allocWithZone:(NSZone*)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        savedTweetsMutableArray = [[NSMutableArray alloc] init];
        tweetsCoreDataMutableArray = [[NSMutableArray alloc] init];
        usersCoreDataMutableArray = [[NSMutableArray alloc] init];

        NSString* accessTokenUserDefaultString = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultAccessToken];
		if (accessTokenUserDefaultString != nil)
        {
			accessTokenString = accessTokenUserDefaultString;
        }
		NSString* tokenTypeUserDefaultString = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultTokenType];
		if (tokenTypeUserDefaultString != nil)
        {
			tokenTypeString = tokenTypeUserDefaultString;
        }

        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        managedObjectContext = appDelegate.managedObjectContext;
        [self fetchCoreDataObjects];

        privateManagedObjectContext = appDelegate.privateManagedObjectContext;
    }

    return self;
}

#pragma mark - Helper Methods

- (NSMutableArray *)getSavedTweets
{
    return savedTweetsMutableArray;
}

- (void)saveTweet:(WCTweet *)tweet
{
    if (![savedTweetsMutableArray containsObject:tweet])
    {
        [self passManagedObjectFromPrivateToMain:tweet];
//        [self passManagedObjectFromPrivateToMain:tweet.user];

//        [managedObjectContext insertObject:tweet];
//        [managedObjectContext insertObject:tweet.user];

        [tweetsCoreDataMutableArray addObject:tweet];
        [usersCoreDataMutableArray addObject:tweet.user];

//        WCUser* user = tweet.user;
//        [savedTweetsMutableArray addObject:tweet];
//
//        NSManagedObject* tweetManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"WhisperChallengeTweet" inManagedObjectContext:managedObjectContext];
//        [tweetManagedObject setValue:tweet.createdAtString forKey:@"createdAtString"];
//        [tweetManagedObject setValue:[NSNumber numberWithInt:tweet.favoriteCount] forKey:@"favoriteCount"];
//        [tweetManagedObject setValue:tweet.idString forKey:@"idString"];
//        if (tweet.inReplyToScreenNameString != (id)[NSNull null])
//        {
//            [tweetManagedObject setValue:tweet.inReplyToScreenNameString forKey:@"inReplyToScreenNameString"];
//        }
//        if (tweet.inReplyToStatusIdString != (id)[NSNull null])
//        {
//            [tweetManagedObject setValue:tweet.inReplyToStatusIdString forKey:@"inReplyToStatusIdString"];
//        }
//        if (tweet.inReplyToUserIdString != (id)[NSNull null])
//        {
//            [tweetManagedObject setValue:tweet.inReplyToUserIdString forKey:@"inReplyToUserIdString"];
//        }
//        [tweetManagedObject setValue:tweet.languageString forKey:@"languageString"];
//        if (tweet.placeString != (id)[NSNull null])
//        {
//            [tweetManagedObject setValue:tweet.placeString forKey:@"placeString"];
//        }
//        [tweetManagedObject setValue:[NSNumber numberWithInt:tweet.retweetCount] forKey:@"retweetCount"];
//        [tweetManagedObject setValue:tweet.sourceString forKey:@"sourceString"];
//        [tweetManagedObject setValue:tweet.textString forKey:@"textString"];
//
//        [tweetsCoreDataMutableArray addObject:tweetManagedObject];
//
//        NSManagedObject* userManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"WhisperChallengeUser" inManagedObjectContext:managedObjectContext];
//        [userManagedObject setValue:user.descriptionString forKey:@"descriptionString"];
//        [userManagedObject setValue:[NSNumber numberWithInt:user.favouritesCount] forKey:@"favouritesCount"];
//        [userManagedObject setValue:[NSNumber numberWithInt:user.followersCount] forKey:@"followersCount"];
//        [userManagedObject setValue:[NSNumber numberWithInt:user.friendsCount] forKey:@"friendsCount"];
//        [userManagedObject setValue:user.idString forKey:@"idString"];
//        [userManagedObject setValue:user.locationString forKey:@"locationString"];
//        [userManagedObject setValue:user.nameString forKey:@"nameString"];
//        [userManagedObject setValue:user.profileBackgroundImageURLString forKey:@"profileBackgroundImageURLString"];
//        [userManagedObject setValue:user.profileImageURLString forKey:@"profileImageURLString"];
//        [userManagedObject setValue:user.screenNameString forKey:@"screenNameString"];
//        [userManagedObject setValue:[NSNumber numberWithInt:user.statusesCount] forKey:@"statusesCount"];
//
//        [usersCoreDataMutableArray addObject:userManagedObject];
    }
}

- (void)saveTweets:(NSMutableArray *)tweets
{
    for (WCTweet* tweet in tweets)
    {
        [self saveTweet:tweet];
    }
}

- (void)unSaveTweet:(WCTweet *)tweet
{
    if ([savedTweetsMutableArray containsObject:tweet])
    {
        NSString* tweetIdString = tweet.idString;
        NSString* userIdString = tweet.user.idString;

        [savedTweetsMutableArray removeObject:tweet];

        NSManagedObject* tweetDeleteManagedObject;
        NSManagedObject* userDeleteManagedObject;

        for (NSManagedObject* tweetManagedObject in tweetsCoreDataMutableArray)
        {
            if ([[tweetManagedObject valueForKey:@"idString"] isEqualToString:tweetIdString])
            {
                tweetDeleteManagedObject = tweetManagedObject;
            }
        }

        for (NSManagedObject* userManagedObject in usersCoreDataMutableArray)
        {
            if ([[userManagedObject valueForKey:@"idString"] isEqualToString:userIdString])
            {
                userDeleteManagedObject = userManagedObject;
            }
        }

        if (tweetDeleteManagedObject)
        {
            [managedObjectContext deleteObject:tweetDeleteManagedObject];
            [tweetsCoreDataMutableArray removeObject:tweetDeleteManagedObject];
        }

        if (userDeleteManagedObject)
        {
            [managedObjectContext deleteObject:userDeleteManagedObject];
            [usersCoreDataMutableArray removeObject:userDeleteManagedObject];
        }

        [managedObjectContext deleteObject:tweet];
        [managedObjectContext deleteObject:tweet.user];
    }
}

#pragma mark - Core Data Methods

- (void)fetchCoreDataObjects
{
    [savedTweetsMutableArray removeAllObjects];

	NSEntityDescription *tweetEntityDescription = [NSEntityDescription entityForName:@"WhisperChallengeTweet" inManagedObjectContext:managedObjectContext];
	NSFetchRequest *tweetRequest = [[NSFetchRequest alloc] init];
	[tweetRequest setEntity:tweetEntityDescription];
	NSError *tweetRequestError;
	NSArray *tweetArray = [managedObjectContext executeFetchRequest:tweetRequest error:&tweetRequestError];

    NSEntityDescription *userEntityDescription = [NSEntityDescription entityForName:@"WhisperChallengeUser" inManagedObjectContext:managedObjectContext];
	NSFetchRequest *userRequest = [[NSFetchRequest alloc] init];
	[userRequest setEntity:userEntityDescription];
	NSError *userRequestError;
	NSArray *userArray = [managedObjectContext executeFetchRequest:userRequest error:&userRequestError];

    int i = 0;
    for (NSManagedObject* tweetManagedObject in tweetArray)
    {
        WCTweet* tweet = [[WCTweet alloc] initWithEntity:tweetEntityDescription insertIntoManagedObjectContext:managedObjectContext];
        [tweet updateWithTweetManagedObject:tweetManagedObject withUserManagedObject:[userArray objectAtIndex:i] withManagedObjectContext:managedObjectContext];

        [savedTweetsMutableArray addObject:tweet];
        [tweetsCoreDataMutableArray addObject:tweetManagedObject];
        [usersCoreDataMutableArray addObject:[userArray objectAtIndex:i]];
        [managedObjectContext deleteObject:tweetManagedObject];
        [managedObjectContext deleteObject:[userArray objectAtIndex:i]];
        i++;
    }
}

- (void)clearCoreDataObjects
{

    NSFetchRequest *tweetFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *tweetEntity = [NSEntityDescription entityForName:@"WhisperChallengeTweet" inManagedObjectContext:managedObjectContext];
    [tweetFetchRequest setEntity:tweetEntity];

    NSError *tweetError = nil;
    NSArray *tweetFetchedObjects = [self.managedObjectContext executeFetchRequest:tweetFetchRequest error:&tweetError];
    if (tweetFetchedObjects == nil)
    {
        NSLog(@"Could not delete Tweet Objects");
    }

    for (NSManagedObject* currentTweetObject in tweetFetchedObjects)
    {
        [managedObjectContext deleteObject:currentTweetObject];
    }

    NSFetchRequest *userFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"WhisperChallengeUser" inManagedObjectContext:managedObjectContext];
    [userFetchRequest setEntity:userEntity];

    NSError *userError = nil;
    NSArray *userFetchedObjects = [self.managedObjectContext executeFetchRequest:userFetchRequest error:&userError];
    if (userFetchedObjects == nil)
    {
        NSLog(@"Could not delete User Objects");
    }

    for (NSManagedObject* currentUserObject in userFetchedObjects)
    {
        [managedObjectContext deleteObject:currentUserObject];
    }

    [self saveContext];
}

- (void)saveContext
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
}

- (void)passManagedObjectFromPrivateToMain:(NSManagedObject *)managedObject
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:managedObject.entity.name];

    [privateManagedObjectContext performBlock:^{
        NSArray *results = [privateManagedObjectContext executeFetchRequest:request error:nil];
        for (NSManagedObject *mo in results) {
            NSManagedObjectID *moid = [mo objectID];
            [managedObjectContext performBlock:^{
                NSManagedObject *mainMO = [managedObjectContext objectWithID:moid];
                [managedObjectContext insertObject:mainMO];
            }];
        }
    }];
}

#pragma mark - Twitter API Authentification Methods

- (void)setAccessToken:(NSString *)newAccessTokenString
{
	accessTokenString = newAccessTokenString;
	if (accessTokenString != nil)
    {
		[[NSUserDefaults standardUserDefaults] setObject:accessTokenString forKey:kUserDefaultAccessToken];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setTokenType:(NSString *)newTokenTypeString
{
	tokenTypeString = newTokenTypeString;
	if (tokenTypeString != nil)
    {
		[[NSUserDefaults standardUserDefaults] setObject:tokenTypeString forKey:kUserDefaultTokenType];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)bearerToken
{
	return [NSString stringWithFormat:@"Bearer %@", accessTokenString];
}

- (void)requestAuthenticationFromTwitter
{
	if (accessTokenString == nil)
    {
		NSString *consumerKeyString = kTwitterAPIKey;
		NSString *consumerSecretKeyString = kTwitterAPISecret;
		NSString *concatenatedKeyString = [NSString stringWithFormat:@"%@:%@", consumerKeyString, consumerSecretKeyString];
		NSString *base64ConcatenatedKeyString = [[concatenatedKeyString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
		bearerTokenString = [NSString stringWithFormat:@"Basic %@", base64ConcatenatedKeyString];

		NSDictionary *dictionary = @{@"grant_type": @"client_credentials"};
		SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/oauth2/token"] parameters:dictionary];
		NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[request preparedURLRequest].URL];
		[urlRequest setAllHTTPHeaderFields:[request preparedURLRequest].allHTTPHeaderFields];
		[urlRequest setHTTPMethod:@"POST"];
		[urlRequest setValue:[NSString stringWithFormat:@"%@", bearerTokenString] forHTTPHeaderField:@"Authorization"];
		[urlRequest setHTTPBody:[@"grant_type=client_credentials" dataUsingEncoding:NSUTF8StringEncoding]];
		authentificationConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
		[authentificationConnection start];
    }
}

#pragma mark - Twitter API Fetch Methods

- (void)fetchPopularTweetsWithString:(NSString *)searchString
{
    NSURL* url = [NSURL URLWithString:kTwitterSearchURL];
	NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
	[parameters setObject:searchString forKey:@"q"];
    [parameters setObject:@"popular" forKey:@"result_type"];
    [parameters setObject:@"25" forKey:@"count"];

	SLRequest* request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:parameters];
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:request.preparedURLRequest.URL];
	urlRequest.allHTTPHeaderFields = [request preparedURLRequest].allHTTPHeaderFields;
	[urlRequest setValue:[NSString stringWithFormat:@"Bearer %@", accessTokenString] forHTTPHeaderField:@"Authorization"];
	popularTweetsConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
    popularTweetsResponseData = nil;
	[popularTweetsConnection start];
}

- (void)fetchRecentTweetsWithString:(NSString *)searchString
{
    NSURL* url = [NSURL URLWithString:kTwitterSearchURL];
	NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
	[parameters setObject:searchString forKey:@"q"];
    [parameters setObject:@"recent" forKey:@"result_type"];
    [parameters setObject:@"25" forKey:@"count"];

	SLRequest* request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:parameters];
	NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:request.preparedURLRequest.URL];
	urlRequest.allHTTPHeaderFields = [request preparedURLRequest].allHTTPHeaderFields;
	[urlRequest setValue:[NSString stringWithFormat:@"Bearer %@", accessTokenString] forHTTPHeaderField:@"Authorization"];
	recentTweetsConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
    recentTweetsResponseData = nil;
	[recentTweetsConnection start];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([connection isEqual:authentificationConnection])
    {
        [self.delegate didFailAuthenticatingBearerToken];
    }
    else if ([connection isEqual:popularTweetsConnection])
    {
        [self.delegate didFailFetchRequest];
    }
    else if ([connection isEqual:recentTweetsConnection])
    {
        [self.delegate didFailFetchRequest];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError *jsonError;

    if ([connection isEqual:authentificationConnection])
    {
        NSDictionary *authentificationResponseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];

        if (authentificationResponseData)
        {
            accessTokenString = [authentificationResponseData objectForKey:@"access_token"];
            tokenTypeString = [authentificationResponseData objectForKey:@"token_type"];

            [self.delegate didFinishAuthenticatingBearerToken];
        }
    }
    else if ([connection isEqual:popularTweetsConnection])
    {
        if (popularTweetsResponseData == nil)
        {
			popularTweetsResponseData = [[NSMutableData alloc] initWithData:data];
        }
		else
        {
			[popularTweetsResponseData appendData:data];
        }
    }
    else if ([connection isEqual:recentTweetsConnection])
    {
        if (recentTweetsResponseData == nil)
        {
			recentTweetsResponseData = [[NSMutableData alloc] initWithData:data];
        }
		else
        {
			[recentTweetsResponseData appendData:data];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([connection isEqual:popularTweetsConnection] || [connection isEqual:recentTweetsConnection])
    {
        NSError* jsonError;

        NSDictionary* responseData;

        if ([connection isEqual:popularTweetsConnection])
        {
            responseData = [NSJSONSerialization JSONObjectWithData:popularTweetsResponseData options:NSJSONReadingAllowFragments error:&jsonError];
        }
        else if ([connection isEqual:recentTweetsConnection])
        {
            responseData = [NSJSONSerialization JSONObjectWithData:recentTweetsResponseData options:NSJSONReadingAllowFragments error:&jsonError];
        }

        if (jsonError)
        {
            [self connection:connection didFailWithError:jsonError];
        }
        else
        {
            NSInteger errorCode = [[responseData valueForKeyPath:@"error.code"] intValue];
            if (errorCode)
            {
                NSString* errorMessage = [responseData valueForKeyPath:@"error.message"];
                NSLog(@"There was an error (%i): %@", errorCode, errorMessage);
            }
            NSArray* statusesArray = [responseData objectForKey:@"statuses"];
            NSMutableArray* statusesMutableArray = [[NSMutableArray alloc] init];

            for (NSDictionary* status in statusesArray)
            {
                WCTweet* tweet = [NSEntityDescription insertNewObjectForEntityForName:@"WhisperChallengeTweet" inManagedObjectContext:privateManagedObjectContext];
                [tweet updateWithDictionary:status withManagedObjectContext:privateManagedObjectContext];

                [statusesMutableArray addObject:tweet];
            }

            [[WCTweetDP sharedInstance] printCounts];

            if ([connection isEqual:popularTweetsConnection])
            {
                [self.delegate didFinishFetchRequestWithPopularTweets:statusesMutableArray];
            }
            else if ([connection isEqual:recentTweetsConnection])
            {
                [self.delegate didFinishFetchRequestWithRecentTweets:statusesMutableArray];
            }
        }
    }
}

#pragma mark - Testing Core Data Methods

- (void)fetchCountOfTweetCoreDataObjects
{
    NSEntityDescription *tweetEntityDescription = [NSEntityDescription entityForName:@"WhisperChallengeTweet" inManagedObjectContext:self.managedObjectContext];
	NSFetchRequest *tweetRequest = [[NSFetchRequest alloc] init];
	[tweetRequest setEntity:tweetEntityDescription];
	NSError *tweetRequestError;
	NSArray *tweetArray = [managedObjectContext executeFetchRequest:tweetRequest error:&tweetRequestError];

    NSLog(@"Number of Core Data Tweets: %i", tweetArray.count);
}

- (void)fetchCountOfUserCoreDataObjects
{
    NSEntityDescription *userEntityDescription = [NSEntityDescription entityForName:@"WhisperChallengeUser" inManagedObjectContext:self.managedObjectContext];
	NSFetchRequest *userRequest = [[NSFetchRequest alloc] init];
	[userRequest setEntity:userEntityDescription];
	NSError *userRequestError;
	NSArray *userArray = [managedObjectContext executeFetchRequest:userRequest error:&userRequestError];

    NSLog(@"Number of Core Data Users: %i", userArray.count);
}

- (void)printCounts
{
    NSLog(@"Number of Tweets/Users in App: %i", savedTweetsMutableArray.count);
    NSLog(@"Number of Copied Core Data Tweets: %i", tweetsCoreDataMutableArray.count);
    NSLog(@"Number of Copied Core Data Users: %i", usersCoreDataMutableArray.count);
    [self fetchCountOfTweetCoreDataObjects];
    [self fetchCountOfUserCoreDataObjects];
}

@end
