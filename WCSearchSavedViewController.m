//
//  ViewController.m
//  WhisperChallenge
//
//  Created by Derrick J Chie on 7/31/14.
//  Copyright (c) 2014 Derrick J Chie. All rights reserved.
//

#import "WCSearchSavedViewController.h"

@interface WCSearchSavedViewController ()

@end

@implementation WCSearchSavedViewController

@synthesize popularSearchResultMutableArray, recentSearchResultMutableArray, popularOrRecentSelected, searchOrSavedSelected;
@synthesize saveButton, twitterSearchBar, searchResultTableView, savedResultTableView, searchSavedSegmentedControl, activityIndicator;

#pragma mark - Initial Setup Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [WCTweetDP sharedInstance].delegate = self;
    [[WCTweetDP sharedInstance] requestAuthenticationFromTwitter];

    twitterSearchBar.delegate = self;

    if (!popularSearchResultMutableArray)
    {
        popularSearchResultMutableArray = [[NSMutableArray alloc] init];
    }

    if (!recentSearchResultMutableArray)
    {
        recentSearchResultMutableArray = [[NSMutableArray alloc] init];
    }

    searchResultTableView.contentInset = UIEdgeInsetsZero;
    savedResultTableView.contentInset = UIEdgeInsetsZero;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [searchResultTableView reloadData];
    [savedResultTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount = 0;

    if (tableView == searchResultTableView)
    {
        if (popularOrRecentSelected == 0)
        {
            rowCount = popularSearchResultMutableArray.count;
        }
        else if (popularOrRecentSelected == 1)
        {
            rowCount = recentSearchResultMutableArray.count;
        }

    }
    else if (tableView == savedResultTableView)
    {
        rowCount = [[WCTweetDP sharedInstance] getSavedTweets].count;
    }

    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"";

    WCTweet* tweet;

    if (tableView == searchResultTableView)
    {
        CellIdentifier = @"SearchResultTableViewCell";

        if (popularOrRecentSelected == 0)
        {
            tweet = [popularSearchResultMutableArray objectAtIndex:indexPath.row];
        }
        else if (popularOrRecentSelected == 1)
        {
            tweet = [recentSearchResultMutableArray objectAtIndex:indexPath.row];
        }
    }
    else if (tableView == savedResultTableView)
    {
        CellIdentifier = @"SavedResultTableViewCell";
        tweet = [[[WCTweetDP sharedInstance] getSavedTweets] objectAtIndex:indexPath.row];
    }

    WCTweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.expandButton.tag = indexPath.row;

    [cell updateWithTweet:tweet inSearchSavedMode:searchOrSavedSelected];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCTweet* tweet;
    int selectedCount = 0;

    if (tableView == searchResultTableView)
    {
        if (popularOrRecentSelected == 0)
        {
            tweet = [popularSearchResultMutableArray objectAtIndex:indexPath.row];
        }
        else if (popularOrRecentSelected == 1)
        {
            tweet = [recentSearchResultMutableArray objectAtIndex:indexPath.row];
        }

        if (tweet.selectedToBeSaved == NO)
        {
            tweet.selectedToBeSaved = YES;

            saveButton.enabled = YES;
        }
        else
        {
            for (WCTweet* currentTweet in popularSearchResultMutableArray)
            {
                if (currentTweet.selectedToBeSaved)
                {
                    selectedCount++;
                }
            }

            for (WCTweet* currentTweet in recentSearchResultMutableArray)
            {
                if (currentTweet.selectedToBeSaved)
                {
                    selectedCount++;
                }
            }

            if (selectedCount == 0)
            {
                saveButton.enabled = NO;
            }

            tweet.selectedToBeSaved = NO;
        }
    }
    else if (tableView == savedResultTableView)
    {
        tweet = [[[WCTweetDP sharedInstance] getSavedTweets] objectAtIndex:indexPath.row];

        if (tweet.selectedToBeUnSaved == NO)
        {
            tweet.selectedToBeUnSaved = YES;

            saveButton.enabled = YES;
        }
        else
        {
            for (WCTweet* currentTweet in popularSearchResultMutableArray)
            {
                if (currentTweet.selectedToBeSaved)
                {
                    selectedCount++;
                }
            }

            for (WCTweet* currentTweet in recentSearchResultMutableArray)
            {
                if (currentTweet.selectedToBeSaved)
                {
                    selectedCount++;
                }
            }

            if (selectedCount == 0)
            {
                saveButton.enabled = NO;
            }

            tweet.selectedToBeUnSaved = NO;
        }
    }

    [tableView reloadData];
}

#pragma mark - UISearchBar Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [[WCTweetDP sharedInstance] clearAllTweetsMutableArray];
    [self fetchPopularTweetsWithString:searchBar.text];
    [self fetchRecentTweetsWithString:searchBar.text];

    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

// Handles switching between viewing popular tweets and recent tweets
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    if (selectedScope == 0)
    {
        popularOrRecentSelected = NO;
    }
    else if (selectedScope == 1)
    {
        popularOrRecentSelected = YES;
    }

    [searchResultTableView reloadData];
}

#pragma mark - IBAction Methods

// Handles saving or unsaving a tweet or a set of tweets
- (IBAction)saveButtonPressed:(id)sender
{
    NSString* alertTitleString = @"";
    NSString* alertMessageString = @"";

    if (searchSavedSegmentedControl.selectedSegmentIndex == 0)
    {
        for (WCTweet* tweet in popularSearchResultMutableArray)
        {
            if (tweet.selectedToBeSaved)
            {
                [[WCTweetDP sharedInstance] saveTweet:tweet];
            }

            tweet.selectedToBeSaved = NO;
        }

        for (WCTweet* tweet in recentSearchResultMutableArray)
        {
            if (tweet.selectedToBeSaved)
            {
                [[WCTweetDP sharedInstance] saveTweet:tweet];
            }

            tweet.selectedToBeSaved = NO;
        }

        [searchResultTableView reloadData];
        saveButton.enabled = NO;

        alertTitleString = @"Tweets Saved!";
        alertMessageString = @"The selected tweets have been saved!";
    }
    else if (searchSavedSegmentedControl.selectedSegmentIndex == 1)
    {
        for (WCTweet* tweet in [[WCTweetDP sharedInstance] getSavedTweets])
        {
            if (tweet.selectedToBeUnSaved)
            {
                [[WCTweetDP sharedInstance] unSaveTweet:tweet];
            }

            tweet.selectedToBeUnSaved = NO;
        }

        [savedResultTableView reloadData];
        saveButton.enabled = NO;

        alertTitleString = @"Tweets UnSaved!";
        alertMessageString = @"The selected tweets have been unsaved!";
    }

    [[WCTweetDP sharedInstance] cleanCoreDataObjects];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:alertTitleString message:alertMessageString delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
    [alert show];
}

// Handles the switch between the search tweet table view and the saved tweets table view
- (IBAction)searchSavedSegmentedControlButtonPressed:(id)sender
{
    int selectedSegment = [sender selectedSegmentIndex];

    if (selectedSegment == 0)
    {
        self.navigationItem.title = @"Search Tweets";
        searchOrSavedSelected = NO;
        saveButton.title = @"Save";
        twitterSearchBar.hidden = NO;
        searchResultTableView.hidden = NO;
        savedResultTableView.hidden = YES;

        [searchResultTableView reloadData];
    }
    else if (selectedSegment == 1)
    {
        self.navigationItem.title = @"Save Tweets";
        searchOrSavedSelected = YES;
        saveButton.title = @"UnSave";
        twitterSearchBar.hidden = YES;
        searchResultTableView.hidden = YES;
        savedResultTableView.hidden = NO;

        [savedResultTableView reloadData];
    }
}

#pragma mark - Twitter Authenfitication Methods

- (void)didFinishAuthenticatingBearerToken
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have been authenticated!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
    [alert show];
}

- (void)didFailAuthenticatingBearerToken
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your Bearer Token could not be authenticated" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
    [alert show];
}

#pragma mark - Twitter Fetch Methods

// Fetches popular tweets given the search string
- (void)fetchPopularTweetsWithString:(NSString *)searchString
{
    [activityIndicator startAnimating];

    [[WCTweetDP sharedInstance] fetchPopularTweetsWithString:searchString];
}

// Fetches recent tweets given the search string
- (void)fetchRecentTweetsWithString:(NSString *)searchString
{
    [activityIndicator startAnimating];

    [[WCTweetDP sharedInstance] fetchRecentTweetsWithString:searchString];
}

- (void)didFinishFetchRequestWithPopularTweets:(NSMutableArray *)popularTweetsMutableArray
{
    popularSearchResultMutableArray = popularTweetsMutableArray;
    [searchResultTableView reloadData];
    [activityIndicator stopAnimating];
}

- (void)didFinishFetchRequestWithRecentTweets:(NSMutableArray *)recentTweetsMutableArray
{
    recentSearchResultMutableArray = recentTweetsMutableArray;
    [searchResultTableView reloadData];
    [activityIndicator stopAnimating];
}

- (void)didFailFetchRequest
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your search could not be completed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
    [alert show];
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    NSInteger selectedIndex = sender.tag;
    WCTweet* tweet;

    if ([segue.identifier isEqualToString:@"SearchToTweetDetailSegue"])
    {
        if (searchSavedSegmentedControl.selectedSegmentIndex == 0)
        {
            tweet = [popularSearchResultMutableArray objectAtIndex:selectedIndex];
        }
        else if (searchSavedSegmentedControl.selectedSegmentIndex == 1)
        {
            tweet = [recentSearchResultMutableArray objectAtIndex:selectedIndex];
        }
    }
    else if ([segue.identifier isEqualToString:@"SavedToTweetDetailSegue"])
    {
        self.navigationItem.title = @"Search Tweets";
        tweet = [[[WCTweetDP sharedInstance] getSavedTweets] objectAtIndex:selectedIndex];
    }

    WCTweetDetailViewController* tDViewController = (WCTweetDetailViewController *)segue.destinationViewController;
    tDViewController.tweet = tweet;
}

@end

// After saving, all the searched results not saved are nulled on the tableView --> need to make a copy when fetching?
// After saving and terminating the app, the saved results are nulled --> something withth e conversion?
// Implement delete object
// Fix save/unsave button in this class
