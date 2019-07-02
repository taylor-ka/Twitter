//
//  TweetCell.m
//  twitter
//
//  Created by taylorka on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setUpTweetCell {
    // Set up profile pic
    NSURL *profilePicURL = [NSURL URLWithString:self.tweet.user.profilePicString];
    self.profilePicView.image = nil;  // to avoid flicker
    [self.profilePicView setImageWithURL:profilePicURL];
    
    // Set up labels
    self.nameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [@"@" stringByAppendingString:self.tweet.user.screenName];
    self.timestampLabel.text = self.tweet.createdAtString;
    self.tweetTextLabel.text = self.tweet.text;
    
    // Set up buttons
    [self.retweetButton setTitle:[NSString stringWithFormat:@"%i", self.tweet.retweetCount] forState: UIControlStateNormal];
    [self.favoriteButton setTitle:[NSString stringWithFormat:@"%i", self.tweet.favoriteCount] forState: UIControlStateNormal];
    
    
}

@end
