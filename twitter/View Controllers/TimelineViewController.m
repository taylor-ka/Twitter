//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//


#import "APIManager.h"
#import "AppDelegate.h"

// Models
#import "TweetCell.h"

// View Controllers
#import "TimelineViewController.h"
#import "ComposeViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"

@interface TimelineViewController () <TweetCellDelegate, ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL isMoreDataLoading;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up table view: data source and delegate
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Set up refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Get timeline
    [self fetchTweets];
}

// Refresh displayed tweets
- (void)fetchTweets {
    // Make API request
    [[APIManager shared] getHomeTimeline:^(NSMutableArray *tweetsArray, NSError *error) {
        // API Manager calls completion handler and passes back data
        if (tweetsArray) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            // Vew controller stores data that was passed back
            self.tweets = tweetsArray;
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        
        // Reload table view
        // reloadData calls numberOfRows and cellForRowAt methods
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isMoreDataLoading) {
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self loadMoreTweets];
        }
    }
}

- (void) loadMoreTweets {
    Tweet *lastTweet = self.tweets[self.tweets.count - 1];
    [[APIManager shared] getHomeTimelineWithLastTweet:lastTweet completion:^(NSMutableArray *tweetsArray, NSError *error) {
        self.isMoreDataLoading = false;
        
        if (tweetsArray) {
            NSLog(@"😎😎😎 Successfully loaded home timeline since last tweet");
            
            // Add new tweets to old ones
            [self.tweets addObjectsFromArray:tweetsArray];
            
            // Reload table view
            // reloadData calls numberOfRows and cellForRowAt methods
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline since last tweet: %@", error.localizedDescription);
        }
    }];
}

// Called after new tweet is composed to reload displayed tweets
- (void)didTweet:(Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (IBAction)onLogoutTap:(id)sender {
    // Get single instance of app delegate
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Create new instance of storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Create new instance of login view controller using identifier
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    // Set root view controller to swich views
    appDelegate.window.rootViewController = loginViewController;
    
    // Clear access tokens
    [[APIManager shared] logout];
}

// Table view
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Gets instance of custom cell
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    // Set up cell delegate
    cell.delegate = self;
    
    // Populate cell with data
    cell.tweet = self.tweets[indexPath.row];
    [cell setUpTweetCell];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of tweets returned by API call
    return self.tweets.count;
}

// TweetCell Delegate
- (void) tweetCell:(TweetCell *)tweetCell didTapProfileOf:(User *)user {
    // Segue to profile view controller
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"profileSegue"]) {
        // Profile segue
        ProfileViewController *profileController = [segue destinationViewController];
        profileController.user = sender;
    } else {
        // Compose segue
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
}

@end
