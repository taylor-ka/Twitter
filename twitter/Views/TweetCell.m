//
//  TweetCell.m
//  twitter
//
//  Created by taylorka on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@protocol  TweetCellDelegate;

@interface TweetCell ()

// Images
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;

// Labels
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Set up tap gesture recognizer for profile picture
    
    // Create tap recognizer
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onUserProfileTap:)];
    
    // Link with profile picture
    [self.profilePicView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePicView setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setUpTweetCell {
    // Set up profile pic with slightly better quality
    NSString *biggerProfilePicString = [self.tweet.user.profilePicString stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    NSURL *profilePicURL = [NSURL URLWithString:biggerProfilePicString];
    self.profilePicView.image = nil;  // to avoid flicker
    [self.profilePicView setImageWithURL:profilePicURL];
    
    // Set up labels
    self.nameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [@"@" stringByAppendingString:self.tweet.user.screenName];
    self.timestampLabel.text = self.tweet.createdAtString;
    self.tweetTextLabel.text = self.tweet.text;
    
    // Set up retweet button
    [self.retweetButton setTitle:[NSString stringWithFormat:@"%i", self.tweet.retweetCount] forState: UIControlStateNormal];
    NSString *retweetIconName = @"retweet-icon";
    if (self.tweet.retweeted) {
        retweetIconName = @"retweet-icon-green";
    }
    [self.retweetButton setImage:[UIImage imageNamed:retweetIconName] forState:UIControlStateNormal];
    
    // Set up favorite button
    [self.favoriteButton setTitle:[NSString stringWithFormat:@"%i", self.tweet.favoriteCount] forState: UIControlStateNormal];
    NSString *favIconName = @"favor-icon";
    if (self.tweet.favorited) {
        favIconName = @"favor-icon-red";
    }
    [self.favoriteButton setImage:[UIImage imageNamed:favIconName] forState:UIControlStateNormal];
}

- (IBAction)onFavoriteTap:(id)sender {
    if (self.tweet.favorited) {
        // User wants to unfavorite tweet
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
                
                // Update local tweet model
                self.tweet.favorited = NO;
                self.tweet.favoriteCount--;
                
                // Update cell UI
                [self setUpTweetCell];
            }
        }];
    } else {
        // User wants to favorite tweet
        // Send POST request to actually favorite tweet
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                
                // Update local tweet model
                self.tweet.favorited = YES;
                self.tweet.favoriteCount++;
                
                // Update cell UI
                [self setUpTweetCell];
            }
        }];
    }
}

- (IBAction)onRetweetTap:(id)sender {
    if (self.tweet.retweeted) {
        // User wants to unretweet
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully unretweeteed the following Tweet: %@", tweet.text);
                
                // Update local tweet model
                self.tweet.retweeted = NO;
                self.tweet.retweetCount--;
                
                // Update cell UI
                [self setUpTweetCell];
            }
        }];
    } else {
        // User wants to retweet
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error) {
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
                
                // Update local tweet model
                self.tweet.retweeted = YES;
                self.tweet.retweetCount++;
                
                // Update cell UI
                [self setUpTweetCell];
            }
        }];
    }
}

- (void) onUserProfileTap:(UITapGestureRecognizer *)sender {
    // Call delegate method
    [self.delegate tweetCell:self didTapProfileOf:self.tweet.user];
}


@end
