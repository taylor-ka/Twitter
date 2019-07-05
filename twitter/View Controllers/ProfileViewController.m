//
//  ProfileViewController.m
//  twitter
//
//  Created by taylorka on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()
// Images
@property (weak, nonatomic) IBOutlet UIImageView *headerPicView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;

// Labels
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;
@property (weak, nonatomic) IBOutlet UILabel *numTweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowersLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowingLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set up header pic
    NSURL *headerPicURL = [NSURL URLWithString:self.user.headerPicString];
    self.headerPicView.image = nil;  // to avoid flicker
    [self.headerPicView setImageWithURL:headerPicURL];
    
    // Set up profile pic with full size image
    NSString *originalProfilePicString = [self.user.profilePicString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *profilePicURL = [NSURL URLWithString: originalProfilePicString];
    self.profilePicView.image = nil;  // to avoid flicker
    [self.profilePicView setImageWithURL:profilePicURL];
    
    // Set up labels
    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat: @"@%@", self.user.screenName];
    self.taglineLabel.text = self.user.tagline;
    self.numTweetsLabel.text = [NSString stringWithFormat: @"Number of Tweets: %i", self.user.numTweets];
    self.numFollowersLabel.text = [NSString stringWithFormat: @"Followers: %i",self.user.numFollowers];
    self.numFollowingLabel.text = [NSString stringWithFormat: @"Following: %i",self.user.numFollowing];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
