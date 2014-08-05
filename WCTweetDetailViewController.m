//
//  WCTweetDetailViewController.m
//  WhisperChallenge
//
//  Created by Derrick J Chie on 8/3/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "WCTweetDetailViewController.h"

@interface WCTweetDetailViewController ()

@end

@implementation WCTweetDetailViewController

@synthesize tweet, saveButton, profileBackgroundImageView, profileImageView, tweetCountLabel, followingCountLabel, followersCountLabel, nameLabel, screenNameLabel, descriptionTextView, dateCreatedLabel, retweetCountLabel, tweetTextView;

#pragma mark - Initial Setup Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    WCUser* user = tweet.user;

    dispatch_queue_t profileBackgroundImageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(profileBackgroundImageQueue, ^{
        NSData *profileBackgroundImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.profileBackgroundImageURLString]];
        UIImage *profileImage = [UIImage imageWithData:profileBackgroundImageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            profileBackgroundImageView.image = profileImage;
        });
    });

    dispatch_queue_t profileImageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(profileImageQueue, ^{
        NSData *profileImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.profileImageURLString]];
        UIImage *profileImage = [UIImage imageWithData:profileImageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            profileImageView.image = profileImage;
        });
    });

    if (!tweet.isSaved)
    {
        saveButton.title = @"Save";
    }
    else
    {
        saveButton.title = @"UnSave";
    }

    tweetCountLabel.text = [NSString stringWithFormat:@"%i", user.statusesCount];
    followingCountLabel.text = [NSString stringWithFormat:@"%i", user.friendsCount];
    followersCountLabel.text = [NSString stringWithFormat:@"%i", user.followersCount];
    nameLabel.text = user.nameString;
    screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenNameString];
    descriptionTextView.text = user.descriptionString;
    dateCreatedLabel.text = tweet.createdAtString;
    retweetCountLabel.text = [NSString stringWithFormat:@"%i Retweets", tweet.retweetCount];
    tweetTextView.text = tweet.textString;
}

#pragma mark - IBAction Methods

// Handles all saving or unsaving a single tweet
- (IBAction)saveButtonPressed:(id)sender
{
    NSString* alertTitleString = @"";
    NSString* alertMessageString = @"";

    if (!tweet.isSaved)
    {
        [[WCTweetDP sharedInstance] saveTweet:tweet];
        tweet.isSaved = YES;
        saveButton.title = @"UnSave";

        alertTitleString = @"Tweet Saved!";
        alertMessageString = @"You have saved this tweet!";
    }
    else
    {
        WCTweet* deleteTweet = [tweet copy];
        [[WCTweetDP sharedInstance] unSaveTweet:deleteTweet];
        deleteTweet = [tweet copy];
        tweet.isSaved = NO;
        saveButton.title = @"Save";

        alertTitleString = @"Tweet UnSaved!";
        alertMessageString = @"You have unsaved this tweet!";
    }

    [[WCTweetDP sharedInstance] cleanCoreDataObjects];

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:alertTitleString message:alertMessageString delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
    [alert show];
}
@end
