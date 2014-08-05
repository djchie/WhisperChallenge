//
//  WCTweetTableViewCell.m
//  WhisperChallenge
//
//  Created by Derrick J Chie on 8/2/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "WCTweetTableViewCell.h"

@implementation WCTweetTableViewCell

@synthesize profileImageView, retweetCountLabel, nameLabel, dateCreatedLabel, tweetTextView, saveCheckmarkImageView, expandButton;

- (void)updateWithTweet:(WCTweet *)tweet inSearchSavedMode:(BOOL)searchOrSaved
{
    WCUser* user = tweet.user;

    dispatch_queue_t profileImageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(profileImageQueue, ^{
        NSData *profileImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.profileImageURLString]];
        UIImage *profileImage = [UIImage imageWithData:profileImageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            profileImageView.image = profileImage;
        });
    });

    retweetCountLabel.text = [NSString stringWithFormat:@"%i Retweets", tweet.retweetCount];
    nameLabel.text = [NSString stringWithFormat:@"%@ @%@", user.nameString, user.screenNameString];
    dateCreatedLabel.text = tweet.createdAtString;
    tweetTextView.text = tweet.textString;

    if (!searchOrSaved)
    {
        if (!tweet.selectedToBeSaved)
        {
            saveCheckmarkImageView.image = [UIImage imageNamed:@"unsave_tweet.png"];
        }
        else
        {
            saveCheckmarkImageView.image = [UIImage imageNamed:@"save_tweet.png"];
        }
    }
    else
    {
        if (!tweet.selectedToBeUnSaved)
        {
            saveCheckmarkImageView.image = [UIImage imageNamed:@"unsave_tweet.png"];
        }
        else
        {
            saveCheckmarkImageView.image = [UIImage imageNamed:@"save_tweet.png"];
        }
    }
}

@end
