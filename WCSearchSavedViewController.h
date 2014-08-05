//
//  ViewController.h
//  WhisperChallenge
//
//  Created by Derrick J Chie on 7/31/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "WCTweet.h"
#import "WCTweetTableViewCell.h"
#import "WCTweetDetailViewController.h"
#import "WCTweetDP.h"
#import "Constants.h"

@interface WCSearchSavedViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, WCAuthDelegate>

@property (strong, nonatomic) NSMutableArray* popularSearchResultMutableArray;
@property (strong, nonatomic) NSMutableArray* recentSearchResultMutableArray;
@property (strong, nonatomic) NSMutableArray* savedResultMutableArray;
@property (nonatomic) BOOL popularOrRecentSelected;
@property (nonatomic) BOOL searchOrSavedSelected;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UISearchBar* twitterSearchBar;
@property (weak, nonatomic) IBOutlet UITableView* searchResultTableView;
@property (weak, nonatomic) IBOutlet UITableView* savedResultTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl* searchSavedSegmentedControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)searchSavedSegmentedControlButtonPressed:(id)sender;

@end
