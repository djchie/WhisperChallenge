//
//  WCTweetTableViewCell.h
//  WhisperChallenge
//
//  Created by Derrick J Chie on 8/2/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCTweet.h"

@interface WCTweetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UIImageView *saveCheckmarkImageView;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;

- (void)updateWithTweet:(WCTweet *)tweet inSearchSavedMode:(BOOL)searchOrSaved;

@end
